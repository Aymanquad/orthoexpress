import * as THREE from 'three'
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js'
import { DRACOLoader } from 'three/addons/loaders/DRACOLoader.js'
import { OrbitControls } from 'three/addons/controls/OrbitControls.js'
import { RoomEnvironment } from 'three/addons/environments/RoomEnvironment.js'
import { clone as cloneSkeleton } from 'three/addons/utils/SkeletonUtils.js'
import gsap from 'gsap'
import { JOINT_HOTSPOTS } from './jointHotspots'

const MODEL_URL = '/assets/models/male_skeleton.glb'
const DRACO_PATH = '/draco/'
const IDLE_RESUME_MS = 3000
const CLICK_DRAG_PX = 6
const HIT_RADIUS = 0.58
const GLOW_SIZE = 0.52
const FRAME_PADDING = 1.32

let cachedGltfPromise = null
let sharedDraco = null

function getLoaders() {
  if (!sharedDraco) {
    sharedDraco = new DRACOLoader()
    sharedDraco.setDecoderPath(DRACO_PATH)
  }
  const loader = new GLTFLoader()
  loader.setDRACOLoader(sharedDraco)
  return loader
}

function loadSkeletonGltf(onProgress) {
  if (cachedGltfPromise) {
    cachedGltfPromise.then(() => onProgress?.(100))
    return cachedGltfPromise
  }
  const loader = getLoaders()
  cachedGltfPromise = new Promise((resolve, reject) => {
    loader.load(
      MODEL_URL,
      resolve,
      (event) => {
        if (event.total) onProgress?.(Math.round((event.loaded / event.total) * 100))
      },
      (err) => {
        cachedGltfPromise = null
        reject(err)
      }
    )
  })
  return cachedGltfPromise
}

function findNode(root, boneName) {
  let exact = null
  let partial = null
  const short = boneName.replace(/_\d+$/, '')
  root.traverse((obj) => {
    if (obj.name === boneName) exact = obj
    else if (!partial && obj.name && (obj.name.startsWith(short) || obj.name.includes(short))) {
      partial = obj
    }
  })
  return exact || partial
}

function makeGlowTexture() {
  const size = 128
  const canvas = document.createElement('canvas')
  canvas.width = size
  canvas.height = size
  const ctx = canvas.getContext('2d')
  const gradient = ctx.createRadialGradient(64, 64, 1, 64, 64, 62)
  gradient.addColorStop(0, 'rgba(255, 255, 255, 0.95)')
  gradient.addColorStop(0.12, 'rgba(255, 130, 130, 0.92)')
  gradient.addColorStop(0.34, 'rgba(255, 72, 72, 0.5)')
  gradient.addColorStop(0.58, 'rgba(126, 224, 200, 0.14)')
  gradient.addColorStop(1, 'rgba(255, 64, 64, 0)')
  ctx.fillStyle = gradient
  ctx.fillRect(0, 0, size, size)
  const texture = new THREE.CanvasTexture(canvas)
  texture.colorSpace = THREE.SRGBColorSpace
  return texture
}

function projectToContainer(vector, camera, width, height) {
  const projected = vector.clone().project(camera)
  return {
    x: (projected.x * 0.5 + 0.5) * width,
    y: (-projected.y * 0.5 + 0.5) * height,
    visible: projected.z > -1 && projected.z < 1,
  }
}

export async function createSkeletonViewer({
  canvas,
  container,
  debugHotspots = false,
  reducedMotion = false,
  onHover,
  onSelect,
  onFrame,
  onProgress,
}) {
  const renderer = new THREE.WebGLRenderer({
    canvas,
    antialias: true,
    alpha: true,
    powerPreference: 'high-performance',
  })
  renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2))
  renderer.outputColorSpace = THREE.SRGBColorSpace
  renderer.toneMapping = THREE.ACESFilmicToneMapping
  renderer.toneMappingExposure = 1.02
  renderer.setClearColor(0x000000, 0)

  const scene = new THREE.Scene()
  const camera = new THREE.PerspectiveCamera(34, 1, 0.1, 250)

  const pmrem = new THREE.PMREMGenerator(renderer)
  scene.environment = pmrem.fromScene(new RoomEnvironment(), 0.08).texture
  scene.environmentIntensity = 0.42

  scene.add(new THREE.AmbientLight(0xc8d0e8, 0.62))
  const key = new THREE.DirectionalLight(0xfff4ea, 1.22)
  key.position.set(3.8, 7.4, 6.2)
  scene.add(key)
  const fill = new THREE.DirectionalLight(0x9eb0d8, 0.38)
  fill.position.set(-6.2, 2.4, 1.6)
  scene.add(fill)
  const rim = new THREE.DirectionalLight(0xdce6ff, 0.28)
  rim.position.set(0.4, 5.2, -7.4)
  scene.add(rim)

  const controls = new OrbitControls(camera, canvas)
  controls.enableDamping = true
  controls.dampingFactor = 0.12
  controls.enablePan = false
  controls.rotateSpeed = 0.62
  controls.zoomSpeed = 0.7
  controls.autoRotate = !reducedMotion
  controls.autoRotateSpeed = 0.28
  controls.minPolarAngle = 0.85
  controls.maxPolarAngle = Math.PI / 1.78

  const defaultCam = { position: new THREE.Vector3(), target: new THREE.Vector3() }
  const raycaster = new THREE.Raycaster()
  const pointer = new THREE.Vector2(2, 2)
  const hitTargets = []
  const markers = new Map()
  const markerTweens = new Map()
  const worldPos = new THREE.Vector3()
  const glowTexture = makeGlowTexture()

  let selectedId = null
  let hoveredId = null
  let raf = 0
  let disposed = false
  let idleTimer = 0
  let pointerDown = null
  let cameraTween = null
  let visible = true
  let lastSize = { w: 0, h: 0 }

  const gltf = await loadSkeletonGltf(onProgress)
  const model = cloneSkeleton(gltf.scene)

  if (disposed) {
    renderer.dispose()
    pmrem.dispose()
    glowTexture.dispose()
    return { dispose() {} }
  }

  model.traverse((obj) => {
    if (obj.isMesh) {
      obj.frustumCulled = false
      obj.castShadow = false
      obj.receiveShadow = false
      const materials = Array.isArray(obj.material) ? obj.material : [obj.material]
      materials.forEach((mat) => {
        if (!mat) return
        mat.roughness = Math.min(mat.roughness ?? 0.85, 0.78)
        mat.metalness = 0.06
        mat.envMapIntensity = 0.28
      })
    }
  })

  const modelRoot = new THREE.Group()
  modelRoot.add(model)
  scene.add(modelRoot)
  model.updateMatrixWorld(true)

  const boneBox = new THREE.Box3()
  let boneCount = 0
  model.traverse((obj) => {
    if (obj.isBone) {
      boneBox.expandByPoint(obj.getWorldPosition(new THREE.Vector3()))
      boneCount += 1
    }
  })
  if (boneCount < 4 || boneBox.isEmpty()) boneBox.setFromObject(modelRoot)
  const rawSize = boneBox.getSize(new THREE.Vector3())
  const rawCenter = boneBox.getCenter(new THREE.Vector3())
  modelRoot.position.sub(rawCenter)
  const targetScale = 10.4 / Math.max(rawSize.y, rawSize.x, 1)
  modelRoot.scale.setScalar(targetScale)
  modelRoot.updateMatrixWorld(true)

  const hotspotRoot = new THREE.Group()
  hotspotRoot.name = 'hotspotRoot'
  scene.add(hotspotRoot)

  JOINT_HOTSPOTS.forEach((hotspot) => {
    const bone = findNode(model, hotspot.bone)
    const group = new THREE.Group()
    group.name = `hotspot-${hotspot.id}`

    const hit = new THREE.Mesh(
      new THREE.SphereGeometry(HIT_RADIUS, 16, 16),
      new THREE.MeshBasicMaterial({
        color: 0xff3b3b,
        transparent: debugHotspots,
        opacity: debugHotspots ? 0.4 : 1,
        colorWrite: debugHotspots,
        depthWrite: false,
        depthTest: false,
      })
    )
    hit.name = hotspot.id
    hit.userData.hotspotId = hotspot.id
    hit.frustumCulled = false
    hit.renderOrder = 3

    const glow = new THREE.Sprite(
      new THREE.SpriteMaterial({
        map: glowTexture,
        color: 0xff6b6b,
        transparent: true,
        opacity: debugHotspots ? 0 : 0.48,
        depthWrite: false,
        depthTest: false,
        blending: THREE.AdditiveBlending,
      })
    )
    glow.scale.setScalar(GLOW_SIZE)
    glow.renderOrder = 4
    glow.frustumCulled = false

    const halo = new THREE.Sprite(
      new THREE.SpriteMaterial({
        map: glowTexture,
        color: 0x7ee0c8,
        transparent: true,
        opacity: 0,
        depthWrite: false,
        depthTest: false,
        blending: THREE.AdditiveBlending,
      })
    )
    halo.scale.setScalar(GLOW_SIZE * 2.15)
    halo.renderOrder = 3
    halo.frustumCulled = false

    group.add(hit, halo, glow)
    hotspotRoot.add(group)
    hitTargets.push(hit)
    markers.set(hotspot.id, { hotspot, bone, group, hit, glow, halo })
  })

  function syncHotspotPositions() {
    modelRoot.updateMatrixWorld(true)
    markers.forEach((marker) => {
      if (!marker.bone) return
      marker.bone.getWorldPosition(marker.group.position)
      const [ox, oy, oz] = marker.hotspot.offset || [0, 0, 0]
      if (ox || oy || oz) {
        marker.group.position.x += ox
        marker.group.position.y += oy
        marker.group.position.z += oz
      }
    })
  }

  syncHotspotPositions()

  const fitted = new THREE.Box3()
  model.traverse((obj) => {
    if (obj.isBone) fitted.expandByPoint(obj.getWorldPosition(new THREE.Vector3()))
  })
  const floor = new THREE.Mesh(
    new THREE.CircleGeometry(3.15, 64),
    new THREE.MeshBasicMaterial({
      color: 0x10183a,
      transparent: true,
      opacity: 0.42,
      depthWrite: false,
    })
  )
  floor.rotation.x = -Math.PI / 2
  floor.position.y = fitted.min.y + 0.02
  scene.add(floor)

  const floorRing = new THREE.Mesh(
    new THREE.RingGeometry(2.55, 3.22, 80),
    new THREE.MeshBasicMaterial({
      color: 0xffffff,
      transparent: true,
      opacity: 0.08,
      depthWrite: false,
    })
  )
  floorRing.rotation.x = -Math.PI / 2
  floorRing.position.y = fitted.min.y + 0.018
  scene.add(floorRing)

  function getModelBox() {
    modelRoot.updateMatrixWorld(true)
    const box = new THREE.Box3()
    let count = 0
    model.traverse((obj) => {
      if (obj.isBone) {
        box.expandByPoint(obj.getWorldPosition(new THREE.Vector3()))
        count += 1
      }
    })
    if (count < 4 || box.isEmpty()) box.setFromObject(modelRoot)
    return box
  }

  function frameModel() {
    const box = getModelBox()
    const size = box.getSize(new THREE.Vector3())
    const center = box.getCenter(new THREE.Vector3())
    const radius = Math.max(size.x, size.y, size.z) * 0.5
    const vFov = THREE.MathUtils.degToRad(camera.fov)
    const fitHeight = radius / Math.tan(vFov / 2)
    const fitWidth = fitHeight / Math.max(camera.aspect, 0.01)
    const distance = Math.max(fitHeight, fitWidth) * FRAME_PADDING

    camera.near = Math.max(0.05, distance / 80)
    camera.far = distance * 24
    camera.updateProjectionMatrix()
    camera.position.set(center.x + distance * 0.16, center.y + distance * 0.02, center.z + distance)
    controls.target.copy(center)
    controls.minDistance = distance * 0.58
    controls.maxDistance = distance * 1.85
    controls.update()
    defaultCam.position.copy(camera.position)
    defaultCam.target.copy(controls.target)
  }

  function setMarkerState(id, { hovered, selected }) {
    const marker = markers.get(id)
    if (!marker || debugHotspots) return
    markerTweens.get(id)?.kill()
    const active = hovered || selected
    const targetOpacity = selected ? 0.98 : hovered ? 0.86 : 0.44
    const targetScale = selected ? GLOW_SIZE * 1.44 : hovered ? GLOW_SIZE * 1.24 : GLOW_SIZE
    const targetHaloOpacity = selected ? 0.34 : hovered ? 0.2 : 0
    const targetHaloScale = selected ? GLOW_SIZE * 2.75 : GLOW_SIZE * 2.2
    const targetColor = selected ? 0xff9090 : hovered ? 0xff7474 : 0xff6b6b

    if (!reducedMotion && active) {
      marker.glow.material.color.setHex(targetColor)
      const tween = gsap.timeline()
      tween.to(marker.glow.material, { opacity: targetOpacity, duration: 0.32, ease: 'power2.out' }, 0)
      tween.to(
        marker.glow.scale,
        { x: targetScale, y: targetScale, duration: 0.52, ease: 'elastic.out(1, 0.62)' },
        0
      )
      tween.to(marker.halo.material, { opacity: targetHaloOpacity, duration: 0.35, ease: 'power2.out' }, 0)
      tween.to(
        marker.halo.scale,
        { x: targetHaloScale, y: targetHaloScale, duration: 0.45, ease: 'power2.out' },
        0
      )
      markerTweens.set(id, tween)
      return
    }

    marker.glow.material.opacity = targetOpacity
    marker.glow.material.color.setHex(targetColor)
    marker.glow.scale.setScalar(targetScale)
    marker.halo.material.opacity = targetHaloOpacity
    marker.halo.scale.setScalar(targetHaloScale)
  }

  function killCameraTween() {
    cameraTween?.kill()
    cameraTween = null
  }

  function focusJoint(id) {
    const marker = markers.get(id)
    if (!marker) return
    marker.group.getWorldPosition(worldPos)
    const box = getModelBox()
    const center = box.getCenter(new THREE.Vector3())
    const span = box.getSize(new THREE.Vector3()).length()
    const distance = Math.max(5.6, span * 0.34)
    const side = marker.hotspot.side || 0
    const lookAt = worldPos.clone().lerp(center, 0.28)
    const offset = new THREE.Vector3(side * 0.58 || 0.22, 0.18, 1.55).normalize().multiplyScalar(distance)
    const nextPos = lookAt.clone().add(offset)
    killCameraTween()
    if (reducedMotion) {
      camera.position.copy(nextPos)
      controls.target.copy(lookAt)
      controls.update()
      return
    }
    const proxy = {
      cx: camera.position.x,
      cy: camera.position.y,
      cz: camera.position.z,
      tx: controls.target.x,
      ty: controls.target.y,
      tz: controls.target.z,
    }
    cameraTween = gsap.to(proxy, {
      cx: nextPos.x,
      cy: nextPos.y,
      cz: nextPos.z,
      tx: lookAt.x,
      ty: lookAt.y,
      tz: lookAt.z,
      duration: 0.92,
      ease: 'power3.inOut',
      onUpdate: () => {
        camera.position.set(proxy.cx, proxy.cy, proxy.cz)
        controls.target.set(proxy.tx, proxy.ty, proxy.tz)
        controls.update()
      },
    })
  }

  function resetCamera() {
    killCameraTween()
    if (reducedMotion) {
      camera.position.copy(defaultCam.position)
      controls.target.copy(defaultCam.target)
      controls.update()
      return
    }
    const proxy = {
      cx: camera.position.x,
      cy: camera.position.y,
      cz: camera.position.z,
      tx: controls.target.x,
      ty: controls.target.y,
      tz: controls.target.z,
    }
    cameraTween = gsap.to(proxy, {
      cx: defaultCam.position.x,
      cy: defaultCam.position.y,
      cz: defaultCam.position.z,
      tx: defaultCam.target.x,
      ty: defaultCam.target.y,
      tz: defaultCam.target.z,
      duration: 0.92,
      ease: 'power3.inOut',
      onUpdate: () => {
        camera.position.set(proxy.cx, proxy.cy, proxy.cz)
        controls.target.set(proxy.tx, proxy.ty, proxy.tz)
        controls.update()
      },
    })
  }

  function applySelection(id) {
    selectedId = id
    markers.forEach((_, markerId) => {
      setMarkerState(markerId, {
        hovered: markerId === hoveredId,
        selected: markerId === selectedId,
      })
    })
    if (id) {
      controls.autoRotate = false
      focusJoint(id)
    } else {
      resetCamera()
      scheduleIdleRotate()
    }
    onSelect?.(id)
  }

  function setPointerFromEvent(event) {
    const rect = canvas.getBoundingClientRect()
    if (!rect.width || !rect.height) return false
    pointer.x = ((event.clientX - rect.left) / rect.width) * 2 - 1
    pointer.y = -((event.clientY - rect.top) / rect.height) * 2 + 1
    return true
  }

  function pickHotspot() {
    raycaster.setFromCamera(pointer, camera)
    const hits = raycaster.intersectObjects(hitTargets, false)
    return hits[0]?.object?.userData?.hotspotId || null
  }

  function applyHover(id) {
    if (id === hoveredId) {
      canvas.style.cursor = id || selectedId ? 'pointer' : 'grab'
      return
    }
    if (hoveredId && hoveredId !== selectedId) {
      setMarkerState(hoveredId, { hovered: false, selected: false })
    }
    hoveredId = id
    if (id) setMarkerState(id, { hovered: true, selected: id === selectedId })
    canvas.style.cursor = id ? 'pointer' : 'grab'
    onHover?.(id)
  }

  function scheduleIdleRotate() {
    window.clearTimeout(idleTimer)
    if (reducedMotion || selectedId) {
      controls.autoRotate = false
      return
    }
    idleTimer = window.setTimeout(() => {
      if (!disposed && !selectedId) controls.autoRotate = true
    }, IDLE_RESUME_MS)
  }

  function onPointerMove(event) {
    if (!setPointerFromEvent(event)) return
    if (pointerDown) {
      canvas.style.cursor = 'grabbing'
      return
    }
    applyHover(pickHotspot())
  }

  function onPointerDown(event) {
    pointerDown = { x: event.clientX, y: event.clientY }
    controls.autoRotate = false
    canvas.style.cursor = 'grabbing'
    setPointerFromEvent(event)
  }

  function onPointerUp(event) {
    const start = pointerDown
    pointerDown = null
    canvas.style.cursor = 'grab'
    if (!start) return
    const dx = event.clientX - start.x
    const dy = event.clientY - start.y
    const dragged = dx * dx + dy * dy > CLICK_DRAG_PX * CLICK_DRAG_PX
    scheduleIdleRotate()
    if (dragged) return
    if (!setPointerFromEvent(event)) return
    const id = pickHotspot()
    if (id) applySelection(id)
    else if (selectedId) applySelection(null)
  }

  function onPointerLeave() {
    pointerDown = null
    if (hoveredId && hoveredId !== selectedId) {
      setMarkerState(hoveredId, { hovered: false, selected: false })
    }
    hoveredId = null
    onHover?.(null)
    canvas.style.cursor = 'grab'
    scheduleIdleRotate()
  }

  function resize() {
    const width = container.clientWidth || 1
    const height = container.clientHeight || 1
    const changed = width !== lastSize.w || height !== lastSize.h
    lastSize = { w: width, h: height }
    camera.aspect = width / height
    camera.updateProjectionMatrix()
    renderer.setSize(width, height, false)
    if (changed && !selectedId && !cameraTween) frameModel()
  }

  const resizeObserver = new ResizeObserver(resize)
  resizeObserver.observe(container)
  resize()
  frameModel()

  canvas.addEventListener('pointermove', onPointerMove)
  canvas.addEventListener('pointerdown', onPointerDown)
  canvas.addEventListener('pointerup', onPointerUp)
  canvas.addEventListener('pointerleave', onPointerLeave)
  canvas.style.cursor = 'grab'
  canvas.style.touchAction = 'none'

  const clock = new THREE.Clock()
  function tick() {
    if (disposed) return
    raf = requestAnimationFrame(tick)
    const elapsed = clock.getElapsedTime()
    const dt = clock.getDelta()
    if (!visible) return
    controls.update(dt)
    syncHotspotPositions()

    if (!debugHotspots) {
      const pulse = 0.88 + Math.sin(elapsed * 1.55) * 0.12
      floorRing.material.opacity = 0.06 + Math.sin(elapsed * 0.9) * 0.025
      markers.forEach((marker, id) => {
        if (id === hoveredId || id === selectedId) return
        marker.glow.material.opacity = 0.38 * pulse
        marker.glow.scale.setScalar(GLOW_SIZE * (0.94 + pulse * 0.08))
        marker.halo.material.opacity = 0
      })
    }

    renderer.render(scene, camera)

    const width = container.clientWidth
    const height = container.clientHeight
    const hoverMarker = hoveredId ? markers.get(hoveredId) : null
    const selectedMarker = selectedId ? markers.get(selectedId) : null
    onFrame?.({
      hover: hoverMarker
        ? {
            id: hoveredId,
            ...projectToContainer(hoverMarker.group.getWorldPosition(new THREE.Vector3()), camera, width, height),
          }
        : null,
      selected: selectedMarker
        ? {
            id: selectedId,
            ...projectToContainer(selectedMarker.group.getWorldPosition(new THREE.Vector3()), camera, width, height),
          }
        : null,
    })
  }
  tick()

  function dispose() {
    disposed = true
    cancelAnimationFrame(raf)
    window.clearTimeout(idleTimer)
    killCameraTween()
    markerTweens.forEach((tween) => tween.kill())
    markerTweens.clear()
    resizeObserver.disconnect()
    canvas.removeEventListener('pointermove', onPointerMove)
    canvas.removeEventListener('pointerdown', onPointerDown)
    canvas.removeEventListener('pointerup', onPointerUp)
    canvas.removeEventListener('pointerleave', onPointerLeave)
    controls.dispose()
    pmrem.dispose()
    glowTexture.dispose()
    markers.forEach((marker) => {
      marker.hit.geometry.dispose()
      marker.hit.material.dispose()
      marker.glow.material.dispose()
      marker.halo.material.dispose()
    })
    floor.geometry.dispose()
    floor.material.dispose()
    floorRing.geometry.dispose()
    floorRing.material.dispose()
    renderer.dispose()
  }

  return {
    dispose,
    resize,
    setVisible: (next) => {
      visible = next
    },
    select: applySelection,
    getSelected: () => selectedId,
  }
}

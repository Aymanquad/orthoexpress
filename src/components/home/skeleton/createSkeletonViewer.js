import * as THREE from 'three'
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js'
import { DRACOLoader } from 'three/addons/loaders/DRACOLoader.js'
import { OrbitControls } from 'three/addons/controls/OrbitControls.js'
import { RoomEnvironment } from 'three/addons/environments/RoomEnvironment.js'
import { clone as cloneSkeleton } from 'three/addons/utils/SkeletonUtils.js'
import { EffectComposer } from 'three/addons/postprocessing/EffectComposer.js'
import { RenderPass } from 'three/addons/postprocessing/RenderPass.js'
import { UnrealBloomPass } from 'three/addons/postprocessing/UnrealBloomPass.js'
import { OutputPass } from 'three/addons/postprocessing/OutputPass.js'
import { ShaderPass } from 'three/addons/postprocessing/ShaderPass.js'
import gsap from 'gsap'
import { JOINT_HOTSPOTS } from './jointHotspots'
import { detectViewerQuality } from './viewerQuality'

const MODEL_URL = '/assets/models/male_skeleton.glb'
const DRACO_PATH = '/draco/'
const IDLE_RESUME_MS = 3000
const CLICK_DRAG_PX = 6
const HIT_RADIUS = 0.58
const GLOW_SIZE = 0.52
const FRAME_PADDING = 1.34
/** Camera orbit speed on stage hover (rad/s). */
const STAGE_SPIN_RAD_PER_SEC = 2.2
/** Model scales up by this fraction on hover (0–1). */
const HOVER_ZOOM_AMOUNT = 0.08
const IDLE_ROTATE_SPEED = 0
/** Brand teal from the section eyebrow — used as a subtle rim accent. */
const RIM_TEAL = 0x7ee0c8

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

/** Soft radial contact shadow — reads as a shadow, not a hard disc. */
function makeShadowTexture() {
  const size = 256
  const canvas = document.createElement('canvas')
  canvas.width = size
  canvas.height = size
  const ctx = canvas.getContext('2d')
  const gradient = ctx.createRadialGradient(128, 128, 8, 128, 128, 124)
  gradient.addColorStop(0, 'rgba(4, 8, 24, 0.55)')
  gradient.addColorStop(0.35, 'rgba(4, 8, 24, 0.28)')
  gradient.addColorStop(0.7, 'rgba(4, 8, 24, 0.08)')
  gradient.addColorStop(1, 'rgba(4, 8, 24, 0)')
  ctx.fillStyle = gradient
  ctx.fillRect(0, 0, size, size)
  const texture = new THREE.CanvasTexture(canvas)
  texture.colorSpace = THREE.SRGBColorSpace
  return texture
}

const VignetteShader = {
  uniforms: {
    tDiffuse: { value: null },
    offset: { value: 0.85 },
    darkness: { value: 0.55 },
  },
  vertexShader: /* glsl */ `
    varying vec2 vUv;
    void main() {
      vUv = uv;
      gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
    }
  `,
  fragmentShader: /* glsl */ `
    uniform sampler2D tDiffuse;
    uniform float offset;
    uniform float darkness;
    varying vec2 vUv;
    void main() {
      vec4 texel = texture2D(tDiffuse, vUv);
      vec2 uv = (vUv - 0.5) * vec2(offset);
      float vig = clamp(1.0 - dot(uv, uv), 0.0, 1.0);
      texel.rgb *= mix(1.0 - darkness, 1.0, vig);
      gl_FragColor = texel;
    }
  `,
}

/** Slightly different camera angles per region so zoom feels directed. */
function focusOffsetFor(hotspot, distance) {
  const side = hotspot.side || 0
  const region = hotspot.region || ''
  let ox = side * 0.62 || 0.24
  let oy = 0.2
  let oz = 1.55
  if (region === 'head' || region === 'neck') {
    oy = 0.42
    oz = 1.35
  } else if (region === 'ankle' || region === 'knee') {
    oy = -0.08
    oz = 1.62
  } else if (region === 'hip' || region === 'soft_tissue') {
    oy = 0.12
    oz = 1.48
  } else if (region === 'wrist' || region === 'elbow') {
    ox = side * 0.78 || 0.32
    oy = 0.16
  }
  return new THREE.Vector3(ox, oy, oz).normalize().multiplyScalar(distance)
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
  const quality = detectViewerQuality()
  const renderer = new THREE.WebGLRenderer({
    canvas,
    antialias: true,
    alpha: true,
    powerPreference: 'high-performance',
  })
  renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, quality.pixelRatioCap))
  renderer.outputColorSpace = THREE.SRGBColorSpace
  renderer.toneMapping = THREE.ACESFilmicToneMapping
  renderer.toneMappingExposure = 0.88
  renderer.setClearColor(0x000000, 0)

  const scene = new THREE.Scene()
  const camera = new THREE.PerspectiveCamera(34, 1, 0.1, 250)

  const pmrem = new THREE.PMREMGenerator(renderer)
  scene.environment = pmrem.fromScene(new RoomEnvironment(), 0.06).texture
  scene.environmentIntensity = 0.38

  scene.add(new THREE.AmbientLight(0xc8d0e8, 0.36))
  const key = new THREE.DirectionalLight(0xfff1e6, 0.92)
  key.position.set(3.8, 7.4, 6.2)
  scene.add(key)
  const fill = new THREE.DirectionalLight(0x9eb0d8, 0.3)
  fill.position.set(-6.2, 2.4, 1.6)
  scene.add(fill)
  // Teal rim — subtle brand accent; kept low so bones don't blow out.
  const rim = new THREE.DirectionalLight(RIM_TEAL, 0.18)
  rim.position.set(-0.6, 4.8, -7.2)
  scene.add(rim)
  const rimCool = new THREE.DirectionalLight(0xdce6ff, 0.1)
  rimCool.position.set(2.2, 3.4, -5.5)
  scene.add(rimCool)

  const controls = new OrbitControls(camera, canvas)
  controls.enableDamping = true
  controls.dampingFactor = 0.075
  controls.enablePan = false
  controls.enableZoom = false
  controls.rotateSpeed = 0.62
  controls.zoomSpeed = 0.7
  controls.autoRotate = false
  controls.autoRotateSpeed = IDLE_ROTATE_SPEED
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
  const shadowTexture = makeShadowTexture()
  const modelMats = []
  let markerIndex = 0

  let selectedId = null
  let hoveredId = null
  let raf = 0
  let disposed = false
  let idleTimer = 0
  let pointerDown = null
  let hoverSpin = false
  let cameraTween = null
  let revealTween = null
  let visible = true
  let lastSize = { w: 0, h: 0 }
  let composer = null
  let bloomPass = null
  let vignettePass = null
  let restY = 0
  let hoverZoom = 0
  let stageHovered = false
  let cameraAnimating = false
  let lastPointer = { x: -1, y: -1 }
  let lastFrameMs = performance.now()
  const hoverCamOffset = new THREE.Vector3()
  const hoverCamSph = new THREE.Spherical()

  const gltf = await loadSkeletonGltf(onProgress)
  const model = cloneSkeleton(gltf.scene)

  if (disposed) {
    renderer.dispose()
    pmrem.dispose()
    glowTexture.dispose()
    shadowTexture.dispose()
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
        // Ivory bone: matte enough to read on dark UI; slight env for depth only.
        mat.roughness = Math.min(mat.roughness ?? 0.85, 0.76)
        mat.metalness = 0.02
        mat.envMapIntensity = 0.3
        if ('transparent' in mat) {
          mat.transparent = true
          mat.opacity = reducedMotion ? 1 : 0
        }
        modelMats.push(mat)
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
  const modelBaseScale = targetScale
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
    markers.set(hotspot.id, {
      hotspot,
      bone,
      group,
      hit,
      glow,
      halo,
      phase: markerIndex * 0.73,
    })
    markerIndex += 1
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
    new THREE.PlaneGeometry(7.2, 7.2),
    new THREE.MeshBasicMaterial({
      map: shadowTexture,
      transparent: true,
      opacity: 0.9,
      depthWrite: false,
    })
  )
  floor.rotation.x = -Math.PI / 2
  floor.position.y = fitted.min.y + 0.02
  scene.add(floor)

  restY = modelRoot.position.y
  if (!reducedMotion) {
    modelRoot.position.y = restY - 0.22
    revealTween = gsap.timeline({ defaults: { ease: 'power2.out' } })
    revealTween.to(modelRoot.position, { y: restY, duration: 1.05 }, 0)
    modelMats.forEach((mat) => {
      revealTween.to(mat, { opacity: 1, duration: 0.9 }, 0.05)
    })
  } else {
    modelMats.forEach((mat) => {
      mat.opacity = 1
    })
  }

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
    const vFov = THREE.MathUtils.degToRad(camera.fov)
    // Prefer body height so a tall stage fills with the skeleton, not empty air.
    const fitByHeight = size.y * 0.5 / Math.tan(vFov / 2)
    const fitByWidth = size.x * 0.5 / Math.tan(vFov / 2) / Math.max(camera.aspect, 0.01)
    const distance = Math.max(fitByHeight, fitByWidth) * FRAME_PADDING

    camera.near = Math.max(0.05, distance / 80)
    camera.far = distance * 24
    camera.updateProjectionMatrix()
    camera.position.set(center.x + distance * 0.12, center.y + distance * 0.01, center.z + distance)
    controls.target.copy(center)
    controls.minDistance = distance * 0.55
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
      // One soft "sonar" ping on hover/select.
      if (hovered && !selected) {
        marker.halo.scale.setScalar(GLOW_SIZE * 1.2)
        marker.halo.material.opacity = 0.28
        tween.to(
          marker.halo.scale,
          { x: GLOW_SIZE * 3.1, y: GLOW_SIZE * 3.1, duration: 0.55, ease: 'power2.out' },
          0
        )
        tween.to(marker.halo.material, { opacity: 0, duration: 0.55, ease: 'power2.out' }, 0)
      }
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
    cameraAnimating = false
    updateHoverSpinState()
  }

  function startCameraTween(proxy, vars, duration) {
    killCameraTween()
    cameraAnimating = true
    updateHoverSpinState()
    cameraTween = gsap.to(proxy, {
      ...vars,
      duration,
      ease: 'power3.inOut',
      onUpdate: () => {
        camera.position.set(proxy.cx, proxy.cy, proxy.cz)
        controls.target.set(proxy.tx, proxy.ty, proxy.tz)
        controls.update()
      },
      onComplete: () => {
        cameraTween = null
        cameraAnimating = false
        updateHoverSpinState()
      },
    })
  }

  function focusJoint(id) {
    const marker = markers.get(id)
    if (!marker) return
    marker.group.getWorldPosition(worldPos)
    const box = getModelBox()
    const center = box.getCenter(new THREE.Vector3())
    const span = box.getSize(new THREE.Vector3()).length()
    const distance = Math.max(5.6, span * 0.34)
    const lookAt = worldPos.clone().lerp(center, 0.28)
    const nextPos = lookAt.clone().add(focusOffsetFor(marker.hotspot, distance))
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
    startCameraTween(proxy, {
      cx: nextPos.x,
      cy: nextPos.y,
      cz: nextPos.z,
      tx: lookAt.x,
      ty: lookAt.y,
      tz: lookAt.z,
    }, 0.82)
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
    startCameraTween(proxy, {
      cx: defaultCam.position.x,
      cy: defaultCam.position.y,
      cz: defaultCam.position.z,
      tx: defaultCam.target.x,
      ty: defaultCam.target.y,
      tz: defaultCam.target.z,
    }, 0.92)
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
      modelRoot.position.y = restY
      updateHoverSpinState()
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
    updateHoverSpinState()
  }

  function isPointerInStage(clientX, clientY) {
    if (clientX < 0 || clientY < 0) return false
    const rect = container.getBoundingClientRect()
    return (
      clientX >= rect.left &&
      clientX <= rect.right &&
      clientY >= rect.top &&
      clientY <= rect.bottom
    )
  }

  function syncStageHover() {
    const over =
      isPointerInStage(lastPointer.x, lastPointer.y) || container.matches(':hover')
    if (over === stageHovered) return
    stageHovered = over
    updateHoverSpinState()
  }

  function updateHoverSpinState() {
    const active = stageHovered && !selectedId && !hoveredId && !pointerDown && !cameraAnimating
    hoverSpin = active
    container.dataset.hoverSpin = active ? '1' : '0'
    container.dataset.stageHover = stageHovered ? '1' : '0'
    controls.autoRotate = false
  }

  function setStageHovered(next) {
    stageHovered = Boolean(next)
    updateHoverSpinState()
  }

  function trackPointer(event) {
    lastPointer.x = event.clientX
    lastPointer.y = event.clientY
    syncStageHover()
  }

  function scheduleIdleRotate() {
    window.clearTimeout(idleTimer)
    updateHoverSpinState()
  }

  function onPointerEnter(event) {
    trackPointer(event)
    setStageHovered(true)
  }

  function onPointerMove(event) {
    trackPointer(event)
    if (!setPointerFromEvent(event)) return
    if (pointerDown) {
      canvas.style.cursor = 'grabbing'
      return
    }
    applyHover(pickHotspot())
  }

  function onGlobalPointerMove(event) {
    trackPointer(event)
  }

  function onGlobalScroll() {
    syncStageHover()
  }

  function onStageMouseEnter(event) {
    trackPointer(event)
    setStageHovered(true)
  }

  function onStageMouseLeave(event) {
    trackPointer(event)
    if (!isPointerInStage(event.clientX, event.clientY)) {
      setStageHovered(false)
    }
  }

  function applyStageOrbit(dt) {
    const baseDist = defaultCam.position.distanceTo(defaultCam.target)
    hoverCamOffset.copy(camera.position).sub(controls.target)
    hoverCamSph.setFromVector3(hoverCamOffset)
    hoverCamSph.theta -= STAGE_SPIN_RAD_PER_SEC * dt
    const zoomedDist = baseDist * (1 - HOVER_ZOOM_AMOUNT * hoverZoom)
    hoverCamSph.radius = THREE.MathUtils.lerp(hoverCamSph.radius, zoomedDist, dt * 4)
    hoverCamOffset.setFromSpherical(hoverCamSph)
    camera.position.copy(controls.target).add(hoverCamOffset)
  }

  function onPointerDown(event) {
    pointerDown = { x: event.clientX, y: event.clientY }
    updateHoverSpinState()
    canvas.style.cursor = 'grabbing'
    setPointerFromEvent(event)
  }

  function onPointerUp(event) {
    const start = pointerDown
    pointerDown = null
    canvas.style.cursor = 'grab'
    if (!start) {
      updateHoverSpinState()
      return
    }
    const dx = event.clientX - start.x
    const dy = event.clientY - start.y
    const dragged = dx * dx + dy * dy > CLICK_DRAG_PX * CLICK_DRAG_PX
    if (dragged) {
      updateHoverSpinState()
      return
    }
    if (!setPointerFromEvent(event)) {
      updateHoverSpinState()
      return
    }
    const id = pickHotspot()
    if (id) applySelection(id)
    else if (selectedId) applySelection(null)
    else updateHoverSpinState()
  }

  function onPointerLeave(event) {
    trackPointer(event)
    if (isPointerInStage(event.clientX, event.clientY)) return
    setStageHovered(false)
    if (hoveredId && hoveredId !== selectedId) {
      setMarkerState(hoveredId, { hovered: false, selected: false })
    }
    hoveredId = null
    onHover?.(null)
    canvas.style.cursor = 'grab'
    updateHoverSpinState()
  }

  function resize() {
    const width = container.clientWidth || 1
    const height = container.clientHeight || 1
    const changed = width !== lastSize.w || height !== lastSize.h
    lastSize = { w: width, h: height }
    camera.aspect = width / height
    camera.updateProjectionMatrix()
    renderer.setSize(width, height, false)
    if (composer) {
      composer.setSize(width, height)
      bloomPass?.setSize(width, height)
    }
    if (changed && !selectedId && !cameraAnimating) frameModel()
  }

  const resizeObserver = new ResizeObserver(resize)
  resizeObserver.observe(container)
  resize()
  frameModel()

  // Post-processing: bloom (hotspots) + vignette. Skipped on constrained GPUs.
  if (quality.bloom && !reducedMotion) {
    composer = new EffectComposer(renderer)
    composer.addPass(new RenderPass(scene, camera))
    // Keep bloom on hotspots only — white bone mesh must stay below threshold.
    bloomPass = new UnrealBloomPass(
      new THREE.Vector2(lastSize.w || 1, lastSize.h || 1),
      0.09,
      0.35,
      0.94
    )
    composer.addPass(bloomPass)
    vignettePass = new ShaderPass(VignetteShader)
    vignettePass.uniforms.offset.value = 0.9
    vignettePass.uniforms.darkness.value = 0.52
    composer.addPass(vignettePass)
    composer.addPass(new OutputPass())
  }

  container.addEventListener('pointerenter', onPointerEnter)
  container.addEventListener('pointerleave', onPointerLeave)
  container.addEventListener('pointermove', onPointerMove)
  container.addEventListener('mouseenter', onStageMouseEnter)
  container.addEventListener('mouseleave', onStageMouseLeave)
  canvas.addEventListener('pointermove', onPointerMove)
  canvas.addEventListener('pointerdown', onPointerDown)
  canvas.addEventListener('pointerup', onPointerUp)
  document.addEventListener('pointermove', onGlobalPointerMove, { passive: true })
  document.addEventListener('scroll', onGlobalScroll, { passive: true, capture: true })
  window.addEventListener('pointerup', onPointerUp)
  window.addEventListener('pointercancel', onPointerUp)
  canvas.style.cursor = 'grab'
  canvas.style.touchAction = 'none'

  function tick(now) {
    if (disposed) return
    raf = requestAnimationFrame(tick)
    const dt = Math.min((now - lastFrameMs) / 1000, 0.05)
    lastFrameMs = now
    const elapsed = now / 1000

    syncStageHover()

    if (hoverSpin) {
      hoverZoom = Math.min(1, hoverZoom + dt * 6)
      controls.enableDamping = false
      applyStageOrbit(dt)
    } else {
      controls.enableDamping = true
      if (!selectedId && !cameraAnimating) {
        hoverZoom = Math.max(0, hoverZoom - dt * 5)
      }
    }

    const zoomScale = modelBaseScale * (1 + HOVER_ZOOM_AMOUNT * hoverZoom)
    modelRoot.scale.setScalar(THREE.MathUtils.lerp(modelRoot.scale.x, zoomScale, dt * 5))

    // Breathing bob only when idle.
    if (!hoverSpin && !selectedId && !cameraAnimating && !reducedMotion) {
      modelRoot.position.y = restY + Math.sin(elapsed * 0.85) * 0.028
    } else if (selectedId || cameraAnimating) {
      modelRoot.position.y = restY
    }

    controls.update(dt)
    syncHotspotPositions()

    if (!debugHotspots) {
      markers.forEach((marker, id) => {
        if (id === hoveredId || id === selectedId) return
        // Staggered pulse (~2.4s) so markers don't blink in unison.
        const pulse = 0.86 + Math.sin(elapsed * 2.4 + marker.phase) * 0.14
        marker.glow.material.opacity = 0.36 * pulse
        marker.glow.scale.setScalar(GLOW_SIZE * (0.92 + pulse * 0.1))
        marker.halo.material.opacity = 0.04 * pulse
        marker.halo.scale.setScalar(GLOW_SIZE * (1.9 + pulse * 0.2))
      })
    }

    if (composer) composer.render()
    else renderer.render(scene, camera)

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
  tick(performance.now())
  syncStageHover()

  function dispose() {
    disposed = true
    cancelAnimationFrame(raf)
    window.clearTimeout(idleTimer)
    killCameraTween()
    revealTween?.kill()
    markerTweens.forEach((tween) => tween.kill())
    markerTweens.clear()
    resizeObserver.disconnect()
    container.removeEventListener('pointerenter', onPointerEnter)
    container.removeEventListener('pointerleave', onPointerLeave)
    container.removeEventListener('pointermove', onPointerMove)
    container.removeEventListener('mouseenter', onStageMouseEnter)
    container.removeEventListener('mouseleave', onStageMouseLeave)
    canvas.removeEventListener('pointermove', onPointerMove)
    canvas.removeEventListener('pointerdown', onPointerDown)
    canvas.removeEventListener('pointerup', onPointerUp)
    document.removeEventListener('pointermove', onGlobalPointerMove)
    document.removeEventListener('scroll', onGlobalScroll, true)
    window.removeEventListener('pointerup', onPointerUp)
    window.removeEventListener('pointercancel', onPointerUp)
    controls.dispose()
    pmrem.dispose()
    glowTexture.dispose()
    shadowTexture.dispose()
    markers.forEach((marker) => {
      marker.hit.geometry.dispose()
      marker.hit.material.dispose()
      marker.glow.material.dispose()
      marker.halo.material.dispose()
    })
    floor.geometry.dispose()
    floor.material.dispose()
    composer?.dispose()
    renderer.dispose()
  }

  return {
    dispose,
    resize,
    setVisible: () => {
      visible = true
    },
    setStageHovered,
    select: applySelection,
    getSelected: () => selectedId,
  }
}

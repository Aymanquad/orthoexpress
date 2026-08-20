import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:three_js/three_js.dart' as three;
import 'package:visibility_detector/visibility_detector.dart';

import '../../../data/skeleton_joints.dart';
import '../../../data/skeleton_labels.dart';
import 'skeleton_stage.dart';

const _hitRadius = 0.58;
const _framePadding = 1.32;
const _idleResumeSeconds = 3.0;

Uint8List? _cachedSkeletonGlbBytes;

void registerSkeleton3d() {
  skeletonStageBuilder =
      ({
        Key? key,
        required Size canvasSize,
        required bool allowOrbit,
        required String? selectedId,
        required String lang,
        required ValueChanged<String?> onSelect,
        SkeletonHotspotProjected? onHotspotProjected,
      }) {
        return SkeletonStage3d(
          key: key,
          canvasSize: canvasSize,
          selectedId: selectedId,
          lang: lang,
          onSelect: onSelect,
          onHotspotProjected: onHotspotProjected,
        );
      };
}

class SkeletonStage3d extends StatefulWidget {
  final Size canvasSize;
  final String? selectedId;
  final String lang;
  final ValueChanged<String?> onSelect;
  final SkeletonHotspotProjected? onHotspotProjected;

  const SkeletonStage3d({
    super.key,
    required this.canvasSize,
    required this.selectedId,
    required this.lang,
    required this.onSelect,
    this.onHotspotProjected,
  });

  @override
  State<SkeletonStage3d> createState() => _SkeletonStage3dState();
}

class _SkeletonStage3dState extends State<SkeletonStage3d>
    with WidgetsBindingObserver {
  three.ThreeJS? _three;
  three.Group? _modelRoot;
  three.OrbitControls? _controls;
  three.Raycaster? _raycaster;
  three.Vector2? _pointer;

  final _hits = <three.Mesh>[];
  final _glows = <String, three.Mesh>{};
  final _bones = <String, three.Object3D>{};
  final _groups = <String, three.Group>{};
  final _defaultCam = three.Vector3();
  final _defaultTarget = three.Vector3();
  final _camStartPos = three.Vector3();
  final _camStartTarget = three.Vector3();
  final _camGoalPos = three.Vector3();
  final _camGoalTarget = three.Vector3();
  final _projectTmp = three.Vector3();
  final _visibilityKey = UniqueKey();

  bool _ready = false;
  bool _failed = false;
  bool _activated = false;
  bool _reduceMotion = false;
  bool _restartQueued = false;
  double _camT = 1;
  double _frameDistance = 12;
  double _idleSeconds = _idleResumeSeconds;
  Offset? _pointerDown;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Wait for VisibilityDetector so ANGLE is not created off-screen.
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controls?.dispose();
    _disposeEngine(_three);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final show = state == AppLifecycleState.resumed;
    _three?.pause = !show;
    _three?.isVisibleOnScreen = show;
  }

  @override
  void didUpdateWidget(covariant SkeletonStage3d oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedId != widget.selectedId) {
      _syncSelection(widget.selectedId);
    }
    // Recreating the ANGLE context on Android after a layout pass often
    // destroys the surface (Lost connection / black stage). Keep the first size.
    if (!_isMobile && _sizeChanged(oldWidget.canvasSize, widget.canvasSize)) {
      _queueEngineRestart();
    }
  }

  bool get _isMobile =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  bool _sizeChanged(Size a, Size b) {
    return (a.width - b.width).abs() > 2 || (a.height - b.height).abs() > 2;
  }

  void _clearSceneRefs() {
    _modelRoot = null;
    _raycaster = null;
    _pointer = null;
    _hits.clear();
    _glows.clear();
    _bones.clear();
    _groups.clear();
    _camT = 1;
    _pointerDown = null;
  }

  void _queueEngineRestart() {
    if (!_activated || _restartQueued) return;
    _restartQueued = true;
    final oldThree = _three;
    final oldControls = _controls;
    _three = null;
    _controls = null;
    _clearSceneRefs();
    _ready = false;
    _failed = false;
    _activated = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        oldControls?.dispose();
      } catch (_) {}
      _disposeEngine(oldThree);
      _restartQueued = false;
      if (mounted) _activate();
    });
  }

  void _disposeEngine(three.ThreeJS? engine) {
    if (engine == null) return;
    try {
      engine.dispose();
    } catch (error) {
      debugPrint('Skeleton engine dispose skipped: $error');
    }
  }

  void _activate() {
    if (_activated || !mounted) return;
    if (widget.canvasSize.width < 8 || widget.canvasSize.height < 8) return;
    _activated = true;
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    final rawDpr = MediaQuery.devicePixelRatioOf(context);
    final conservativeGl = _isMobile || defaultTargetPlatform == TargetPlatform.windows;
    final dpr = conservativeGl ? 1.0 : math.min(rawDpr, 2).toDouble();
    try {
      _three = three.ThreeJS(
        size: Size(
          widget.canvasSize.width.floorToDouble(),
          widget.canvasSize.height.floorToDouble(),
        ),
        settings: three.Settings(
          alpha: false,
          antialias: !conservativeGl,
          stencil: false,
          depth: true,
          animate: true,
          useSourceTexture: true,
          enableShadowMap: false,
          clearColor: 0x070b18,
          clearAlpha: 1,
          screenResolution: dpr,
          toneMappingExposure: 1.02,
          renderOptions: const {
            'samples': 0,
            'depthBuffer': true,
            'stencilBuffer': false,
          },
        ),
        loadingWidget: const SizedBox.expand(),
        onSetupComplete: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _initControls();
            setState(() => _ready = true);
            _syncSelection(widget.selectedId);
          });
        },
        setup: () async {
          try {
            await _setup();
          } catch (error, stack) {
            debugPrint('Skeleton setup failed: $error\n$stack');
            if (mounted) setState(() => _failed = true);
          }
        },
      );
      setState(() {});
    } catch (_) {
      setState(() => _failed = true);
    }
  }

  Future<void> _setup() async {
    final threeJs = _three!;
    threeJs.scene = three.Scene();
    threeJs.camera = three.PerspectiveCamera(
      34,
      threeJs.width / math.max(threeJs.height, 1),
      0.1,
      250,
    );

    threeJs.scene.add(three.AmbientLight(0xc8d0e8, 0.62));
    final key = three.DirectionalLight(0xfff4ea, 1.22);
    key.position.setValues(3.8, 7.4, 6.2);
    threeJs.scene.add(key);
    final fill = three.DirectionalLight(0x9eb0d8, 0.38);
    fill.position.setValues(-6.2, 2.4, 1.6);
    threeJs.scene.add(fill);
    final rim = three.DirectionalLight(0xdce6ff, 0.28);
    rim.position.setValues(0.4, 5.2, -7.4);
    threeJs.scene.add(rim);

    final gltf = await _loadSkeletonGltf();
    if (!mounted || gltf == null) {
      throw StateError('Skeleton GLB missing');
    }

    final model = gltf.scene;
    model.traverse((obj) {
      obj.frustumCulled = false;
      obj.castShadow = false;
      obj.receiveShadow = false;
      final mat = obj.material;
      if (mat != null) {
        mat.flatShading = false;
        mat.roughness = math.min(mat.roughness, 0.78);
        mat.metalness = 0.06;
        mat.envMapIntensity = 0.28;
        mat.needsUpdate = true;
      }
    });

    final modelRoot = three.Group();
    modelRoot.add(model);
    threeJs.scene.add(modelRoot);
    model.updateMatrixWorld(true);
    _modelRoot = modelRoot;

    final box = _boneBox(model) ?? _objectBox(modelRoot);
    final sx = box.max.x - box.min.x;
    final sy = box.max.y - box.min.y;
    final sz = box.max.z - box.min.z;
    final cx = (box.max.x + box.min.x) / 2;
    final cy = (box.max.y + box.min.y) / 2;
    final cz = (box.max.z + box.min.z) / 2;
    modelRoot.position.setValues(-cx, -cy, -cz);
    final scale = 10.4 / math.max(sy, math.max(sx, math.max(sz, 1)));
    modelRoot.scale.setValues(scale, scale, scale);
    modelRoot.updateMatrixWorld(true);

    _raycaster = three.Raycaster();
    _pointer = three.Vector2();
    _attachHotspots(model);

    final fitted = _boneBox(modelRoot) ?? _objectBox(modelRoot);
    final floor = three.Mesh(
      three.CircleGeometry(radius: 3.15, segments: 64),
      three.MeshBasicMaterial.fromMap({
        'color': 0x10183a,
        'transparent': true,
        'opacity': 0.42,
        'depthWrite': false,
      }),
    );
    floor.rotation.x = -math.pi / 2;
    floor.position.y = fitted.min.y + 0.02;
    threeJs.scene.add(floor);

    _frameCamera();

    threeJs.addAnimationEvent((dt) {
      if (!mounted || _modelRoot == null) return;
      _syncHotspotPositions();
      _tickCamera(dt);
      _tickIdleRotate(dt);
      _controls?.update();
      _pulseGlows();
      _reportHotspotProjection();
    });

    _syncSelection(widget.selectedId);
  }

  Future<three.GLTFData?> _loadSkeletonGltf() async {
    const assetPath = 'assets/models/male_skeleton.glb';
    try {
      _cachedSkeletonGlbBytes ??= await _readAssetBytes(assetPath);
      final parsed = await three.GLTFLoader().fromBytes(_cachedSkeletonGlbBytes!);
      if (parsed != null) return parsed;
    } catch (error) {
      debugPrint('Skeleton bytes load failed: $error');
    }
    for (var attempt = 0; attempt < 3; attempt++) {
      final gltf = await three.GLTFLoader().fromAsset(assetPath);
      if (gltf != null) return gltf;
      await Future<void>.delayed(Duration(milliseconds: 140 * (attempt + 1)));
    }
    return null;
  }

  Future<Uint8List> _readAssetBytes(String assetPath) async {
    final packed = await rootBundle.load(assetPath);
    return packed.buffer.asUint8List(
      packed.offsetInBytes,
      packed.lengthInBytes,
    );
  }

  void _attachHotspots(three.Object3D model) {
    final hotspotRoot = three.Group();
    _three!.scene.add(hotspotRoot);

    for (final joint in skeletonJoints) {
      final bone = _findNode(model, joint.bone);
      if (bone == null) continue;
      _bones[joint.id] = bone;

      final group = three.Group();
      bone.getWorldPosition(group.position);
      group.position.x += joint.offset[0];
      group.position.y += joint.offset[1];
      group.position.z += joint.offset[2];

      final outerGlow = three.Mesh(
        three.SphereGeometry(0.22, 16, 16),
        three.MeshBasicMaterial.fromMap({
          'color': 0xff6b6b,
          'transparent': true,
          'opacity': 0.16,
          'depthWrite': false,
          'depthTest': false,
          'blending': three.AdditiveBlending,
        }),
      );
      outerGlow.renderOrder = 3;
      outerGlow.frustumCulled = false;

      final glow = three.Mesh(
        three.SphereGeometry(0.12, 16, 16),
        three.MeshBasicMaterial.fromMap({
          'color': 0xff7474,
          'transparent': true,
          'opacity': 0.44,
          'depthWrite': false,
          'depthTest': false,
          'blending': three.AdditiveBlending,
        }),
      );
      glow.renderOrder = 4;
      glow.frustumCulled = false;

      final hit = three.Mesh(
        three.SphereGeometry(_hitRadius, 12, 12),
        three.MeshBasicMaterial.fromMap({
          'color': 0xff3b3b,
          'transparent': true,
          'opacity': 0.01,
          'depthWrite': false,
          'depthTest': false,
        }),
      );
      hit.userData['hotspotId'] = joint.id;
      hit.frustumCulled = false;
      hit.renderOrder = 5;

      group.add(outerGlow);
      group.add(glow);
      group.add(hit);
      hotspotRoot.add(group);
      _hits.add(hit);
      _glows[joint.id] = glow;
      _groups[joint.id] = group;
    }
    _syncHotspotPositions();
  }

  void _syncHotspotPositions() {
    final tmp = three.Vector3();
    _modelRoot?.updateMatrixWorld(true);
    for (final joint in skeletonJoints) {
      final bone = _bones[joint.id];
      final group = _groups[joint.id];
      if (bone == null || group == null) continue;
      bone.getWorldPosition(tmp);
      group.position.setValues(
        tmp.x + joint.offset[0],
        tmp.y + joint.offset[1],
        tmp.z + joint.offset[2],
      );
    }
  }

  void _pulseGlows() {
    final t = DateTime.now().millisecondsSinceEpoch / 1000;
    final pulse = 0.88 + math.sin(t * 1.55) * 0.12;
    _glows.forEach((id, mesh) {
      final selected = id == widget.selectedId;
      final mat = mesh.material;
      if (mat != null) {
        mat.opacity = selected ? 0.92 : 0.44 * pulse;
        mat.needsUpdate = true;
      }
      final s = selected ? 1.35 : (0.94 + pulse * 0.08);
      mesh.scale.setValues(s, s, s);
      final outer = mesh.parent?.children.first;
      if (outer is three.Mesh) {
        final outerMat = outer.material;
        if (outerMat != null) {
          outerMat.opacity = selected ? 0.28 : 0.14 * pulse;
          outerMat.needsUpdate = true;
        }
        final os = selected ? 1.28 : (0.98 + pulse * 0.06);
        outer.scale.setValues(os, os, os);
      }
    });
  }

  void _tickIdleRotate(double dt) {
    final controls = _controls;
    if (controls == null || _reduceMotion) return;
    if (widget.selectedId != null || _pointerDown != null) {
      _idleSeconds = 0;
      controls.autoRotate = false;
      return;
    }
    _idleSeconds += dt;
    controls.autoRotate = _idleSeconds >= _idleResumeSeconds;
  }

  void _initControls() {
    final threeJs = _three;
    if (threeJs == null || _controls != null) return;
    if (threeJs.globalKey.currentState == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _initControls();
      });
      return;
    }

    try {
      final controls = three.OrbitControls(threeJs.camera, threeJs.globalKey);
      controls.enableDamping = true;
      controls.dampingFactor = 0.12;
      controls.enablePan = false;
      controls.enableZoom = true;
      controls.zoomSpeed = 0.7;
      controls.enableRotate = true;
      controls.rotateSpeed = 0.62;
      controls.autoRotate = false;
      controls.autoRotateSpeed = 1.4;
      controls.minPolarAngle = 0.85;
      controls.maxPolarAngle = math.pi / 1.78;
      controls.minDistance = _frameDistance * 0.58;
      controls.maxDistance = _frameDistance * 1.85;
      controls.target.setFrom(_defaultTarget);
      controls.update();
      _controls = controls;

      threeJs.domElement.addEventListener(
        three.PeripheralType.pointerdown,
        _onPointerDown,
      );
      threeJs.domElement.addEventListener(
        three.PeripheralType.pointerup,
        _onPointerUp,
      );
    } catch (error, stack) {
      debugPrint('Skeleton controls failed: $error\n$stack');
    }
  }

  void _onPointerDown(dynamic event) {
    final x = (event.clientX as num?)?.toDouble();
    final y = (event.clientY as num?)?.toDouble();
    if (x == null || y == null) return;
    _pointerDown = Offset(x, y);
    _idleSeconds = 0;
  }

  void _onPointerUp(dynamic event) {
    final down = _pointerDown;
    _pointerDown = null;
    if (down == null) return;
    final x = (event.clientX as num?)?.toDouble();
    final y = (event.clientY as num?)?.toDouble();
    if (x == null || y == null) return;
    if ((Offset(x, y) - down).distance > 6) return;
    _handleTap(Offset(x, y));
  }

  void _frameCamera() {
    final threeJs = _three;
    final root = _modelRoot;
    if (threeJs == null || root == null) return;
    final box = _boneBox(root) ?? _objectBox(root);
    final sx = box.max.x - box.min.x;
    final sy = box.max.y - box.min.y;
    final sz = box.max.z - box.min.z;
    final cx = (box.max.x + box.min.x) / 2;
    final cy = (box.max.y + box.min.y) / 2;
    final cz = (box.max.z + box.min.z) / 2;
    final radius = math.max(sx, math.max(sy, sz)) * 0.5;
    final cam = threeJs.camera as three.PerspectiveCamera;
    final vFov = cam.fov * math.pi / 180;
    final fitHeight = radius / math.tan(vFov / 2);
    final fitWidth = fitHeight / math.max(cam.aspect, 0.01);
    final distance = math.max(fitHeight, fitWidth) * _framePadding;
    _frameDistance = distance;
    cam.near = math.max(0.05, distance / 80);
    cam.far = distance * 24;
    cam.updateProjectionMatrix();
    cam.position.setValues(
      cx + distance * 0.16,
      cy + distance * 0.02,
      cz + distance,
    );
    final target = three.Vector3(cx, cy, cz);
    cam.lookAt(target);
    _defaultCam.setFrom(cam.position);
    _defaultTarget.setFrom(target);
    _camGoalPos.setFrom(cam.position);
    _camGoalTarget.setFrom(target);
    _camT = 1;
    _applyCamera(cam.position, target);
  }

  void _applyCamera(three.Vector3 pos, three.Vector3 target) {
    final threeJs = _three;
    if (threeJs == null) return;
    threeJs.camera.position.setFrom(pos);
    final controls = _controls;
    if (controls != null) {
      controls.target.setFrom(target);
      controls.update();
    } else {
      threeJs.camera.lookAt(target);
    }
  }

  void _beginCameraMove(three.Vector3 goalPos, three.Vector3 goalTarget) {
    final threeJs = _three;
    if (threeJs == null) return;
    _camStartPos.setFrom(threeJs.camera.position);
    _camStartTarget.setFrom(_controls?.target ?? _defaultTarget);
    _camGoalPos.setFrom(goalPos);
    _camGoalTarget.setFrom(goalTarget);
    if (_reduceMotion) {
      _camT = 1;
      _applyCamera(goalPos, goalTarget);
      return;
    }
    _camT = 0;
  }

  void _tickCamera(double dt) {
    if (_camT >= 1) return;
    _camT = math.min(1, _camT + dt * 2.1);
    final e = _camT * _camT * (3 - 2 * _camT);
    final pos = three.Vector3(
      _camStartPos.x + (_camGoalPos.x - _camStartPos.x) * e,
      _camStartPos.y + (_camGoalPos.y - _camStartPos.y) * e,
      _camStartPos.z + (_camGoalPos.z - _camStartPos.z) * e,
    );
    final target = three.Vector3(
      _camStartTarget.x + (_camGoalTarget.x - _camStartTarget.x) * e,
      _camStartTarget.y + (_camGoalTarget.y - _camStartTarget.y) * e,
      _camStartTarget.z + (_camGoalTarget.z - _camStartTarget.z) * e,
    );
    _applyCamera(pos, target);
  }

  void _focusJoint(String id) {
    final group = _groups[id];
    final threeJs = _three;
    final root = _modelRoot;
    if (group == null || threeJs == null || root == null) return;
    _syncHotspotPositions();
    final world = three.Vector3();
    group.getWorldPosition(world);
    final box = _boneBox(root) ?? _objectBox(root);
    final cx = (box.max.x + box.min.x) / 2;
    final cy = (box.max.y + box.min.y) / 2;
    final cz = (box.max.z + box.min.z) / 2;
    final sx = box.max.x - box.min.x;
    final sy = box.max.y - box.min.y;
    final sz = box.max.z - box.min.z;
    final span = math.sqrt(sx * sx + sy * sy + sz * sz);
    final distance = math.max(5.6, span * 0.34);
    final joint = skeletonJointById(id);
    final side = joint?.side ?? 0;
    final lookAt = three.Vector3(
      world.x * 0.72 + cx * 0.28,
      world.y * 0.72 + cy * 0.28,
      world.z * 0.72 + cz * 0.28,
    );
    var ox = side * 0.58;
    if (ox == 0) ox = 0.22;
    var oy = 0.18;
    var oz = 1.55;
    final len = math.sqrt(ox * ox + oy * oy + oz * oz);
    final goalPos = three.Vector3(
      lookAt.x + ox / len * distance,
      lookAt.y + oy / len * distance,
      lookAt.z + oz / len * distance,
    );
    _controls?.minDistance = math.min(distance * 0.72, _frameDistance * 0.58);
    _beginCameraMove(goalPos, lookAt);
  }

  void _resetCamera() {
    _controls?.minDistance = _frameDistance * 0.58;
    _beginCameraMove(_defaultCam, _defaultTarget);
  }

  void _syncSelection(String? id) {
    if (!_ready && id == null) return;
    if (id != null) {
      _focusJoint(id);
    } else {
      _resetCamera();
    }
    _controls?.autoRotate = id == null && !_reduceMotion && _idleSeconds >= _idleResumeSeconds;
  }

  void _reportHotspotProjection() {
    final callback = widget.onHotspotProjected;
    if (callback == null) return;
    final id = widget.selectedId;
    final threeJs = _three;
    if (id == null || threeJs == null || !_ready) return;
    final group = _groups[id];
    if (group == null) {
      callback(null, null);
      return;
    }
    group.getWorldPosition(_projectTmp);
    _projectTmp.project(threeJs.camera);
    if (_projectTmp.z < -1 || _projectTmp.z > 1) {
      callback(null, null);
      return;
    }
    final w = threeJs.width;
    final h = threeJs.height;
    if (w <= 0 || h <= 0) return;
    callback(
      id,
      Offset(
        (_projectTmp.x * 0.5 + 0.5) * w,
        (-_projectTmp.y * 0.5 + 0.5) * h,
      ),
    );
  }

  void _handleTap(Offset local) {
    final threeJs = _three;
    final raycaster = _raycaster;
    final pointer = _pointer;
    if (threeJs == null ||
        raycaster == null ||
        pointer == null ||
        _hits.isEmpty ||
        !_ready) {
      return;
    }
    final w = threeJs.width;
    final h = threeJs.height;
    if (w <= 0 || h <= 0) return;
    pointer.setValues((local.dx / w) * 2 - 1, -(local.dy / h) * 2 + 1);
    raycaster.setFromCamera(pointer, threeJs.camera);
    final hits = raycaster.intersectObjects(
      List<three.Object3D>.from(_hits),
      false,
    );
    if (hits.isEmpty) {
      if (widget.selectedId != null) widget.onSelect(null);
      return;
    }
    final id = hits.first.object?.userData['hotspotId'] as String?;
    if (id == null) return;
    widget.onSelect(widget.selectedId == id ? null : id);
  }

  three.Object3D? _findNode(three.Object3D root, String boneName) {
    three.Object3D? exact;
    three.Object3D? partial;
    final short = boneName.replaceAll(RegExp(r'_\d+$'), '');
    root.traverse((obj) {
      if (obj.name == boneName) {
        exact = obj;
      } else if (partial == null &&
          obj.name.isNotEmpty &&
          (obj.name.startsWith(short) || obj.name.contains(short))) {
        partial = obj;
      }
    });
    return exact ?? partial;
  }

  three.BoundingBox _objectBox(three.Object3D root) {
    final box = three.BoundingBox();
    final tmp = three.Vector3();
    var count = 0;
    root.traverse((obj) {
      obj.getWorldPosition(tmp);
      box.expandByPoint(tmp);
      count += 1;
    });
    if (count == 0) {
      box.min.setValues(-1, -1, -1);
      box.max.setValues(1, 1, 1);
    }
    return box;
  }

  three.BoundingBox? _boneBox(three.Object3D root) {
    final box = three.BoundingBox();
    final tmp = three.Vector3();
    var count = 0;
    root.traverse((obj) {
      if (obj is three.Bone) {
        obj.getWorldPosition(tmp);
        box.expandByPoint(tmp);
        count += 1;
      }
    });
    if (count < 4 || box.isEmpty()) return null;
    return box;
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return ColoredBox(
        color: const Color(0xFF0C1650),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              SkeletonLabels.error.forLang(widget.lang),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xCCEEF2FF)),
            ),
          ),
        ),
      );
    }

    return VisibilityDetector(
      key: _visibilityKey,
      onVisibilityChanged: (info) {
        final show = info.visibleFraction > 0.08;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          if (show && !_activated) _activate();
          _three?.pause = !show;
          _three?.isVisibleOnScreen = show;
        });
      },
      child: SizedBox(
        width: widget.canvasSize.width,
        height: widget.canvasSize.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_three != null)
              RepaintBoundary(child: _three!.build())
            else
              const ColoredBox(color: Color(0x00000000)),
            if (!_ready)
              AbsorbPointer(
                child: ColoredBox(
                  color: const Color(0x8A070B1C),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: Color(0xFFC4D2FF),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        SkeletonLabels.loading.forLang(widget.lang),
                        style: const TextStyle(
                          color: Color(0xE6EEF2FF),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

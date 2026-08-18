Cursor Prompt — Interactive 3D Skeleton Viewer (Angular + Three.js)
Before you paste this into Cursor
Model file: src/assets/models/male-skeleton.glb (2k texture version).
Important — verified mesh structure: this model is NOT segmented per-bone. It only has 14 region-level skinnedMeshes: ArmsHands, HipsLegs, Sacrum, HipCartilage, Discs, Ribs, Sternum, RibCartilage, Spine, Hyoid, Cranium, UpperTeeth, Mandible, LowerTeeth — left/right are NOT split, and individual joints (shoulder, elbow, hip, knee) are fused into ArmsHands / HipsLegs.
Because of that, this prompt uses coordinate-based hotspot markers instead of raycasting the skin mesh directly — small invisible spheres placed at each joint position, positioned once by eye in the Three.js scene (or in Blender against the model, then hand the local coordinates to Cursor). This is standard practice for anatomy viewers even on fully-segmented models, since a "joint" (shoulder, knee) is a point on a bone, not a mesh boundary.
You'll need to place those coordinates yourself once — see the JOINT_HOTSPOTS stub below, fill in real [x, y, z] values after eyeballing them against the loaded model (e.g. temporarily render the markers as visible red spheres, nudge positions until they sit right, then set visible: false).

Paste everything below into Cursor as one prompt, editing JOINT_HOTSPOTS first.

PROMPT START

I'm building a feature in an Angular 22 standalone-components app (NestJS backend, not relevant to this file). I need an interactive 3D skeleton viewer component.

Goal

A component SkeletonViewerComponent that:

Loads assets/models/male-skeleton.glb into a Three.js scene rendered on a <canvas> filling its parent container. Note: this glb has only 14 region-level skinnedMeshes (arms/legs/spine/etc, not per-joint) — so do NOT raycast against the skin mesh for hotspot detection. Instead, create one small invisible marker (SphereGeometry, radius ~0.02–0.04 in model units, visible: false or opacity: 0 material) per joint, positioned at the JOINT_HOTSPOTS coordinates below, parented into the model's scale-0.01 group so they move with rotation. Raycast against these marker objects only.
Auto-rotates slowly when idle; user can drag to rotate freely (OrbitControls, damping enabled, auto-rotate pauses on user interaction and resumes after 3s idle).
On hover over a joint marker: render a small visible highlight ring/dot at that marker's position (a separate always-visible mesh, distinct from the invisible hit-test sphere), cursor becomes a pointer, and a thin leader line is drawn from the marker's position out to a floating label showing the joint's display name.
On click of a joint marker:
Camera smoothly animates (tween, ~600ms, easeInOutCubic) to focus/zoom on that bone from a nice angle.
An info panel slides in (from the right on desktop, bottom sheet on mobile) showing injury data for that bone, sourced from an @Input() injuryData: Record<string, InjuryInfo> map keyed by mesh name.
The leader line stays connected from the bone to the panel's anchor point while the panel is open, and updates on every render frame if the camera moves.
Clicking elsewhere on the model, or an explicit close (X) button, closes the panel, clears the highlight, and animates the camera back to the default framing.
Emits an @Output() jointSelected = new EventEmitter<string>() whenever a joint marker is clicked, so parent components can react (e.g. log analytics, sync with a 2D chart).
Tech requirements
Use three (already available or install via npm) with GLTFLoader, OrbitControls from three/examples/jsm/controls/OrbitControls, and Raycaster for pointer picking.
Use gsap for camera tween/zoom animation and panel slide animation (install if not present) — smoother easing control than raw Three.js tweening.
Wrap the Three.js render loop in NgZone.runOutsideAngular() and only re-enter the Angular zone when updating component state that affects template bindings (e.g. selectedBone, panel visibility) — this is critical for perf, don't let requestAnimationFrame trigger change detection every frame.
Use ViewChild + AfterViewInit to get the canvas element; dispose the renderer, controls, and remove event listeners in ngOnDestroy to avoid memory leaks on route navigation.
Debounce/throttle the pointermove raycast check (e.g. only raycast every other frame) so hover detection doesn't tank frame rate on lower-end devices.
Make the canvas responsive: use ResizeObserver on the container to update camera aspect ratio and renderer size, not just a window resize listener.
Add basic lighting: one ambient light + one directional key light + a soft fill light, so the bone material (off-white, slight roughness, subtle specular) reads clearly against a neutral/dark background matching a healthcare UI (I'll hand you exact hex values from our design system separately).
Joint hotspot coordinates (fill in real [x,y,z] values — see step 4 in "Before you paste" above)
ts
// Coordinates are in the model's local space, inside the scale(0.01) group.
// Placeholder values below — MUST be replaced by eyeballing against the loaded model.
export interface JointHotspot {
  id: string;
  label: string;
  position: [number, number, number];
}

export const JOINT_HOTSPOTS: JointHotspot[] = [
  { id: 'shoulder_l', label: 'Left Shoulder', position: [0, 0, 0] },
  { id: 'shoulder_r', label: 'Right Shoulder', position: [0, 0, 0] },
  { id: 'elbow_l', label: 'Left Elbow', position: [0, 0, 0] },
  { id: 'elbow_r', label: 'Right Elbow', position: [0, 0, 0] },
  { id: 'wrist_l', label: 'Left Wrist', position: [0, 0, 0] },
  { id: 'wrist_r', label: 'Right Wrist', position: [0, 0, 0] },
  { id: 'hip_l', label: 'Left Hip', position: [0, 0, 0] },
  { id: 'hip_r', label: 'Right Hip', position: [0, 0, 0] },
  { id: 'knee_l', label: 'Left Knee', position: [0, 0, 0] },
  { id: 'knee_r', label: 'Right Knee', position: [0, 0, 0] },
  { id: 'ankle_l', label: 'Left Ankle', position: [0, 0, 0] },
  { id: 'ankle_r', label: 'Right Ankle', position: [0, 0, 0] },
  { id: 'spine', label: 'Spine', position: [0, 0, 0] },
  { id: 'skull', label: 'Skull', position: [0, 0, 0] },
];

Tell Cursor explicitly: "Add a temporary debug mode (?debugHotspots=true query param or a dev-only toggle) that renders each JOINT_HOTSPOTS marker as a bright visible red sphere, so I can nudge the position values and see them update live before switching to production (invisible hit-sphere + separate highlight-ring) rendering." This makes placing the coordinates by eye ten times faster than guessing blind.

File structure to generate
src/app/features/skeleton-viewer/skeleton-viewer.component.ts (standalone component, OnPush change detection)
src/app/features/skeleton-viewer/skeleton-viewer.component.html
src/app/features/skeleton-viewer/skeleton-viewer.component.scss
src/app/features/skeleton-viewer/joint-hotspots.const.ts (the array above)
src/app/features/skeleton-viewer/models/injury-info.model.ts (the InjuryInfo interface — leave fields minimal like title, description, severity, since I'll wire real data separately)
Interaction polish to include
Cursor changes to pointer only when hovering a joint marker, grab/grabbing when dragging to rotate.
Small scale-pulse (1.0 → 1.4 → 1.0, ~400ms) on the highlight-ring mesh on click, as a "selected" confirmation before the panel opens.
If two markers are close together in screen space, pick the nearest raycast hit only — don't multi-select. Also raise Raycaster.params.Points / sphere hit radius slightly (or use THREE.Sphere intersection instead of exact mesh intersection) so small markers are easy to hit precisely on both desktop and touch.

Please scaffold all of this now, keeping the render/interaction logic isolated in the component (no service needed yet — I'll extract one later if I reuse this viewer elsewhere).

PROMPT END
ROUND 2 — FIXES (paste this after reviewing the first build)

Context: you built this in React (not Angular, correct call given the site's stack) and placed it after "How we care for you." The hotspot marker approach is right. Three things need fixing before this ships.

1. Initial camera framing is off

Right now the skeleton loads cropped/off-center (head near top edge, legs cut at the bottom). Fix: after loading the model, compute its bounding box (new THREE.Box3().setFromObject(model)), get its center and size, and position the camera + OrbitControls.target so the entire skeleton fits inside the canvas with even padding on all sides, front-facing, on initial load — do this dynamically from the bounding box, don't hardcode a camera position that only happens to work for this one model. Recompute on canvas resize too.

2. Layout — clean up the two-panel structure

Restructure so:

The joint buttons (currently a wrapping row below the model) move to a vertical list docked on the right-hand side of the viewer, next to the model.
The injury-info display becomes a clean rectangular panel docked on the left-hand side (see point 3 below for what goes inside it — not the current card style).
Model stays centered between the two. This reads much cleaner than the current bottom-chip-row + floating-right-card layout, and scales better if more joints get added later.
Keep the chip/button list as the accessibility + mobile fallback (that part is good, keep it), just move its position.
3. The actual point — hover/click ON the model isn't working, and the panel style is wrong

Two bugs, both important:

a) Hover/click on the 3D skeleton itself does nothing. Only the button chips trigger the info panel right now. This defeats the whole feature — the point is a user can hover/click the physical joint on the model, not just a text button. Debug the raycaster: check that (1) the hotspot marker meshes are actually being added to the scene and are intersect-able (not accidentally visible: false in a way that also excludes them from raycasting — use an invisible material with normal render/raycast behavior, not a hidden object), (2) the raycaster is checking against the marker array specifically (raycaster.intersectObjects(hotspotMarkers)) on both pointermove (hover) and click events on the canvas, and (3) pointer NDC coordinates are calculated relative to the canvas bounding rect, not the window — a common source of "raycaster silently hits nothing."

b) Add a 3D highlight so the user knows where to click. At each hotspot position, render a soft light-red glow — a translucent sphere or a radial-gradient sprite/decal (THREE.Sprite with a soft circular texture, or a low-opacity MeshBasicMaterial sphere with additive blending) sitting on the skeleton's surface at that joint. Keep it subtle at rest (low opacity, maybe a slow pulse) and brighten it on hover. This is the visual cue that the model itself is clickable, not just the button list.

c) Replace the current white card-with-shadow panel with the original spec: on hover or click, draw a clean thin white line from the joint point outward to the injury info, and show the text directly beside/at the end of that line — not inside a bordered/shadowed card. Think medical-diagram callout style: a straight or slightly-angled white line from the exact joint position to a label point in open space, with the injury text (common injuries, approach, learn more, book) laid out plainly next to the line's endpoint, no card chrome around it. The line should animate drawing itself (grow from joint → endpoint, ~300–400ms) on hover, and stay locked in place with the fuller info revealed on click. This should visually feel like it's pointing out of the skeleton, not popping up a UI card next to it.

ROUND 3 — FLUTTER NATIVE 3D RENDERING PARITY FIX

Context: the same .glb renders correctly (clean off-white bones, soft lighting, subtle joint highlights) in the web build using Three.js, but looks noticeably worse in the Flutter app — yellow/orange-tinted bones, harsh single-direction lighting, and solid opaque red dot markers at the joints instead of soft highlights. This is almost certainly because the Flutter mobile viewer is a different rendering engine/package than the web Three.js scene, with its own default lighting and material handling — same file, different renderer, different result.

Step 1 — diagnose first, don't guess

Before changing anything, report back: which package/widget is currently rendering the 3D model in the Flutter app (e.g. model_viewer_plus, flutter_3d_controller, a Filament-based viewer, a custom flutter_gl/OpenGL setup, or something else)? What lighting/environment/tonemap options does that specific package expose? The fix approach depends entirely on this — some packages (Filament-based ones) expose exposure/shadow/IBL controls directly; others only expose a fixed default light rig, which would explain the flat orange look and might mean a package swap is the real fix even though we're going native.

Step 2 — match material to web

The web bone material is a light ivory/off-white (not yellow or orange), low metalness, slight roughness, subtle specular highlight — not flat/matte and not glossy-orange. Check:

Whether the package is applying its own default material override on top of the glb's embedded materials (common cause of color shift).
Color temperature of the light source — many mobile 3D viewers default to a warm "sunlight" white balance; force it neutral/cool-white to match the web scene.
If the package supports an environment map / IBL (image-based lighting), use a neutral studio/soft environment rather than an outdoor/warm one — that alone often fixes the orange cast.
Step 3 — match lighting rig to web

Web setup is: one soft ambient light (fills shadows so nothing goes pure black) + one directional key light (main shape-defining light) + one soft fill light (reduces harsh shadow on the opposite side). Replicate this three-light balance in whatever the Flutter package allows — if it only supports a single light, that's the core limitation causing the harsh look, and worth flagging back to me before spending more time tuning it.

Step 4 — fix the joint hotspot markers

Currently solid opaque red spheres — replace with the same soft, translucent, low-opacity highlight the web build uses (glow ring or radial gradient decal, not a flat colored ball), subtle at rest, brightening slightly on tap. Should read as "this spot is interactive," not as a hard-edged red dot sitting on the bone.

Step 5 — verify background and framing

Confirm the scene background is the same dark navy as the design system (not a lighter/different navy from a default), and re-check the bounding-box auto-framing fix from Round 2 was also applied here — the mobile screenshots show the model reasonably centered but double check it's computed dynamically, not hardcoded separately from the web version's logic.

Step 6 — the ground shadow ellipse

There's a soft dark ellipse/halo under the feet in the mobile build that isn't present in the web screenshots. Confirm whether this is an intentional contact-shadow (fine to keep if it's subtle) or a default ground-reflection plane the package auto-adds (in which case either disable it or soften its opacity significantly to match the cleaner web look).

Report back after Step 1 with the package name before proceeding — the rest of the fix depends on what that package actually exposes.
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

Keep everything else as-is (idle rotation, drag-to-rotate, EN/ES copy, chip fallback, lazy-load at 13MB). Also go ahead and generate the Draco-compressed version of the glb now while you're in there — no reason to wait on that.
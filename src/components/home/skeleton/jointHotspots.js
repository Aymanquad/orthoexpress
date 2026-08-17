/**
 * Joint markers for the Sketchfab male skeleton GLB.
 *
 * The mesh is region-level only (ArmsHands, HipsLegs, Spine, …) — left/right
 * and individual joints are not separate meshes. Markers are parented to named
 * skeleton bones so they sit on the actual joints.
 *
 * Optional `offset` is local to the bone (model units, before the fit-to-frame
 * scale). Enable `?debugHotspots=true` to see red spheres and nudge offsets.
 */
export const JOINT_HOTSPOTS = [
  { id: 'shoulder_l', bone: 'lShldr_042', region: 'shoulder', slug: 'shoulder-elbow', side: 1, offset: [0, 0, 0] },
  { id: 'shoulder_r', bone: 'rShldr_018', region: 'shoulder', slug: 'shoulder-elbow', side: -1, offset: [0, 0, 0] },
  { id: 'elbow_l', bone: 'lForeArm_043', region: 'elbow', slug: 'shoulder-elbow', side: 1, offset: [0, 0, 0] },
  { id: 'elbow_r', bone: 'rForeArm_019', region: 'elbow', slug: 'shoulder-elbow', side: -1, offset: [0, 0, 0] },
  { id: 'wrist_l', bone: 'lHand_044', region: 'wrist', slug: 'hand-wrist-care', side: 1, offset: [0, 0, 0] },
  { id: 'wrist_r', bone: 'rHand_020', region: 'wrist', slug: 'hand-wrist-care', side: -1, offset: [0, 0, 0] },
  { id: 'hip_l', bone: 'lThigh_0100', region: 'hip', slug: 'hip-knee-care', side: 1, offset: [0, 0, 0] },
  { id: 'hip_r', bone: 'rThigh_083', region: 'hip', slug: 'hip-knee-care', side: -1, offset: [0, 0, 0] },
  { id: 'knee_l', bone: 'lPatella_0113', region: 'knee', slug: 'hip-knee-care', side: 1, offset: [0, 0, 0] },
  { id: 'knee_r', bone: 'rPatella_096', region: 'knee', slug: 'hip-knee-care', side: -1, offset: [0, 0, 0] },
  { id: 'ankle_l', bone: 'lFoot_0102', region: 'ankle', slug: 'foot-ankle-care', side: 1, offset: [0, 0, 0] },
  { id: 'ankle_r', bone: 'rFoot_085', region: 'ankle', slug: 'foot-ankle-care', side: -1, offset: [0, 0, 0] },
  { id: 'spine', bone: 'abdomen_03', region: 'spine', slug: 'lumbar-cervical-spine', side: 0, offset: [0, 0.18, 0.12] },
  { id: 'skull', bone: 'head_06', region: 'skull', slug: 'lumbar-cervical-spine', side: 0, offset: [0, 0.22, 0.08] },
]

export function getHotspot(id) {
  return JOINT_HOTSPOTS.find((item) => item.id === id) || null
}

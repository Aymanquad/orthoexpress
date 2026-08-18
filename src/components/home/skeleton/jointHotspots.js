/**
 * Joint markers for the Sketchfab male skeleton GLB.
 *
 * The mesh is region-level only (ArmsHands, HipsLegs, Spine, …) — left/right
 * and individual joints are not separate meshes. Markers are parented to named
 * skeleton bones so they sit on the actual joints.
 *
 * Optional `offset` is in model-local bone units. Enable `?debugHotspots=true`
 * to see red spheres and nudge positions.
 */
export const BODY_TOPICS = [
  { id: 'neck', hotspotIds: ['neck'] },
  { id: 'back', hotspotIds: ['back'] },
  { id: 'shoulder', hotspotIds: ['shoulder_l', 'shoulder_r'] },
  { id: 'head', hotspotIds: ['head'] },
  { id: 'knee', hotspotIds: ['knee_l', 'knee_r'] },
  { id: 'hip', hotspotIds: ['hip_l', 'hip_r'] },
  { id: 'wrist', hotspotIds: ['wrist_l', 'wrist_r'] },
  { id: 'soft_tissue', hotspotIds: ['soft_tissue'] },
  { id: 'elbow', hotspotIds: ['elbow_l', 'elbow_r'] },
  { id: 'ankle', hotspotIds: ['ankle_l', 'ankle_r'] },
]

export const JOINT_HOTSPOTS = [
  { id: 'neck', bone: 'neck_05', region: 'neck', slug: 'lumbar-cervical-spine', side: 0, offset: [0, 0, 0] },
  { id: 'back', bone: 'abdomen_03', region: 'back', slug: 'lumbar-cervical-spine', side: 0, offset: [0, 0.12, 0.1] },
  { id: 'head', bone: 'head_06', region: 'head', slug: 'pain-inflammation', side: 0, offset: [0, 0.18, 0.08] },
  { id: 'soft_tissue', bone: 'chest_04', region: 'soft_tissue', slug: 'muscle-soft-tissue-care', side: 0, offset: [0, 0, 0.12] },
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
]

export function getHotspot(id) {
  return JOINT_HOTSPOTS.find((item) => item.id === id) || null
}

export function getTopicForHotspot(id) {
  return BODY_TOPICS.find((topic) => topic.hotspotIds.includes(id)) || null
}

export function getPrimaryHotspotId(topicId) {
  const topic = BODY_TOPICS.find((item) => item.id === topicId)
  return topic?.hotspotIds[0] || null
}

export function isTopicActive(topicId, selectedHotspotId) {
  const topic = BODY_TOPICS.find((item) => item.id === topicId)
  return Boolean(topic && selectedHotspotId && topic.hotspotIds.includes(selectedHotspotId))
}

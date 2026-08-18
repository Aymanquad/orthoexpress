/// Joint markers for the Sketchfab male skeleton GLB — from web jointHotspots.js
class SkeletonJoint {
  final String id;
  final String bone;
  final String region;
  final String slug;
  final double side;
  final List<double> offset;

  const SkeletonJoint({
    required this.id,
    required this.bone,
    required this.region,
    required this.slug,
    required this.side,
    this.offset = const [0, 0, 0],
  });
}

class SkeletonTopic {
  final String id;
  final List<String> hotspotIds;

  const SkeletonTopic({required this.id, required this.hotspotIds});
}

const skeletonTopics = <SkeletonTopic>[
  SkeletonTopic(id: 'neck', hotspotIds: ['neck']),
  SkeletonTopic(id: 'back', hotspotIds: ['back']),
  SkeletonTopic(id: 'shoulder', hotspotIds: ['shoulder_l', 'shoulder_r']),
  SkeletonTopic(id: 'head', hotspotIds: ['head']),
  SkeletonTopic(id: 'knee', hotspotIds: ['knee_l', 'knee_r']),
  SkeletonTopic(id: 'hip', hotspotIds: ['hip_l', 'hip_r']),
  SkeletonTopic(id: 'wrist', hotspotIds: ['wrist_l', 'wrist_r']),
  SkeletonTopic(id: 'soft_tissue', hotspotIds: ['soft_tissue']),
  SkeletonTopic(id: 'elbow', hotspotIds: ['elbow_l', 'elbow_r']),
  SkeletonTopic(id: 'ankle', hotspotIds: ['ankle_l', 'ankle_r']),
];

const skeletonJoints = <SkeletonJoint>[
  SkeletonJoint(id: 'neck', bone: 'neck_05', region: 'neck', slug: 'lumbar-cervical-spine', side: 0),
  SkeletonJoint(
    id: 'back',
    bone: 'abdomen_03',
    region: 'back',
    slug: 'lumbar-cervical-spine',
    side: 0,
    offset: [0, 0.12, 0.1],
  ),
  SkeletonJoint(
    id: 'head',
    bone: 'head_06',
    region: 'head',
    slug: 'pain-inflammation',
    side: 0,
    offset: [0, 0.18, 0.08],
  ),
  SkeletonJoint(
    id: 'soft_tissue',
    bone: 'chest_04',
    region: 'soft_tissue',
    slug: 'muscle-soft-tissue-care',
    side: 0,
    offset: [0, 0, 0.12],
  ),
  SkeletonJoint(id: 'shoulder_l', bone: 'lShldr_042', region: 'shoulder', slug: 'shoulder-elbow', side: 1),
  SkeletonJoint(id: 'shoulder_r', bone: 'rShldr_018', region: 'shoulder', slug: 'shoulder-elbow', side: -1),
  SkeletonJoint(id: 'elbow_l', bone: 'lForeArm_043', region: 'elbow', slug: 'shoulder-elbow', side: 1),
  SkeletonJoint(id: 'elbow_r', bone: 'rForeArm_019', region: 'elbow', slug: 'shoulder-elbow', side: -1),
  SkeletonJoint(id: 'wrist_l', bone: 'lHand_044', region: 'wrist', slug: 'hand-wrist-care', side: 1),
  SkeletonJoint(id: 'wrist_r', bone: 'rHand_020', region: 'wrist', slug: 'hand-wrist-care', side: -1),
  SkeletonJoint(id: 'hip_l', bone: 'lThigh_0100', region: 'hip', slug: 'hip-knee-care', side: 1),
  SkeletonJoint(id: 'hip_r', bone: 'rThigh_083', region: 'hip', slug: 'hip-knee-care', side: -1),
  SkeletonJoint(id: 'knee_l', bone: 'lPatella_0113', region: 'knee', slug: 'hip-knee-care', side: 1),
  SkeletonJoint(id: 'knee_r', bone: 'rPatella_096', region: 'knee', slug: 'hip-knee-care', side: -1),
  SkeletonJoint(id: 'ankle_l', bone: 'lFoot_0102', region: 'ankle', slug: 'foot-ankle-care', side: 1),
  SkeletonJoint(id: 'ankle_r', bone: 'rFoot_085', region: 'ankle', slug: 'foot-ankle-care', side: -1),
];

SkeletonJoint? skeletonJointById(String id) {
  for (final joint in skeletonJoints) {
    if (joint.id == id) return joint;
  }
  return null;
}

String? primaryHotspotId(String topicId) {
  for (final topic in skeletonTopics) {
    if (topic.id == topicId) return topic.hotspotIds.first;
  }
  return null;
}

bool isTopicActive(String topicId, String? selectedHotspotId) {
  if (selectedHotspotId == null) return false;
  for (final topic in skeletonTopics) {
    if (topic.id == topicId) return topic.hotspotIds.contains(selectedHotspotId);
  }
  return false;
}

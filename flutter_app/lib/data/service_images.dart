// Service image rules — mirrors src/data/images.js + ServiceDetail.jsx

import 'package:flutter/material.dart';

class ServiceImageEntry {
  final String src;
  final String fallback;
  final String placement;
  final String? heroSrc;
  final String? bodySrc;
  final Alignment alignment;

  const ServiceImageEntry({
    required this.src,
    required this.fallback,
    this.placement = 'photo',
    this.heroSrc,
    this.bodySrc,
    this.alignment = Alignment.center,
  });

  /// Hero banner — never duplicates [bodyImage] on the same page.
  String? get heroImage {
    return heroSrc ?? (placement == 'photo' ? src : null);
  }

  /// Inline body figure — omitted for full-bleed photo services unless [bodySrc] is set.
  String? get bodyImage {
    if (bodySrc != null) return bodySrc;
    if (placement == 'photo') return null;
    final hero = heroImage;
    if (hero != null && hero == src) return null;
    return src;
  }
}

class ServiceImages {
  static const _clinical = 'assets/images/knee-injury.webp';
  static const _recovery = 'assets/images/recovery-after-orthopedicsurgery.jpg';
  static const _sports = 'assets/images/services/sports-medicine.avif';
  static const _jointWide = 'assets/images/joint-img.jpg';

  static const _entries = <String, ServiceImageEntry>{
    'pain-inflammation': ServiceImageEntry(
      src: 'assets/images/blogs/chronic-pain.webp',
      fallback: 'assets/images/services/arthritis.webp',
      placement: 'square',
      heroSrc: 'assets/images/services/pain-inflammation-long.jpg',
    ),
    'injuries-fractures-sprains': ServiceImageEntry(
      src: 'assets/images/services/injuries-fractures.webp',
      fallback: _jointWide,
      bodySrc: 'assets/images/services/common-injuries.webp',
    ),
    'car-motor-vehicle-accident-care': ServiceImageEntry(
      src: 'assets/images/services/auto-accident.jpg',
      fallback: _clinical,
      heroSrc: 'assets/images/services/accident-long.jpg',
      alignment: Alignment(0, -0.12),
    ),
    'motorcycle-accident-care': ServiceImageEntry(
      src: 'assets/images/services/motorcycle-accident.jpg',
      fallback: _sports,
      heroSrc: 'assets/images/services/motorcycle-accident.jpg',
      alignment: Alignment(0, -0.14),
    ),
    'pedestrian-injury-care': ServiceImageEntry(
      src: 'assets/images/services/pedestrian-injury.webp',
      fallback: _clinical,
      heroSrc: 'assets/images/services/pedestrian-injury.webp',
      alignment: Alignment(0, -0.08),
    ),
    'truck-accident-care': ServiceImageEntry(
      src: 'assets/images/services/truck-accident.webp',
      fallback: _clinical,
      heroSrc: 'assets/images/services/truck-accident-long.jpg',
      alignment: Alignment(0, -0.14),
    ),
    'work-injury-care': ServiceImageEntry(
      src: 'assets/images/services/work-injury.jpg',
      fallback: _recovery,
      heroSrc: 'assets/images/services/work-injury-long.jpeg',
      alignment: Alignment(0, -0.1),
    ),
    'arthritis': ServiceImageEntry(
      src: 'assets/images/services/arthritis.webp',
      fallback: _jointWide,
      placement: 'square',
      heroSrc: 'assets/images/services/arthritis-long.jpg',
    ),
    'casting-splinting': ServiceImageEntry(
      src: 'assets/images/services/casting-splinting.webp',
      fallback: _recovery,
      placement: 'wide',
      heroSrc: 'assets/images/services/casting-splinting-long.jpg',
    ),
    'mri-digital-imaging': ServiceImageEntry(
      src: 'assets/images/services/x-ray.jpeg',
      fallback: _clinical,
      placement: 'wide',
      heroSrc: 'assets/images/services/mri-digital-imaging-long.avif',
    ),
    'prp-orthobiologics': ServiceImageEntry(
      src: 'assets/images/services/prp-injection.webp',
      fallback: _jointWide,
      placement: 'square',
      heroSrc: 'assets/images/services/prp-orthobiologics-long.jpg',
    ),
    'hand-wrist-care': ServiceImageEntry(
      src: 'assets/images/services/hand-wrist.jpg',
      fallback: _jointWide,
      placement: 'pack',
      heroSrc: _sports,
    ),
    'shoulder-elbow': ServiceImageEntry(
      src: 'assets/images/services/shoulder-elbow.webp',
      fallback: _recovery,
      placement: 'square',
      heroSrc: 'assets/images/services/shoulder-elbow-long.webp',
    ),
    'lumbar-cervical-spine': ServiceImageEntry(
      src: 'assets/images/services/spine-back.webp',
      fallback: _jointWide,
      placement: 'square',
      heroSrc: 'assets/images/services/lumbar-cervical-spine-long.webp',
    ),
    'chiropractic-surgery': ServiceImageEntry(
      src: 'assets/images/services/chiropractic.jpeg',
      fallback: _clinical,
      alignment: Alignment(0, -0.24),
    ),
    'spine-surgery': ServiceImageEntry(
      src: 'assets/images/services/spine-surgery.png',
      fallback: 'assets/images/services/spine.webp',
      placement: 'wide',
      heroSrc: 'assets/images/services/spine-surgery-long.jpg',
    ),
    'hip-knee-care': ServiceImageEntry(
      src: 'assets/images/services/hip-knee-care.jpg',
      fallback: _clinical,
      alignment: Alignment(0, -0.2),
    ),
    'foot-ankle-care': ServiceImageEntry(
      src: 'assets/images/services/foot-ankle.jpg',
      fallback: _clinical,
      placement: 'portrait',
      heroSrc: _sports,
    ),
    'muscle-soft-tissue-care': ServiceImageEntry(
      src: 'assets/images/services/muscle-soft-tissue-long.jpg',
      fallback: _recovery,
      heroSrc: 'assets/images/services/muscle-soft-tissue-long.jpg',
      alignment: Alignment(0, -0.1),
    ),
    'total-joint-replacement': ServiceImageEntry(
      src: 'assets/images/services/joint-replacement.jpg',
      fallback: _jointWide,
      placement: 'square',
      heroSrc: 'assets/images/services/total-joint-replacement-long.png',
    ),
    'sports-medicine': ServiceImageEntry(
      src: 'assets/images/services/sports-medicine.avif',
      fallback: _recovery,
      alignment: Alignment(0, -0.16),
    ),
    'workers-comp': ServiceImageEntry(
      src: 'assets/images/workers-comp/hero.webp',
      fallback: _recovery,
      alignment: Alignment(0, -0.2),
    ),
  };

  static ServiceImageEntry forSlug(String slug) {
    return _entries[slug] ??
        ServiceImageEntry(
          src: 'assets/images/blogs/chronic-pain.webp',
          fallback: _clinical,
        );
  }

  /// Card / grid thumbnail — primary service image.
  static String listImagePath(String slug) => forSlug(slug).src;

  static String listFallbackPath(String slug) => forSlug(slug).fallback;
}

/// About page images — each section uses a distinct asset (no duplicates on one page).
class AboutImages {
  /// Recovery scene — not the same file as facility background.
  static const hero = AboutImageSlot(
    src: 'assets/images/recovery-after-orthopedicsurgery.jpg',
    fallback: 'assets/images/home/hero.jpg',
  );
  /// Mission: single clinician (distinct from care-team story shot).
  static const team = AboutImageSlot(
    src: 'assets/images/about/team.avif',
    fallback: 'assets/images/joint-img.jpg',
  );
  /// Vision: clinic / location exterior (los-angeles — not the clinician photo).
  static const clinic = AboutImageSlot(
    src: 'assets/images/los-angeles.avif',
    fallback: 'assets/images/berlin.webp',
  );
  /// Story: care team group photo.
  static const care = AboutImageSlot(
    src: 'assets/images/about/care.avif',
    fallback: 'assets/images/recovery-after-orthopedicsurgery.jpg',
  );
  static const facility = AboutImageSlot(
    src: 'assets/images/about/facility.jpg',
    fallback: 'assets/images/berlin.webp',
  );

  /// All primary image paths on the About page — for duplicate detection.
  static List<String> primaryPaths() => [
        hero.src,
        team.src,
        clinic.src,
        care.src,
        facility.src,
      ];
}

class AboutImageSlot {
  final String src;
  final String fallback;

  const AboutImageSlot({required this.src, required this.fallback});
}

class HomeImages {
  static const hero = 'assets/images/home/home-page.jpg';
  static const heroFallback = 'assets/images/recovery-after-orthopedicsurgery.jpg';
  static const lawyers = 'assets/images/home/lawyers.avif';
  static const lawyersFallback = 'assets/images/about/facility.jpg';
  static const injured = 'assets/images/home/snapshot-injured.png';
  static const pain = 'assets/images/home/snapshot-pain.jpg';
  static const workers = 'assets/images/home/snapshot-workers.png';
}

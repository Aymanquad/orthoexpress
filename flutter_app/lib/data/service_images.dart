// Service image rules — mirrors src/data/images.js + ServiceDetail.jsx

class ServiceImageEntry {
  final String src;
  final String fallback;
  final String placement;
  final String? heroSrc;

  const ServiceImageEntry({
    required this.src,
    required this.fallback,
    this.placement = 'photo',
    this.heroSrc,
  });

  /// Hero banner — never duplicates [bodyImage] on the same page.
  String? get heroImage {
    final hero = heroSrc ?? (placement == 'photo' ? src : null);
    return hero;
  }

  /// Inline body figure — omitted for full-bleed photo services.
  String? get bodyImage {
    if (placement == 'photo') return null;
    final hero = heroImage;
    if (hero != null && hero == src) return null;
    return src;
  }
}

class ServiceImages {
  static const _clinical = 'assets/images/knee-injury.webp';
  static const _recovery = 'assets/images/recovery-after-orthopedicsurgery.jpg';
  static const _sports = 'assets/images/services/sports-medicine.jpg';
  static const _facility = 'assets/images/about/facility.jpg';
  static const _jointWide = 'assets/images/joint-img.jpg';

  static const _entries = <String, ServiceImageEntry>{
    'pain-inflammation': ServiceImageEntry(
      src: 'assets/images/services/pain-inflammation.jpg',
      fallback: _jointWide,
    ),
    'injuries-fractures-sprains': ServiceImageEntry(
      src: 'assets/images/services/injuries-fractures.webp',
      fallback: _jointWide,
    ),
    'arthritis': ServiceImageEntry(
      src: 'assets/images/services/arthritis.webp',
      fallback: _jointWide,
      placement: 'square',
      heroSrc: _clinical,
    ),
    'casting-splinting': ServiceImageEntry(
      src: 'assets/images/services/casting-splinting.webp',
      fallback: _recovery,
      placement: 'wide',
      heroSrc: _facility,
    ),
    'mri-digital-imaging': ServiceImageEntry(
      src: 'assets/images/services/mri-imaging.jpg',
      fallback: _clinical,
      placement: 'square',
      heroSrc: _facility,
    ),
    'prp-orthobiologics': ServiceImageEntry(
      src: 'assets/images/services/prp-orthobiologics.webp',
      fallback: _jointWide,
      placement: 'square',
      heroSrc: _clinical,
    ),
    'pediatric-care': ServiceImageEntry(
      src: 'assets/images/services/pediatric-care.webp',
      fallback: _recovery,
      placement: 'wide',
      heroSrc: _facility,
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
      heroSrc: _sports,
    ),
    'lumbar-cervical-spine': ServiceImageEntry(
      src: 'assets/images/services/spine.webp',
      fallback: _jointWide,
      placement: 'square',
      heroSrc: _clinical,
    ),
    'chiropractic-surgery': ServiceImageEntry(
      src: 'assets/images/services/chiropractic.png',
      fallback: _clinical,
    ),
    'spine-surgery': ServiceImageEntry(
      src: 'assets/images/services/spine-surgery.png',
      fallback: 'assets/images/services/spine.webp',
      placement: 'wide',
      heroSrc: _clinical,
    ),
    'hip-knee-care': ServiceImageEntry(
      src: 'assets/images/services/hip-knee.avif',
      fallback: _clinical,
    ),
    'foot-ankle-care': ServiceImageEntry(
      src: 'assets/images/services/foot-ankle.jpg',
      fallback: _clinical,
      placement: 'portrait',
      heroSrc: _sports,
    ),
    'total-joint-replacement': ServiceImageEntry(
      src: 'assets/images/services/joint-replacement.jpg',
      fallback: _jointWide,
      placement: 'square',
      heroSrc: _clinical,
    ),
    'sports-medicine': ServiceImageEntry(
      src: 'assets/images/services/sports-medicine.jpg',
      fallback: _recovery,
    ),
  };

  static ServiceImageEntry forSlug(String slug) {
    return _entries[slug] ??
        ServiceImageEntry(
          src: 'assets/images/services/pain-inflammation.jpg',
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

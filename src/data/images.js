/**
 * Central image map — files live in public/assets/
 *
 * placement:
 *   photo   — strong landscape → full-bleed hero only
 *   square  — 1:1 / near-square → filled body figure (object-fit: cover)
 *   portrait — taller than wide → body figure
 *   wide    — mild landscape not hero-ready → body 4:3 figure
 *   pack    — product packshot needing full product visible (contain)
 *
 * heroSrc — optional stronger landscape reused as hero when primary is body-only
 */
const SHARED = {
  clinicalLandscape: '/assets/knee-injury.webp',
  recovery: '/assets/recovery-after-orthopedicsurgery.jpg',
  sports: '/assets/services/sports-medicine.avif',
  facility: '/assets/about/facility.jpg',
  jointWide: '/assets/joint-img.jpg',
}

export const IMAGES = {
  home: {
    hero: {
      src: '/assets/home/hero.jpg',
      fallback: SHARED.recovery,
      placement: 'photo',
    },
    snapshotInjured: {
      src: '/assets/home/snapshot-injured.png',
      fallback: SHARED.clinicalLandscape,
      placement: 'square',
    },
    snapshotPain: {
      src: '/assets/home/snapshot-pain.jpg',
      fallback: SHARED.jointWide,
      placement: 'square',
    },
    snapshotSports: {
      src: '/assets/home/snapshot-sports.avif',
      fallback: SHARED.clinicalLandscape,
      placement: 'photo',
    },
    snapshotWorkers: {
      src: '/assets/home/snapshot-workers.png',
      fallback: SHARED.recovery,
      placement: 'square',
    },
    lawyers: {
      src: '/assets/home/lawyers.avif',
      fallback: SHARED.facility,
      placement: 'photo',
    },
  },
  about: {
    hero: {
      src: '/assets/about/hero.jpg',
      fallback: SHARED.recovery,
      placement: 'photo',
    },
    team: {
      src: '/assets/about/team.avif',
      fallback: SHARED.jointWide,
      placement: 'photo',
    },
    clinic: {
      src: '/assets/about/clinic.avif',
      fallback: '/assets/los-angeles.avif',
      placement: 'photo',
    },
    care: {
      src: '/assets/about/care.avif',
      fallback: SHARED.recovery,
      placement: 'photo',
    },
    facility: {
      src: '/assets/about/facility.jpg',
      fallback: '/assets/berlin.webp',
      placement: 'photo',
    },
  },
  workersComp: {
    hero: {
      src: '/assets/workers-comp/hero.webp',
      fallback: SHARED.recovery,
      placement: 'photo',
      objectPosition: 'center 40%',
    },
  },
  services: {
    // 300×168 tiny wide → reuse clinical hero, skip blurry body crop
    'pain-inflammation': {
      src: '/assets/blogs/chronic-pain.webp',
      fallback: '/assets/services/arthritis.webp',
      placement: 'square',
      heroSrc: '/assets/services/pain-inflammation-long.jpg',
    },
    // 2560×1616 landscape hero; common-injuries in page body
    'injuries-fractures-sprains': {
      src: '/assets/services/injuries-fractures.webp',
      fallback: SHARED.clinicalLandscape,
      placement: 'photo',
      bodySrc: '/assets/services/common-injuries.webp',
      bodyLayout: 'wide',
    },
    // 612×408 landscape — car / motor vehicle accident care
    'car-motor-vehicle-accident-care': {
      src: '/assets/services/auto-accident.jpg',
      fallback: SHARED.clinicalLandscape,
      placement: 'photo',
      heroSrc: '/assets/services/accident-long.jpg',
      objectPosition: 'center 42%',
    },
    // Kept for shared references (same asset as accident care)
    'auto-accident': {
      src: '/assets/services/auto-accident.jpg',
      fallback: SHARED.clinicalLandscape,
      placement: 'photo',
      heroSrc: '/assets/services/accident-long.jpg',
      objectPosition: 'center 42%',
    },
    // 600×484 near-square
    arthritis: {
      src: '/assets/services/arthritis.webp',
      fallback: SHARED.jointWide,
      placement: 'square',
      heroSrc: '/assets/services/arthritis-long.jpg',
    },
    // 800×600 mild landscape
    'casting-splinting': {
      src: '/assets/services/casting-splinting.webp',
      fallback: SHARED.recovery,
      placement: 'wide',
      heroSrc: '/assets/services/casting-splinting-long.jpg',
    },
    // 612×612 square
    'mri-digital-imaging': {
      src: '/assets/services/x-ray.jpeg',
      fallback: SHARED.clinicalLandscape,
      placement: 'wide',
      heroSrc: '/assets/services/mri-digital-imaging-long.avif',
    },
    // 400×400 square clinical
    'prp-orthobiologics': {
      src: '/assets/services/prp-injection.webp',
      fallback: SHARED.jointWide,
      placement: 'square',
      heroSrc: '/assets/services/prp-orthobiologics-long.jpg',
    },
    // 2478×2478 packshot — show full brace
    'hand-wrist-care': {
      src: '/assets/services/hand-wrist.jpg',
      fallback: SHARED.jointWide,
      placement: 'pack',
      heroSrc: SHARED.sports,
    },
    // 253×280 tiny — body square + reuse sports hero
    'shoulder-elbow': {
      src: '/assets/services/shoulder-elbow.webp',
      fallback: SHARED.recovery,
      placement: 'square',
      heroSrc: '/assets/services/shoulder-elbow-long.webp',
    },
    // 800×800 square (was wrongly photo)
    'lumbar-cervical-spine': {
      src: '/assets/services/spine-back.webp',
      fallback: SHARED.jointWide,
      placement: 'square',
      heroSrc: '/assets/services/lumbar-cervical-spine-long.webp',
    },
    // 2400×2000 landscape
    'chiropractic-surgery': {
      src: '/assets/services/chiropractic.jpeg',
      fallback: SHARED.clinicalLandscape,
      placement: 'photo',
      objectPosition: 'center 38%',
    },
    // 419×298 — body figure + shared clinical hero
    'spine-surgery': {
      src: '/assets/services/spine-surgery.png',
      fallback: '/assets/services/spine.webp',
      placement: 'wide',
      heroSrc: '/assets/services/spine-surgery-long.jpg',
    },
    'hip-knee-care': {
      src: '/assets/services/hip-knee-care.jpg',
      fallback: SHARED.clinicalLandscape,
      placement: 'photo',
      objectPosition: 'center 40%',
    },
    // 527×581 near-portrait
    'foot-ankle-care': {
      src: '/assets/services/foot-ankle.jpg',
      fallback: SHARED.clinicalLandscape,
      placement: 'portrait',
      heroSrc: SHARED.sports,
    },
    // 2048×2048 illustration with white margins — cover fills card
    'total-joint-replacement': {
      src: '/assets/services/joint-replacement.jpg',
      fallback: SHARED.jointWide,
      placement: 'square',
      heroSrc: '/assets/services/total-joint-replacement-long.png',
    },
    // 612×408 landscape
    'sports-medicine': {
      src: '/assets/services/sports-medicine.avif',
      fallback: SHARED.recovery,
      placement: 'photo',
      objectPosition: 'center 42%',
    },
    'workers-comp': {
      src: '/assets/workers-comp/hero.webp',
      fallback: SHARED.recovery,
      placement: 'photo',
      objectPosition: 'center 40%',
    },
  },
  blogs: {
    // 2048×1536 landscape
    'understanding-orthopedic-injuries': {
      src: '/assets/blogs/orthopedic-injuries.webp',
      fallback: SHARED.clinicalLandscape,
      placement: 'photo',
    },
    // 310×163 tiny — reuse recovery landscape
    'recovery-after-surgery': {
      src: SHARED.recovery,
      fallback: SHARED.clinicalLandscape,
      placement: 'photo',
    },
    'sports-injury-prevention': {
      src: '/assets/blogs/sports-prevention.jpg',
      fallback: SHARED.clinicalLandscape,
      placement: 'photo',
    },
    // 1000×1000 square
    'managing-chronic-pain': {
      src: '/assets/blogs/chronic-pain.webp',
      fallback: SHARED.jointWide,
      placement: 'square',
      heroSrc: SHARED.clinicalLandscape,
    },
    // 300×168 tiny — reuse
    'exercise-for-joint-health': {
      src: SHARED.jointWide,
      fallback: '/assets/services/arthritis.webp',
      placement: 'photo',
    },
    'when-to-see-orthopedic-specialist': {
      src: '/assets/blogs/see-specialist.jpg',
      fallback: SHARED.recovery,
      placement: 'photo',
    },
  },
}

/** @deprecated prefer placement; kept for older callers */
function toHeroLayout(placement) {
  if (placement === 'photo') return 'photo'
  if (placement === 'portrait') return 'portrait'
  if (placement === 'wide') return 'wide'
  if (placement === 'pack') return 'pack'
  return 'square'
}

function normalizeImage(img) {
  if (!img) return img
  const placement = img.placement || toHeroLayout(img.heroLayout) || 'photo'
  return {
    ...img,
    placement,
    heroLayout: toHeroLayout(placement),
    bodySrc: img.bodySrc || null,
    bodyLayout: img.bodyLayout || (placement === 'photo' ? null : placement),
  }
}

export function getServiceImage(slug) {
  return normalizeImage(IMAGES.services[slug] || IMAGES.services['pain-inflammation'])
}

export function getBlogImage(slug) {
  return normalizeImage(IMAGES.blogs[slug] || IMAGES.blogs['understanding-orthopedic-injuries'])
}

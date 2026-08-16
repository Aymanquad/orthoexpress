import { getServiceName, getServiceSummary } from '../i18n/services'

/** Primary services — header dropdown (8 core clinical services) */
export const NAV_SERVICES = [
  { slug: 'pain-inflammation' },
  { slug: 'injuries-fractures-sprains' },
  { slug: 'arthritis' },
  { slug: 'casting-splinting' },
  { slug: 'sports-medicine' },
  { slug: 'mri-digital-imaging' },
  { slug: 'prp-orthobiologics' },
  { slug: 'car-motor-vehicle-accident-care' },
]

/** Regional / specialty services — separate pages, not in header dropdown */
export const SPECIALTY_SERVICES = [
  { slug: 'hand-wrist-care' },
  { slug: 'shoulder-elbow' },
  { slug: 'lumbar-cervical-spine' },
  { slug: 'chiropractic-surgery' },
  { slug: 'spine-surgery' },
  { slug: 'hip-knee-care' },
  { slug: 'foot-ankle-care' },
  { slug: 'total-joint-replacement' },
]

/** Full list for footer and site-wide links */
export const SERVICES = [...NAV_SERVICES, ...SPECIALTY_SERVICES]

export const WORKERS_COMP_SERVICE = {
  slug: 'workers-comp',
  href: '/workers-comp',
}

/** Every service link shown in header dropdown and footer */
export const ALL_SERVICE_LINKS = [
  { href: '/services' },
  ...SERVICES.map((service) => ({ ...service })),
  WORKERS_COMP_SERVICE,
]

/** Core services for the All Services page */
export const PRIMARY_SERVICE_CARDS = NAV_SERVICES.map((service) => ({
  ...service,
}))

/** Regional / specialty cards for the All Services page */
export const SPECIALTY_SERVICE_CARDS = SPECIALTY_SERVICES.map((service) => ({
  ...service,
}))

/** @deprecated Use PRIMARY_SERVICE_CARDS + SPECIALTY_SERVICE_CARDS */
export const SERVICE_CATALOG = [
  ...PRIMARY_SERVICE_CARDS,
  WORKERS_COMP_SERVICE,
  ...SPECIALTY_SERVICE_CARDS,
]

export function getServicePath(service) {
  if (service.href) return service.href
  return `/services/${service.slug}`
}

export function getServiceLabel(service, lang = 'en') {
  if (!service) return ''
  if (service.href === '/services') return lang === 'es' ? 'Todos los servicios' : 'All Services'
  const slug = service.slug || service.href?.replace('/services/', '')
  return getServiceName(slug, lang)
}

export function getServiceCardSummary(service, lang = 'en') {
  if (!service?.slug) return ''
  if (service.href === '/workers-comp' || service.slug === 'workers-comp') {
    return getServiceSummary('workers-comp', lang)
  }
  return getServiceSummary(service.slug, lang)
}

export { getServiceName, getServiceSummary }

import { writeFileSync, mkdirSync } from 'fs'
import { pathToFileURL } from 'url'
import { resolve, dirname } from 'path'
import { fileURLToPath } from 'url'

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..')

const content = await import(pathToFileURL(resolve(root, 'src/data/content.js')).href)
const patientCare = await import(pathToFileURL(resolve(root, 'src/data/patientCare.js')).href)
const blogEs = await import(pathToFileURL(resolve(root, 'src/data/blogContentEs.js')).href)

// Import blogs module via a shim that stubs images
const { createRequire } = await import('module')
const require = createRequire(import.meta.url)

// Manually rebuild blogs from source by reading and evaluating after stubs
const blogsPath = resolve(root, 'src/data/blogs.js')
const blogsSrc = await (await import('fs')).promises.readFile(blogsPath, 'utf8')

const BLOG_I18N_MATCH = blogsSrc.match(/const BLOG_I18N = (\{[\s\S]*?\n\})/)
const BLOGS_MATCH = blogsSrc.match(/export const BLOGS = (\[[\s\S]*\n\])/)

function evalObject(src) {
  // Replace getBlogImage(...) with slug string
  const cleaned = src
    .replace(/getBlogImage\('([^']+)'\)\.src/g, "'$1'")
    .replace(/image:\s*'[^']+',/g, (m) => m)
  // eslint-disable-next-line no-new-func
  return new Function(`return (${cleaned})`)()
}

const BLOG_I18N = evalObject(BLOG_I18N_MATCH[1])
const BLOGS_RAW = evalObject(
  BLOGS_MATCH[1].replace(/image:\s*getBlogImage\('([^']+)'\)\.src/g, "image: '$1'")
)

const blogImageMap = {
  'understanding-orthopedic-injuries': 'assets/images/blogs/orthopedic-injuries.webp',
  'recovery-after-surgery': 'assets/images/blogs/recovery-surgery.jpg',
  'sports-injury-prevention': 'assets/images/blogs/sports-prevention.jpg',
  'managing-chronic-pain': 'assets/images/blogs/chronic-pain.webp',
  'exercise-for-joint-health': 'assets/images/blogs/joint-exercise.jpg',
  'when-to-see-orthopedic-specialist': 'assets/images/blogs/see-specialist.jpg',
}

const out = {
  insuranceProviders: content.INSURANCE_PROVIDERS,
  selfPayPricing: content.SELF_PAY_PRICING,
  faqs: content.FAQS,
  careers: content.CAREERS,
  newsItems: content.NEWS_ITEMS,
  telehealthWhen: patientCare.TELEHEALTH_WHEN,
  telehealthSteps: patientCare.TELEHEALTH_STEPS,
  afterVisitSteps: patientCare.AFTER_VISIT_STEPS,
  portalFeatures: patientCare.PORTAL_FEATURES,
  technologyFeatures: patientCare.TECHNOLOGY_FEATURES,
  orthochatFeatures: patientCare.ORTHOCHAT_FEATURES,
  faqSpecialties: patientCare.FAQ_SPECIALTIES,
  blogs: BLOGS_RAW.map((b) => ({
    slug: b.slug,
    title: { en: b.title, es: BLOG_I18N[b.slug]?.title?.es || b.title },
    excerpt: { en: b.excerpt, es: BLOG_I18N[b.slug]?.excerpt?.es || b.excerpt },
    category: { en: b.category, es: BLOG_I18N[b.slug]?.category?.es || b.category },
    date: { en: b.date, es: blogEs.BLOG_DATES_ES?.[b.slug] || b.date },
    imagePath: blogImageMap[b.slug] || 'assets/images/blogs/orthopedic-injuries.webp',
    content: {
      en: String(b.content || '').trim(),
      es: String(blogEs.BLOG_CONTENT_ES?.[b.slug] || b.content || '').trim(),
    },
  })),
}

const destDir = resolve(root, 'flutter_app/assets/data')
mkdirSync(destDir, { recursive: true })
const dest = resolve(destDir, 'content_pages.json')
writeFileSync(dest, JSON.stringify(out, null, 2))
console.log(
  'Wrote',
  dest,
  Object.fromEntries(
    Object.entries(out).map(([k, v]) => [k, Array.isArray(v) ? v.length : typeof v]),
  ),
)

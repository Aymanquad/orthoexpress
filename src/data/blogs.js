/** Blog content translations keyed by slug */
import { BLOG_CONTENT_ES, BLOG_DATES_ES } from './blogContentEs'
import { getBlogImage } from './images'

const BLOG_I18N = {
  'understanding-orthopedic-injuries': {
    title: { es: 'Comprender las lesiones ortopédicas comunes' },
    excerpt: {
      es: 'Conozca las lesiones ortopédicas más comunes y cómo prevenirlas en su vida diaria.',
    },
    category: { es: 'Salud general' },
  },
  'recovery-after-surgery': {
    title: { es: 'Consejos de recuperación después de cirugía ortopédica' },
    excerpt: {
      es: 'Consejos esenciales y pautas para un proceso de recuperación fluido después de procedimientos ortopédicos.',
    },
    category: { es: 'Recuperación' },
  },
  'sports-injury-prevention': {
    title: { es: 'Estrategias de prevención de lesiones deportivas' },
    excerpt: {
      es: 'Consejos expertos para prevenir lesiones relacionadas con el deporte y mantener el máximo rendimiento.',
    },
    category: { es: 'Medicina deportiva' },
  },
  'managing-chronic-pain': {
    title: { es: 'Manejo del dolor ortopédico crónico' },
    excerpt: {
      es: 'Estrategias efectivas para manejar el dolor ortopédico a largo plazo y mejorar la calidad de vida.',
    },
    category: { es: 'Manejo del dolor' },
  },
  'exercise-for-joint-health': {
    title: { es: 'Ejercicio para la salud articular' },
    excerpt: {
      es: 'Descubra los mejores ejercicios para mantener articulaciones saludables y prevenir problemas ortopédicos.',
    },
    category: { es: 'Ejercicio' },
  },
  'when-to-see-orthopedic-specialist': {
    title: { es: 'Cuándo ver a un especialista ortopédico' },
    excerpt: {
      es: 'Conozca las señales y síntomas que indican que debe consultar con un especialista ortopédico.',
    },
    category: { es: 'Salud general' },
  },
}

export function getBlogField(blog, field, lang = 'en') {
  if (!blog) return ''
  if (lang === 'en') return blog[field] ?? ''
  if (field === 'content') {
    return BLOG_CONTENT_ES[blog.slug] ?? blog.content ?? ''
  }
  if (field === 'date') {
    return BLOG_DATES_ES[blog.slug] ?? blog.date ?? ''
  }
  const translated = BLOG_I18N[blog.slug]?.[field]?.es
  return translated ?? blog[field] ?? ''
}

/** All blog posts — list, preview, and detail pages share this data */
export const BLOGS = [
  {
    slug: 'understanding-orthopedic-injuries',
    title: 'Understanding Common Orthopedic Injuries',
    excerpt:
      'Learn about the most common orthopedic injuries and how to prevent them in your daily life.',
    date: 'August 8, 2026',
    category: 'General Health',
    image: getBlogImage('understanding-orthopedic-injuries').src,
    content: `
        <p>Orthopedic injuries are among the most common medical conditions affecting people of all ages. Understanding these injuries can help you recognize symptoms early and seek appropriate treatment.</p>
        
        <h3>Common Types of Orthopedic Injuries</h3>
        <p>Some of the most frequently encountered orthopedic injuries include:</p>
        <ul>
          <li><strong>Fractures:</strong> Broken bones that can occur from falls, accidents, or overuse.</li>
          <li><strong>Sprains and Strains:</strong> Injuries to ligaments (sprains) or muscles/tendons (strains).</li>
          <li><strong>Dislocations:</strong> When bones are forced out of their normal positions.</li>
          <li><strong>Tendinitis:</strong> Inflammation of tendons, often from repetitive motion.</li>
          <li><strong>Bursitis:</strong> Inflammation of the fluid-filled sacs that cushion joints.</li>
        </ul>

        <h3>Prevention Strategies</h3>
        <p>While not all injuries can be prevented, there are steps you can take to reduce your risk:</p>
        <ul>
          <li>Maintain a healthy weight to reduce stress on joints</li>
          <li>Engage in regular exercise to strengthen muscles and bones</li>
          <li>Use proper technique when lifting or performing physical activities</li>
          <li>Wear appropriate protective equipment during sports</li>
          <li>Take breaks during repetitive activities</li>
        </ul>

        <h3>When to Seek Medical Attention</h3>
        <p>If you experience severe pain, inability to move a joint, visible deformity, or symptoms that worsen over time, it's important to seek medical attention promptly. Early diagnosis and treatment can significantly improve outcomes.</p>
      `,
  },
  {
    slug: 'recovery-after-surgery',
    title: 'Recovery Tips After Orthopedic Surgery',
    excerpt:
      'Essential tips and guidelines for a smooth recovery process after orthopedic procedures.',
    date: 'July 22, 2026',
    category: 'Recovery',
    image: getBlogImage('recovery-after-surgery').src,
    content: `
        <p>Recovery after orthopedic surgery requires patience, dedication, and following your doctor's instructions carefully. Here are essential tips to help you through the recovery process.</p>
        
        <h3>Follow Your Doctor's Instructions</h3>
        <p>Your surgeon will provide specific instructions based on your procedure. It's crucial to follow these guidelines regarding activity levels, medications, and wound care.</p>

        <h3>Manage Pain Effectively</h3>
        <p>Pain management is crucial for recovery. Take prescribed medications as directed and communicate with your healthcare team about your pain levels.</p>

        <h3>Physical Therapy</h3>
        <p>Most orthopedic surgeries require physical therapy to restore function. Attend all sessions and perform home exercises as recommended.</p>

        <h3>Nutrition and Hydration</h3>
        <p>Proper nutrition supports healing. Focus on protein-rich foods, vitamins, and stay well-hydrated.</p>

        <h3>Rest and Activity Balance</h3>
        <p>Balance rest with appropriate activity. Too much rest can delay recovery, while too much activity can cause complications.</p>
      `,
  },
  {
    slug: 'sports-injury-prevention',
    title: 'Sports Injury Prevention Strategies',
    excerpt:
      'Expert advice on preventing sports-related injuries and maintaining peak performance.',
    date: 'July 3, 2026',
    category: 'Sports Medicine',
    image: getBlogImage('sports-injury-prevention').src,
    content: `
        <p>Preventing sports injuries is essential for athletes of all levels. Here are proven strategies to keep you in the game.</p>
        
        <h3>Proper Warm-up and Cool-down</h3>
        <p>Always warm up before activity and cool down afterward. This prepares your body for exercise and helps with recovery.</p>

        <h3>Use Proper Equipment</h3>
        <p>Wear appropriate protective gear and ensure equipment fits correctly. This includes helmets, pads, and proper footwear.</p>

        <h3>Gradual Progression</h3>
        <p>Avoid sudden increases in training intensity or duration. Gradually build up your activity level to prevent overuse injuries.</p>

        <h3>Cross-Training</h3>
        <p>Engage in a variety of activities to prevent overuse of specific muscle groups and maintain overall fitness.</p>

        <h3>Listen to Your Body</h3>
        <p>Pay attention to pain and fatigue. Rest when needed and don't push through injuries.</p>
      `,
  },
  {
    slug: 'managing-chronic-pain',
    title: 'Managing Chronic Orthopedic Pain',
    excerpt:
      'Effective strategies for managing long-term orthopedic pain and improving quality of life.',
    date: 'June 18, 2026',
    category: 'Pain Management',
    image: getBlogImage('managing-chronic-pain').src,
    content: `
        <p>Chronic orthopedic pain can significantly impact your daily life and well-being. Here are effective strategies for managing long-term pain and improving your quality of life.</p>
        
        <h3>Understanding Chronic Pain</h3>
        <p>Chronic pain persists beyond the normal healing period and may require ongoing management strategies. Understanding your pain is the first step toward effective treatment.</p>

        <h3>Medical Treatment Options</h3>
        <p>Various medical treatments can help manage chronic pain, including medications, injections, and physical therapy. Work with your healthcare provider to find the right combination.</p>

        <h3>Lifestyle Modifications</h3>
        <p>Simple lifestyle changes can make a significant difference. This includes maintaining a healthy weight, staying active within your limits, and practicing stress management techniques.</p>

        <h3>Mind-Body Techniques</h3>
        <p>Techniques such as meditation, deep breathing, and mindfulness can help you better manage pain and reduce its impact on your life.</p>
      `,
  },
  {
    slug: 'exercise-for-joint-health',
    title: 'Exercise for Joint Health',
    excerpt:
      'Discover the best exercises to maintain healthy joints and prevent orthopedic issues.',
    date: 'May 27, 2026',
    category: 'Exercise',
    image: getBlogImage('exercise-for-joint-health').src,
    content: `
        <p>Regular exercise is essential for maintaining healthy joints and preventing orthopedic issues. Discover the best exercises to keep your joints strong and flexible.</p>
        
        <h3>Low-Impact Exercises</h3>
        <p>Low-impact activities like swimming, cycling, and walking are excellent for joint health. These exercises strengthen muscles without excessive stress on joints.</p>

        <h3>Strength Training</h3>
        <p>Building muscle strength supports and protects your joints. Focus on exercises that target the muscles around your joints without causing pain.</p>

        <h3>Flexibility and Range of Motion</h3>
        <p>Stretching and range-of-motion exercises help maintain joint flexibility and prevent stiffness. Regular stretching can improve mobility and reduce the risk of injury.</p>

        <h3>Balance and Stability</h3>
        <p>Balance exercises help prevent falls and injuries. Simple balance training can significantly improve joint stability and coordination.</p>
      `,
  },
  {
    slug: 'when-to-see-orthopedic-specialist',
    title: 'When to See an Orthopedic Specialist',
    excerpt:
      'Learn the signs and symptoms that indicate you should consult with an orthopedic specialist.',
    date: 'May 6, 2026',
    category: 'General Health',
    image: getBlogImage('when-to-see-orthopedic-specialist').src,
    content: `
        <p>Knowing when to see an orthopedic specialist can help you get the right care at the right time. Here are key signs and symptoms that indicate you should consult with an orthopedic specialist.</p>
        
        <h3>Persistent Pain</h3>
        <p>If you experience pain that lasts more than a few weeks or interferes with your daily activities, it's time to see a specialist. Persistent pain may indicate an underlying condition that needs professional evaluation.</p>

        <h3>Limited Range of Motion</h3>
        <p>Difficulty moving a joint through its full range of motion, or feeling that a joint is stuck, warrants a specialist consultation. This could indicate injury or joint degeneration.</p>

        <h3>Joint Instability</h3>
        <p>If a joint feels weak, gives way, or feels like it might "pop out," you should see an orthopedic specialist. Instability can lead to further injury if not addressed.</p>

        <h3>Visible Deformity or Swelling</h3>
        <p>Visible changes in joint appearance, significant swelling, or deformity require immediate medical attention. These symptoms may indicate serious injury or infection.</p>
      `,
  },
]

export function getBlogBySlug(slug) {
  return BLOGS.find((blog) => blog.slug === slug) ?? null
}

export function getFeaturedBlogs(limit = 3) {
  return BLOGS.slice(0, limit)
}

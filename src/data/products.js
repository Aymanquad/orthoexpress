export const PRODUCT_CATEGORIES = [
  { id: 'all', label: 'All Products' },
  { id: 'cbd-wellness', label: 'CBD & Wellness' },
  { id: 'pain-relief', label: 'Pain Relief' },
  { id: 'braces-supports', label: 'Braces & Supports' },
]

export const PRODUCTS = [
  {
    id: 'cbd-lotion-1000',
    slug: 'cbd-lotion-1000mg',
    name: 'OrthoNaturals CBD 1000mg Lotion',
    price: 80.24,
    category: 'cbd-wellness',
    image: '/assets/shop/cbd-lotion.jpg',
    imageVariant: 'bottle',
    baseUnitsSold: 186,
    highlights: [
      '1000mg full-spectrum CBD per bottle',
      'Fast-absorbing lotion for muscles & joints',
      'Ideal after workouts or long shifts on your feet',
    ],
    review: {
      rating: 4.9,
      text: 'Noticeable relief within minutes on sore shoulders. Non-greasy and clinic-recommended.',
      author: 'Maria L.',
    },
    description: 'Topical CBD lotion formulated for muscle and joint comfort after activity.',
  },
  {
    id: 'cbd-freeze-rollon',
    slug: 'cbd-freeze-rollon-750mg',
    name: 'OrthoNaturals CBD 750mg Freeze Roll-On',
    price: 74.89,
    category: 'cbd-wellness',
    image: '/assets/shop/cbd-rollon.jpg',
    imageVariant: 'bottle',
    baseUnitsSold: 142,
    highlights: [
      'Cooling menthol + 750mg CBD blend',
      'Mess-free roll-on for targeted application',
      'Fits easily in a gym or travel bag',
    ],
    review: {
      rating: 4.8,
      text: 'Perfect for my lower back after PT sessions. The cooling effect lasts a good while.',
      author: 'James T.',
    },
    description: 'Cooling roll-on with CBD for targeted relief on sore muscles and joints.',
  },
  {
    id: 'cbd-tincture-500',
    slug: 'cbd-tincture-500mg',
    name: 'OrthoNaturals 500mg Tincture With Terpenes',
    price: 58.83,
    category: 'cbd-wellness',
    image: '/assets/shop/cbd-tincture.webp',
    imageVariant: 'packshot',
    baseUnitsSold: 231,
    highlights: [
      '500mg CBD with natural terpenes',
      'Peppermint flavor for easy daily use',
      '1 fl oz (30 ml) — about a month supply',
    ],
    review: {
      rating: 4.7,
      text: 'Helps me unwind in the evenings without feeling drowsy. Quality you can trust.',
      author: 'Priya S.',
    },
    description: 'Full-spectrum CBD tincture with natural terpenes for daily wellness support.',
  },
  {
    id: 'cold-therapy-gel-pack',
    slug: 'cold-therapy-gel-pack',
    name: 'Reusable Cold Therapy Gel Pack',
    price: 24.99,
    category: 'pain-relief',
    image: '/assets/shop/cold-pack.webp',
    imageVariant: 'packshot',
    baseUnitsSold: 312,
    highlights: [
      'Reusable hot & cold therapy gel pack',
      'Flexible design molds to knees, ankles & back',
      'Microwave or freezer ready in minutes',
    ],
    review: {
      rating: 4.8,
      text: 'Stays cold long enough for post-game icing. Much better than a bag of peas!',
      author: 'Coach D.',
    },
    description: 'Flexible gel pack for icing injuries, swelling, and post-activity recovery.',
  },
  {
    id: 'knee-stabilizer-brace',
    slug: 'knee-stabilizer-brace',
    name: 'Knee Stabilizer Brace',
    price: 49.99,
    category: 'braces-supports',
    image: '/assets/shop/knee-brace.jpg',
    imageVariant: 'wearable',
    baseUnitsSold: 278,
    highlights: [
      'Open-patella design with side stabilizers',
      'Adjustable straps for a secure custom fit',
      'Breathable material for all-day wear',
    ],
    review: {
      rating: 4.9,
      text: 'Gave me confidence returning to light jogging after my meniscus strain.',
      author: 'Alex R.',
    },
    description: 'Adjustable knee brace with side stabilizers for ligament and patella support.',
  },
  {
    id: 'wrist-splint',
    slug: 'wrist-splint-support',
    name: 'Wrist Splint Support',
    price: 34.99,
    category: 'braces-supports',
    image: '/assets/shop/wrist-splint.jpg',
    imageVariant: 'wearable',
    baseUnitsSold: 195,
    highlights: [
      'Breathable mesh with adjustable velcro',
      'Thumb-loop design keeps wrist aligned',
      'Great for carpal tunnel & sprain recovery',
    ],
    review: {
      rating: 4.6,
      text: 'Comfortable enough to wear at the desk all day. Pain eased within the first week.',
      author: 'Nina K.',
    },
    description: 'Breathable wrist splint ideal for carpal tunnel, sprains, and post-cast support.',
  },
  {
    id: 'ankle-brace',
    slug: 'ankle-support-brace',
    name: 'Ankle Support Brace',
    price: 39.99,
    category: 'braces-supports',
    image: '/assets/shop/ankle-brace.webp',
    imageVariant: 'wearable',
    baseUnitsSold: 224,
    highlights: [
      'Lace-up support with figure-8 strap',
      'Low-profile fit inside most shoes',
      'Recommended for sprains & instability',
    ],
    review: {
      rating: 4.8,
      text: 'Solid support without feeling bulky. Back on the court in two weeks.',
      author: 'Chris M.',
    },
    description: 'Low-profile ankle brace for sprains, instability, and return-to-sport protection.',
  },
  {
    id: 'compression-ice-wrap',
    slug: 'compression-ice-wrap',
    name: 'Compression Ice Wrap',
    price: 29.99,
    category: 'pain-relief',
    image: '/assets/shop/ice-wrap.jpg',
    imageVariant: 'packaging',
    baseUnitsSold: 167,
    highlights: [
      'Instant cooling relief in a reusable wrap',
      'One size — works on knee, elbow & ankle',
      'Minimizes swelling after activity or injury',
    ],
    review: {
      rating: 4.7,
      text: 'Easy to apply right after practice. Compression plus cold is a game changer.',
      author: 'Taylor W.',
    },
    description: 'Combined compression and cold therapy wrap for knees, elbows, and ankles.',
  },
  {
    id: 'arm-sling',
    slug: 'arm-sling-pocket',
    name: 'Arm Sling with Pocket',
    price: 27.99,
    category: 'braces-supports',
    image: '/assets/shop/arm-sling.webp',
    imageVariant: 'wearable',
    baseUnitsSold: 153,
    highlights: [
      'Padded shoulder strap for comfort',
      'Built-in pocket for phone or small items',
      'Contoured pouch supports elbow & forearm',
    ],
    review: {
      rating: 4.8,
      text: 'Much more comfortable than the hospital sling. The pocket is surprisingly handy.',
      author: 'Robert H.',
    },
    description: 'Comfortable arm sling with padded strap and storage pocket for everyday use.',
  },
]

export function getProductById(id) {
  return PRODUCTS.find((product) => product.id === id)
}

export function formatPrice(amount, lang = 'en') {
  const locale = lang === 'es' ? 'es-US' : 'en-US'
  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency: 'USD',
  }).format(amount)
}

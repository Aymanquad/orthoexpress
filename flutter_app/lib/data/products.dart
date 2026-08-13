/// Product catalog — ported from src/data/products.js
class ProductCategory {
  final String id;
  final String label;

  const ProductCategory({required this.id, required this.label});
}

class Product {
  final String id;
  final String slug;
  final String name;
  final double price;
  final String category;
  final String imagePath;
  final String? imageVariant;
  final List<String> highlights;
  final String description;

  const Product({
    required this.id,
    required this.slug,
    required this.name,
    required this.price,
    required this.category,
    required this.imagePath,
    this.imageVariant,
    required this.highlights,
    required this.description,
  });
}

const productCategories = [
  ProductCategory(id: 'all', label: 'All Products'),
  ProductCategory(id: 'cbd-wellness', label: 'CBD & Wellness'),
  ProductCategory(id: 'pain-relief', label: 'Pain Relief'),
  ProductCategory(id: 'braces-supports', label: 'Braces & Supports'),
];

const products = <Product>[
  Product(
    id: 'cbd-lotion-1000',
    slug: 'cbd-lotion-1000mg',
    name: 'OrthoNaturals CBD 1000mg Lotion',
    price: 80.24,
    category: 'cbd-wellness',
    imagePath: 'assets/images/shop/cbd-lotion.jpg',
    imageVariant: 'bottle',
    highlights: [
      '1000mg full-spectrum CBD per bottle',
      'Fast-absorbing lotion for muscles & joints',
      'Ideal after workouts or long shifts on your feet',
    ],
    description:
        'Topical CBD lotion formulated for muscle and joint comfort after activity.',
  ),
  Product(
    id: 'cbd-freeze-rollon',
    slug: 'cbd-freeze-rollon-750mg',
    name: 'OrthoNaturals CBD 750mg Freeze Roll-On',
    price: 74.89,
    category: 'cbd-wellness',
    imagePath: 'assets/images/shop/cbd-rollon.jpg',
    imageVariant: 'bottle',
    highlights: [
      'Cooling menthol + 750mg CBD blend',
      'Mess-free roll-on for targeted application',
      'Fits easily in a gym or travel bag',
    ],
    description:
        'Cooling roll-on with CBD for targeted relief on sore muscles and joints.',
  ),
  Product(
    id: 'cbd-tincture-500',
    slug: 'cbd-tincture-500mg',
    name: 'OrthoNaturals 500mg Tincture With Terpenes',
    price: 58.83,
    category: 'cbd-wellness',
    imagePath: 'assets/images/shop/cbd-tincture.webp',
    imageVariant: 'packshot',
    highlights: [
      '500mg CBD with natural terpenes',
      'Peppermint flavor for easy daily use',
      '1 fl oz (30 ml) — about a month supply',
    ],
    description:
        'Full-spectrum CBD tincture with natural terpenes for daily wellness support.',
  ),
  Product(
    id: 'cold-therapy-gel-pack',
    slug: 'cold-therapy-gel-pack',
    name: 'Reusable Cold Therapy Gel Pack',
    price: 24.99,
    category: 'pain-relief',
    imagePath: 'assets/images/shop/cold-pack.webp',
    imageVariant: 'packshot',
    highlights: [
      'Reusable hot & cold therapy gel pack',
      'Flexible design molds to knees, ankles & back',
      'Microwave or freezer ready in minutes',
    ],
    description:
        'Flexible gel pack for icing injuries, swelling, and post-activity recovery.',
  ),
  Product(
    id: 'knee-stabilizer-brace',
    slug: 'knee-stabilizer-brace',
    name: 'Knee Stabilizer Brace',
    price: 49.99,
    category: 'braces-supports',
    imagePath: 'assets/images/shop/knee-brace.jpg',
    imageVariant: 'wearable',
    highlights: [
      'Open-patella design with side stabilizers',
      'Adjustable straps for a secure custom fit',
      'Breathable material for all-day wear',
    ],
    description:
        'Adjustable knee brace with side stabilizers for ligament and patella support.',
  ),
  Product(
    id: 'wrist-splint',
    slug: 'wrist-splint-support',
    name: 'Wrist Splint Support',
    price: 34.99,
    category: 'braces-supports',
    imagePath: 'assets/images/shop/wrist-splint.jpg',
    imageVariant: 'wearable',
    highlights: [
      'Breathable mesh with adjustable velcro',
      'Thumb-loop design keeps wrist aligned',
      'Great for carpal tunnel & sprain recovery',
    ],
    description:
        'Breathable wrist splint ideal for carpal tunnel, sprains, and post-cast support.',
  ),
  Product(
    id: 'ankle-brace',
    slug: 'ankle-support-brace',
    name: 'Ankle Support Brace',
    price: 39.99,
    category: 'braces-supports',
    imagePath: 'assets/images/shop/ankle-brace.webp',
    imageVariant: 'wearable',
    highlights: [
      'Lace-up support with figure-8 strap',
      'Low-profile fit inside most shoes',
      'Recommended for sprains & instability',
    ],
    description:
        'Low-profile ankle brace for sprains, instability, and return-to-sport protection.',
  ),
  Product(
    id: 'compression-ice-wrap',
    slug: 'compression-ice-wrap',
    name: 'Compression Ice Wrap',
    price: 29.99,
    category: 'pain-relief',
    imagePath: 'assets/images/shop/ice-wrap.jpg',
    imageVariant: 'packaging',
    highlights: [
      'Instant cooling relief in a reusable wrap',
      'One size — works on knee, elbow & ankle',
      'Minimizes swelling after activity or injury',
    ],
    description:
        'Combined compression and cold therapy wrap for knees, elbows, and ankles.',
  ),
  Product(
    id: 'arm-sling',
    slug: 'arm-sling-pocket',
    name: 'Arm Sling with Pocket',
    price: 27.99,
    category: 'braces-supports',
    imagePath: 'assets/images/shop/arm-sling.webp',
    imageVariant: 'wearable',
    highlights: [
      'Padded shoulder strap for comfort',
      'Built-in pocket for phone or small items',
      'Contoured pouch supports elbow & forearm',
    ],
    description:
        'Comfortable arm sling with padded strap and storage pocket for everyday use.',
  ),
];

Product? getProductById(String id) {
  try {
    return products.firstWhere((p) => p.id == id);
  } catch (_) {
    return null;
  }
}

String formatPrice(double amount) {
  return '\$${amount.toStringAsFixed(2)}';
}

/// Locations — ported from src/data/locations.js (summary fields)
class LocationItem {
  final String slug;
  final String name;
  final String address;
  final String city;
  final String phone;
  final String hours;
  final String imagePath;
  final List<String> features;

  const LocationItem({
    required this.slug,
    required this.name,
    required this.address,
    required this.city,
    required this.phone,
    required this.hours,
    required this.imagePath,
    required this.features,
  });
}

const locations = <LocationItem>[
  LocationItem(
    slug: 'los-angeles',
    name: 'Los Angeles',
    address: '8500 Beverly Boulevard, Suite 450',
    city: 'Los Angeles, CA 90048',
    phone: '(323) 655-8450',
    hours: 'Mon - Fri: 9 am to 5 pm',
    imagePath: 'assets/images/los-angeles.avif',
    features: [
      'Advanced Sports Medicine',
      'Joint Replacement',
      'Spinal Surgery',
    ],
  ),
  LocationItem(
    slug: 'london',
    name: 'London',
    address: '123 Harley Street',
    city: 'London, UK W1G 6AX',
    phone: '+44 20 7935 5555',
    hours: 'Mon - Fri: 9 am to 5 pm',
    imagePath: 'assets/images/london.jpg',
    features: [
      'Hand & Wrist Surgery',
      'Orthopedic Trauma Care',
      'Rehabilitation Services',
    ],
  ),
  LocationItem(
    slug: 'berlin',
    name: 'Berlin',
    address: 'Friedrichstraße 123',
    city: '10117 Berlin, Germany',
    phone: '+49 30 1234 5678',
    hours: 'Mon - Fri: 9 am to 5 pm',
    imagePath: 'assets/images/berlin.webp',
    features: [
      'Minimally Invasive Surgery',
      'Hip & Knee Care',
      'Pain Management',
    ],
  ),
];

LocationItem? getLocationBySlug(String slug) {
  try {
    return locations.firstWhere((l) => l.slug == slug);
  } catch (_) {
    return null;
  }
}

// Service navigation — aligned with src/data/services.js

import 'service_images.dart';

class ServiceItem {
  final String slug;
  final bool isSpecialty;

  const ServiceItem({
    required this.slug,
    this.isSpecialty = false,
  });
}

const primaryServices = <ServiceItem>[
  ServiceItem(slug: 'pain-inflammation'),
  ServiceItem(slug: 'injuries-fractures-sprains'),
  ServiceItem(slug: 'arthritis'),
  ServiceItem(slug: 'casting-splinting'),
  ServiceItem(slug: 'sports-medicine'),
  ServiceItem(slug: 'mri-digital-imaging'),
  ServiceItem(slug: 'prp-orthobiologics'),
  ServiceItem(slug: 'car-motor-vehicle-accident-care'),
];

const specialtyServices = <ServiceItem>[
  ServiceItem(slug: 'hand-wrist-care', isSpecialty: true),
  ServiceItem(slug: 'shoulder-elbow', isSpecialty: true),
  ServiceItem(slug: 'lumbar-cervical-spine', isSpecialty: true),
  ServiceItem(slug: 'chiropractic-surgery', isSpecialty: true),
  ServiceItem(slug: 'spine-surgery', isSpecialty: true),
  ServiceItem(slug: 'hip-knee-care', isSpecialty: true),
  ServiceItem(slug: 'foot-ankle-care', isSpecialty: true),
  ServiceItem(slug: 'total-joint-replacement', isSpecialty: true),
];

String serviceImagePath(String slug) => ServiceImages.listImagePath(slug);

ServiceItem? getServiceBySlug(String slug) {
  for (final s in primaryServices) {
    if (s.slug == slug) return s;
  }
  for (final s in specialtyServices) {
    if (s.slug == slug) return s;
  }
  return null;
}

List<ServiceItem> get allServices => [...primaryServices, ...specialtyServices];

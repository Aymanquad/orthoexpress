/** All clinic locations — summaries + detail pages share this data */
export const LOCATIONS = [
  {
    slug: 'los-angeles',
    name: 'Los Angeles',
    address: '8500 Beverly Boulevard, Suite 450',
    city: 'Los Angeles, CA 90048',
    phone: '(323) 655-8450',
    hours: 'Mon - Fri: 9 am to 5 pm',
    hoursShort: 'Mon-Fri: 9AM-5PM',
    image: '/assets/los-angeles.avif',
    features: ['Advanced Sports Medicine', 'Joint Replacement', 'Spinal Surgery'],
    title: 'Orthopedic Urgent Care',
    description:
      'Conveniently located in the heart of Los Angeles with ample parking, our clinic provides quality and compassionate urgent and acute care walk-in services for non-life threatening illnesses and auto injuries.',
    description2:
      'From preventive care to careful diagnosis, from back pain or other problems related to a spinal condition, our team of expert physicians provide accurate diagnosis and a wide range of treatments.',
    description3:
      'Our Los Angeles facility features state-of-the-art diagnostic equipment and a dedicated team of orthopedic specialists. We offer comprehensive treatment options including non-surgical interventions, advanced surgical procedures, and personalized rehabilitation programs. Our clinic is equipped to handle everything from sports injuries to complex joint replacements, ensuring you receive the highest quality care in a comfortable, modern environment.',
    highlights: ['urgent and acute care', 'illnesses', 'Injuries'],
    specialties: ['Advanced Sports Medicine', 'Joint Replacement', 'Spinal Surgery'],
    services: [
      'Emergency Orthopedic Care',
      'Sports Injury Treatment',
      'Joint Replacement Surgery',
      'Spinal Surgery & Treatment',
      'Physical Therapy & Rehabilitation',
      'X-Ray & Diagnostic Imaging',
      'Pain Management',
      'Workers Compensation Services',
    ],
    locationFeatures: [
      'Same-Day Appointments Available',
      'Walk-In Urgent Care',
      'On-Site X-Ray Facilities',
      'Expert Orthopedic Surgeons',
      'Modern Surgical Suites',
      'Physical Therapy Center',
      'Ample Parking Available',
      'Wheelchair Accessible',
    ],
  },
  {
    slug: 'london',
    name: 'London',
    address: '123 Harley Street',
    city: 'London, UK W1G 6AX',
    phone: '+44 20 7935 5555',
    hours: 'Mon - Fri: 9 am to 5 pm',
    hoursShort: 'Mon-Fri: 9AM-5PM',
    image: '/assets/london.jpg',
    features: ['Hand & Wrist Surgery', 'Orthopedic Trauma Care', 'Rehabilitation Services'],
    title: 'Orthopedic Urgent Care',
    description:
      'Conveniently located in the prestigious Harley Street medical district with ample parking, our clinic provides quality and compassionate urgent and acute care walk-in services for non-life threatening illnesses and auto injuries.',
    description2:
      'From preventive care to careful diagnosis, from back pain or other problems related to a spinal condition, our team of expert physicians provide accurate diagnosis and a wide range of treatments.',
    description3:
      'Our Harley Street location represents the pinnacle of orthopedic excellence in London. With a reputation built on precision, innovation, and patient-centered care, our facility offers specialized services in hand and wrist surgery, orthopedic trauma management, and comprehensive rehabilitation. Our team of internationally recognized surgeons utilizes the latest techniques and technologies to deliver exceptional outcomes for our patients.',
    highlights: ['urgent and acute care', 'illnesses', 'Injuries'],
    specialties: ['Hand & Wrist Surgery', 'Orthopedic Trauma Care', 'Rehabilitation Services'],
    services: [
      'Hand & Wrist Surgery',
      'Orthopedic Trauma Care',
      'Complex Fracture Management',
      'Microsurgery',
      'Rehabilitation Services',
      'Occupational Therapy',
      'Custom Splinting & Bracing',
      'Arthroscopic Procedures',
    ],
    locationFeatures: [
      'Prestigious Harley Street Location',
      'Internationally Recognized Surgeons',
      'Advanced Surgical Facilities',
      'Comprehensive Rehabilitation Center',
      'Private Consultation Rooms',
      'Multilingual Staff',
      'International Patient Services',
      'Easy Transport Access',
    ],
  },
  {
    slug: 'berlin',
    name: 'Berlin',
    address: 'Friedrichstraße 123',
    city: '10117 Berlin, Germany',
    phone: '+49 30 1234 5678',
    hours: 'Mon - Fri: 9 am to 5 pm',
    hoursShort: 'Mon-Fri: 9AM-5PM',
    image: '/assets/berlin.webp',
    features: ['Minimally Invasive Surgery', 'Hip & Knee Care', 'Pain Management'],
    title: 'Orthopedic Urgent Care',
    description:
      'Conveniently located in central Berlin with ample parking, our clinic provides quality and compassionate urgent and acute care walk-in services for non-life threatening illnesses and auto injuries.',
    description2:
      'From preventive care to careful diagnosis, from back pain or other problems related to a spinal condition, our team of expert physicians provide accurate diagnosis and a wide range of treatments.',
    description3:
      'Our Berlin clinic combines cutting-edge medical technology with a patient-first approach. Specializing in minimally invasive surgical techniques, hip and knee care, and comprehensive pain management, we serve both local and international patients. Our multilingual team ensures clear communication, and our modern facility is designed to provide a comfortable, efficient healthcare experience in the heart of Europe.',
    highlights: ['urgent and acute care', 'illnesses', 'Injuries'],
    specialties: ['Minimally Invasive Surgery', 'Hip & Knee Care', 'Pain Management'],
    services: [
      'Minimally Invasive Surgery',
      'Hip & Knee Replacement',
      'Arthroscopic Surgery',
      'Pain Management & Injections',
      'Physical Therapy',
      'Sports Medicine',
      'Pediatric Orthopedics',
      'Geriatric Orthopedic Care',
    ],
    locationFeatures: [
      'Central Berlin Location',
      'Minimally Invasive Techniques',
      'State-of-the-Art Operating Rooms',
      'Multilingual Medical Staff',
      'International Patient Coordination',
      'Comprehensive Pain Management',
      'Rehabilitation Services',
      'Public Transport Access',
    ],
  },
]

export function getLocationBySlug(slug) {
  return LOCATIONS.find((loc) => loc.slug === slug)
}

export function getLocationNavItems() {
  return LOCATIONS.map(({ name, slug }) => ({ name, slug }))
}

/** Shape expected by LocationDetail page */
export function getLocationDetail(slug) {
  const loc = getLocationBySlug(slug)
  if (!loc) return null

  return {
    name: loc.name,
    displayName: loc.name,
    address: loc.address,
    city: loc.city,
    phone: loc.phone,
    hours: loc.hours,
    heroImage: loc.image,
    contentImage: loc.image,
    title: loc.title,
    description: loc.description,
    description2: loc.description2,
    description3: loc.description3,
    highlights: loc.highlights,
    specialties: loc.specialties,
    services: loc.services,
    features: loc.locationFeatures,
  }
}

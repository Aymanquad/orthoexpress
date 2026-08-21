import '../core/l10n/localized.dart';

class Doctor {
  final String id;
  final String name;
  final L10nString specialty;
  final L10nString clinic;
  final String phone;
  final String username;
  final String password;
  final String monogram;
  final bool availableNow;
  final L10nString bio;

  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.clinic,
    required this.phone,
    required this.username,
    required this.password,
    required this.monogram,
    required this.availableNow,
    required this.bio,
  });
}

const demoDoctors = <Doctor>[
  Doctor(
    id: 'dr-chen',
    name: 'Dr. Maya Chen',
    specialty: L10nString(en: 'Sports Medicine', es: 'Medicina deportiva'),
    clinic: L10nString(en: 'Los Angeles', es: 'Los Ángeles'),
    phone: '(323) 655-8451',
    username: 'dr.chen',
    password: 'doctor123',
    monogram: 'MC',
    availableNow: true,
    bio: L10nString(
      en: 'Same-day injury care, sprains, and return-to-sport guidance.',
      es: 'Atención de lesiones el mismo día, esguinces y retorno al deporte.',
    ),
  ),
  Doctor(
    id: 'dr-patel',
    name: 'Dr. Arjun Patel',
    specialty: L10nString(en: 'Joint Replacement', es: 'Reemplazo articular'),
    clinic: L10nString(en: 'Midland', es: 'Midland'),
    phone: '(432) 322-8676',
    username: 'dr.patel',
    password: 'doctor123',
    monogram: 'AP',
    availableNow: true,
    bio: L10nString(
      en: 'Hip and knee consults, post-op check-ins, and recovery questions.',
      es: 'Consultas de cadera y rodilla, controles postoperatorios y recuperación.',
    ),
  ),
  Doctor(
    id: 'dr-rivera',
    name: 'Dr. Sofia Rivera',
    specialty: L10nString(en: 'Spine Care', es: 'Cuidado de la columna'),
    clinic: L10nString(en: 'Los Angeles', es: 'Los Ángeles'),
    phone: '(323) 655-8452',
    username: 'dr.rivera',
    password: 'doctor123',
    monogram: 'SR',
    availableNow: false,
    bio: L10nString(
      en: 'Back and neck pain triage, imaging follow-up, and conservative care.',
      es: 'Triage de dolor de espalda y cuello, imágenes y cuidado conservador.',
    ),
  ),
  Doctor(
    id: 'dr-okonkwo',
    name: 'Dr. James Okonkwo',
    specialty: L10nString(en: 'Trauma & Fractures', es: 'Trauma y fracturas'),
    clinic: L10nString(en: 'Midland', es: 'Midland'),
    phone: '(432) 322-8677',
    username: 'dr.okonkwo',
    password: 'doctor123',
    monogram: 'JO',
    availableNow: true,
    bio: L10nString(
      en: 'Acute injury calls, fracture follow-ups, and urgent orthopedic advice.',
      es: 'Llamadas por lesiones agudas, seguimiento de fracturas y consejo urgente.',
    ),
  ),
  Doctor(
    id: 'dr-nguyen',
    name: 'Dr. Linh Nguyen',
    specialty: L10nString(en: 'Hand & Wrist', es: 'Mano y muñeca'),
    clinic: L10nString(en: 'Los Angeles', es: 'Los Ángeles'),
    phone: '(323) 655-8453',
    username: 'dr.nguyen',
    password: 'doctor123',
    monogram: 'LN',
    availableNow: true,
    bio: L10nString(
      en: 'Carpal tunnel, tendon injuries, and post-splint check-ins.',
      es: 'Túnel carpiano, lesiones de tendón y controles post-férula.',
    ),
  ),
  Doctor(
    id: 'dr-hassan',
    name: 'Dr. Omar Hassan',
    specialty: L10nString(en: 'Foot & Ankle', es: 'Pie y tobillo'),
    clinic: L10nString(en: 'Midland', es: 'Midland'),
    phone: '(432) 322-8678',
    username: 'dr.hassan',
    password: 'doctor123',
    monogram: 'OH',
    availableNow: false,
    bio: L10nString(
      en: 'Sprains, plantar pain, and walking-boot recovery questions.',
      es: 'Esguinces, dolor plantar y recuperación con bota ortopédica.',
    ),
  ),
  Doctor(
    id: 'dr-brooks',
    name: 'Dr. Elena Brooks',
    specialty: L10nString(en: 'Pediatric Orthopedics', es: 'Ortopedia pediátrica'),
    clinic: L10nString(en: 'Los Angeles', es: 'Los Ángeles'),
    phone: '(323) 655-8454',
    username: 'dr.brooks',
    password: 'doctor123',
    monogram: 'EB',
    availableNow: true,
    bio: L10nString(
      en: 'Growth-related concerns, sports injuries in teens, and parent guidance.',
      es: 'Crecimiento, lesiones deportivas en adolescentes y orientación a padres.',
    ),
  ),
];

Doctor? doctorById(String id) {
  for (final d in demoDoctors) {
    if (d.id == id) return d;
  }
  return null;
}

Doctor? doctorByUsername(String username) {
  final key = username.trim().toLowerCase();
  for (final d in demoDoctors) {
    if (d.username.toLowerCase() == key) return d;
  }
  return null;
}

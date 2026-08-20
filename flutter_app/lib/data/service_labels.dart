import '../core/l10n/localized.dart';

/// Service names and card summaries — from src/i18n/services.js
class ServiceLabels {
  static const Map<String, L10nString> names = {
    'pain-inflammation': L10nString(en: 'Pain & Inflammation', es: 'Dolor e inflamación'),
    'injuries-fractures-sprains': L10nString(
      en: 'Injuries, Fractures & Sprains',
      es: 'Lesiones, fracturas y esguinces',
    ),
    'arthritis': L10nString(en: 'Arthritis', es: 'Artritis'),
    'casting-splinting': L10nString(en: 'Casting & Splinting', es: 'Yesos y férulas'),
    'sports-medicine': L10nString(
      en: 'Sports Medicine (Physicals)',
      es: 'Medicina deportiva (exámenes físicos)',
    ),
    'mri-digital-imaging': L10nString(
      en: 'MRI & Digital Imaging',
      es: 'Resonancia magnética e imágenes digitales',
    ),
    'prp-orthobiologics': L10nString(
      en: 'PRP Therapy & Orthobiologics',
      es: 'Terapia con PRP y ortobiología',
    ),
    'car-motor-vehicle-accident-care': L10nString(
      en: 'Car Accident Care',
      es: 'Atención por accidente de auto',
    ),
    'motorcycle-accident-care': L10nString(
      en: 'Motorcycle Accident Care',
      es: 'Atención por accidente de motocicleta',
    ),
    'pedestrian-injury-care': L10nString(
      en: 'Pedestrian Injury Care',
      es: 'Atención por lesión de peatón',
    ),
    'truck-accident-care': L10nString(
      en: 'Truck Accident Care',
      es: 'Atención por accidente de camión',
    ),
    'work-injury-care': L10nString(
      en: 'Work Injury Care',
      es: 'Atención por lesión laboral',
    ),
    'hand-wrist-care': L10nString(en: 'Hand & Wrist Care', es: 'Atención de mano y muñeca'),
    'shoulder-elbow': L10nString(en: 'Shoulder & Elbow Care', es: 'Atención de hombro y codo'),
    'lumbar-cervical-spine': L10nString(
      en: 'Lumbar & Cervical Spine Care',
      es: 'Atención de columna lumbar y cervical',
    ),
    'chiropractic-surgery': L10nString(
      en: 'Chiropractic',
      es: 'Quiropráctica',
    ),
    'spine-surgery': L10nString(en: 'Spine Surgery', es: 'Cirugía de columna'),
    'hip-knee-care': L10nString(en: 'Hip & Knee Care', es: 'Atención de cadera y rodilla'),
    'foot-ankle-care': L10nString(en: 'Foot & Ankle Care', es: 'Atención de pie y tobillo'),
    'muscle-soft-tissue-care': L10nString(
      en: 'Muscle & Soft Tissue',
      es: 'Músculo y tejidos blandos',
    ),
    'total-joint-replacement': L10nString(
      en: 'Total Joint Replacement',
      es: 'Reemplazo articular total',
    ),
    'workers-comp': L10nString(en: "Workers' Compensation", es: 'Compensación laboral'),
  };

  static const Map<String, L10nString> summaries = {
    'pain-inflammation': L10nString(
      en: 'We diagnose and treat acute and chronic musculoskeletal pain caused by injuries, overuse, or degenerative conditions.',
      es: 'Diagnosticamos y tratamos el dolor musculoesquelético agudo y crónico causado por lesiones, sobreuso o condiciones degenerativas.',
    ),
    'injuries-fractures-sprains': L10nString(
      en: 'Expert care for fractures, sprains, sports injuries, and workplace trauma — with same-day walk-in availability.',
      es: 'Atención experta para fracturas, esguinces, lesiones deportivas y trauma laboral — con disponibilidad sin cita el mismo día.',
    ),
    'arthritis': L10nString(
      en: 'Comprehensive arthritis care to reduce pain, stiffness, and swelling with conservative treatments and advanced options when needed.',
      es: 'Atención integral de artritis para reducir dolor, rigidez e hinchazón con tratamientos conservadores y opciones avanzadas cuando sea necesario.',
    ),
    'casting-splinting': L10nString(
      en: 'Proper stabilization is critical for healing fractures and ligament injuries. We provide expert casting and splinting services.',
      es: 'La estabilización adecuada es crítica para sanar fracturas y lesiones de ligamentos. Ofrecemos servicios expertos de yesos y férulas.',
    ),
    'sports-medicine': L10nString(
      en: 'We specialize in diagnosing and treating sports injuries for everyone from weekend warriors to competitive athletes, including physicals.',
      es: 'Nos especializamos en diagnosticar y tratar lesiones deportivas para todos, desde aficionados hasta atletas competitivos, incluyendo exámenes físicos.',
    ),
    'mri-digital-imaging': L10nString(
      en: 'State-of-the-art imaging services provide fast, accurate diagnostics for bone and soft tissue injuries.',
      es: 'Servicios de imágenes de última generación proporcionan diagnósticos rápidos y precisos para lesiones óseas y de tejidos blandos.',
    ),
    'prp-orthobiologics': L10nString(
      en: 'Regenerative treatment options that support natural healing for tendon, ligament, and joint conditions.',
      es: 'Opciones de tratamiento regenerativo que apoyan la sanación natural para condiciones de tendones, ligamentos y articulaciones.',
    ),
    'car-motor-vehicle-accident-care': L10nString(
      en: 'Same-day evaluation and treatment for car accident injuries, with imaging and insurance documentation support.',
      es: 'Evaluación y tratamiento el mismo día para lesiones por accidente de auto, con imagenología y apoyo en documentación de seguros.',
    ),
    'motorcycle-accident-care': L10nString(
      en: 'Expert orthopedic care after motorcycle crashes — fractures, road rash, and impact injuries evaluated walk-in.',
      es: 'Atención ortopédica experta después de accidentes de motocicleta — fracturas, abrasiones y lesiones por impacto sin cita.',
    ),
    'pedestrian-injury-care': L10nString(
      en: 'Urgent walk-in care for pedestrians hit by vehicles — fractures, soft tissue trauma, and spinal evaluation.',
      es: 'Atención urgente sin cita para peatones atropellados — fracturas, trauma de tejidos blandos y evaluación espinal.',
    ),
    'truck-accident-care': L10nString(
      en: 'Specialized injury evaluation after truck and commercial vehicle collisions, with thorough documentation.',
      es: 'Evaluación especializada de lesiones tras colisiones con camiones y vehículos comerciales, con documentación completa.',
    ),
    'work-injury-care': L10nString(
      en: 'On-the-job injury evaluation, workers compensation documentation, and return-to-work treatment plans.',
      es: 'Evaluación de lesiones laborales, documentación de compensación laboral y planes de tratamiento para el regreso al trabajo.',
    ),
    'hand-wrist-care': L10nString(
      en: 'Expert treatment for carpal tunnel, wrist fractures, tendon injuries, and conditions affecting hand function.',
      es: 'Tratamiento experto para túnel carpiano, fracturas de muñeca, lesiones de tendones y condiciones que afectan la función de la mano.',
    ),
    'shoulder-elbow': L10nString(
      en: 'From rotator cuff tears to tennis elbow, we restore mobility and relieve pain in the shoulder and elbow.',
      es: 'Desde desgarros del manguito rotador hasta codo de tenista, restauramos la movilidad y aliviamos el dolor en hombro y codo.',
    ),
    'lumbar-cervical-spine': L10nString(
      en: 'Specialized treatment for herniated discs, sciatica, neck pain, and other spine-related conditions.',
      es: 'Tratamiento especializado para hernias de disco, ciática, dolor de cuello y otras condiciones relacionadas con la columna.',
    ),
    'chiropractic-surgery': L10nString(
      en: 'Integrated spinal care with chiropractic evaluation, manual therapy, and coordinated surgical options when needed.',
      es: 'Atención espinal integral con evaluación quiropráctica, terapia manual y opciones quirúrgicas coordinadas cuando sea necesario.',
    ),
    'spine-surgery': L10nString(
      en: 'Advanced surgical treatment for herniated discs, stenosis, and complex spine conditions — minimally invasive when possible.',
      es: 'Tratamiento quirúrgico avanzado para hernias discales, estenosis y afecciones complejas de columna — mínimamente invasivo cuando sea posible.',
    ),
    'hip-knee-care': L10nString(
      en: 'Comprehensive care for hip and knee injuries, arthritis, ACL tears, and weight-bearing joint conditions.',
      es: 'Atención integral para lesiones de cadera y rodilla, artritis, desgarros de LCA y condiciones de articulaciones de carga.',
    ),
    'foot-ankle-care': L10nString(
      en: 'Treatment for sprains, plantar fasciitis, Achilles injuries, and foot deformities to keep you moving.',
      es: 'Tratamiento para esguinces, fascitis plantar, lesiones de Aquiles y deformidades del pie para mantenerlo en movimiento.',
    ),
    'muscle-soft-tissue-care': L10nString(
      en: 'Same-day walk-in care for muscle strains, tendonitis, and soft-tissue injuries.',
      es: 'Atención sin cita el mismo día para distensiones musculares, tendinitis y lesiones de tejidos blandos.',
    ),
    'total-joint-replacement': L10nString(
      en: 'Advanced hip, knee, and shoulder replacement procedures to restore mobility and reduce chronic joint pain.',
      es: 'Procedimientos avanzados de reemplazo de cadera, rodilla y hombro para restaurar movilidad y reducir dolor articular crónico.',
    ),
    'workers-comp': L10nString(
      en: 'Complete workers compensation injury care with documentation, treatment plans, and return-to-work support.',
      es: 'Atención completa de lesiones de compensación laboral con documentación, planes de tratamiento y apoyo para el regreso al trabajo.',
    ),
  };

  static String name(String slug, String lang) =>
      names[slug]?.forLang(lang) ?? slug;

  static String summary(String slug, String lang) =>
      summaries[slug]?.forLang(lang) ?? '';
}

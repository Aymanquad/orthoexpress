import '../core/l10n/localized.dart';

class EhrSystem {
  final String id;
  final String name;
  final String monogram;
  final String developer;
  final L10nString country;
  final L10nString highlight;

  const EhrSystem({
    required this.id,
    required this.name,
    required this.monogram,
    required this.developer,
    required this.country,
    required this.highlight,
  });
}

/// EHR systems OrthoExpress integrates with (homepage showcase).
const ehrSystems = <EhrSystem>[
  EhrSystem(
    id: 'epic',
    name: 'Epic Systems',
    monogram: 'EP',
    developer: 'Epic Systems Corporation',
    country: L10nString(en: 'United States', es: 'Estados Unidos'),
    highlight: L10nString(
      en: 'Hospital and academic medical center focus — interoperability, analytics, and scale.',
      es: 'Enfoque en hospitales y centros médicos académicos — interoperabilidad, analítica y escala.',
    ),
  ),
  EhrSystem(
    id: 'oracle-health',
    name: 'Oracle Health',
    monogram: 'OH',
    developer: 'Oracle Health (formerly Cerner)',
    country: L10nString(en: 'United States', es: 'Estados Unidos'),
    highlight: L10nString(
      en: 'Millennium platform with open APIs, global reach, and AI-assisted clinical support.',
      es: 'Plataforma Millennium con APIs abiertas, alcance global y apoyo clínico asistido por IA.',
    ),
  ),
  EhrSystem(
    id: 'meditech',
    name: 'MEDITECH',
    monogram: 'MT',
    developer: 'MEDITECH Inc.',
    country: L10nString(en: 'United States', es: 'Estados Unidos'),
    highlight: L10nString(
      en: 'Acute and community hospital workflows — scalable from small facilities upward.',
      es: 'Flujos para hospitales agudos y comunitarios — escalable desde centros pequeños.',
    ),
  ),
  EhrSystem(
    id: 'athenahealth',
    name: 'athenahealth',
    monogram: 'AH',
    developer: 'Athenahealth, Inc.',
    country: L10nString(en: 'United States', es: 'Estados Unidos'),
    highlight: L10nString(
      en: 'Cloud EHR with practice management, billing, telehealth, and ambulatory insights.',
      es: 'EHR en la nube con gestión de práctica, facturación, telesalud e insights ambulatorios.',
    ),
  ),
  EhrSystem(
    id: 'nextgen',
    name: 'NextGen Healthcare',
    monogram: 'NG',
    developer: 'NextGen Healthcare, Inc.',
    country: L10nString(en: 'United States', es: 'Estados Unidos'),
    highlight: L10nString(
      en: 'Specialty templates, patient portal, telehealth, and revenue cycle for mid-sized practices.',
      es: 'Plantillas por especialidad, portal del paciente, telesalud y ciclo de ingresos.',
    ),
  ),
  EhrSystem(
    id: 'eclinicalworks',
    name: 'eClinicalWorks',
    monogram: 'eC',
    developer: 'eClinicalWorks',
    country: L10nString(en: 'United States', es: 'Estados Unidos'),
    highlight: L10nString(
      en: 'Cloud and mobile EHR with telehealth, engagement tools, and population health.',
      es: 'EHR en la nube y móvil con telesalud, engagement y salud poblacional.',
    ),
  ),
  EhrSystem(
    id: 'greenway',
    name: 'Greenway Health',
    monogram: 'GH',
    developer: 'Greenway Health, LLC',
    country: L10nString(en: 'United States', es: 'Estados Unidos'),
    highlight: L10nString(
      en: 'Ambulatory EHR with built-in RCM and customizable clinical workflows.',
      es: 'EHR ambulatorio con RCM integrado y flujos clínicos personalizables.',
    ),
  ),
  EhrSystem(
    id: 'veradigm',
    name: 'Veradigm',
    monogram: 'VA',
    developer: 'Veradigm (formerly Allscripts)',
    country: L10nString(en: 'United States', es: 'Estados Unidos'),
    highlight: L10nString(
      en: 'Ambulatory solutions with open APIs, scheduling, billing, and modular specialties.',
      es: 'Soluciones ambulatorias con APIs abiertas, citas, facturación y especialidades modulares.',
    ),
  ),
  EhrSystem(
    id: 'practice-fusion',
    name: 'Practice Fusion',
    monogram: 'PF',
    developer: 'Veradigm (Practice Fusion)',
    country: L10nString(en: 'United States', es: 'Estados Unidos'),
    highlight: L10nString(
      en: 'Affordable web-based EHR with e-prescribing and lab integration for small practices.',
      es: 'EHR web asequible con e-prescripción e integración de laboratorios para clínicas pequeñas.',
    ),
  ),
  EhrSystem(
    id: 'advancedmd',
    name: 'AdvancedMD',
    monogram: 'AM',
    developer: 'AdvancedMD, Inc.',
    country: L10nString(en: 'United States', es: 'Estados Unidos'),
    highlight: L10nString(
      en: 'SaaS EHR with telemedicine, customizable templates, and practice analytics.',
      es: 'EHR SaaS con telemedicina, plantillas personalizables y analítica de práctica.',
    ),
  ),
  EhrSystem(
    id: 'dedalus',
    name: 'Dedalus',
    monogram: 'DE',
    developer: 'Dedalus Group',
    country: L10nString(en: 'Italy', es: 'Italia'),
    highlight: L10nString(
      en: "Europe's largest health IT vendor — integrated EHR, lab, and imaging systems.",
      es: 'El mayor proveedor de TI de salud en Europa — EHR, laboratorio e imagen integrados.',
    ),
  ),
  EhrSystem(
    id: 'trakcare',
    name: 'InterSystems TrakCare',
    monogram: 'TC',
    developer: 'InterSystems Corporation',
    country: L10nString(en: 'United States', es: 'Estados Unidos'),
    highlight: L10nString(
      en: 'Global unified patient record with analytics and strong FHIR support.',
      es: 'Registro de paciente unificado global con analítica y sólido soporte FHIR.',
    ),
  ),
  EhrSystem(
    id: 'emis',
    name: 'EMIS Health',
    monogram: 'EM',
    developer: 'EMIS Health (part of Optum)',
    country: L10nString(en: 'United Kingdom', es: 'Reino Unido'),
    highlight: L10nString(
      en: 'UK primary care leader — prescribing, patient portals, and GP–pharmacy links.',
      es: 'Líder en atención primaria del Reino Unido — recetas, portales y enlace GP–farmacia.',
    ),
  ),
  EhrSystem(
    id: 'systmone',
    name: 'SystmOne',
    monogram: 'S1',
    developer: 'The Phoenix Partnership (TPP)',
    country: L10nString(en: 'United Kingdom', es: 'Reino Unido'),
    highlight: L10nString(
      en: 'NHS primary and community care with real-time record sharing and mobile access.',
      es: 'Atención primaria y comunitaria del NHS con registros en tiempo real y acceso móvil.',
    ),
  ),
  EhrSystem(
    id: 'vision',
    name: 'Vision',
    monogram: 'VI',
    developer: 'Cegedim Healthcare Solutions',
    country: L10nString(en: 'United Kingdom', es: 'Reino Unido'),
    highlight: L10nString(
      en: 'UK primary care EHR with intuitive prescribing and cross-practice data sharing.',
      es: 'EHR de atención primaria del Reino Unido con recetas intuitivas e intercambio de datos.',
    ),
  ),
  EhrSystem(
    id: 'carecloud',
    name: 'CareCloud',
    monogram: 'CC',
    developer: 'CareCloud, Inc.',
    country: L10nString(en: 'United States', es: 'Estados Unidos'),
    highlight: L10nString(
      en: 'Cloud EHR plus practice management, RCM, billing, and telemedicine.',
      es: 'EHR en la nube con gestión de práctica, RCM, facturación y telemedicina.',
    ),
  ),
  EhrSystem(
    id: 'drchrono',
    name: 'DrChrono',
    monogram: 'DC',
    developer: 'DrChrono, Inc.',
    country: L10nString(en: 'United States', es: 'Estados Unidos'),
    highlight: L10nString(
      en: 'Mobile-first EHR for iPad and iPhone — scheduling and telehealth built in.',
      es: 'EHR móvil para iPad e iPhone — citas y telesalud integradas.',
    ),
  ),
  EhrSystem(
    id: 'kareo',
    name: 'Kareo Clinical',
    monogram: 'KA',
    developer: 'Kareo, Inc.',
    country: L10nString(en: 'United States', es: 'Estados Unidos'),
    highlight: L10nString(
      en: 'Cloud EHR with integrated billing, RCM, and engagement for independent practices.',
      es: 'EHR en la nube con facturación, RCM y engagement para prácticas independientes.',
    ),
  ),
  EhrSystem(
    id: 'modmed',
    name: 'ModMed',
    monogram: 'MM',
    developer: 'Modernizing Medicine, Inc.',
    country: L10nString(en: 'United States', es: 'Estados Unidos'),
    highlight: L10nString(
      en: 'Specialty-specific EHRs with AI documentation, telehealth, and analytics.',
      es: 'EHRs por especialidad con documentación IA, telesalud y analítica.',
    ),
  ),
  EhrSystem(
    id: 'ge-healthcare',
    name: 'GE Healthcare',
    monogram: 'GE',
    developer: 'GE Healthcare',
    country: L10nString(en: 'United States', es: 'Estados Unidos'),
    highlight: L10nString(
      en: 'Enterprise hospital deployments with imaging integration and clinical documentation.',
      es: 'Despliegues hospitalarios empresariales con integración de imagen y documentación clínica.',
    ),
  ),
];

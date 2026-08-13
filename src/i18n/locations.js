/** Location content translations and UI helpers */
import { localize, localizeArray } from './localize'
import { getLocationBySlug } from '../data/locations'

const LOCATION_I18N = {
  'los-angeles': {
    title: { es: 'Atención ortopédica urgente' },
    hours: { es: 'Lun - Vie: 9 am a 5 pm' },
    hoursShort: { es: 'Lun-Vie: 9AM-5PM' },
    features: {
      es: ['Medicina deportiva avanzada', 'Reemplazo articular', 'Cirugía de columna'],
    },
    description: {
      es: 'Convenientemente ubicada en el corazón de Los Ángeles con amplio estacionamiento, nuestra clínica brinda servicios de atención urgente y aguda compasivos para enfermedades no mortales y lesiones automovilísticas.',
    },
    description2: {
      es: 'Desde la atención preventiva hasta el diagnóstico cuidadoso, desde el dolor de espalda u otros problemas relacionados con una condición espinal, nuestro equipo de médicos expertos proporciona diagnóstico preciso y una amplia gama de tratamientos.',
    },
    services: {
      es: [
        'Atención ortopédica de emergencia',
        'Tratamiento de lesiones deportivas',
        'Cirugía de reemplazo articular',
        'Cirugía y tratamiento de columna',
        'Fisioterapia y rehabilitación',
        'Rayos X e imágenes diagnósticas',
        'Manejo del dolor',
        'Servicios de compensación laboral',
      ],
    },
    locationFeatures: {
      es: [
        'Citas el mismo día disponibles',
        'Atención urgente sin cita',
        'Instalaciones de rayos X en el sitio',
        'Cirujanos ortopédicos expertos',
        'Quirófanos modernos',
        'Centro de fisioterapia',
        'Amplio estacionamiento disponible',
        'Accesible para sillas de ruedas',
      ],
    },
  },
  london: {
    title: { es: 'Atención ortopédica urgente' },
    hours: { es: 'Lun - Vie: 9 am a 5 pm' },
    hoursShort: { es: 'Lun-Vie: 9AM-5PM' },
    features: {
      es: ['Cirugía de mano y muñeca', 'Atención de trauma ortopédico', 'Servicios de rehabilitación'],
    },
    description: {
      es: 'Convenientemente ubicada en el prestigioso distrito médico de Harley Street con amplio estacionamiento, nuestra clínica brinda servicios de atención urgente y aguda compasivos para enfermedades no mortales y lesiones automovilísticas.',
    },
    description2: {
      es: 'Desde la atención preventiva hasta el diagnóstico cuidadoso, nuestro equipo de médicos expertos proporciona diagnóstico preciso y una amplia gama de tratamientos.',
    },
    services: {
      es: [
        'Cirugía de mano y muñeca',
        'Atención de trauma ortopédico',
        'Manejo de fracturas complejas',
        'Microcirugía',
        'Servicios de rehabilitación',
        'Terapia ocupacional',
        'Férulas y yesos personalizados',
        'Procedimientos artroscópicos',
      ],
    },
    locationFeatures: {
      es: [
        'Ubicación prestigiosa en Harley Street',
        'Cirujanos reconocidos internacionalmente',
        'Instalaciones quirúrgicas avanzadas',
        'Centro de rehabilitación integral',
        'Salas de consulta privadas',
        'Personal multilingüe',
        'Servicios para pacientes internacionales',
        'Fácil acceso al transporte',
      ],
    },
  },
  berlin: {
    title: { es: 'Atención ortopédica urgente' },
    hours: { es: 'Lun - Vie: 9 am a 5 pm' },
    hoursShort: { es: 'Lun-Vie: 9AM-5PM' },
    features: {
      es: ['Cirugía mínimamente invasiva', 'Atención de cadera y rodilla', 'Manejo del dolor'],
    },
    description: {
      es: 'Convenientemente ubicada en el centro de Berlín con amplio estacionamiento, nuestra clínica brinda servicios de atención urgente y aguda compasivos para enfermedades no mortales y lesiones automovilísticas.',
    },
    description2: {
      es: 'Desde la atención preventiva hasta el diagnóstico cuidadoso, nuestro equipo de médicos expertos proporciona diagnóstico preciso y una amplia gama de tratamientos.',
    },
    services: {
      es: [
        'Cirugía mínimamente invasiva',
        'Reemplazo de cadera y rodilla',
        'Cirugía artroscópica',
        'Manejo del dolor e inyecciones',
        'Fisioterapia',
        'Medicina deportiva',
        'Ortopedia pediátrica',
        'Atención ortopédica geriátrica',
      ],
    },
    locationFeatures: {
      es: [
        'Ubicación central en Berlín',
        'Técnicas mínimamente invasivas',
        'Quirófanos de última generación',
        'Personal médico multilingüe',
        'Coordinación de pacientes internacionales',
        'Manejo integral del dolor',
        'Servicios de rehabilitación',
        'Acceso al transporte público',
      ],
    },
  },
}

export function getLocalizedLocation(slug, lang = 'en') {
  const loc = getLocationBySlug(slug)
  if (!loc) return null

  const i18n = LOCATION_I18N[slug] || {}

  return {
    ...loc,
    displayName: loc.name,
    heroImage: loc.image,
    contentImage: loc.image,
    title: localize(i18n.title, lang) || loc.title,
    description: localize(i18n.description, lang) || loc.description,
    description2: localize(i18n.description2, lang) || loc.description2,
    description3: loc.description3 ? localize(i18n.description3, lang) || loc.description3 : undefined,
    hours: localize(i18n.hours, lang) || loc.hours,
    hoursShort: localize(i18n.hoursShort, lang) || loc.hoursShort,
    services: localizeArray(i18n.services, lang).length
      ? localizeArray(i18n.services, lang)
      : loc.services,
    cardFeatures: localizeArray(i18n.features, lang).length
      ? localizeArray(i18n.features, lang)
      : loc.features,
    features: localizeArray(i18n.locationFeatures, lang).length
      ? localizeArray(i18n.locationFeatures, lang)
      : loc.locationFeatures,
    highlights: loc.highlights,
    specialties: loc.specialties,
  }
}

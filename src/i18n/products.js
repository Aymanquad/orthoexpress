/** Product name/description translations keyed by product id */
const PRODUCT_I18N = {
  'cbd-lotion-1000': {
    name: { es: 'Loción CBD OrthoNaturals 1000mg' },
    description: { es: 'Loción tópica de CBD formulada para el confort muscular y articular después de la actividad.' },
    highlights: {
      es: [
        '1000mg de CBD de espectro completo por botella',
        'Loción de absorción rápida para músculos y articulaciones',
        'Ideal después de entrenamientos o turnos largos de pie',
      ],
    },
  },
  'cbd-freeze-rollon': {
    name: { es: 'Roll-On Refrescante CBD OrthoNaturals 750mg' },
    description: { es: 'Roll-on refrescante con CBD para alivio dirigido en músculos y articulaciones adoloridos.' },
    highlights: {
      es: [
        'Mezcla refrescante de mentol + 750mg CBD',
        'Roll-on sin desorden para aplicación dirigida',
        'Cabe fácilmente en un bolso de gimnasio o viaje',
      ],
    },
  },
  'cbd-tincture-500': {
    name: { es: 'Tintura OrthoNaturals 500mg con Terpenos' },
    description: { es: 'Tintura de CBD de espectro completo con terpenos naturales para apoyo diario de bienestar.' },
    highlights: {
      es: [
        '500mg CBD con terpenos naturales',
        'Sabor a menta para uso diario fácil',
        '1 fl oz (30 ml) — aproximadamente un mes de suministro',
      ],
    },
  },
  'cold-therapy-gel-pack': {
    name: { es: 'Paquete de Gel de Terapia Fría Reutilizable' },
    description: { es: 'Paquete de gel flexible para hielo en lesiones, hinchazón y recuperación post-actividad.' },
    highlights: {
      es: [
        'Paquete de gel reutilizable de terapia caliente y fría',
        'Diseño flexible que se adapta a rodillas, tobillos y espalda',
        'Listo para microondas o congelador en minutos',
      ],
    },
  },
  'knee-stabilizer-brace': {
    name: { es: 'Férula Estabilizadora de Rodilla' },
    description: { es: 'Férula de rodilla ajustable con estabilizadores laterales para soporte de ligamentos y rótula.' },
    highlights: {
      es: [
        'Diseño de rótula abierta con estabilizadores laterales',
        'Correas ajustables para un ajuste seguro personalizado',
        'Material transpirable para uso todo el día',
      ],
    },
  },
  'wrist-splint': {
    name: { es: 'Soporte de Férula de Muñeca' },
    description: { es: 'Férula de muñeca transpirable ideal para túnel carpiano, esguinces y soporte post-yeso.' },
    highlights: {
      es: [
        'Malla transpirable con velcro ajustable',
        'Diseño con lazo para pulgar mantiene la muñeca alineada',
        'Excelente para túnel carpiano y recuperación de esguinces',
      ],
    },
  },
  'ankle-brace': {
    name: { es: 'Férula de Soporte de Tobillo' },
    description: { es: 'Férula de tobillo de perfil bajo para esguinces, inestabilidad y protección al regresar al deporte.' },
    highlights: {
      es: [
        'Soporte con cordones y correa en figura 8',
        'Ajuste de perfil bajo dentro de la mayoría de zapatos',
        'Recomendado para esguinces e inestabilidad',
      ],
    },
  },
  'compression-ice-wrap': {
    name: { es: 'Venda de Hielo con Compresión' },
    description: { es: 'Venda combinada de compresión y terapia fría para rodillas, codos y tobillos.' },
    highlights: {
      es: [
        'Alivio refrescante instantáneo en una venda reutilizable',
        'Talla única — funciona en rodilla, codo y tobillo',
        'Minimiza la hinchazón después de actividad o lesión',
      ],
    },
  },
  'arm-sling': {
    name: { es: 'Cabestrillo con Bolsillo' },
    description: { es: 'Cabestrillo cómodo con correa acolchada y bolsillo de almacenamiento para uso diario.' },
    highlights: {
      es: [
        'Correa de hombro acolchada para comodidad',
        'Bolsillo integrado para teléfono o artículos pequeños',
        'Bolsa contorneada soporta codo y antebrazo',
      ],
    },
  },
}

const PRODUCT_REVIEW_I18N = {
  'cbd-lotion-1000': {
    text: {
      es: 'Alivio notable en minutos en hombros adoloridos. No grasoso y recomendado por la clínica.',
    },
  },
  'cbd-freeze-rollon': {
    text: {
      es: 'Perfecto para mi espalda baja después de sesiones de fisioterapia. El efecto refrescante dura bastante.',
    },
  },
  'cbd-tincture-500': {
    text: {
      es: 'Me ayuda a relajarme por las noches sin sentir somnolencia. Calidad en la que puede confiar.',
    },
  },
  'cold-therapy-gel-pack': {
    text: {
      es: 'Se mantiene frío el tiempo suficiente para hielo post-partido. ¡Mucho mejor que una bolsa de guisantes!',
    },
  },
  'knee-stabilizer-brace': {
    text: {
      es: 'Me dio confianza para volver a trotar ligero después de mi distensión de menisco.',
    },
  },
  'wrist-splint': {
    text: {
      es: 'Lo suficientemente cómodo para usarlo en el escritorio todo el día. El dolor disminuyó en la primera semana.',
    },
  },
  'ankle-brace': {
    text: {
      es: 'Soporte sólido sin sentirse voluminoso. De vuelta a la cancha en dos semanas.',
    },
  },
  'compression-ice-wrap': {
    text: {
      es: 'Fácil de aplicar justo después de la práctica. Compresión más frío es un cambio total.',
    },
  },
  'arm-sling': {
    text: {
      es: 'Mucho más cómodo que el cabestrillo del hospital. El bolsillo es sorprendentemente útil.',
    },
  },
}

export function getProductField(product, field, lang = 'en') {
  if (!product) return ''
  if (lang === 'en') return product[field] ?? ''
  const translated = PRODUCT_I18N[product.id]?.[field]
  if (!translated) return product[field] ?? ''
  if (Array.isArray(translated.es)) return translated.es
  return translated.es ?? product[field] ?? ''
}

export function getProductReviewField(product, field, lang = 'en') {
  if (!product?.review) return ''
  if (lang === 'en') return product.review[field] ?? ''
  const translated = PRODUCT_REVIEW_I18N[product.id]?.[field]?.es
  return translated ?? product.review[field] ?? ''
}

export function getCategoryLabel(categoryId, t) {
  return t(`shop.categories.${categoryId}`) || categoryId
}

/** Patient experience content — telehealth, portal, after-visit, technology */

export const TELEHEALTH_WHEN = [
  {
    id: 'follow-up',
    title: { en: 'Follow-up visits', es: 'Consultas de seguimiento' },
    text: {
      en: 'Review healing progress, adjust treatment plans, and discuss imaging results without another trip to the clinic.',
      es: 'Revise la evolución, ajuste planes de tratamiento y comente resultados de imágenes sin otro viaje a la clínica.',
    },
  },
  {
    id: 'post-op',
    title: { en: 'Post-procedure check-ins', es: 'Controles post-procedimiento' },
    text: {
      en: 'Quick virtual visits after casting, splinting, or minor procedures when an in-person exam is not required.',
      es: 'Visitas virtuales rápidas después de yesos, férulas o procedimientos menores cuando no se requiere examen presencial.',
    },
  },
  {
    id: 'second-opinion',
    title: { en: 'Care coordination', es: 'Coordinación de atención' },
    text: {
      en: 'Connect with your care team about PT referrals, medication questions, and return-to-work or sport guidance.',
      es: 'Conéctese con su equipo sobre referencias de fisioterapia, medicamentos y orientación para volver al trabajo o deporte.',
    },
  },
]

export const TELEHEALTH_STEPS = [
  {
    id: 'book',
    title: { en: 'Request a virtual visit', es: 'Solicite una visita virtual' },
    text: {
      en: 'Call your center or book online. Our team confirms whether teleorthopedics is appropriate for your concern.',
      es: 'Llame a su centro o reserve en línea. Nuestro equipo confirma si la teleortopedia es adecuada para su caso.',
    },
  },
  {
    id: 'prep',
    title: { en: 'Prepare your visit', es: 'Prepare su visita' },
    text: {
      en: 'Use a phone, tablet, or computer with camera. Have your ID, insurance card, and any prior imaging ready.',
      es: 'Use teléfono, tableta u ordenador con cámara. Tenga su identificación, seguro e imágenes previas listas.',
    },
  },
  {
    id: 'connect',
    title: { en: 'Connect with your clinician', es: 'Conéctese con su clínico' },
    text: {
      en: 'Join your secure OrthoExpress Live session. Your provider evaluates symptoms, answers questions, and orders next steps.',
      es: 'Únase a su sesión segura OrthoExpress Live. Su proveedor evalúa síntomas, responde preguntas y ordena los siguientes pasos.',
    },
  },
]

export const AFTER_VISIT_STEPS = [
  {
    id: 'instructions',
    icon: 'clipboard',
    title: { en: 'Discharge instructions', es: 'Instrucciones al alta' },
    text: {
      en: 'Review home-care guidance, activity restrictions, and when to call if symptoms worsen.',
      es: 'Revise cuidados en casa, restricciones de actividad y cuándo llamar si los síntomas empeoran.',
    },
    link: '/contact-us',
    linkLabel: { en: 'Questions? Contact us', es: '¿Preguntas? Contáctenos' },
  },
  {
    id: 'imaging',
    icon: 'scan',
    title: { en: 'Imaging & results', es: 'Imágenes y resultados' },
    text: {
      en: 'If X-ray or MRI was ordered, we coordinate scheduling and follow up when results are available.',
      es: 'Si se ordenó radiografía o resonancia, coordinamos la programación y el seguimiento cuando haya resultados.',
    },
    link: '/services/mri-digital-imaging',
    linkLabel: { en: 'Imaging services', es: 'Servicios de imágenes' },
  },
  {
    id: 'pt',
    icon: 'rehab',
    title: { en: 'Physical therapy referrals', es: 'Referencias de fisioterapia' },
    text: {
      en: 'We connect you with trusted PT partners and share recovery goals so rehab starts on the right track.',
      es: 'Lo conectamos con socios de fisioterapia de confianza y compartimos metas de recuperación para un buen inicio.',
    },
    link: '/book-appointment',
    linkLabel: { en: 'Schedule follow-up', es: 'Programar seguimiento' },
  },
  {
    id: 'workers',
    icon: 'work',
    title: { en: "Workers' comp paperwork", es: 'Documentación de compensación laboral' },
    text: {
      en: 'Employer and adjuster documentation, work restrictions, and return-to-work plans are handled by our team.',
      es: 'Documentación para empleador y ajustador, restricciones laborales y planes de regreso al trabajo los gestiona nuestro equipo.',
    },
    link: '/workers-comp',
    linkLabel: { en: "Workers' comp hub", es: 'Centro de compensación laboral' },
  },
  {
    id: 'billing',
    icon: 'billing',
    title: { en: 'Billing & payment', es: 'Facturación y pagos' },
    text: {
      en: 'Review estimates, insurance coverage, and self-pay options. Pay balances online when your portal is active.',
      es: 'Revise estimados, cobertura de seguro y opciones de pago propio. Pague saldos en línea cuando su portal esté activo.',
    },
    link: '/payment',
    linkLabel: { en: 'Payment & insurance', es: 'Pagos y seguros' },
  },
  {
    id: 'tele',
    icon: 'video',
    title: { en: 'Virtual follow-ups', es: 'Seguimientos virtuales' },
    text: {
      en: 'Eligible patients can continue recovery with OrthoExpress Live teleorthopedics between in-clinic visits.',
      es: 'Pacientes elegibles pueden continuar la recuperación con teleortopedia OrthoExpress Live entre visitas presenciales.',
    },
    link: '/telehealth',
    linkLabel: { en: 'OrthoExpress Live', es: 'OrthoExpress Live' },
  },
]

export const PORTAL_FEATURES = [
  {
    id: 'records',
    title: { en: 'Visit summaries & records', es: 'Resúmenes de visita e historial' },
    text: {
      en: 'Access discharge instructions, visit notes, and request copies of imaging or medical records.',
      es: 'Acceda a instrucciones al alta, notas de visita y solicite copias de imágenes o historial médico.',
    },
    link: '/contact-us',
    internal: true,
  },
  {
    id: 'billing',
    title: { en: 'Pay your bill', es: 'Pague su factura' },
    text: {
      en: 'View statements, understand charges, and pay balances securely online.',
      es: 'Vea estados de cuenta, entienda cargos y pague saldos de forma segura en línea.',
    },
    link: '/payment',
    internal: true,
  },
  {
    id: 'appointments',
    title: { en: 'Appointments', es: 'Citas' },
    text: {
      en: 'Book follow-ups, telehealth visits, and manage upcoming appointments.',
      es: 'Reserve seguimientos, visitas de telemedicina y gestione citas próximas.',
    },
    link: '/book-appointment',
    internal: true,
  },
  {
    id: 'messages',
    title: { en: 'Secure messaging', es: 'Mensajería segura' },
    text: {
      en: 'Message your care team about non-urgent questions between visits (when portal messaging is enabled).',
      es: 'Envíe mensajes a su equipo sobre preguntas no urgentes entre visitas (cuando la mensajería esté habilitada).',
    },
    link: '/technology#orthochat',
    internal: true,
  },
]

export const TECHNOLOGY_FEATURES = [
  {
    id: 'ehr',
    title: { en: 'Electronic health records (EHR)', es: 'Historial clínico electrónico (ECE)' },
    text: {
      en: 'Unified digital records across centers so your history, allergies, and imaging follow you wherever you are seen.',
      es: 'Historial digital unificado en todos los centros para que su historial, alergias e imágenes le sigan donde sea atendido.',
    },
  },
  {
    id: 'imaging',
    title: { en: 'Digital imaging workflow', es: 'Flujo de imágenes digitales' },
    text: {
      en: 'On-site digital X-ray with rapid reads. MRI and advanced imaging are coordinated and results shared with your care team.',
      es: 'Radiografía digital en el centro con lecturas rápidas. Resonancia e imágenes avanzadas se coordinan y se comparten con su equipo.',
    },
  },
  {
    id: 'security',
    title: { en: 'Privacy & security', es: 'Privacidad y seguridad' },
    text: {
      en: 'HIPAA-aligned systems, encrypted data in transit and at rest, and role-based access for clinical staff only.',
      es: 'Sistemas alineados con HIPAA, datos cifrados en tránsito y en reposo, y acceso basado en roles solo para personal clínico.',
    },
  },
]

export const ORTHOCHAT_FEATURES = [
  {
    id: 'referrals',
    title: { en: 'Specialist referrals', es: 'Referencias a especialistas' },
    text: {
      en: 'Clinicians share imaging, notes, and treatment context securely when coordinating with surgeons or PT partners.',
      es: 'Los clínicos comparten imágenes, notas y contexto de tratamiento de forma segura al coordinar con cirujanos o fisioterapeutas.',
    },
  },
  {
    id: 'multisite',
    title: { en: 'Multi-center collaboration', es: 'Colaboración multi-centro' },
    text: {
      en: 'Providers across OrthoExpress locations access the same record so follow-ups stay consistent when you travel.',
      es: 'Los proveedores en todas las ubicaciones de OrthoExpress acceden al mismo historial para seguimientos consistentes cuando viaja.',
    },
  },
  {
    id: 'urgent',
    title: { en: 'Urgent case handoffs', es: 'Transferencias de casos urgentes' },
    text: {
      en: 'OrthoChat flags complex injuries for rapid review by senior clinicians without delaying your visit.',
      es: 'OrthoChat marca lesiones complejas para revisión rápida por clínicos senior sin retrasar su visita.',
    },
  },
]

export const FAQ_SPECIALTIES = [
  { id: 'all', label: { en: 'All topics', es: 'Todos los temas' } },
  { id: 'general', label: { en: 'General', es: 'General' } },
  { id: 'sports-medicine', label: { en: 'Sports Medicine', es: 'Medicina deportiva' } },
  { id: 'workers-comp', label: { en: "Workers' Comp", es: 'Compensación laboral' } },
  { id: 'mri-digital-imaging', label: { en: 'Imaging', es: 'Imágenes' } },
  { id: 'car-motor-vehicle-accident-care', label: { en: 'Auto Accident', es: 'Accidente de auto' } },
  { id: 'lumbar-cervical-spine', label: { en: 'Spine', es: 'Columna' } },
  { id: 'chiropractic-surgery', label: { en: 'Chiropractic', es: 'Quiropráctica' } },
  { id: 'spine-surgery', label: { en: 'Spine Surgery', es: 'Cirugía de columna' } },
  { id: 'hand-wrist-care', label: { en: 'Hand & Wrist', es: 'Mano y muñeca' } },
  { id: 'injuries-fractures-sprains', label: { en: 'Injuries', es: 'Lesiones' } },
  { id: 'arthritis', label: { en: 'Arthritis', es: 'Artritis' } },
  { id: 'pain-inflammation', label: { en: 'Pain', es: 'Dolor' } },
  { id: 'telehealth', label: { en: 'Telehealth', es: 'Telemedicina' } },
]

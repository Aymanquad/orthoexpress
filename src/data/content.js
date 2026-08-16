export const INSURANCE_PROVIDERS = [
  'ACPN',
  'AvMed',
  'AETNA',
  'Molina',
  'Cigna',
  'United Healthcare',
  'Coventry',
  'Florida Blue',
  'Simply Healthcare',
  'Medicare',
  'Medicaid',
]

export const SELF_PAY_PRICING = [
  {
    id: 'office-visit',
    name: { en: 'New Patient Office Visit', es: 'Consulta de paciente nuevo' },
    price: '$150 – $225',
    note: {
      en: 'Includes evaluation by an orthopedic specialist.',
      es: 'Incluye evaluación por un especialista ortopédico.',
    },
  },
  {
    id: 'follow-up',
    name: { en: 'Follow-Up Visit', es: 'Consulta de seguimiento' },
    price: '$85 – $125',
    note: {
      en: 'Established patients returning for continued care.',
      es: 'Pacientes establecidos que regresan para seguimiento.',
    },
  },
  {
    id: 'xray',
    name: { en: 'Digital X-Ray (per region)', es: 'Radiografía digital (por región)' },
    price: '$75 – $120',
    note: {
      en: 'On-site imaging when clinically indicated.',
      es: 'Imágenes en el centro cuando esté clínicamente indicado.',
    },
  },
  {
    id: 'casting',
    name: { en: 'Casting / Splinting', es: 'Yeso / Férula' },
    price: '$100 – $250',
    note: {
      en: 'Price varies by type and complexity of immobilization.',
      es: 'El precio varía según el tipo y complejidad.',
    },
  },
  {
    id: 'injection',
    name: { en: 'Joint Injection', es: 'Inyección articular' },
    price: '$175 – $350',
    note: {
      en: 'Therapeutic injection when appropriate for your condition.',
      es: 'Inyección terapéutica cuando sea adecuada para su condición.',
    },
  },
]

export const FAQS = [
  {
    id: 'walk-in',
    specialty: 'general',
    category: { en: 'Visits', es: 'Visitas' },
    q: {
      en: 'Do I need an appointment?',
      es: '¿Necesito una cita?',
    },
    a: {
      en: 'No. OrthoExpress accepts walk-ins and same-day visits. Appointments are available if you prefer to book ahead.',
      es: 'No. OrthoExpress acepta visitas sin cita y el mismo día. También puede reservar con anticipación si lo prefiere.',
    },
  },
  {
    id: 'what-bring',
    specialty: 'general',
    category: { en: 'Visits', es: 'Visitas' },
    q: {
      en: 'What should I bring to my visit?',
      es: '¿Qué debo llevar a mi visita?',
    },
    a: {
      en: 'Please bring a photo ID, your insurance card (if applicable), a list of current medications, and any prior imaging or records related to your injury.',
      es: 'Lleve una identificación con foto, su tarjeta de seguro (si aplica), una lista de medicamentos actuales y cualquier imagen o historial previo relacionado con su lesión.',
    },
  },
  {
    id: 'insurance',
    specialty: 'general',
    category: { en: 'Payment', es: 'Pagos' },
    q: {
      en: 'Do you accept insurance?',
      es: '¿Aceptan seguros?',
    },
    a: {
      en: 'Yes. We accept most major insurance plans. Call your local center to verify coverage, or visit our Insurance Providers page.',
      es: 'Sí. Aceptamos la mayoría de los planes de seguro principales. Llame a su centro local para verificar cobertura, o visite nuestra página de Aseguradoras.',
    },
  },
  {
    id: 'self-pay',
    specialty: 'general',
    category: { en: 'Payment', es: 'Pagos' },
    q: {
      en: 'What if I don’t have insurance?',
      es: '¿Qué pasa si no tengo seguro?',
    },
    a: {
      en: 'No problem. We offer transparent self-pay pricing for common services. See Self-Pay Pricing for estimated ranges.',
      es: 'No hay problema. Ofrecemos precios transparentes de pago propio. Consulte Precios de pago propio para rangos estimados.',
    },
  },
  {
    id: 'auto-accident',
    specialty: 'car-motor-vehicle-accident-care',
    category: { en: 'Auto Accident Care', es: 'Atención por accidente de auto' },
    q: {
      en: 'Do you treat injuries from car or motor vehicle accidents?',
      es: '¿Atienden lesiones por accidentes de auto o de vehículo?',
    },
    a: {
      en: 'Yes. We provide same-day evaluation and treatment for car and motor vehicle accident injuries, including documentation support for insurance claims.',
      es: 'Sí. Ofrecemos evaluación y tratamiento el mismo día para lesiones por accidentes de auto o de vehículo, incluyendo apoyo con documentación para reclamaciones de seguros.',
    },
  },
  {
    id: 'imaging',
    specialty: 'mri-digital-imaging',
    category: { en: 'Imaging', es: 'Imágenes' },
    q: {
      en: 'Do you offer X-rays or MRI?',
      es: '¿Ofrecen radiografías o resonancia magnética?',
    },
    a: {
      en: 'We provide digital X-ray evaluation and coordinate MRI / advanced imaging when needed for accurate diagnosis.',
      es: 'Ofrecemos evaluación con radiografía digital y coordinamos resonancia / imágenes avanzadas cuando sea necesario.',
    },
  },
  {
    id: 'workers-comp',
    specialty: 'workers-comp',
    category: { en: "Workers' Compensation", es: 'Compensación laboral' },
    q: {
      en: 'Do you handle workers’ compensation injuries?',
      es: '¿Atienden lesiones de compensación laboral?',
    },
    a: {
      en: 'Yes. We provide workers’ compensation injury care with documentation and return-to-work support.',
      es: 'Sí. Brindamos atención para lesiones de compensación laboral con documentación y apoyo para el regreso al trabajo.',
    },
  },
  {
    id: 'hours',
    specialty: 'general',
    category: { en: 'Locations', es: 'Ubicaciones' },
    q: {
      en: 'What are your hours?',
      es: '¿Cuáles son sus horarios?',
    },
    a: {
      en: 'Most centers are open Monday–Friday, 9:00 AM – 5:00 PM. Check your location page for specific hours.',
      es: 'La mayoría de los centros abren de lunes a viernes, 9:00 AM – 5:00 PM. Consulte la página de su ubicación para horarios específicos.',
    },
  },
  {
    id: 'tele',
    specialty: 'telehealth',
    category: { en: 'Telehealth', es: 'Telemedicina' },
    q: {
      en: 'Do you offer teleorthopedics?',
      es: '¿Ofrecen teleortopedia?',
    },
    a: {
      en: 'Yes. OrthoExpress Live offers secure virtual follow-ups for eligible patients. Visit our Telehealth page or call your center to schedule.',
      es: 'Sí. OrthoExpress Live ofrece seguimientos virtuales seguros para pacientes elegibles. Visite nuestra página de Telemedicina o llame a su centro para programar.',
    },
  },
  {
    id: 'shop',
    specialty: 'general',
    category: { en: 'Shop', es: 'Tienda' },
    q: {
      en: 'Can I buy braces or wellness products online?',
      es: '¿Puedo comprar órtesis o productos de bienestar en línea?',
    },
    a: {
      en: 'Yes. Visit the OrthoExpress Shop for braces, CBD topicals, cold therapy, and recovery essentials.',
      es: 'Sí. Visite la Tienda OrthoExpress para órtesis, productos tópicos de CBD, terapia de frío y esenciales de recuperación.',
    },
  },
  {
    id: 'sports-acl',
    specialty: 'sports-medicine',
    category: { en: 'Sports Medicine', es: 'Medicina deportiva' },
    q: {
      en: 'Can you evaluate a suspected ACL or meniscus injury same day?',
      es: '¿Pueden evaluar una posible lesión de LCA o menisco el mismo día?',
    },
    a: {
      en: 'Yes. We perform clinical exams, order imaging when needed, and discuss bracing, PT, or specialist referral options the same visit.',
      es: 'Sí. Realizamos exámenes clínicos, ordenamos imágenes cuando es necesario y comentamos opciones de férula, fisioterapia o referencia al especialista en la misma visita.',
    },
  },
  {
    id: 'sports-return',
    specialty: 'sports-medicine',
    category: { en: 'Sports Medicine', es: 'Medicina deportiva' },
    q: {
      en: 'When can I return to sports after a sprain or strain?',
      es: '¿Cuándo puedo volver al deporte después de un esguince o distensión?',
    },
    a: {
      en: 'It depends on the injury and healing stage. We provide activity-specific timelines and may coordinate PT before full return-to-play.',
      es: 'Depende de la lesión y la etapa de curación. Ofrecemos plazos según la actividad y podemos coordinar fisioterapia antes del regreso completo.',
    },
  },
  {
    id: 'sports-concussion',
    specialty: 'sports-medicine',
    category: { en: 'Sports Medicine', es: 'Medicina deportiva' },
    q: {
      en: 'Do you treat sports-related concussions or head injuries?',
      es: '¿Tratan conmociones o lesiones en la cabeza relacionadas con el deporte?',
    },
    a: {
      en: 'We evaluate musculoskeletal injuries on site. Suspected concussions may require ER or neurology referral — we help coordinate next steps.',
      es: 'Evaluamos lesiones musculoesqueléticas en el centro. Las posibles conmociones pueden requerir referencia a urgencias o neurología; ayudamos a coordinar los siguientes pasos.',
    },
  },
  {
    id: 'wc-first-visit',
    specialty: 'workers-comp',
    category: { en: "Workers' Compensation", es: 'Compensación laboral' },
    q: {
      en: 'What should I bring for a workers’ compensation visit?',
      es: '¿Qué debo llevar para una visita de compensación laboral?',
    },
    a: {
      en: 'Bring your claim number, employer details, photo ID, and any incident reports. We handle required documentation for adjusters and employers.',
      es: 'Lleve su número de reclamo, datos del empleador, identificación con foto y cualquier informe del incidente. Gestionamos la documentación requerida para ajustadores y empleadores.',
    },
  },
  {
    id: 'wc-rtw',
    specialty: 'workers-comp',
    category: { en: "Workers' Compensation", es: 'Compensación laboral' },
    q: {
      en: 'Can you provide work restrictions and return-to-work notes?',
      es: '¿Pueden proporcionar restricciones laborales y notas de regreso al trabajo?',
    },
    a: {
      en: 'Yes. We document functional limitations and modified-duty recommendations and communicate with employers when authorized.',
      es: 'Sí. Documentamos limitaciones funcionales y recomendaciones de trabajo modificado y nos comunicamos con empleadores cuando está autorizado.',
    },
  },
  {
    id: 'wc-urgent',
    specialty: 'workers-comp',
    category: { en: "Workers' Compensation", es: 'Compensación laboral' },
    q: {
      en: 'Do you accept walk-in workplace injuries?',
      es: '¿Aceptan lesiones laborales sin cita?',
    },
    a: {
      en: 'Yes. Walk-ins are welcome for acute workplace injuries. Early evaluation helps prevent complications and supports faster recovery.',
      es: 'Sí. Aceptamos visitas sin cita para lesiones laborales agudas. La evaluación temprana ayuda a prevenir complicaciones y apoya una recuperación más rápida.',
    },
  },
  {
    id: 'mri-wait',
    specialty: 'mri-digital-imaging',
    category: { en: 'Imaging', es: 'Imágenes' },
    q: {
      en: 'How long do X-ray results take?',
      es: '¿Cuánto tardan los resultados de radiografía?',
    },
    a: {
      en: 'Digital X-rays are often reviewed during your visit. Your provider discusses findings and next steps before you leave when possible.',
      es: 'Las radiografías digitales a menudo se revisan durante su visita. Su proveedor comenta los hallazgos y siguientes pasos antes de salir cuando es posible.',
    },
  },
  {
    id: 'mri-order',
    specialty: 'mri-digital-imaging',
    category: { en: 'Imaging', es: 'Imágenes' },
    q: {
      en: 'Can you order an MRI from the walk-in clinic?',
      es: '¿Pueden ordenar una resonancia desde la clínica sin cita?',
    },
    a: {
      en: 'Yes. When clinically indicated, we order MRI or advanced imaging and coordinate scheduling with trusted imaging partners.',
      es: 'Sí. Cuando está clínicamente indicado, ordenamos resonancia o imágenes avanzadas y coordinamos la programación con socios de imágenes de confianza.',
    },
  },
  {
    id: 'auto-whiplash',
    specialty: 'car-motor-vehicle-accident-care',
    category: { en: 'Auto Accident Care', es: 'Atención por accidente de auto' },
    q: {
      en: 'Can I walk in after a car accident for whiplash or neck pain?',
      es: '¿Puedo llegar sin cita después de un accidente de auto por latigazo cervical o dolor de cuello?',
    },
    a: {
      en: 'Yes. Walk-ins are welcome for same-day evaluation of whiplash, neck, back, and other collision-related injuries.',
      es: 'Sí. Recibimos pacientes sin cita para evaluación el mismo día de latigazo cervical, cuello, espalda y otras lesiones relacionadas con colisiones.',
    },
  },
  {
    id: 'auto-docs',
    specialty: 'car-motor-vehicle-accident-care',
    category: { en: 'Auto Accident Care', es: 'Atención por accidente de auto' },
    q: {
      en: 'Do you help with insurance documentation after a motor vehicle accident?',
      es: '¿Ayudan con la documentación del seguro después de un accidente de vehículo?',
    },
    a: {
      en: 'Yes. We provide thorough clinical documentation to support insurance and claims needs while you focus on recovery.',
      es: 'Sí. Proporcionamos documentación clínica completa para apoyar necesidades de seguros y reclamaciones mientras usted se enfoca en recuperarse.',
    },
  },
  {
    id: 'spine-radicular',
    specialty: 'lumbar-cervical-spine',
    category: { en: 'Spine', es: 'Columna' },
    q: {
      en: 'Do you treat back pain with leg numbness or tingling?',
      es: '¿Tratan dolor de espalda con entumecimiento u hormigueo en la pierna?',
    },
    a: {
      en: 'Yes. We evaluate radicular symptoms, order imaging when appropriate, and discuss injections, PT, or specialist referral.',
      es: 'Sí. Evaluamos síntomas radiculares, ordenamos imágenes cuando corresponde y comentamos inyecciones, fisioterapia o referencia a especialista.',
    },
  },
  {
    id: 'spine-conservative',
    specialty: 'lumbar-cervical-spine',
    category: { en: 'Spine', es: 'Columna' },
    q: {
      en: 'Will I need surgery for my neck or back pain?',
      es: '¿Necesitaré cirugía por dolor de cuello o espalda?',
    },
    a: {
      en: 'Most patients improve with conservative care first. We focus on accurate diagnosis and non-surgical options before surgical referral.',
      es: 'La mayoría de los pacientes mejoran primero con tratamiento conservador. Nos enfocamos en diagnóstico preciso y opciones no quirúrgicas antes de referir a cirugía.',
    },
  },
  {
    id: 'chiro-same-day',
    specialty: 'chiropractic-surgery',
    category: { en: 'Chiropractic', es: 'Quiropráctica' },
    q: {
      en: 'Can I get a same-day chiropractic or spine evaluation?',
      es: '¿Puedo obtener una evaluación quiropráctica o de columna el mismo día?',
    },
    a: {
      en: 'Yes. Walk-in appointments are available for neck and back pain. We evaluate, order imaging when needed, and discuss conservative and surgical pathways.',
      es: 'Sí. Hay citas sin cita previa para dolor de cuello y espalda. Evaluamos, ordenamos imágenes cuando sea necesario y comentamos vías conservadoras y quirúrgicas.',
    },
  },
  {
    id: 'chiro-vs-surgery',
    specialty: 'chiropractic-surgery',
    category: { en: 'Chiropractic', es: 'Quiropráctica' },
    q: {
      en: 'What is the difference between chiropractic care and spine surgery?',
      es: '¿Cuál es la diferencia entre atención quiropráctica y cirugía de columna?',
    },
    a: {
      en: 'Chiropractic care focuses on manual therapy, alignment, and decompression. Surgery is considered when structural damage or nerve compression requires direct correction. We coordinate both under one care team.',
      es: 'La atención quiropráctica se enfoca en terapia manual, alineación y descompresión. La cirugía se considera cuando el daño estructural o la compresión nerviosa requieren corrección directa. Coordinamos ambas bajo un mismo equipo de atención.',
    },
  },
  {
    id: 'spine-surgery-candidate',
    specialty: 'spine-surgery',
    category: { en: 'Spine Surgery', es: 'Cirugía de columna' },
    q: {
      en: 'How do I know if I am a candidate for spine surgery?',
      es: '¿Cómo sé si soy candidato para cirugía de columna?',
    },
    a: {
      en: 'Candidates typically have persistent pain, weakness, or numbness after conservative treatment, with imaging showing disc herniation, stenosis, or instability. Our surgeons review your case and explain all options.',
      es: 'Los candidatos suelen tener dolor persistente, debilidad o entumecimiento después del tratamiento conservador, con imágenes que muestran hernia discal, estenosis o inestabilidad. Nuestros cirujanos revisan su caso y explican todas las opciones.',
    },
  },
  {
    id: 'spine-surgery-recovery',
    specialty: 'spine-surgery',
    category: { en: 'Spine Surgery', es: 'Cirugía de columna' },
    q: {
      en: 'What is recovery like after spine surgery?',
      es: '¿Cómo es la recuperación después de la cirugía de columna?',
    },
    a: {
      en: 'Recovery varies by procedure. Many minimally invasive surgeries allow same-day walking and a return to light activity within weeks. We provide a structured rehab plan and follow-up visits.',
      es: 'La recuperación varía según el procedimiento. Muchas cirugías mínimamente invasivas permiten caminar el mismo día y retomar actividad ligera en pocas semanas. Ofrecemos un plan de rehabilitación estructurado y visitas de seguimiento.',
    },
  },
  {
    id: 'hand-carpal',
    specialty: 'hand-wrist-care',
    category: { en: 'Hand & Wrist', es: 'Mano y muñeca' },
    q: {
      en: 'Can you evaluate carpal tunnel or wrist pain?',
      es: '¿Pueden evaluar túnel carpiano o dolor de muñeca?',
    },
    a: {
      en: 'Yes. We assess nerve compression, tendon issues, and fractures with exam and imaging, then discuss splinting, injections, or referral.',
      es: 'Sí. Evaluamos compresión nerviosa, problemas de tendones y fracturas con examen e imágenes, luego comentamos férulas, inyecciones o referencia.',
    },
  },
  {
    id: 'hand-fracture',
    specialty: 'hand-wrist-care',
    category: { en: 'Hand & Wrist', es: 'Mano y muñeca' },
    q: {
      en: 'Do you treat finger and hand fractures same day?',
      es: '¿Tratan fracturas de dedos y mano el mismo día?',
    },
    a: {
      en: 'Yes. We provide same-day splinting and casting for many hand and finger injuries with follow-up planning.',
      es: 'Sí. Ofrecemos férulas y yeso el mismo día para muchas lesiones de mano y dedos con planificación de seguimiento.',
    },
  },
  {
    id: 'injury-fracture',
    specialty: 'injuries-fractures-sprains',
    category: { en: 'Injuries', es: 'Lesiones' },
    q: {
      en: 'Should I go to the ER or OrthoExpress for a possible fracture?',
      es: '¿Debo ir a urgencias o a OrthoExpress por una posible fractura?',
    },
    a: {
      en: 'Open fractures, severe bleeding, or head trauma need the ER. Most closed fractures and sprains are treated efficiently in our walk-in clinic.',
      es: 'Las fracturas abiertas, sangrado severo o trauma craneal requieren urgencias. La mayoría de fracturas cerradas y esguinces se tratan eficientemente en nuestra clínica sin cita.',
    },
  },
  {
    id: 'injury-sprain',
    specialty: 'injuries-fractures-sprains',
    category: { en: 'Injuries', es: 'Lesiones' },
    q: {
      en: 'Do I need imaging for every ankle or wrist sprain?',
      es: '¿Necesito imágenes para cada esguince de tobillo o muñeca?',
    },
    a: {
      en: 'Not always. We use clinical criteria to decide when X-ray is needed, avoiding unnecessary radiation and cost.',
      es: 'No siempre. Usamos criterios clínicos para decidir cuándo se necesita radiografía, evitando radiación y costos innecesarios.',
    },
  },
  {
    id: 'arthritis-injection',
    specialty: 'arthritis',
    category: { en: 'Arthritis', es: 'Artritis' },
    q: {
      en: 'Do you offer joint injections for arthritis pain?',
      es: '¿Ofrecen inyecciones articulares para dolor de artritis?',
    },
    a: {
      en: 'Yes. When appropriate, we provide therapeutic injections and discuss long-term options including PT and lifestyle modifications.',
      es: 'Sí. Cuando es apropiado, ofrecemos inyecciones terapéuticas y comentamos opciones a largo plazo incluyendo fisioterapia y cambios de estilo de vida.',
    },
  },
  {
    id: 'arthritis-oa',
    specialty: 'arthritis',
    category: { en: 'Arthritis', es: 'Artritis' },
    q: {
      en: 'Can walk-in care help osteoarthritis flare-ups?',
      es: '¿Puede la atención sin cita ayudar con brotes de osteoartritis?',
    },
    a: {
      en: 'Yes. We address acute flares with pain management, activity guidance, and coordination with your ongoing care plan.',
      es: 'Sí. Abordamos brotes agudos con manejo del dolor, orientación de actividad y coordinación con su plan de atención continua.',
    },
  },
  {
    id: 'pain-urgent',
    specialty: 'pain-inflammation',
    category: { en: 'Pain Management', es: 'Manejo del dolor' },
    q: {
      en: 'Can I walk in for sudden joint or muscle pain?',
      es: '¿Puedo ir sin cita por dolor articular o muscular repentino?',
    },
    a: {
      en: 'Yes. Same-day evaluation helps identify the cause and start treatment — from anti-inflammatory plans to imaging and injections.',
      es: 'Sí. La evaluación el mismo día ayuda a identificar la causa e iniciar tratamiento — desde planes antiinflamatorios hasta imágenes e inyecciones.',
    },
  },
  {
    id: 'pain-chronic',
    specialty: 'pain-inflammation',
    category: { en: 'Pain Management', es: 'Manejo del dolor' },
    q: {
      en: 'Do you manage chronic orthopedic pain?',
      es: '¿Manejan dolor ortopédico crónico?',
    },
    a: {
      en: 'We evaluate chronic pain, adjust care plans, and coordinate specialists or PT. Ongoing pain may benefit from scheduled follow-ups.',
      es: 'Evaluamos dolor crónico, ajustamos planes de atención y coordinamos especialistas o fisioterapia. El dolor continuo puede beneficiarse de seguimientos programados.',
    },
  },
  {
    id: 'tele-eligible',
    specialty: 'telehealth',
    category: { en: 'Telehealth', es: 'Telemedicina' },
    q: {
      en: 'Who is eligible for OrthoExpress Live virtual visits?',
      es: '¿Quién es elegible para visitas virtuales OrthoExpress Live?',
    },
    a: {
      en: 'Established patients with follow-up needs, post-procedure check-ins, and some consultation types qualify. Acute injuries may still need an in-person exam.',
      es: 'Pacientes establecidos con necesidades de seguimiento, controles post-procedimiento y algunos tipos de consulta califican. Las lesiones agudas pueden requerir examen presencial.',
    },
  },
  {
    id: 'tele-device',
    specialty: 'telehealth',
    category: { en: 'Telehealth', es: 'Telemedicina' },
    q: {
      en: 'What device do I need for a telehealth visit?',
      es: '¿Qué dispositivo necesito para una visita de telemedicina?',
    },
    a: {
      en: 'A smartphone, tablet, or computer with camera and internet works. We send simple join instructions before your appointment.',
      es: 'Funciona un teléfono inteligente, tableta u ordenador con cámara e internet. Enviamos instrucciones simples antes de su cita.',
    },
  },
]

export const CAREERS = [
  {
    id: 'ma',
    title: { en: 'Medical Assistant', es: 'Asistente médico' },
    type: { en: 'Full-time', es: 'Tiempo completo' },
    location: { en: 'Multiple locations', es: 'Varias ubicaciones' },
    summary: {
      en: 'Support clinic flow, vitals, patient intake, and provider assistance in a fast-paced orthopedic walk-in setting.',
      es: 'Apoye el flujo clínico, signos vitales, ingreso de pacientes y asistencia a proveedores en un entorno ortopédico sin cita.',
    },
  },
  {
    id: 'frontdesk',
    title: { en: 'Front Desk Coordinator', es: 'Coordinador de recepción' },
    type: { en: 'Full-time', es: 'Tiempo completo' },
    location: { en: 'Midland / satellite centers', es: 'Midland / centros satélite' },
    summary: {
      en: 'Welcome patients, verify insurance, schedule visits, and create a calm, helpful first impression.',
      es: 'Reciba pacientes, verifique seguros, programe visitas y cree una primera impresión calmada y útil.',
    },
  },
  {
    id: 'np-pa',
    title: { en: 'Orthopedic NP / PA', es: 'NP / PA ortopédico' },
    type: { en: 'Full-time', es: 'Tiempo completo' },
    location: { en: 'Openings vary by center', es: 'Disponibilidad según el centro' },
    summary: {
      en: 'Evaluate and treat musculoskeletal injuries with a collaborative orthopedic team focused on same-day care.',
      es: 'Evalúe y trate lesiones musculoesqueléticas con un equipo ortopédico colaborativo enfocado en atención el mismo día.',
    },
  },
]

export const NEWS_ITEMS = [
  {
    id: 'spring-hours',
    date: '2026-03-12',
    tag: { en: 'Clinic Update', es: 'Actualización' },
    title: {
      en: 'Extended walk-in hours at select centers',
      es: 'Horario extendido sin cita en centros seleccionados',
    },
    summary: {
      en: 'We’re expanding afternoon walk-in availability so more patients can get same-day orthopedic care.',
      es: 'Estamos ampliando la disponibilidad por la tarde para que más pacientes reciban atención ortopédica el mismo día.',
    },
  },
  {
    id: 'community-day',
    date: '2026-02-20',
    tag: { en: 'Event', es: 'Evento' },
    title: {
      en: 'Community sports injury awareness day',
      es: 'Día comunitario de concientización sobre lesiones deportivas',
    },
    summary: {
      en: 'Join our team for free screenings tips, Q&A, and guidance on when to seek urgent orthopedic care.',
      es: 'Únase a nuestro equipo para consejos de evaluación, preguntas y orientación sobre cuándo buscar atención ortopédica urgente.',
    },
  },
  {
    id: 'teleortho',
    date: '2026-01-15',
    tag: { en: 'News', es: 'Noticias' },
    title: {
      en: 'Teleorthopedics follow-ups now easier to schedule',
      es: 'Los seguimientos de teleortopedia ahora son más fáciles de programar',
    },
    summary: {
      en: 'Eligible patients can book convenient virtual follow-ups after an in-clinic evaluation.',
      es: 'Los pacientes elegibles pueden reservar seguimientos virtuales convenientes después de una evaluación en clínica.',
    },
  },
]

export const PATIENT_REVIEWS = [
  {
    name: 'Vivian P.',
    when: { en: '1 year ago', es: 'Hace 1 año' },
    text: {
      en: 'Walked in first thing in the morning. Short wait, clear communication, and great follow-through from the team.',
      es: 'Llegué a primera hora. Poca espera, buena comunicación y excelente seguimiento del equipo.',
    },
  },
  {
    name: 'Natalie G.',
    when: { en: '1 year ago', es: 'Hace 1 año' },
    text: {
      en: 'The staff took time to understand my foot pain and explained reasonable treatment options. Highly recommend.',
      es: 'El personal se tomó el tiempo de entender el dolor de mi pie y explicó opciones de tratamiento razonables. Muy recomendable.',
    },
  },
  {
    name: 'Craig R.',
    when: { en: '1 year ago', es: 'Hace 1 año' },
    text: {
      en: 'Injured my foot while traveling. Front desk helped with insurance questions and the clinical team provided exactly the urgent care I needed.',
      es: 'Me lesioné el pie viajando. Recepción ayudó con el seguro y el equipo clínico brindó exactamente la atención urgente que necesitaba.',
    },
  },
  {
    name: 'Michelle B.',
    when: { en: '2 years ago', es: 'Hace 2 años' },
    text: {
      en: 'OrthoExpress got me back on the field, pain-free. Professional, kind, and efficient care.',
      es: 'OrthoExpress me devolvió al campo sin dolor. Atención profesional, amable y eficiente.',
    },
  },
]

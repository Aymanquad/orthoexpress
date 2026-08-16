import { localize, localizeArray } from '../i18n/localize'
import { IMAGES, getServiceImage } from './images'

const SERVICE_IMAGES = Object.fromEntries(
  Object.entries(IMAGES.services).map(([slug, img]) => [slug, img.src])
)

const SERVICE_DETAILS = {
  'pain-inflammation': {
    title: {
      en: 'Pain & Inflammation',
      es: 'Dolor e inflamación',
    },
    description: {
      en: 'Targeted treatment for acute and chronic pain and inflammatory conditions.',
      es: 'Tratamiento dirigido para el dolor agudo y crónico y las afecciones inflamatorias.',
    },
    image: SERVICE_IMAGES['pain-inflammation'],
    overview: {
      en: 'Pain and inflammation can limit mobility and reduce quality of life. Our specialists provide comprehensive evaluation and treatment plans that address the root cause of your discomfort, combining medical management, injections, and rehabilitation when appropriate.',
      es: 'El dolor y la inflamación pueden limitar la movilidad y reducir la calidad de vida. Nuestros especialistas ofrecen evaluación integral y planes de tratamiento que abordan la causa subyacente de su malestar, combinando manejo médico, inyecciones y rehabilitación cuando corresponda.',
    },
    conditions: {
      en: [
        'Chronic joint pain',
        'Tendonitis and bursitis',
        'Post-injury inflammation',
        'Nerve-related pain',
        'Overuse syndromes',
      ],
      es: [
        'Dolor articular crónico',
        'Tendinitis y bursitis',
        'Inflamación postraumática',
        'Dolor de origen nervioso',
        'Síndromes por sobreuso',
      ],
    },
    treatments: {
      en: [
        'Anti-inflammatory medication management',
        'Corticosteroid injections',
        'Physical therapy referrals',
        'Lifestyle and activity modification guidance',
      ],
      es: [
        'Manejo de medicamentos antiinflamatorios',
        'Inyecciones de corticosteroides',
        'Referencias a fisioterapia',
        'Orientación sobre modificaciones en el estilo de vida y la actividad',
      ],
    },
    additionalInfo: {
      en: 'We focus on reducing pain while restoring function. Whether your symptoms are new or long-standing, our walk-in clinic can evaluate your condition and start treatment the same day.',
      es: 'Nos enfocamos en reducir el dolor mientras restauramos la función. Ya sea que sus síntomas sean recientes o de larga data, nuestra clínica sin cita previa puede evaluar su afección e iniciar el tratamiento el mismo día.',
    },
  },
  'injuries-fractures-sprains': {
    title: {
      en: 'Injuries, Fractures & Sprains',
      es: 'Lesiones, fracturas y esguinces',
    },
    description: {
      en: 'Urgent orthopedic care for traumatic injuries, fractures, sprains, and soft tissue trauma.',
      es: 'Atención ortopédica urgente para lesiones traumáticas, fracturas, esguinces y traumatismos de tejidos blandos.',
    },
    image: SERVICE_IMAGES['injuries-fractures-sprains'],
    overview: {
      en: 'From sports injuries and workplace accidents to falls and sudden trauma, we provide prompt diagnosis and treatment for fractures, sprains, strains, and soft tissue injuries. On-site imaging helps us determine the right course of care quickly so you can start recovering the same day.',
      es: 'Desde lesiones deportivas y accidentes laborales hasta caídas y traumatismos repentinos, ofrecemos diagnóstico y tratamiento oportunos para fracturas, esguinces, distensiones y lesiones de tejidos blandos. La imagenología en el sitio nos permite determinar rápidamente el plan de atención adecuado para que pueda comenzar a recuperarse el mismo día.',
    },
    conditions: {
      en: [
        'Bone fractures',
        'Ankle and wrist sprains',
        'Ligament tears',
        'Muscle strains',
        'Dislocations',
        'Soft tissue injuries from impacts',
      ],
      es: [
        'Fracturas óseas',
        'Esguinces de tobillo y muñeca',
        'Desgarros ligamentarios',
        'Distensiones musculares',
        'Luxaciones',
        'Lesiones de tejidos blandos por impactos',
      ],
    },
    treatments: {
      en: [
        'Splinting and bracing',
        'Fracture reduction and casting',
        'Pain management',
        'Physical therapy coordination',
        'Surgical intervention when needed',
        'Follow-up recovery planning',
      ],
      es: [
        'Inmovilización con férulas y ortesis',
        'Reducción de fracturas y enyesado',
        'Manejo del dolor',
        'Coordinación de fisioterapia',
        'Intervención quirúrgica cuando sea necesaria',
        'Planificación de seguimiento y recuperación',
      ],
    },
    additionalInfo: {
      en: 'Walk-in appointments are available for acute injuries. Early evaluation helps prevent complications and supports faster recovery.',
      es: 'Hay citas sin cita previa disponibles para lesiones agudas. La evaluación temprana ayuda a prevenir complicaciones y favorece una recuperación más rápida.',
    },
  },
  arthritis: {
    title: {
      en: 'Arthritis Care',
      es: 'Atención de artritis',
    },
    description: {
      en: 'Comprehensive management for osteoarthritis, rheumatoid arthritis, and related joint conditions.',
      es: 'Manejo integral de la osteoartritis, artritis reumatoide y otras afecciones articulares relacionadas.',
    },
    image: SERVICE_IMAGES.arthritis,
    overview: {
      en: 'Arthritis affects millions of people and can cause persistent joint pain, stiffness, and reduced mobility. Our team develops individualized plans to manage symptoms, preserve joint function, and improve daily comfort.',
      es: 'La artritis afecta a millones de personas y puede causar dolor articular persistente, rigidez y reducción de la movilidad. Nuestro equipo elabora planes individualizados para controlar los síntomas, preservar la función articular y mejorar el confort diario.',
    },
    conditions: {
      en: [
        'Osteoarthritis',
        'Rheumatoid arthritis',
        'Post-traumatic arthritis',
        'Joint stiffness and swelling',
        'Activity-limiting joint pain',
      ],
      es: [
        'Osteoartritis',
        'Artritis reumatoide',
        'Artritis postraumática',
        'Rigidez e hinchazón articular',
        'Dolor articular que limita la actividad',
      ],
    },
    treatments: {
      en: [
        'Medication and injection therapy',
        'Physical therapy coordination',
        'Assistive device recommendations',
        'Surgical consultation when needed',
      ],
      es: [
        'Terapia con medicamentos e inyecciones',
        'Coordinación de fisioterapia',
        'Recomendaciones de dispositivos de asistencia',
        'Consulta quirúrgica cuando sea necesaria',
      ],
    },
    additionalInfo: {
      en: 'We help patients stay active with evidence-based arthritis care tailored to their lifestyle and goals.',
      es: 'Ayudamos a los pacientes a mantenerse activos con atención de artritis basada en evidencia, adaptada a su estilo de vida y objetivos.',
    },
  },
  'casting-splinting': {
    title: {
      en: 'Casting & Splinting Services',
      es: 'Servicios de yesos y férulas',
    },
    description: {
      en: 'Expert immobilization and support for fractures and soft tissue injuries.',
      es: 'Inmovilización y soporte experto para fracturas y lesiones de tejidos blandos.',
    },
    image: SERVICE_IMAGES['casting-splinting'],
    overview: {
      en: 'Proper immobilization is essential for healing after fractures and significant sprains. Our clinic provides professional casting and splinting services with follow-up care to monitor recovery.',
      es: 'La inmovilización adecuada es esencial para la cicatrización después de fracturas y esguinces significativos. Nuestra clínica ofrece servicios profesionales de yesos y férulas con seguimiento para monitorear la recuperación.',
    },
    conditions: {
      en: [
        'Stable fractures',
        'Wrist and ankle injuries',
        'Post-reduction immobilization',
        'Tendon and ligament protection',
        'Post-surgical support',
      ],
      es: [
        'Fracturas estables',
        'Lesiones de muñeca y tobillo',
        'Inmovilización postreducción',
        'Protección de tendones y ligamentos',
        'Soporte postquirúrgico',
      ],
    },
    treatments: {
      en: [
        'Fiberglass and plaster casting',
        'Removable splints and braces',
        'Cast checks and adjustments',
        'Healing progress monitoring',
      ],
      es: [
        'Yesos de fibra de vidrio y yeso de escayola',
        'Férulas y ortesis removibles',
        'Revisiones y ajustes del yeso',
        'Monitoreo del progreso de cicatrización',
      ],
    },
    additionalInfo: {
      en: 'We ensure your cast or splint fits correctly and provide clear instructions for care at home to support optimal healing.',
      es: 'Nos aseguramos de que su yeso o férula ajuste correctamente y proporcionamos instrucciones claras para el cuidado en el hogar que favorezcan una cicatrización óptima.',
    },
  },
  'mri-digital-imaging': {
    title: {
      en: 'MRI & Digital Imaging',
      es: 'Resonancia magnética e imagenología digital',
    },
    description: {
      en: 'Advanced diagnostic imaging to accurately evaluate orthopedic conditions.',
      es: 'Imagenología diagnóstica avanzada para evaluar con precisión las afecciones ortopédicas.',
    },
    image: SERVICE_IMAGES['mri-digital-imaging'],
    overview: {
      en: 'Accurate diagnosis starts with quality imaging. We coordinate MRI, X-ray, and digital imaging services to identify injuries, degenerative changes, and structural problems affecting bones and soft tissues.',
      es: 'Un diagnóstico preciso comienza con imagenología de calidad. Coordinamos servicios de resonancia magnética, radiografía e imagenología digital para identificar lesiones, cambios degenerativos y problemas estructurales que afectan huesos y tejidos blandos.',
    },
    conditions: {
      en: [
        'Suspected ligament or meniscus tears',
        'Unresolved joint pain',
        'Spine and nerve compression concerns',
        'Post-injury internal damage',
        'Pre-surgical planning needs',
      ],
      es: [
        'Sospecha de desgarros ligamentarios o de menisco',
        'Dolor articular sin resolver',
        'Preocupaciones por compresión espinal y nerviosa',
        'Daño interno postraumático',
        'Necesidades de planificación prequirúrgica',
      ],
    },
    treatments: {
      en: [
        'Digital X-ray evaluation',
        'MRI referrals and review',
        'Ultrasound-guided assessments',
        'Image-guided treatment planning',
      ],
      es: [
        'Evaluación con radiografía digital',
        'Referencias y revisión de resonancia magnética',
        'Evaluaciones guiadas por ultrasonido',
        'Planificación de tratamiento guiada por imagen',
      ],
    },
    additionalInfo: {
      en: 'Timely imaging helps us create precise treatment plans and avoid unnecessary delays in your recovery.',
      es: 'La imagenología oportuna nos ayuda a crear planes de tratamiento precisos y evitar retrasos innecesarios en su recuperación.',
    },
  },
  'prp-orthobiologics': {
    title: {
      en: 'PRP Therapy & Orthobiologics',
      es: 'Terapia con PRP y ortobiología',
    },
    description: {
      en: 'Regenerative treatment options to support natural healing and tissue recovery.',
      es: 'Opciones de tratamiento regenerativo para favorecer la cicatrización natural y la recuperación tisular.',
    },
    image: SERVICE_IMAGES['prp-orthobiologics'],
    overview: {
      en: "Platelet-rich plasma (PRP) and orthobiologic therapies can help stimulate the body's natural healing response for certain tendon, ligament, and joint conditions. Our specialists evaluate candidacy and guide patients through regenerative treatment options.",
      es: 'El plasma rico en plaquetas (PRP) y las terapias ortobiológicas pueden ayudar a estimular la respuesta natural de cicatrización del cuerpo para ciertas afecciones de tendones, ligamentos y articulaciones. Nuestros especialistas evalúan la candidatura y orientan a los pacientes en las opciones de tratamiento regenerativo.',
    },
    conditions: {
      en: [
        'Chronic tendon injuries',
        'Mild to moderate osteoarthritis',
        'Ligament and soft tissue strains',
        'Post-surgical recovery support',
        'Sports-related overuse injuries',
      ],
      es: [
        'Lesiones tendinosas crónicas',
        'Osteoartritis leve a moderada',
        'Distensiones de ligamentos y tejidos blandos',
        'Apoyo en la recuperación postquirúrgica',
        'Lesiones deportivas por sobreuso',
      ],
    },
    treatments: {
      en: [
        'PRP injections',
        'Orthobiologic consultation',
        'Combined rehabilitation protocols',
        'Follow-up functional assessments',
      ],
      es: [
        'Inyecciones de PRP',
        'Consulta de ortobiología',
        'Protocolos de rehabilitación combinados',
        'Evaluaciones funcionales de seguimiento',
      ],
    },
    additionalInfo: {
      en: 'Regenerative therapies may be considered when conservative care has not provided sufficient relief. We discuss benefits, expectations, and recovery timelines with every patient.',
      es: 'Las terapias regenerativas pueden considerarse cuando el tratamiento conservador no ha proporcionado alivio suficiente. Discutimos los beneficios, las expectativas y los plazos de recuperación con cada paciente.',
    },
  },
  'car-motor-vehicle-accident-care': {
    title: {
      en: 'Auto Accident Care',
      es: 'Atención por accidente de auto',
    },
    description: {
      en: 'Same-day injury evaluation after a car or motor vehicle accident.',
      es: 'Evaluación de lesiones el mismo día después de un accidente de auto o vehículo.',
    },
    image: SERVICE_IMAGES['car-motor-vehicle-accident-care'],
    overview: {
      en: 'Car and motor vehicle accidents can cause a wide range of orthopedic injuries — from whiplash and soft tissue trauma to fractures and spinal injuries. Our team provides prompt walk-in evaluation, on-site imaging when needed, and clear treatment plans so you can start healing right away. We also help with thorough documentation for insurance and claims.',
      es: 'Los accidentes de auto y de vehículos pueden causar una amplia variedad de lesiones ortopédicas, desde latigazo cervical y traumatismos de tejidos blandos hasta fracturas y lesiones de columna. Nuestro equipo ofrece evaluación sin cita previa, imagenología en el sitio cuando sea necesario y planes de tratamiento claros para que pueda comenzar a recuperarse de inmediato. También ayudamos con documentación completa para seguros y reclamaciones.',
    },
    conditions: {
      en: [
        'Whiplash and neck injuries',
        'Back and spinal trauma from collisions',
        'Fractures and dislocations',
        'Shoulder, knee, and joint injuries',
        'Soft tissue and ligament injuries',
        'Seatbelt and impact-related trauma',
      ],
      es: [
        'Latigazo cervical y lesiones de cuello',
        'Traumatismos de espalda y columna por colisiones',
        'Fracturas y luxaciones',
        'Lesiones de hombro, rodilla y articulaciones',
        'Lesiones de tejidos blandos y ligamentos',
        'Traumatismos por cinturón de seguridad e impacto',
      ],
    },
    treatments: {
      en: [
        'Same-day accident injury evaluation',
        'Digital imaging and diagnostic coordination',
        'Splinting, bracing, and fracture care',
        'Pain management and rehabilitation planning',
        'Insurance and claims documentation',
        'Follow-up recovery and specialist referrals',
      ],
      es: [
        'Evaluación de lesiones por accidente el mismo día',
        'Imagenología digital y coordinación diagnóstica',
        'Férulas, ortesis y atención de fracturas',
        'Manejo del dolor y planificación de rehabilitación',
        'Documentación para seguros y reclamaciones',
        'Seguimiento de recuperación y referencias a especialistas',
      ],
    },
    additionalInfo: {
      en: 'If you were in a car or motor vehicle accident, early evaluation matters. Walk in today for expert injury care and documentation support — no referral required.',
      es: 'Si estuvo en un accidente de auto o de vehículo, la evaluación temprana importa. Entre hoy mismo para atención experta de lesiones y apoyo con documentación — sin necesidad de remisión.',
    },
  },
  'hand-wrist-care': {
    title: {
      en: 'Hand & Wrist Care',
      es: 'Atención de mano y muñeca',
    },
    description: {
      en: 'Comprehensive treatment for hand and wrist conditions and injuries.',
      es: 'Tratamiento integral para afecciones y lesiones de mano y muñeca.',
    },
    image: SERVICE_IMAGES['hand-wrist-care'],
    overview: {
      en: 'Our expert hand and wrist specialists provide comprehensive care for a wide range of conditions affecting these critical joints. From common repetitive strain injuries to complex fractures, we offer both conservative and surgical treatment options to restore function and relieve pain.',
      es: 'Nuestros especialistas expertos en mano y muñeca ofrecen atención integral para una amplia variedad de afecciones que afectan estas articulaciones esenciales. Desde lesiones comunes por esfuerzo repetitivo hasta fracturas complejas, ofrecemos opciones de tratamiento conservador y quirúrgico para restaurar la función y aliviar el dolor.',
    },
    conditions: {
      en: [
        'Carpal Tunnel Syndrome',
        'Wrist Fractures',
        'Tendon Injuries',
        'Arthritis',
        'Trigger Finger',
        'Ganglion Cysts',
      ],
      es: [
        'Síndrome del túnel carpiano',
        'Fracturas de muñeca',
        'Lesiones tendinosas',
        'Artritis',
        'Dedo en gatillo',
        'Quistes ganglionares',
      ],
    },
    treatments: {
      en: [
        'Non-surgical treatments including splinting and therapy',
        'Minimally invasive procedures',
        'Surgical reconstruction when needed',
        'Rehabilitation and recovery programs',
      ],
      es: [
        'Tratamientos no quirúrgicos, incluyendo férulas y terapia',
        'Procedimientos mínimamente invasivos',
        'Reconstrucción quirúrgica cuando sea necesaria',
        'Programas de rehabilitación y recuperación',
      ],
    },
    additionalInfo: {
      en: 'Hand and wrist injuries can significantly impact daily activities and quality of life. Our team uses advanced diagnostic tools and techniques to accurately assess your condition and develop a personalized treatment plan. We understand the importance of hand function in your daily life and work closely with you to achieve the best possible outcomes.',
      es: 'Las lesiones de mano y muñeca pueden afectar significativamente las actividades diarias y la calidad de vida. Nuestro equipo utiliza herramientas y técnicas diagnósticas avanzadas para evaluar con precisión su afección y desarrollar un plan de tratamiento personalizado. Comprendemos la importancia de la función de la mano en su vida diaria y trabajamos en estrecha colaboración con usted para lograr los mejores resultados posibles.',
    },
  },
  'shoulder-elbow': {
    title: {
      en: 'Shoulder & Elbow Care',
      es: 'Atención de hombro y codo',
    },
    description: {
      en: 'Expert care for shoulder and elbow injuries and conditions.',
      es: 'Atención experta para lesiones y afecciones de hombro y codo.',
    },
    image: SERVICE_IMAGES['shoulder-elbow'],
    overview: {
      en: 'Shoulder and elbow problems can severely limit your mobility and cause significant discomfort. Our orthopedic specialists are experienced in treating everything from sports injuries to age-related degenerative conditions. We utilize the latest surgical and non-surgical techniques to help you regain full function and return to your active lifestyle.',
      es: 'Los problemas de hombro y codo pueden limitar severamente su movilidad y causar malestar significativo. Nuestros especialistas ortopédicos tienen experiencia en el tratamiento de todo, desde lesiones deportivas hasta afecciones degenerativas relacionadas con la edad. Utilizamos las técnicas quirúrgicas y no quirúrgicas más recientes para ayudarle a recuperar la función completa y volver a su estilo de vida activo.',
    },
    conditions: {
      en: [
        'Rotator Cuff Tears',
        'Shoulder Dislocations',
        'Tennis Elbow',
        'Frozen Shoulder',
        'Bursitis',
        'Arthritis',
      ],
      es: [
        'Desgarros del manguito rotador',
        'Luxaciones de hombro',
        'Codo de tenista',
        'Hombro congelado',
        'Bursitis',
        'Artritis',
      ],
    },
    treatments: {
      en: [
        'Physical therapy and rehabilitation',
        'Cortisone injections',
        'Arthroscopic surgery',
        'Joint replacement when necessary',
      ],
      es: [
        'Fisioterapia y rehabilitación',
        'Inyecciones de cortisona',
        'Cirugía artroscópica',
        'Reemplazo articular cuando sea necesario',
      ],
    },
    additionalInfo: {
      en: "The shoulder and elbow are complex joints that require specialized care. Whether you're an athlete dealing with a sports injury or someone experiencing age-related joint problems, our comprehensive approach ensures you receive the most effective treatment. We prioritize conservative management when possible, but are fully equipped to perform advanced surgical procedures when needed.",
      es: 'El hombro y el codo son articulaciones complejas que requieren atención especializada. Ya sea que sea un atleta con una lesión deportiva o alguien que experimenta problemas articulares relacionados con la edad, nuestro enfoque integral garantiza que reciba el tratamiento más eficaz. Priorizamos el manejo conservador cuando es posible, pero estamos plenamente equipados para realizar procedimientos quirúrgicos avanzados cuando sea necesario.',
    },
  },
  'lumbar-cervical-spine': {
    title: {
      en: 'Lumbar & Cervical Spine Care',
      es: 'Atención de columna lumbar y cervical',
    },
    description: {
      en: 'Specialized treatment for back and neck conditions.',
      es: 'Tratamiento especializado para afecciones de espalda y cuello.',
    },
    image: SERVICE_IMAGES['lumbar-cervical-spine'],
    overview: {
      en: 'Back and neck pain are among the most common reasons people seek medical care. Our spine specialists offer comprehensive evaluation and treatment for conditions affecting the cervical (neck) and lumbar (lower back) regions. We focus on identifying the root cause of your pain and providing effective, long-term solutions.',
      es: 'El dolor de espalda y cuello se encuentra entre las razones más comunes por las que las personas buscan atención médica. Nuestros especialistas en columna ofrecen evaluación y tratamiento integral para afecciones que afectan las regiones cervical (cuello) y lumbar (parte baja de la espalda). Nos enfocamos en identificar la causa subyacente de su dolor y proporcionar soluciones eficaces a largo plazo.',
    },
    conditions: {
      en: [
        'Herniated Discs',
        'Spinal Stenosis',
        'Sciatica',
        'Neck Pain',
        'Scoliosis',
        'Degenerative Disc Disease',
      ],
      es: [
        'Hernias discales',
        'Estenosis espinal',
        'Ciática',
        'Dolor cervical',
        'Escoliosis',
        'Enfermedad degenerativa del disco',
      ],
    },
    treatments: {
      en: [
        'Physical therapy',
        'Pain management injections',
        'Minimally invasive procedures',
        'Spinal fusion surgery when needed',
      ],
      es: [
        'Fisioterapia',
        'Inyecciones para el manejo del dolor',
        'Procedimientos mínimamente invasivos',
        'Cirugía de fusión espinal cuando sea necesaria',
      ],
    },
    additionalInfo: {
      en: 'Spine conditions can cause debilitating pain and significantly impact your quality of life. Our team uses advanced imaging and diagnostic techniques to accurately identify the source of your pain. We offer a full spectrum of treatment options, from conservative approaches like physical therapy and injections to minimally invasive surgical procedures that can provide lasting relief.',
      es: 'Las afecciones de la columna pueden causar dolor debilitante y afectar significativamente su calidad de vida. Nuestro equipo utiliza técnicas avanzadas de imagenología y diagnóstico para identificar con precisión el origen de su dolor. Ofrecemos un espectro completo de opciones de tratamiento, desde enfoques conservadores como fisioterapia e inyecciones hasta procedimientos quirúrgicos mínimamente invasivos que pueden proporcionar alivio duradero.',
    },
  },
  'chiropractic-surgery': {
    title: {
      en: 'Chiropractic',
      es: 'Quiropráctica',
    },
    description: {
      en: 'Integrated spinal care combining chiropractic evaluation, manual therapy, and surgical coordination.',
      es: 'Atención espinal integral que combina evaluación quiropráctica, terapia manual y coordinación quirúrgica.',
    },
    image: SERVICE_IMAGES['chiropractic-surgery'],
    overview: {
      en: 'Chronic neck and back pain often responds best to a coordinated approach. Our chiropractic surgery program combines hands-on spinal evaluation, targeted manual therapy, and decompression techniques with direct access to orthopedic surgeons when advanced intervention is needed. We focus on restoring alignment, reducing nerve pressure, and building a clear path from conservative care to surgical options — all under one roof.',
      es: 'El dolor crónico de cuello y espalda a menudo responde mejor a un enfoque coordinado. Nuestro programa de cirugía quiropráctica combina evaluación espinal manual, terapia dirigida y técnicas de descompresión con acceso directo a cirujanos ortopédicos cuando se necesita intervención avanzada. Nos enfocamos en restaurar la alineación, reducir la presión nerviosa y trazar un camino claro desde la atención conservadora hasta las opciones quirúrgicas, todo en un solo lugar.',
    },
    conditions: {
      en: [
        'Chronic neck and back pain',
        'Herniated or bulging discs',
        'Sciatica and radicular symptoms',
        'Spinal misalignment and stiffness',
        'Post-injury spinal dysfunction',
        'Failed prior conservative treatment',
      ],
      es: [
        'Dolor crónico de cuello y espalda',
        'Hernias o protrusiones discales',
        'Ciática y síntomas radiculares',
        'Desalineación y rigidez espinal',
        'Disfunción espinal postraumática',
        'Tratamiento conservador previo sin éxito',
      ],
    },
    treatments: {
      en: [
        'Chiropractic spinal evaluation and adjustments',
        'Spinal decompression therapy',
        'Therapeutic exercise and rehabilitation',
        'Pain management injections',
        'Surgical consultation and coordination when indicated',
      ],
      es: [
        'Evaluación quiropráctica y ajustes espinales',
        'Terapia de descompresión espinal',
        'Ejercicio terapéutico y rehabilitación',
        'Inyecciones para el manejo del dolor',
        'Consulta y coordinación quirúrgica cuando corresponda',
      ],
    },
    additionalInfo: {
      en: 'Every patient receives a thorough exam and imaging review before treatment begins. We prioritize safe, evidence-based care and only recommend surgery when conservative options have been exhausted or when urgent structural damage requires it. Our team coordinates your entire recovery — from the first adjustment through post-operative rehabilitation.',
      es: 'Cada paciente recibe un examen exhaustivo y revisión de imágenes antes de iniciar el tratamiento. Priorizamos una atención segura y basada en evidencia, y solo recomendamos cirugía cuando se han agotado las opciones conservadoras o cuando el daño estructural urgente lo requiere. Nuestro equipo coordina toda su recuperación, desde el primer ajuste hasta la rehabilitación postoperatoria.',
    },
  },
  'spine-surgery': {
    title: {
      en: 'Spine Surgery',
      es: 'Cirugía de columna',
    },
    description: {
      en: 'Advanced surgical solutions for complex cervical and lumbar spine conditions.',
      es: 'Soluciones quirúrgicas avanzadas para afecciones complejas de columna cervical y lumbar.',
    },
    image: SERVICE_IMAGES['spine-surgery'],
    overview: {
      en: 'When back or neck pain persists despite conservative treatment, spine surgery may be the most effective path to lasting relief. Our experienced spine surgeons perform a full range of cervical and lumbar procedures using minimally invasive techniques whenever possible. From microdiscectomy and laminectomy to spinal fusion, we use advanced imaging and surgical planning to restore stability, decompress nerves, and help you return to daily activities.',
      es: 'Cuando el dolor de espalda o cuello persiste a pesar del tratamiento conservador, la cirugía de columna puede ser el camino más eficaz hacia un alivio duradero. Nuestros cirujanos de columna experimentados realizan una gama completa de procedimientos cervicales y lumbares utilizando técnicas mínimamente invasivas siempre que sea posible. Desde microdiscectomía y laminectomía hasta fusión espinal, utilizamos imagenología avanzada y planificación quirúrgica para restaurar la estabilidad, descomprimir nervios y ayudarle a retomar sus actividades diarias.',
    },
    conditions: {
      en: [
        'Herniated discs with nerve compression',
        'Spinal stenosis',
        'Spondylolisthesis',
        'Degenerative disc disease',
        'Compression fractures',
        'Failed prior spine surgery',
      ],
      es: [
        'Hernias discales con compresión nerviosa',
        'Estenosis espinal',
        'Espondilolistesis',
        'Enfermedad degenerativa del disco',
        'Fracturas por compresión',
        'Cirugía de columna previa fallida',
      ],
    },
    treatments: {
      en: [
        'Microdiscectomy and discectomy',
        'Laminectomy and decompression',
        'Anterior and posterior spinal fusion',
        'Minimally invasive spine surgery (MISS)',
        'Comprehensive post-operative rehabilitation',
      ],
      es: [
        'Microdiscectomía y discectomía',
        'Laminectomía y descompresión',
        'Fusión espinal anterior y posterior',
        'Cirugía de columna mínimamente invasiva (MISS)',
        'Rehabilitación postoperatoria integral',
      ],
    },
    additionalInfo: {
      en: 'Spine surgery is a significant decision, and we take time to explain every option, expected outcomes, and recovery timeline. Our surgeons work closely with physical therapists and pain management specialists to support you before and after your procedure. Most patients begin walking the same day and return to light activities within weeks, depending on the procedure performed.',
      es: 'La cirugía de columna es una decisión importante, y nos tomamos el tiempo para explicar cada opción, los resultados esperados y el cronograma de recuperación. Nuestros cirujanos trabajan en estrecha colaboración con fisioterapeutas y especialistas en manejo del dolor para apoyarle antes y después de su procedimiento. La mayoría de los pacientes comienzan a caminar el mismo día y retoman actividades ligeras en pocas semanas, según el procedimiento realizado.',
    },
  },
  'hip-knee-care': {
    title: {
      en: 'Hip & Knee Care',
      es: 'Atención de cadera y rodilla',
    },
    description: {
      en: 'Comprehensive care for hip and knee conditions.',
      es: 'Atención integral para afecciones de cadera y rodilla.',
    },
    image: SERVICE_IMAGES['hip-knee-care'],
    overview: {
      en: 'Hip and knee problems can make even simple activities like walking or climbing stairs painful and difficult. Our orthopedic specialists provide expert care for injuries, arthritis, and other conditions affecting these weight-bearing joints. We work with you to develop a treatment plan that addresses your specific needs and helps you maintain an active lifestyle.',
      es: 'Los problemas de cadera y rodilla pueden hacer que actividades sencillas como caminar o subir escaleras resulten dolorosas y difíciles. Nuestros especialistas ortopédicos brindan atención experta para lesiones, artritis y otras afecciones que afectan estas articulaciones de carga. Trabajamos con usted para desarrollar un plan de tratamiento que atienda sus necesidades específicas y le ayude a mantener un estilo de vida activo.',
    },
    conditions: {
      en: [
        'Osteoarthritis',
        'ACL Tears',
        'Meniscus Injuries',
        'Hip Fractures',
        'Bursitis',
        'Tendonitis',
      ],
      es: [
        'Osteoartritis',
        'Desgarros del LCA',
        'Lesiones de menisco',
        'Fracturas de cadera',
        'Bursitis',
        'Tendinitis',
      ],
    },
    treatments: {
      en: [
        'Conservative management',
        'Arthroscopic surgery',
        'Joint replacement',
        'Rehabilitation programs',
      ],
      es: [
        'Manejo conservador',
        'Cirugía artroscópica',
        'Reemplazo articular',
        'Programas de rehabilitación',
      ],
    },
    additionalInfo: {
      en: "The hip and knee joints bear significant weight and stress throughout our lives, making them susceptible to injury and wear. Whether you're dealing with a sports injury, arthritis, or a traumatic fracture, our comprehensive approach ensures you receive appropriate care. From advanced arthroscopic procedures to joint replacement surgery, we utilize the latest techniques to restore function and reduce pain.",
      es: 'Las articulaciones de cadera y rodilla soportan un peso y estrés significativos a lo largo de nuestra vida, lo que las hace susceptibles a lesiones y desgaste. Ya sea que enfrente una lesión deportiva, artritis o una fractura traumática, nuestro enfoque integral garantiza que reciba la atención adecuada. Desde procedimientos artroscópicos avanzados hasta cirugía de reemplazo articular, utilizamos las técnicas más recientes para restaurar la función y reducir el dolor.',
    },
  },
  'foot-ankle-care': {
    title: {
      en: 'Foot & Ankle Care',
      es: 'Atención de pie y tobillo',
    },
    description: {
      en: 'Expert treatment for foot and ankle conditions.',
      es: 'Tratamiento experto para afecciones de pie y tobillo.',
    },
    image: SERVICE_IMAGES['foot-ankle-care'],
    overview: {
      en: 'Your feet and ankles support your entire body, making them essential for mobility and daily function. Our foot and ankle specialists provide comprehensive care for a wide range of conditions, from common sprains to complex deformities. We understand that foot problems can significantly impact your quality of life and are committed to helping you stay active and pain-free.',
      es: 'Sus pies y tobillos sostienen todo su cuerpo, lo que los hace esenciales para la movilidad y la función diaria. Nuestros especialistas en pie y tobillo ofrecen atención integral para una amplia variedad de afecciones, desde esguinces comunes hasta deformidades complejas. Comprendemos que los problemas de pie pueden afectar significativamente su calidad de vida y estamos comprometidos a ayudarle a mantenerse activo y sin dolor.',
    },
    conditions: {
      en: [
        'Ankle Sprains',
        'Plantar Fasciitis',
        'Achilles Tendon Injuries',
        'Bunions',
        'Stress Fractures',
        'Arthritis',
      ],
      es: [
        'Esguinces de tobillo',
        'Fascitis plantar',
        'Lesiones del tendón de Aquiles',
        'Juanetes',
        'Fracturas por estrés',
        'Artritis',
      ],
    },
    treatments: {
      en: [
        'Custom orthotics',
        'Physical therapy',
        'Minimally invasive procedures',
        'Surgical correction when needed',
      ],
      es: [
        'Ortesis personalizadas',
        'Fisioterapia',
        'Procedimientos mínimamente invasivos',
        'Corrección quirúrgica cuando sea necesaria',
      ],
    },
    additionalInfo: {
      en: 'Foot and ankle conditions can develop from overuse, injury, or structural problems. Our specialists are skilled in both conservative treatments and surgical interventions. We often start with non-invasive approaches like custom orthotics, physical therapy, and medication. When surgery is necessary, we utilize minimally invasive techniques whenever possible to promote faster recovery and minimize discomfort.',
      es: 'Las afecciones de pie y tobillo pueden desarrollarse por sobreuso, lesión o problemas estructurales. Nuestros especialistas están capacitados tanto en tratamientos conservadores como en intervenciones quirúrgicas. A menudo comenzamos con enfoques no invasivos como ortesis personalizadas, fisioterapia y medicación. Cuando la cirugía es necesaria, utilizamos técnicas mínimamente invasivas siempre que sea posible para favorecer una recuperación más rápida y minimizar las molestias.',
    },
  },
  'total-joint-replacement': {
    title: {
      en: 'Total Joint Replacement',
      es: 'Reemplazo articular total',
    },
    description: {
      en: 'Advanced joint replacement procedures for improved mobility.',
      es: 'Procedimientos avanzados de reemplazo articular para mejorar la movilidad.',
    },
    image: SERVICE_IMAGES['total-joint-replacement'],
    overview: {
      en: 'When conservative treatments no longer provide relief from severe joint pain, joint replacement surgery can restore function and dramatically improve quality of life. Our experienced surgeons perform hip, knee, and shoulder replacement procedures using the latest techniques and materials. We focus on personalized care and comprehensive rehabilitation to help you return to your favorite activities.',
      es: 'Cuando los tratamientos conservadores ya no proporcionan alivio del dolor articular severo, la cirugía de reemplazo articular puede restaurar la función y mejorar dramáticamente la calidad de vida. Nuestros cirujanos experimentados realizan procedimientos de reemplazo de cadera, rodilla y hombro utilizando las técnicas y materiales más recientes. Nos enfocamos en atención personalizada y rehabilitación integral para ayudarle a volver a sus actividades favoritas.',
    },
    conditions: {
      en: [
        'Severe Arthritis',
        'Joint Degeneration',
        'Failed Previous Surgeries',
        'Traumatic Joint Damage',
      ],
      es: [
        'Artritis severa',
        'Degeneración articular',
        'Cirugías previas fallidas',
        'Daño articular traumático',
      ],
    },
    treatments: {
      en: [
        'Hip Replacement',
        'Knee Replacement',
        'Shoulder Replacement',
        'Comprehensive rehabilitation',
      ],
      es: [
        'Reemplazo de cadera',
        'Reemplazo de rodilla',
        'Reemplazo de hombro',
        'Rehabilitación integral',
      ],
    },
    additionalInfo: {
      en: 'Joint replacement surgery has advanced significantly in recent years, with new techniques and materials that improve outcomes and recovery times. Our surgeons use advanced imaging and planning tools to ensure precise placement of implants. We also emphasize comprehensive pre- and post-operative care, including physical therapy and pain management, to help you achieve the best possible results and return to your active lifestyle.',
      es: 'La cirugía de reemplazo articular ha avanzado significativamente en los últimos años, con nuevas técnicas y materiales que mejoran los resultados y los tiempos de recuperación. Nuestros cirujanos utilizan herramientas avanzadas de imagenología y planificación para garantizar la colocación precisa de los implantes. También enfatizamos la atención pre y postoperatoria integral, incluyendo fisioterapia y manejo del dolor, para ayudarle a lograr los mejores resultados posibles y volver a su estilo de vida activo.',
    },
  },
  'sports-medicine': {
    title: {
      en: 'Sports Medicine (Physicals)',
      es: 'Medicina deportiva (exámenes físicos)',
    },
    description: {
      en: 'Comprehensive care for athletes, including sports physicals and injury management.',
      es: 'Atención integral para atletas, incluyendo exámenes físicos deportivos y manejo de lesiones.',
    },
    image: SERVICE_IMAGES['sports-medicine'],
    overview: {
      en: "Whether you're a professional athlete or a weekend warrior, sports injuries can sideline you from the activities you love. Our sports medicine specialists understand the unique needs of active individuals and provide comprehensive care focused on rapid recovery and injury prevention. We work with athletes of all levels to get them back in the game safely and effectively.",
      es: 'Ya sea que sea un atleta profesional o alguien que practica deporte los fines de semana, las lesiones deportivas pueden apartarlo de las actividades que ama. Nuestros especialistas en medicina deportiva comprenden las necesidades únicas de las personas activas y ofrecen atención integral enfocada en la recuperación rápida y la prevención de lesiones. Trabajamos con atletas de todos los niveles para devolverlos al juego de forma segura y eficaz.',
    },
    conditions: {
      en: [
        'Sports-related Fractures',
        'Ligament Tears',
        'Muscle Strains',
        'Overuse Injuries',
        'Concussions',
        'Performance Issues',
      ],
      es: [
        'Fracturas relacionadas con el deporte',
        'Desgarros ligamentarios',
        'Distensiones musculares',
        'Lesiones por sobreuso',
        'Conmociones cerebrales',
        'Problemas de rendimiento',
      ],
    },
    treatments: {
      en: [
        'Sports physicals and clearance exams',
        'Injury prevention programs',
        'Performance optimization',
        'Rapid recovery protocols',
        'Return-to-play assessments',
      ],
      es: [
        'Exámenes físicos deportivos y de aptitud',
        'Programas de prevención de lesiones',
        'Optimización del rendimiento',
        'Protocolos de recuperación rápida',
        'Evaluaciones para el retorno al juego',
      ],
    },
    additionalInfo: {
      en: "Sports medicine goes beyond just treating injuries—it's about optimizing performance and preventing future problems. Our approach includes comprehensive evaluation, personalized treatment plans, and guidance on training modifications. We utilize cutting-edge techniques like platelet-rich plasma (PRP) therapy and advanced rehabilitation protocols to help athletes recover faster and stronger. Our goal is not just to treat your injury, but to help you perform better than before.",
      es: 'La medicina deportiva va más allá de tratar lesiones: se trata de optimizar el rendimiento y prevenir problemas futuros. Nuestro enfoque incluye evaluación integral, planes de tratamiento personalizados y orientación sobre modificaciones en el entrenamiento. Utilizamos técnicas de vanguardia como la terapia con plasma rico en plaquetas (PRP) y protocolos avanzados de rehabilitación para ayudar a los atletas a recuperarse más rápido y con mayor fortaleza. Nuestro objetivo no es solo tratar su lesión, sino ayudarle a rendir mejor que antes.',
    },
  },
}

export function getServiceDetail(slug, lang = 'en') {
  const detail = SERVICE_DETAILS[slug]
  if (!detail) return null
  const img = getServiceImage(slug)
  const placement = img.placement || 'photo'
  return {
    ...detail,
    title: localize(detail.title, lang),
    description: localize(detail.description, lang),
    overview: localize(detail.overview, lang),
    conditions: localizeArray(detail.conditions, lang),
    treatments: localizeArray(detail.treatments, lang),
    additionalInfo: localize(detail.additionalInfo, lang),
    image: img.src,
    imageFallback: img.fallback,
    placement,
    bodySrc: img.bodySrc || (placement !== 'photo' ? img.src : null),
    bodyLayout: img.bodyLayout,
    heroSrc: img.heroSrc || (placement === 'photo' ? img.src : null),
    heroLayout: img.heroLayout || 'photo',
    heroObjectPosition: img.objectPosition,
    featureSections: detail.featureSections?.map((section) => ({
      ...section,
      title: localize(section.title, lang),
      overview: localize(section.overview, lang),
      highlights: localizeArray(section.highlights, lang),
      note: localize(section.note, lang),
      image: section.image,
      imageFallback: IMAGES.services['auto-accident'].fallback,
      imageLayout: 'photo',
    })),
  }
}

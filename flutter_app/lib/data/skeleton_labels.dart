import '../core/l10n/localized.dart';
import 'skeleton_joints.dart';

/// Home skeleton viewer copy — from src/i18n/home.js `skeletonViewer`
class SkeletonLabels {
  static const eyebrow = L10nString(en: 'Where are you hurting?', es: '¿Dónde le duele?');
  static const title = L10nString(
    en: 'Explore your injury on the body',
    es: 'Explore su lesión en el cuerpo',
  );
  static const subtitle = L10nString(
    en:
        'Tap a highlighted area on the model, or choose a body area from the list. Each region shows common injuries and how we treat them.',
    es:
        'Toque un área resaltada en el modelo, o elija un área del cuerpo en la lista. Cada región muestra lesiones comunes y cómo las tratamos.',
  );
  static const loading = L10nString(en: 'Loading anatomy model', es: 'Cargando modelo anatómico');
  static const error = L10nString(
    en: 'The 3D model could not load. Use the body area list to browse treatments.',
    es: 'No se pudo cargar el modelo 3D. Use la lista de áreas del cuerpo para ver los tratamientos.',
  );
  static const hintPhone = L10nString(
    en: 'Drag to rotate · Tap a joint to zoom in',
    es: 'Arrastre para girar · Toque una articulación para acercar',
  );
  static const hintDesktop = L10nString(
    en: 'Drag to rotate · Tap a highlighted area',
    es: 'Arrastre para girar · Toque un área resaltada',
  );
  static const hintLocked = L10nString(
    en: 'Scroll freely · Turn on Rotate to spin the model',
    es: 'Desplace con libertad · Active Rotar para girar el modelo',
  );
  static const rotateLabel = L10nString(en: 'Rotate', es: 'Rotar');
  static const idle = L10nString(
    en: 'Choose a highlighted area on the model, or pick one from the list.',
    es: 'Elija un área resaltada en el modelo, o seleccione una de la lista.',
  );
  static const navLabel = L10nString(en: 'Body areas', es: 'Áreas del cuerpo');
  static const panelKicker = L10nString(en: 'How we treat this', es: 'Cómo lo tratamos');
  static const injuriesLabel = L10nString(en: 'Common injuries', es: 'Lesiones comunes');
  static const treatmentLabel = L10nString(en: 'Our approach', es: 'Nuestro enfoque');
  static const credit = L10nString(
    en: '3D model: Male Skeleton by projectkaizen, CC BY 4.0.',
    es: 'Modelo 3D: Male Skeleton de projectkaizen, CC BY 4.0.',
  );
  static const close = L10nString(en: 'Close', es: 'Cerrar');
  static const retry = L10nString(en: 'Try again', es: 'Intentar de nuevo');

  static String topicName(String id, String lang) {
    const map = {
      'neck': L10nString(en: 'Neck', es: 'Cuello'),
      'back': L10nString(en: 'Back', es: 'Espalda'),
      'shoulder': L10nString(en: 'Shoulder', es: 'Hombro'),
      'head': L10nString(en: 'Head / Headache', es: 'Cabeza / Dolor de cabeza'),
      'knee': L10nString(en: 'Knee', es: 'Rodilla'),
      'hip': L10nString(en: 'Hip', es: 'Cadera'),
      'wrist': L10nString(en: 'Wrist / Hand', es: 'Muñeca / Mano'),
      'soft_tissue': L10nString(en: 'Muscle & Soft Tissue', es: 'Músculo y tejidos blandos'),
      'elbow': L10nString(en: 'Elbow', es: 'Codo'),
      'ankle': L10nString(en: 'Ankle', es: 'Tobillo'),
    };
    return map[id]?.forLang(lang) ?? id;
  }

  static String jointName(String id, String lang) {
    const map = {
      'neck': L10nString(en: 'Neck', es: 'Cuello'),
      'back': L10nString(en: 'Back', es: 'Espalda'),
      'head': L10nString(en: 'Head / Headache', es: 'Cabeza / Dolor de cabeza'),
      'soft_tissue': L10nString(en: 'Muscle & Soft Tissue', es: 'Músculo y tejidos blandos'),
      'shoulder_l': L10nString(en: 'Left shoulder', es: 'Hombro izquierdo'),
      'shoulder_r': L10nString(en: 'Right shoulder', es: 'Hombro derecho'),
      'elbow_l': L10nString(en: 'Left elbow', es: 'Codo izquierdo'),
      'elbow_r': L10nString(en: 'Right elbow', es: 'Codo derecho'),
      'wrist_l': L10nString(en: 'Left wrist / hand', es: 'Muñeca / mano izquierda'),
      'wrist_r': L10nString(en: 'Right wrist / hand', es: 'Muñeca / mano derecha'),
      'hip_l': L10nString(en: 'Left hip', es: 'Cadera izquierda'),
      'hip_r': L10nString(en: 'Right hip', es: 'Cadera derecha'),
      'knee_l': L10nString(en: 'Left knee', es: 'Rodilla izquierda'),
      'knee_r': L10nString(en: 'Right knee', es: 'Rodilla derecha'),
      'ankle_l': L10nString(en: 'Left ankle', es: 'Tobillo izquierdo'),
      'ankle_r': L10nString(en: 'Right ankle', es: 'Tobillo derecho'),
    };
    return map[id]?.forLang(lang) ?? id;
  }

  static List<String> injuries(String region, String lang) {
    const en = {
      'neck': ['Cervical strain', 'Stiff neck', 'Whiplash'],
      'back': ['Herniated discs', 'Sciatica', 'Lower back pain'],
      'head': ['Tension headaches', 'Concussion', 'Post-trauma pain'],
      'soft_tissue': ['Muscle strains', 'Tendonitis', 'Contusions'],
      'shoulder': ['Rotator cuff tears', 'Dislocations', 'Frozen shoulder'],
      'elbow': ['Tennis elbow', 'Fractures', 'Bursitis'],
      'wrist': ['Carpal tunnel', 'Wrist fractures', 'Tendon injuries'],
      'hip': ['Arthritis', 'Bursitis', 'Labral tears'],
      'knee': ['ACL tears', 'Meniscus injuries', 'Arthritis'],
      'ankle': ['Sprains', 'Achilles injuries', 'Fractures'],
    };
    const es = {
      'neck': ['Contractura cervical', 'Cuello rígido', 'Latigazo'],
      'back': ['Hernias de disco', 'Ciática', 'Dolor lumbar'],
      'head': ['Dolor de cabeza tensional', 'Conmoción', 'Dolor post-trauma'],
      'soft_tissue': ['Distensiones musculares', 'Tendinitis', 'Contusiones'],
      'shoulder': ['Desgarro del manguito rotador', 'Luxaciones', 'Hombro congelado'],
      'elbow': ['Codo de tenista', 'Fracturas', 'Bursitis'],
      'wrist': ['Túnel carpiano', 'Fracturas de muñeca', 'Lesiones de tendón'],
      'hip': ['Artritis', 'Bursitis', 'Desgarros del labrum'],
      'knee': ['Desgarro de LCA', 'Lesiones de menisco', 'Artritis'],
      'ankle': ['Esguinces', 'Lesiones de Aquiles', 'Fracturas'],
    };
    return (lang == 'es' ? es : en)[region] ?? const [];
  }

  static String treatment(String region, String lang) {
    const en = {
      'neck':
          'We assess cervical motion and nerve symptoms with same-day imaging when needed, then treat with bracing, therapy, injections, or coordinated spine care.',
      'back':
          'We evaluate disc, nerve, and alignment issues with on-site imaging, then coordinate therapy, pain care, or spine procedures as needed.',
      'head':
          'Head and post-trauma pain is assessed promptly with a careful exam and imaging when indicated, then managed with a clear recovery plan.',
      'soft_tissue':
          'Muscle, tendon, and soft-tissue injuries are treated with rest, bracing, therapy, and sports-medicine care to restore strength and function.',
      'shoulder':
          'Same-day exam and imaging, then a plan that may include bracing, injections, physical therapy, or surgical repair when a tear will not heal on its own.',
      'elbow':
          'We calm inflammation, protect the joint, and restore motion with targeted therapy — surgery only when conservative care is not enough.',
      'wrist':
          'Stabilization, splinting, and precise diagnosis for nerve and tendon injuries, with a clear path back to grip strength and daily use.',
      'hip':
          'From arthritis care and joint preservation to replacement when needed — focused on walking comfortably again.',
      'knee':
          'Sports and wear-and-tear injuries are treated with imaging, bracing, therapy, and ligament or joint procedures when required.',
      'ankle':
          'Walk-in evaluation for sprains and fractures, with boot or cast support, guided rehab, and specialist follow-up.',
    };
    const es = {
      'neck':
          'Evaluamos el movimiento cervical y los síntomas nerviosos con imágenes el mismo día cuando se necesitan, luego tratamos con férula, terapia, inyecciones o cuidado coordinado de columna.',
      'back':
          'Evaluamos discos, nervios y alineación con imágenes en el sitio, y coordinamos terapia, manejo del dolor o procedimientos de columna según sea necesario.',
      'head':
          'El dolor de cabeza y post-trauma se evalúa de inmediato con un examen cuidadoso e imágenes cuando corresponde, luego se maneja con un plan claro de recuperación.',
      'soft_tissue':
          'Las lesiones de músculo, tendón y tejidos blandos se tratan con reposo, férulas, terapia y medicina deportiva para restaurar fuerza y función.',
      'shoulder':
          'Evaluación e imágenes el mismo día, luego un plan que puede incluir férula, inyecciones, terapia física o reparación quirúrgica si el desgarro no sana solo.',
      'elbow':
          'Calmamos la inflamación, protegemos la articulación y recuperamos el movimiento con terapia dirigida — cirugía solo cuando el cuidado conservador no basta.',
      'wrist':
          'Estabilización, férulas y diagnóstico preciso de nervios y tendones, con un camino claro para recuperar fuerza de agarre y uso diario.',
      'hip':
          'Desde el cuidado de la artritis y la preservación articular hasta el reemplazo cuando hace falta — con el objetivo de volver a caminar con comodidad.',
      'knee':
          'Lesiones deportivas y por desgaste se tratan con imágenes, férulas, terapia y procedimientos de ligamentos o articulación cuando se necesitan.',
      'ankle':
          'Evaluación sin cita para esguinces y fracturas, con bota o yeso, rehabilitación guiada y seguimiento especializado.',
    };
    return (lang == 'es' ? es : en)[region] ?? '';
  }

  static String nameFor(SkeletonJoint joint, String lang) => jointName(joint.id, lang);
}

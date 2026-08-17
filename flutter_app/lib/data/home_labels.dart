/// Home + hero + treat + reviews strings — from src/i18n/home.js & translations.js
class HomeLabels {
  static String heroEyebrow(String lang) =>
      lang == 'es' ? 'Sin cita · Mismo día · Sin remisión' : 'Walk-in · Same-day · No referral needed';

  static String heroTitle(String lang) =>
      lang == 'es' ? 'Cuidado experto de lesiones' : 'Expert Injury Care';

  static String heroTitleAccent(String lang) =>
      lang == 'es' ? 'Disponible para todas las edades' : 'On-demand for all ages';

  static String heroLead(String lang) =>
      lang == 'es'
          ? 'Citas el mismo día para lesiones disponibles — tratamiento listo para esguinces, fracturas, lesiones deportivas y dolor articular.'
          : 'Same-day injury appointments available — treatment ready for sprains, fractures, sports injuries, and joint pain.';

  static String heroBook(String lang) =>
      lang == 'es' ? 'Reservar cita' : 'Book an Appointment';

  static String heroFindCenter(String lang) =>
      lang == 'es' ? 'Buscar un centro' : 'Find a Center';

  static String heroTrustWalkIn(String lang) =>
      lang == 'es' ? 'Sin cita previa' : 'Walk-ins welcome';

  static String heroTrustSameDay(String lang) =>
      lang == 'es' ? 'Mismo día' : 'Same-day visits';

  static String heroTrustInsurance(String lang) =>
      lang == 'es' ? 'Aceptamos seguros' : 'Most insurance accepted';

  static String treatTitle(String lang) =>
      lang == 'es' ? 'Lo que tratamos' : 'What We Treat';

  static String treatSubtitle(String lang) =>
      lang == 'es'
          ? 'Elija lo que necesita — entre hoy mismo.'
          : 'Choose what you need — walk in today.';

  static String treatCard(String key, String lang) {
    final map = lang == 'es'
        ? {
            'injured': 'Estoy lesionado',
            'pain': 'Tengo dolor',
            'scan': 'Necesito un escaneo',
            'sports': 'Lesiones deportivas',
            'spine': 'Espalda y cuello',
            'workers': 'Comp. laboral',
          }
        : {
            'injured': "I'm Injured",
            'pain': "I'm in pain",
            'scan': 'I need a test or scan',
            'sports': 'Sports injuries',
            'spine': 'Back & neck pain',
            'workers': "Workers' comp",
          };
    return map[key] ?? key;
  }

  static String treatViewAll(String lang) =>
      lang == 'es' ? 'Ver todos los servicios' : 'View all services';

  static String howWeCareTitle(String lang) =>
      lang == 'es' ? 'Cómo cuidamos de usted' : 'How we care for you';

  static String howWeCareSubtitle(String lang) =>
      lang == 'es'
          ? 'Desde apoyo legal hasta la recuperación — pasos claros cuando necesita atención.'
          : 'From legal support to recovery — clear steps when you need care.';

  static String howWeCareTileTitle(String key, String lang) {
    final map = lang == 'es'
        ? {
            'lawyers': 'Demografía / Abogados',
            'diagnose': 'Diagnosticar',
            'treat': 'Tratar',
            'surgery': 'Cirugía cuando se necesita',
            'recover': 'Recuperar',
          }
        : {
            'lawyers': 'Demographics / Lawyers',
            'diagnose': 'Diagnose',
            'treat': 'Treat',
            'surgery': 'Surgery when needed',
            'recover': 'Recover',
          };
    return map[key] ?? key;
  }

  static String howWeCareTileDesc(String key, String lang) {
    final map = lang == 'es'
        ? {
            'lawyers': '¿No tiene uno? También trabajamos con abogados.',
            'diagnose': 'Rayos X, imágenes y evaluación experta en el sitio — a menudo el mismo día.',
            'treat': 'Cuidado no quirúrgico, inyecciones, férulas y manejo del dolor.',
            'surgery': 'Reemplazo articular y procedimientos avanzados de cirujanos experimentados.',
            'recover': 'Planes de rehabilitación y medicina deportiva para volver a moverse.',
          }
        : {
            'lawyers': "Don't have one? We work with lawyers as well.",
            'diagnose': 'On-site X-rays, imaging, and expert evaluation — often same day.',
            'treat': 'Non-surgical care, injections, bracing, and pain management.',
            'surgery': 'Joint replacement and advanced procedures from experienced surgeons.',
            'recover': 'Rehab plans and sports medicine to get you moving again.',
          };
    return map[key] ?? '';
  }

  static String learnMore(String lang) => lang == 'es' ? 'Saber más' : 'Learn more';

  static String locationsLabel(String lang) =>
      lang == 'es' ? 'ENCUÉNTRENOS CERCA' : 'FIND US NEAR YOU';

  static String locationsTitle(String lang) =>
      lang == 'es' ? 'Nuestras ubicaciones' : 'Our Locations';

  static String locationsSubtitle(String lang) =>
      lang == 'es'
          ? 'Entre hoy — o obtenga indicaciones en un toque.'
          : 'Walk in today — or get directions in one tap.';

  static String locationsViewAll(String lang) =>
      lang == 'es' ? 'Todas las ubicaciones' : 'All locations';

  static String locationsCall(String lang) => lang == 'es' ? 'Llamar' : 'Call';

  static String locationsViewClinic(String lang) =>
      lang == 'es' ? 'Ver clínica' : 'View clinic';

  static String locationsDirections(String lang) =>
      lang == 'es' ? 'Cómo llegar' : 'Directions';

  static String reviewsTitle(String lang) =>
      lang == 'es' ? 'Reseñas de pacientes' : 'Patient reviews';

  static String reviewsSubtitle(String lang) =>
      lang == 'es'
          ? 'Atención ortopédica de confianza.'
          : 'Walk-in orthopedic care patients trust.';

  static String reviewsGoogle(String lang) =>
      lang == 'es' ? 'Reseñas de Google' : 'Google Reviews';

  static String reviewsRatingLabel(String lang) =>
      lang == 'es' ? 'de 5' : 'out of 5';

  static String reviewsCount(String lang, int count) =>
      lang == 'es'
          ? 'Basado en más de $count reseñas de Google'
          : 'Based on $count+ Google reviews';

  static String reviewsViewOnGoogle(String lang) =>
      lang == 'es' ? 'Ver en Google' : 'View on Google';

  static String reviewsWriteOnGoogle(String lang) =>
      lang == 'es' ? 'Escribir una reseña en Google' : 'Write a review on Google';

  static String reviewsPowered(String lang) =>
      lang == 'es' ? 'Reseñas de pacientes de Google' : 'Patient reviews from Google';

  static String statsHappyPatients(String lang) =>
      lang == 'es' ? 'Pacientes satisfechos' : 'Happy Patients';

  static String statsPatientsServed(String lang) =>
      lang == 'es' ? 'Pacientes atendidos' : 'Patients Served';

  static String insuranceTitle(String lang) =>
      lang == 'es' ? 'Seguros' : 'Insurance';

  static String insuranceSubtitle(String lang) =>
      lang == 'es'
          ? 'Aceptamos la mayoría de los planes. Llame para confirmar su cobertura.'
          : 'Most plans accepted. Call to confirm your coverage.';

  static String insuranceNoInsurance(String lang) =>
      lang == 'es'
          ? '¿Sin seguro? No hay problema. Ofrecemos opciones asequibles de pago en efectivo.'
          : 'No insurance? No problem. We offer affordable cash pay options.';

  static String insuranceVerify(String lang) =>
      lang == 'es' ? 'Verificar cobertura' : 'Verify coverage';

  static String insuranceViewPricing(String lang) =>
      lang == 'es' ? 'Ver precios y seguros' : 'View pricing & insurance';

  static String insuranceAndMore(String lang) =>
      lang == 'es' ? '+ muchos más' : '+ many more';

  static String blogTitle(String lang) =>
      lang == 'es' ? 'De nuestro blog' : 'From our blog';

  static String blogAll(String lang) =>
      lang == 'es' ? 'Todos los blogs →' : 'All Blogs →';

  static String blogReadMore(String lang) =>
      lang == 'es' ? 'Leer más →' : 'Read More →';
}

class NotFoundLabels {
  static String title(String lang) =>
      lang == 'es' ? 'Página no encontrada' : 'Page Not Found';

  static String text(String lang) =>
      lang == 'es'
          ? 'Lo sentimos, no pudimos encontrar la página que busca.'
          : "Sorry, we couldn't find the page you're looking for.";

  static String goHome(String lang) =>
      lang == 'es' ? 'Ir al inicio' : 'Go to Home';

  static String bookAppointment(String lang) =>
      lang == 'es' ? 'Reservar cita' : 'Book Appointment';

  static String call(String lang) => lang == 'es' ? 'Llamar' : 'Call';
}

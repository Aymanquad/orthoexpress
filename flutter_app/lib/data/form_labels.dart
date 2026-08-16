import 'clinic.dart';

/// Contact & appointment form strings — from src/i18n/pages.js
class ContactLabels {
  static String title(String lang) =>
      lang == 'es' ? 'Contáctenos' : 'Contact Us';

  static String subtitle(String lang) =>
      lang == 'es'
          ? 'Estamos aquí para ayudarle. Póngase en contacto con nosotros hoy.'
          : "We're here to help. Get in touch with us today.";

  static String getInTouch(String lang) =>
      lang == 'es' ? 'Póngase en contacto' : 'Get in Touch';

  static String getInTouchText(String lang) =>
      lang == 'es'
          ? '¿Tiene preguntas o necesita programar una cita? Estamos aquí para ayudarle.'
          : "Have questions or need to schedule an appointment? We're here to help. Reach out to us through any of the following methods.";

  static String phone(String lang) => lang == 'es' ? 'Teléfono' : 'Phone';
  static String fax(String lang) => lang == 'es' ? 'Fax' : 'Fax';
  static String email(String lang) => lang == 'es' ? 'Correo' : 'Email';
  static String headquarters(String lang) =>
      lang == 'es' ? 'Oficina central' : 'Headquarters';
  static String viewAllLocations(String lang) =>
      lang == 'es' ? 'Ver todas las ubicaciones →' : 'View all locations →';
  static String hours(String lang) => lang == 'es' ? 'Horario' : 'Hours';
  static String sendMessage(String lang) =>
      lang == 'es' ? 'Envíenos un mensaje' : 'Send us a Message';
  static String formHint(String lang) =>
      lang == 'es'
          ? 'No incluya detalles médicos sensibles. Para asuntos urgentes, llámenos.'
          : 'Please do not include sensitive medical details. For urgent matters, call us directly.';

  static String yourDetails(String lang) =>
      lang == 'es' ? 'Sus datos' : 'Your details';
  static String message(String lang) => lang == 'es' ? 'Mensaje' : 'Message';
  static String consent(String lang) =>
      lang == 'es'
          ? 'Acepto ser contactado por ${ClinicData.name} respecto a mi consulta. Vea nuestra'
          : 'I agree to be contacted by ${ClinicData.name} regarding my inquiry. See our';
  static String privacyPolicy(String lang) =>
      lang == 'es' ? 'Política de privacidad' : 'Privacy Policy';
  static String sending(String lang) => lang == 'es' ? 'Enviando...' : 'Sending...';
  static String send(String lang) => lang == 'es' ? 'Enviar mensaje' : 'Send Message';
  static String successTitle(String lang) =>
      lang == 'es' ? '¡Mensaje enviado!' : 'Message sent!';
  static String successMailto(String lang) =>
      lang == 'es'
          ? 'Su aplicación de correo debería abrirse con su mensaje listo para enviar.'
          : 'Your email app should open with your message ready to send. We will respond as soon as possible.';
  static String successForm(String lang) =>
      lang == 'es'
          ? 'Gracias por contactarnos. Nuestro equipo le responderá dentro de un día hábil.'
          : 'Thank you for reaching out. Our team will get back to you within one business day.';
  static String errorTitle(String lang) =>
      lang == 'es' ? 'No se pudo enviar el mensaje' : 'Unable to send message';
  static String errorMessage(String lang) =>
      lang == 'es'
          ? 'Algo salió mal. Llámenos directamente y le ayudaremos de inmediato.'
          : 'Something went wrong. Please call us directly and we will help you right away.';
  static String gotIt(String lang) => lang == 'es' ? 'Entendido' : 'Got it';
  static String checkForm(String lang) =>
      lang == 'es' ? 'Por favor revise su formulario' : 'Please check your form';
}

class BookLabels {
  static String title(String lang) =>
      lang == 'es' ? 'Reservar una cita' : 'Book an Appointment';

  static String subtitle(String lang) =>
      lang == 'es'
          ? 'Programe su visita — también aceptamos visitas sin cita.'
          : 'Schedule your visit — walk-ins also welcome.';

  static String formTitle(String lang) =>
      lang == 'es' ? 'Solicitud de cita' : 'Appointment Request';

  static String formHint(String lang) =>
      lang == 'es'
          ? 'Complete el formulario y nuestro equipo confirmará su cita.'
          : 'Fill out the form below and our team will confirm your appointment.';

  static String yourDetails(String lang) =>
      lang == 'es' ? 'Sus datos' : 'Your details';

  static String visitDetails(String lang) =>
      lang == 'es' ? 'Su visita' : 'Your visit';

  static String fullName(String lang) => lang == 'es' ? 'Nombre completo' : 'Full Name';
  static String phone(String lang) =>
      lang == 'es' ? 'Número de teléfono' : 'Phone Number';
  static String email(String lang) => lang == 'es' ? 'Correo' : 'Email';
  static String location(String lang) =>
      lang == 'es' ? 'Ubicación preferida' : 'Preferred Location';
  static String selectLocation(String lang) =>
      lang == 'es' ? 'Seleccione una ubicación' : 'Select a location';
  static String selectDate(String lang) =>
      lang == 'es' ? 'Seleccione una fecha' : 'Select a date';
  static String preferredDate(String lang) =>
      lang == 'es' ? 'Fecha preferida' : 'Preferred Date';
  static String preferredTime(String lang) =>
      lang == 'es' ? 'Hora preferida' : 'Preferred Time';
  static String noPreference(String lang) =>
      lang == 'es' ? 'Sin preferencia' : 'No preference';
  static String reason(String lang) =>
      lang == 'es' ? 'Motivo de la visita' : 'Reason for Visit';
  static String reasonPlaceholder(String lang) =>
      lang == 'es'
          ? 'Describa brevemente sus síntomas o motivo de la visita'
          : 'Briefly describe your symptoms or reason for visit';
  static String consent(String lang) =>
      lang == 'es'
          ? 'Acepto ser contactado por ${ClinicData.name} para confirmar mi cita. Vea nuestra'
          : 'I agree to be contacted by ${ClinicData.name} to confirm my appointment. See our';
  static String privacyPolicy(String lang) =>
      lang == 'es' ? 'Política de privacidad' : 'Privacy Policy';
  static String submitting(String lang) =>
      lang == 'es' ? 'Enviando...' : 'Submitting...';
  static String submit(String lang) =>
      lang == 'es' ? 'Solicitar cita' : 'Request Appointment';
  static String successTitle(String lang) =>
      lang == 'es' ? '¡Solicitud recibida!' : 'Request received!';
  static String successMailto(String lang) =>
      lang == 'es'
          ? 'Su aplicación de correo debería abrirse con su solicitud. Confirmaremos pronto.'
          : 'Your email app should open with your request. We will confirm shortly.';
  static String successForm(String lang) =>
      lang == 'es'
          ? '¡Gracias! Nuestro equipo le contactará dentro de un día hábil para confirmar su cita.'
          : 'Thank you! Our team will contact you within one business day to confirm your appointment.';
  static String errorTitle(String lang) =>
      lang == 'es' ? 'No se pudo enviar la solicitud' : 'Unable to submit request';
  static String morning(String lang) =>
      lang == 'es' ? 'Mañana (9 AM – 12 PM)' : 'Morning (9 AM – 12 PM)';
  static String afternoon(String lang) =>
      lang == 'es' ? 'Tarde (12 PM – 3 PM)' : 'Afternoon (12 PM – 3 PM)';
  static String lateAfternoon(String lang) =>
      lang == 'es' ? 'Tarde (3 PM – 5 PM)' : 'Late Afternoon (3 PM – 5 PM)';
  static String gotIt(String lang) => lang == 'es' ? 'Entendido' : 'Got it';
  static String checkForm(String lang) =>
      lang == 'es' ? 'Por favor revise su formulario' : 'Please check your form';
}

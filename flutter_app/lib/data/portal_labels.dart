import '../core/l10n/localized.dart';

/// Patient portal strings — from src/i18n/portal.js
class PortalLabels {
  static const signIn = L10nString(en: 'Patient Sign In', es: 'Iniciar sesión');
  static const myPortal = L10nString(en: 'My Portal', es: 'Mi portal');
  static const myAppointments = L10nString(en: 'My Appointments', es: 'Mis citas');
  static const signInWithPhone = L10nString(
    en: 'Sign in with your phone',
    es: 'Iniciar sesión con su teléfono',
  );
  static const goToDashboard = L10nString(en: 'Go to my dashboard', es: 'Ir a mi panel');
  static const signOut = L10nString(en: 'Sign out', es: 'Cerrar sesión');

  static const loginTitle = L10nString(
    en: 'Patient Portal Sign In',
    es: 'Inicio de sesión del portal',
  );
  static const loginSubtitle = L10nString(
    en: 'Enter your mobile number to receive a one-time verification code.',
    es: 'Ingrese su número móvil para recibir un código de verificación.',
  );
  static const phoneLabel = L10nString(en: 'Mobile number', es: 'Número móvil');
  static const phonePlaceholder = L10nString(en: '(213) 555-0100', es: '(213) 555-0100');
  static const phoneHelp = L10nString(
    en: "We'll text a one-time code to this number.",
    es: 'Le enviaremos un código de un solo uso a este número.',
  );
  static const sendCode = L10nString(en: 'Send code', es: 'Enviar código');
  static const sending = L10nString(en: 'Sending…', es: 'Enviando…');
  static const verifyTitle = L10nString(en: 'Enter verification code', es: 'Ingrese el código');
  static String verifySubtitle(String lang, String phone) => lang == 'es'
      ? 'Enviamos un código de 6 dígitos a $phone'
      : 'We sent a 6-digit code to $phone';
  static const codeLabel = L10nString(en: 'Verification code', es: 'Código de verificación');
  static const verify = L10nString(en: 'Verify & sign in', es: 'Verificar e iniciar sesión');
  static const verifying = L10nString(en: 'Verifying…', es: 'Verificando…');
  static const changeNumber = L10nString(en: 'Change number', es: 'Cambiar número');
  static const resend = L10nString(en: 'Resend code', es: 'Reenviar código');
  static String resendIn(String lang, int seconds) =>
      lang == 'es' ? 'Reenviar en ${seconds}s' : 'Resend in ${seconds}s';
  static const invalidPhone = L10nString(
    en: 'Please enter a valid US phone number.',
    es: 'Ingrese un número de teléfono válido de EE. UU.',
  );
  static const invalidCode = L10nString(
    en: 'Please enter the 6-digit code.',
    es: 'Ingrese el código de 6 dígitos.',
  );

  static const dashboardTitle = L10nString(en: 'My Portal', es: 'Mi portal');
  static String welcome(String lang, String name) =>
      lang == 'es' ? 'Hola, $name' : 'Hello, $name';
  static const welcomeGuest = L10nString(en: 'Hello', es: 'Hola');
  static const upcoming = L10nString(en: 'Upcoming appointments', es: 'Próximas citas');
  static const viewAll = L10nString(en: 'View all appointments', es: 'Ver todas las citas');
  static const noUpcoming = L10nString(
    en: 'No upcoming visits scheduled.',
    es: 'No hay visitas programadas.',
  );
  static const bookCta = L10nString(en: 'Book an appointment', es: 'Reservar cita');
  static const contactClinic = L10nString(en: 'Contact clinic', es: 'Contactar clínica');
  static const myOrders = L10nString(en: 'My shop orders', es: 'Mis pedidos');
  static const shopOrders = L10nString(en: 'Shop orders', es: 'Pedidos de la tienda');
  static const noOrders = L10nString(
    en: 'No shop orders linked to this phone yet.',
    es: 'Aún no hay pedidos vinculados a este teléfono.',
  );

  static const appointmentsTitle = L10nString(en: 'My Appointments', es: 'Mis citas');
  static const tabUpcoming = L10nString(en: 'Upcoming', es: 'Próximas');
  static const tabPast = L10nString(en: 'Past', es: 'Anteriores');
  static const tabAll = L10nString(en: 'All', es: 'Todas');
  static const empty = L10nString(en: 'No appointments found.', es: 'No se encontraron citas.');
  static const date = L10nString(en: 'Date', es: 'Fecha');
  static const provider = L10nString(en: 'Provider', es: 'Proveedor');
  static const reason = L10nString(en: 'Reason', es: 'Motivo');

  static String status(String key, String lang) {
    const map = {
      'REQUESTED': L10nString(en: 'Requested', es: 'Solicitada'),
      'SCHEDULED': L10nString(en: 'Scheduled', es: 'Programada'),
      'COMPLETED': L10nString(en: 'Completed', es: 'Completada'),
      'CANCELLED': L10nString(en: 'Cancelled', es: 'Cancelada'),
      'NO_SHOW': L10nString(en: 'No show', es: 'No asistió'),
    };
    return map[key]?.forLang(lang) ?? key;
  }

  static const genericError = L10nString(
    en: 'Something went wrong. Please try again.',
    es: 'Algo salió mal. Inténtelo de nuevo.',
  );
  static const notAuthenticated = L10nString(
    en: 'Please sign in to continue.',
    es: 'Inicie sesión para continuar.',
  );
  static const apiUnavailable = L10nString(
    en: 'Could not reach the portal. Make sure the clinic API is running.',
    es: 'No se pudo conectar al portal. Verifique que la API de la clínica esté en funcionamiento.',
  );
}

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
  static const myProfile = L10nString(en: 'My profile', es: 'Mi perfil');
  static const profileTitle = L10nString(en: 'My profile', es: 'Mi perfil');
  static const profileLead = L10nString(
    en: 'Keep your details up to date for booking and orders.',
    es: 'Mantenga sus datos actualizados para citas y pedidos.',
  );
  static const firstName = L10nString(en: 'First name', es: 'Nombre');
  static const lastName = L10nString(en: 'Last name', es: 'Apellido');
  static const email = L10nString(en: 'Email', es: 'Correo');
  static const preferredClinic = L10nString(
    en: 'Preferred clinic',
    es: 'Clínica preferida',
  );
  static const preferredClinicNone = L10nString(
    en: 'No preference',
    es: 'Sin preferencia',
  );
  static const preferredClinicHelp = L10nString(
    en: 'Used to pre-select a location when you book.',
    es: 'Se usa para preseleccionar una ubicación al reservar.',
  );
  static const phoneChangeHelp = L10nString(
    en: 'This is your sign-in number. Use a number that can receive texts.',
    es: 'Este es su número de inicio de sesión. Use un número que pueda recibir mensajes.',
  );
  static const saveProfile = L10nString(en: 'Save changes', es: 'Guardar cambios');
  static const savingProfile = L10nString(en: 'Saving…', es: 'Guardando…');
  static const profileSaved = L10nString(
    en: 'Profile saved',
    es: 'Perfil guardado',
  );
  static const firstNameRequired = L10nString(
    en: 'Enter your first name.',
    es: 'Ingrese su nombre.',
  );
  static const emailInvalid = L10nString(
    en: 'Enter a valid email address.',
    es: 'Ingrese un correo válido.',
  );
  static const phoneInUse = L10nString(
    en: 'That phone number is already in use.',
    es: 'Ese número ya está en uso.',
  );
  static const goToDashboard = L10nString(en: 'Go to my dashboard', es: 'Ir a mi panel');
  static const goToHome = L10nString(en: 'View home dashboard', es: 'Ver panel de inicio');
  static const signOut = L10nString(en: 'Sign out', es: 'Cerrar sesión');

  static const loginTitle = L10nString(
    en: 'Sign in',
    es: 'Iniciar sesión',
  );
  static const loginSubtitle = L10nString(
    en: 'Enter your mobile number to receive a one-time verification code.',
    es: 'Ingrese su número móvil para recibir un código de verificación.',
  );
  static const continueAsGuest = L10nString(
    en: 'Continue browsing as guest',
    es: 'Continuar como invitado',
  );
  static const signInPromptTitle = L10nString(
    en: 'Sign in for your care',
    es: 'Inicie sesión para su atención',
  );
  static const signInPromptBody = L10nString(
    en: 'See appointments and orders linked to your phone.',
    es: 'Vea citas y pedidos vinculados a su teléfono.',
  );
  static const signInPromptCta = L10nString(
    en: 'Sign in',
    es: 'Iniciar sesión',
  );
  static const privacyNote = L10nString(
    en: 'We only use your number to verify it is you and send visit updates.',
    es: 'Solo usamos su número para verificar su identidad y enviar actualizaciones de visitas.',
  );
  static const welcomeBack = L10nString(
    en: 'You are signed in',
    es: 'Ha iniciado sesión',
  );
  static String welcomeBackNamed(String lang, String name) => lang == 'es'
      ? 'Bienvenido/a, $name'
      : 'Welcome back, $name';
  static const signedInAs = L10nString(
    en: 'Signed in',
    es: 'Sesión iniciada',
  );
  static const logoutConfirmTitle = L10nString(
    en: 'Sign out?',
    es: '¿Cerrar sesión?',
  );
  static const logoutConfirmBody = L10nString(
    en: 'You can sign back in anytime with your phone number.',
    es: 'Puede volver a iniciar sesión en cualquier momento con su número.',
  );
  static const logoutConfirmYes = L10nString(
    en: 'Sign out',
    es: 'Cerrar sesión',
  );
  static const logoutConfirmNo = L10nString(
    en: 'Stay signed in',
    es: 'Permanecer conectado',
  );
  static const codeSent = L10nString(
    en: 'Code sent',
    es: 'Código enviado',
  );
  static const invalidCodeRetry = L10nString(
    en: 'That code did not work. Check the text and try again.',
    es: 'Ese código no funcionó. Revise el mensaje e inténtelo de nuevo.',
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
  static const myRecords = L10nString(en: 'My records', es: 'Mis registros');
  static const recordsTitle = L10nString(en: 'My records', es: 'Mis registros');
  static String recordsHeroTitle(String lang, String name) => lang == 'es'
      ? '$name, su resumen de salud'
      : '$name, your health snapshot';
  static const recordsLead = L10nString(
    en: 'Everything your care team has on file — prescriptions, profile, and contact details in one place.',
    es: 'Todo lo que su equipo de atención tiene registrado — recetas, perfil y contacto en un solo lugar.',
  );
  static const snapshotLabel = L10nString(en: 'Health snapshot', es: 'Resumen de salud');
  static const lastUpdated = L10nString(en: 'Profile last updated', es: 'Perfil actualizado');
  static const activeRx = L10nString(en: 'Active medications', es: 'Medicamentos activos');
  static const insurance = L10nString(en: 'Insurance', es: 'Seguro');
  static const allergyAlert = L10nString(en: 'Known allergy on file', es: 'Alergia registrada');
  static const editContact = L10nString(en: 'Update contact info', es: 'Actualizar contacto');
  static const addContact = L10nString(en: 'Add contact info', es: 'Agregar contacto');
  static const saveContact = L10nString(en: 'Save contact info', es: 'Guardar contacto');
  static const savingContact = L10nString(en: 'Saving…', es: 'Guardando…');
  static const cancel = L10nString(en: 'Cancel', es: 'Cancelar');
  static const contactSaved = L10nString(
    en: 'Contact information saved.',
    es: 'Información de contacto guardada.',
  );
  static const contactEditHint = L10nString(
    en: 'You can update your address and emergency contact. Clinical fields are managed by your care team.',
    es: 'Puede actualizar su dirección y contacto de emergencia. Los datos clínicos los gestiona su equipo.',
  );
  static const clinicalReadOnly = L10nString(
    en: 'Clinical and insurance details are maintained by your care team.',
    es: 'Los datos clínicos y de seguro los mantiene su equipo de atención.',
  );
  static const sectionIdentity = L10nString(en: 'Identity', es: 'Identidad');
  static const sectionContact = L10nString(en: 'Contact & address', es: 'Contacto y dirección');
  static const sectionCoverage = L10nString(en: 'Insurance', es: 'Seguro');
  static const sectionClinical = L10nString(en: 'Clinical history', es: 'Historial clínico');
  static const demographicsHint = L10nString(
    en: 'Your profile and contact details with the clinic.',
    es: 'Su perfil y datos de contacto en la clínica.',
  );
  static const prescriptionsHint = L10nString(
    en: 'Medications prescribed during your care.',
    es: 'Medicamentos recetados durante su atención.',
  );
  static const filterAll = L10nString(en: 'All', es: 'Todas');
  static const noRxFilter = L10nString(
    en: 'No prescriptions match this filter.',
    es: 'No hay recetas con este filtro.',
  );
  static const demographics = L10nString(en: 'Demographics', es: 'Datos demográficos');
  static const prescriptions = L10nString(en: 'Prescriptions', es: 'Recetas');
  static const noDemo = L10nString(
    en: 'No demographic record has been added yet.',
    es: 'Aún no hay un registro demográfico.',
  );
  static const noRx = L10nString(en: 'No prescriptions on file.', es: 'No hay recetas en el expediente.');
  static const dob = L10nString(en: 'Date of birth', es: 'Fecha de nacimiento');
  static const sex = L10nString(en: 'Sex', es: 'Sexo');
  static const bloodType = L10nString(en: 'Blood type', es: 'Tipo de sangre');
  static const address = L10nString(en: 'Address', es: 'Dirección');
  static const country = L10nString(en: 'Country', es: 'País');
  static const emergency = L10nString(en: 'Emergency contact', es: 'Contacto de emergencia');
  static const emergencyPhone = L10nString(en: 'Emergency phone', es: 'Teléfono de emergencia');
  static const emergencyRelationship = L10nString(en: 'Relationship', es: 'Parentesco');
  static const allergies = L10nString(en: 'Allergies', es: 'Alergias');
  static const conditions = L10nString(en: 'Conditions', es: 'Condiciones');

  static String rxStatus(String key, String lang) {
    const map = {
      'ACTIVE': L10nString(en: 'Active', es: 'Activa'),
      'COMPLETED': L10nString(en: 'Completed', es: 'Completada'),
      'DISCONTINUED': L10nString(en: 'Discontinued', es: 'Descontinuada'),
      'STOPPED': L10nString(en: 'Discontinued', es: 'Descontinuada'),
    };
    return map[key]?.forLang(lang) ?? key;
  }

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
    en: 'We couldn’t connect right now. Check your connection and try again.',
    es: 'No pudimos conectar ahora. Revise su conexión e inténtelo de nuevo.',
  );
}

import '../core/l10n/localized.dart';

class DoctorLabels {
  static const talkToDoctor = L10nString(
    en: 'Talk to a doctor',
    es: 'Hablar con un médico',
  );
  static const title = L10nString(
    en: 'Call or chat with a doctor',
    es: 'Llamar o chatear con un médico',
  );
  static const lead = L10nString(
    en: 'Reach an OrthoExpress clinician for follow-ups and non-emergency questions.',
    es: 'Comuníquese con un clínico de OrthoExpress para seguimientos y preguntas no urgentes.',
  );
  static const emergencyNote = L10nString(
    en: 'For emergencies, call 911. This is not for life-threatening care.',
    es: 'En emergencias, llame al 911. Esto no es para atención de riesgo vital.',
  );
  static const availableNow = L10nString(en: 'Available now', es: 'Disponible ahora');
  static const away = L10nString(en: 'Away', es: 'Ausente');
  static const call = L10nString(en: 'Call', es: 'Llamar');
  static const chat = L10nString(en: 'Chat', es: 'Chat');
  static const callFailed = L10nString(
    en: 'Could not open the phone dialer on this device.',
    es: 'No se pudo abrir el marcador en este dispositivo.',
  );
  static const signInRequired = L10nString(
    en: 'Sign in to call or chat with a doctor.',
    es: 'Inicie sesión para llamar o chatear con un médico.',
  );
  static const doctorLogin = L10nString(
    en: 'Doctor sign in',
    es: 'Inicio de sesión médico',
  );
  static const doctorLoginLead = L10nString(
    en: 'Demo access for OrthoExpress clinicians.',
    es: 'Acceso de demostración para clínicos de OrthoExpress.',
  );
  static const username = L10nString(en: 'Username', es: 'Usuario');
  static const password = L10nString(en: 'Password', es: 'Contraseña');
  static const signIn = L10nString(en: 'Sign in as doctor', es: 'Entrar como médico');
  static const demoHint = L10nString(
    en: 'Try dr.chen / doctor123',
    es: 'Pruebe dr.chen / doctor123',
  );
  static const invalidLogin = L10nString(
    en: 'Incorrect username or password.',
    es: 'Usuario o contraseña incorrectos.',
  );
  static const doctorInbox = L10nString(
    en: 'Doctor portal',
    es: 'Portal del médico',
  );
  static const patientMessages = L10nString(
    en: 'Patient messages',
    es: 'Mensajes de pacientes',
  );
  static const openChats = L10nString(en: 'Open chats', es: 'Chats abiertos');
  static const awaitingReply = L10nString(
    en: 'Awaiting your reply',
    es: 'Esperan su respuesta',
  );
  static const portalTip = L10nString(
    en: 'Patients reach you from Talk to a doctor after they sign in.',
    es: 'Los pacientes le contactan desde Hablar con un médico después de iniciar sesión.',
  );
  static const noConversations = L10nString(
    en: 'No patient chats yet. When a patient messages you, it will show up here.',
    es: 'Aún no hay chats. Cuando un paciente le escriba, aparecerá aquí.',
  );
  static const openChat = L10nString(en: 'Open chat', es: 'Abrir chat');
  static const typeMessage = L10nString(
    en: 'Type a message…',
    es: 'Escriba un mensaje…',
  );
  static const send = L10nString(en: 'Send', es: 'Enviar');
  static const you = L10nString(en: 'You', es: 'Usted');
  static const patient = L10nString(en: 'Patient', es: 'Paciente');
  static const doctor = L10nString(en: 'Doctor', es: 'Médico');
  static const emptyChat = L10nString(
    en: 'Send a message to start this conversation.',
    es: 'Envíe un mensaje para iniciar esta conversación.',
  );
  static const emptyChatHint = L10nString(
    en: 'Messages stay on this device for the demo.',
    es: 'Los mensajes se guardan en este dispositivo para la demo.',
  );
  static const signOutDoctor = L10nString(
    en: 'Sign out of doctor mode',
    es: 'Cerrar sesión de médico',
  );
  static const imADoctor = L10nString(
    en: "I'm a doctor",
    es: 'Soy médico',
  );
  static const today = L10nString(en: 'Today', es: 'Hoy');
  static const yesterday = L10nString(en: 'Yesterday', es: 'Ayer');
  static const conversationMissing = L10nString(
    en: 'This conversation is unavailable.',
    es: 'Esta conversación no está disponible.',
  );
  static const newFromPatient = L10nString(en: 'New', es: 'Nuevo');
  static String chatWith(String lang, String name) =>
      lang == 'es' ? 'Chat con $name' : 'Chat with $name';
  static String lastMessagePreview(String lang, String text) {
    final t = text.trim();
    if (t.isEmpty) return lang == 'es' ? 'Sin mensajes' : 'No messages yet';
    return t.length > 48 ? '${t.substring(0, 48)}…' : t;
  }
  static String openChatsCount(String lang, int n) =>
      lang == 'es' ? '$n chats' : '$n chats';
  static String awaitingCount(String lang, int n) =>
      lang == 'es' ? '$n por responder' : '$n need reply';
}

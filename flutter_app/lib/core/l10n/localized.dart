/// Bilingual string helpers — mirrors web `localize` / `localizeArray`.
class L10nString {
  final String en;
  final String es;

  const L10nString({required this.en, required this.es});

  String forLang(String lang) => lang == 'es' ? es : en;
}

class L10nList {
  final List<String> en;
  final List<String> es;

  const L10nList({required this.en, required this.es});

  List<String> forLang(String lang) => lang == 'es' ? es : en;
}

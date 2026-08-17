import '../core/l10n/localized.dart';

/// Los Angeles personal injury / accident attorneys — from src/data/lawyers.js
class LawyerListing {
  final String name;
  final L10nString focus;
  final String area;

  const LawyerListing({
    required this.name,
    required this.focus,
    required this.area,
  });
}

const laLawyers = <LawyerListing>[
  LawyerListing(
    name: 'Panish Shea Ravipudi LLP',
    focus: L10nString(
      en: 'Catastrophic injury & high-value litigation',
      es: 'Lesiones catastróficas y litigios de alto valor',
    ),
    area: 'Los Angeles, CA',
  ),
  LawyerListing(
    name: 'Greene Broillet & Wheeler, LLP',
    focus: L10nString(
      en: 'Personal injury & complex trial advocacy',
      es: 'Lesiones personales y litigio complejo',
    ),
    area: 'Los Angeles, CA',
  ),
  LawyerListing(
    name: 'The Dominguez Firm',
    focus: L10nString(
      en: 'Auto accidents & personal injury',
      es: 'Accidentes de auto y lesiones personales',
    ),
    area: 'Los Angeles, CA',
  ),
  LawyerListing(
    name: 'Wilshire Law Firm',
    focus: L10nString(
      en: 'Personal injury & accident claims',
      es: 'Lesiones personales y reclamaciones por accidentes',
    ),
    area: 'Los Angeles, CA',
  ),
  LawyerListing(
    name: 'Bisnar Chase Personal Injury Attorneys',
    focus: L10nString(
      en: 'Car accidents & serious injury cases',
      es: 'Accidentes de auto y lesiones graves',
    ),
    area: 'Los Angeles / Southern California',
  ),
  LawyerListing(
    name: 'Arash Law',
    focus: L10nString(
      en: 'Personal injury across California',
      es: 'Lesiones personales en California',
    ),
    area: 'Los Angeles, CA',
  ),
  LawyerListing(
    name: 'McNicholas & McNicholas LLP',
    focus: L10nString(
      en: 'Personal injury & wrongful death',
      es: 'Lesiones personales y muerte por negligencia',
    ),
    area: 'Los Angeles, CA',
  ),
  LawyerListing(
    name: 'Taylor & Ring',
    focus: L10nString(
      en: 'Plaintiff personal injury litigation',
      es: 'Litigio de lesiones personales',
    ),
    area: 'Los Angeles, CA',
  ),
  LawyerListing(
    name: 'Morgan & Morgan',
    focus: L10nString(
      en: 'Personal injury representation',
      es: 'Representación en lesiones personales',
    ),
    area: 'Los Angeles, CA',
  ),
  LawyerListing(
    name: 'Law Offices of John C. Ye',
    focus: L10nString(
      en: 'Injury & accident advocacy',
      es: 'Defensa en lesiones y accidentes',
    ),
    area: 'Los Angeles, CA',
  ),
  LawyerListing(
    name: 'M&Y Personal Injury Lawyers',
    focus: L10nString(
      en: 'Personal injury & accident claims',
      es: 'Lesiones personales y reclamaciones',
    ),
    area: 'Los Angeles, CA',
  ),
  LawyerListing(
    name: 'Peerali Law',
    focus: L10nString(
      en: 'Serious & catastrophic injury',
      es: 'Lesiones graves y catastróficas',
    ),
    area: 'Los Angeles, CA',
  ),
  LawyerListing(
    name: 'Steven M. Sweat, APC',
    focus: L10nString(
      en: 'Car accidents & trial-focused injury law',
      es: 'Accidentes de auto y litigio de lesiones',
    ),
    area: 'Los Angeles / Southern California',
  ),
];

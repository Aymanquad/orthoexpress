import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_config.dart';
import '../../config/theme.dart';
import '../../core/widgets/content_page_scaffold.dart';
import '../../data/clinic.dart';
import '../../data/content_repository.dart';
import '../../data/nav_labels.dart';
import '../../providers/language_provider.dart';

IconData _stepIcon(String key) {
  switch (key) {
    case 'scan':
      return Icons.image_search_outlined;
    case 'rehab':
      return Icons.accessibility_new;
    case 'work':
      return Icons.work_outline;
    case 'billing':
      return Icons.receipt_long_outlined;
    case 'video':
      return Icons.videocam_outlined;
    default:
      return Icons.assignment_outlined;
  }
}

class FaqsScreen extends StatefulWidget {
  const FaqsScreen({super.key});

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  String _specialty = 'all';

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final faqs = ContentRepository.faqs.where((f) {
      if (_specialty == 'all') return true;
      return f.specialty == _specialty;
    }).toList();

    return ContentPageScaffold(
      eyebrow: ContentRepository.label('info', 'help', lang),
      title: ContentRepository.label('info', 'faqsTitle', lang),
      lead: ContentRepository.label('info', 'faqsLead', lang),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ContentRepository.faqSpecialties.map((s) {
            final selected = s.id == _specialty;
            return ChoiceChip(
              label: Text(s.label.forLang(lang)),
              selected: selected,
              onSelected: (_) => setState(() => _specialty = s.id),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        ...faqs.map(
          (faq) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ExpansionTile(
              title: Text(faq.question.forLang(lang)),
              subtitle: Text(
                faq.category.forLang(lang),
                style: const TextStyle(color: AppColors.accent),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(faq.answer.forLang(lang)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;

    return ContentPageScaffold(
      eyebrow: ContentRepository.label('info', 'paymentEyebrow', lang),
      title: ContentRepository.label('info', 'paymentTitle', lang),
      lead: ContentRepository.label('info', 'paymentLead', lang),
      children: [
        Text(
          ContentRepository.label('info', 'insuranceHeading', lang),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(ContentRepository.label('info', 'insuranceLead', lang)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ContentRepository.insuranceProviders
              .map(
                (p) => Chip(
                  label: Text(p),
                  backgroundColor: AppColors.primarySoft,
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),
        Text(
          ContentRepository.label('info', 'selfPayHeading', lang),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(ContentRepository.label('info', 'selfPayLead', lang)),
        const SizedBox(height: 12),
        ...ContentRepository.selfPayPricing.map(
          (item) => Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              title: Text(item.name.forLang(lang)),
              subtitle: Text(item.note.forLang(lang)),
              trailing: Text(
                item.price,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CareersScreen extends StatelessWidget {
  const CareersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;

    return ContentPageScaffold(
      eyebrow: ContentRepository.label('info', 'careersEyebrow', lang),
      title: ContentRepository.label('info', 'careersTitle', lang),
      lead: ContentRepository.label('info', 'careersLead', lang),
      children: ContentRepository.careers
          .map(
            (job) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.title.forLang(lang), style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      '${job.type.forLang(lang)} · ${job.location.forLang(lang)}',
                      style: const TextStyle(color: AppColors.textLight),
                    ),
                    const SizedBox(height: 8),
                    Text(job.summary.forLang(lang)),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => context.push('/more/contact-us'),
                      style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
                      child: Text(ContentRepository.label('info', 'applyNow', lang)),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;

    return ContentPageScaffold(
      eyebrow: ContentRepository.label('info', 'newsEyebrow', lang),
      title: ContentRepository.label('info', 'newsTitle', lang),
      lead: ContentRepository.label('info', 'newsLead', lang),
      children: ContentRepository.newsItems
          .map(
            (item) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(item.title.forLang(lang)),
                subtitle: Text(
                  '${item.tag.forLang(lang)} · ${item.date}\n${item.summary.forLang(lang)}',
                ),
                isThreeLine: true,
              ),
            ),
          )
          .toList(),
    );
  }
}

class TelehealthScreen extends StatelessWidget {
  const TelehealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;

    return ContentPageScaffold(
      eyebrow: ContentRepository.patientLabel('telehealth', 'eyebrow', lang),
      title: ContentRepository.patientLabel('telehealth', 'title', lang),
      lead: ContentRepository.patientLabel('telehealth', 'lead', lang),
      children: [
        Text(
          ContentRepository.patientLabel('telehealth', 'whenHeading', lang),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        ...ContentRepository.telehealthWhen.map(
          (b) => FeatureTile(title: b.title.forLang(lang), text: b.text.forLang(lang)),
        ),
        const SizedBox(height: 8),
        Text(
          ContentRepository.patientLabel('telehealth', 'stepsHeading', lang),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        ...ContentRepository.telehealthSteps.map(
          (b) => FeatureTile(title: b.title.forLang(lang), text: b.text.forLang(lang)),
        ),
        Text(
          ContentRepository.patientLabel('telehealth', 'walkInNote', lang),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => context.push('/more/book-appointment'),
          style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
          child: Text(ContentRepository.patientLabel('telehealth', 'ctaBook', lang)),
        ),
        TextButton(
          onPressed: () => context.push('/more/after-your-visit'),
          child: Text(ContentRepository.patientLabel('telehealth', 'ctaAfterVisit', lang)),
        ),
      ],
    );
  }
}

class AfterVisitScreen extends StatelessWidget {
  const AfterVisitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;

    return ContentPageScaffold(
      eyebrow: ContentRepository.patientLabel('afterVisit', 'eyebrow', lang),
      title: ContentRepository.patientLabel('afterVisit', 'title', lang),
      lead: ContentRepository.patientLabel('afterVisit', 'lead', lang),
      children: [
        Text(
          ContentRepository.patientLabel('afterVisit', 'stepsHeading', lang),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        ...ContentRepository.afterVisitSteps.map((step) {
          return FeatureTile(
            icon: _stepIcon(step.icon),
            title: step.title.forLang(lang),
            text: step.text.forLang(lang),
            trailing: step.link == null
                ? null
                : TextButton(
                    onPressed: () => context.push(mapAppPath(step.link)),
                    child: Text(step.linkLabel.forLang(lang)),
                  ),
          );
        }),
        FilledButton(
          onPressed: () => context.push('/more/contact-us'),
          style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
          child: Text(ContentRepository.patientLabel('afterVisit', 'ctaContact', lang)),
        ),
      ],
    );
  }
}

class PatientPortalScreen extends StatelessWidget {
  const PatientPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;

    return ContentPageScaffold(
      eyebrow: ContentRepository.patientLabel('portal', 'eyebrow', lang),
      title: ContentRepository.patientLabel('portal', 'title', lang),
      lead: ContentRepository.patientLabel('portal', 'lead', lang),
      children: [
        ...ContentRepository.portalFeatures.map((f) {
          return FeatureTile(
            title: f.title.forLang(lang),
            text: f.text.forLang(lang),
            trailing: f.link == null
                ? null
                : TextButton(
                    onPressed: () async {
                      final path = f.link!;
                      if (f.internal) {
                        context.push(mapAppPath(path));
                      } else {
                        final uri = Uri.parse(path);
                        if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Text(NavLabels.open.forLang(lang)),
                  ),
          );
        }),
        if (AppConfig.hasPatientPortal) ...[
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () async {
              final uri = Uri.parse(AppConfig.patientPortalUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
            icon: const Icon(Icons.login),
            label: Text(ContentRepository.patientLabel('portal', 'signIn', lang)),
          ),
          const SizedBox(height: 8),
          Text(
            ContentRepository.patientLabel('portal', 'signInHelp', lang),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () async {
            final uri = Uri.parse(ClinicData.telLink(ClinicData.headquartersPhone));
            if (await canLaunchUrl(uri)) await launchUrl(uri);
          },
          icon: const Icon(Icons.phone),
          label: Text(ClinicData.headquartersPhone),
        ),
      ],
    );
  }
}

class TechnologyScreen extends StatelessWidget {
  const TechnologyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;

    return ContentPageScaffold(
      eyebrow: ContentRepository.patientLabel('technology', 'eyebrow', lang),
      title: ContentRepository.patientLabel('technology', 'title', lang),
      lead: ContentRepository.patientLabel('technology', 'lead', lang),
      children: [
        ...ContentRepository.technologyFeatures.map(
          (b) => FeatureTile(title: b.title.forLang(lang), text: b.text.forLang(lang)),
        ),
        const SizedBox(height: 8),
        Text(
          ContentRepository.patientLabel('technology', 'orthochatHeading', lang),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(ContentRepository.patientLabel('technology', 'orthochatLead', lang)),
        const SizedBox(height: 8),
        ...ContentRepository.orthochatFeatures.map(
          (b) => FeatureTile(title: b.title.forLang(lang), text: b.text.forLang(lang)),
        ),
      ],
    );
  }
}

class LegalScreen extends StatelessWidget {
  final LegalPageType type;

  const LegalScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;

    if (type == LegalPageType.accessibility) {
      return ContentPageScaffold(
        eyebrow: ContentRepository.label('info', 'accessibilityEyebrow', lang),
        title: ContentRepository.label('info', 'accessibilityTitle', lang),
        lead: ContentRepository.label('info', 'accessibilityLead', lang),
        children: [
          FeatureTile(
            title: ContentRepository.label('info', 'accessibilityCommitment', lang),
            text: ContentRepository.label('info', 'accessibilityLead', lang),
          ),
          FeatureTile(
            title: ContentRepository.label('info', 'accessibilityTools', lang),
            text: ContentRepository.label('info', 'accessibilityToolsText', lang),
          ),
          FeatureTile(
            title: ContentRepository.label('info', 'accessibilityContact', lang),
            text: ContentRepository.label('info', 'accessibilityContactText', lang),
          ),
        ],
      );
    }

    final isPrivacy = type == LegalPageType.privacy;
    final sections = isPrivacy
        ? const [
            ('overview', 'privacyOverview'),
            ('infoCollect', null),
            ('howWeUse', null),
            ('sharing', 'privacySharing'),
            ('dataSecurity', 'privacySecurity'),
            ('yourRights', 'privacyRights'),
            ('contact', 'privacyContact'),
          ]
        : const [
            ('acceptance', 'termsAccept'),
            ('websitePurpose', 'termsPurpose'),
            ('noEmergency', 'termsEmergency'),
            ('appointments', 'termsAppointments'),
            ('accuracy', 'termsAccuracy'),
            ('limitation', 'termsLiability'),
            ('changes', 'termsChanges'),
            ('contact', 'termsContact'),
          ];

    return ContentPageScaffold(
      title: isPrivacy
          ? NavLabels.privacyPolicy.forLang(lang)
          : NavLabels.termsOfService.forLang(lang),
      lead: ContentRepository.label(
        'legal',
        isPrivacy ? 'privacySubtitle' : 'termsSubtitle',
        lang,
      ),
      children: [
        Text(
          ContentRepository.label('legal', 'lastUpdated', lang),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: 16),
        ...sections.map((s) {
          final heading = ContentRepository.label('legal', s.$1, lang);
          final bodyKey = s.$2;
          final children = <Widget>[
            Text(heading, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
          ];
          if (bodyKey != null) {
            children.add(Text(ContentRepository.label('legal', bodyKey, lang)));
          } else if (isPrivacy && s.$1 == 'infoCollect') {
            children.add(Text(ContentRepository.label('legal', 'privacyCollectIntro', lang)));
            children.add(const SizedBox(height: 8));
            for (final i in [1, 2, 3]) {
              children.add(Text('• ${ContentRepository.label('legal', 'privacyCollect$i', lang)}'));
            }
            children.add(const SizedBox(height: 8));
            children.add(Text(ContentRepository.label('legal', 'privacyNoSensitive', lang)));
          } else if (isPrivacy && s.$1 == 'howWeUse') {
            for (final i in [1, 2, 3]) {
              children.add(Text('• ${ContentRepository.label('legal', 'privacyUse$i', lang)}'));
            }
          }
          if (s.$1 == 'contact') {
            children.add(const SizedBox(height: 8));
            children.add(Text(ContentRepository.label('legal', 'emailOrCall', lang)));
          }
          children.add(const SizedBox(height: 20));
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
        }),
      ],
    );
  }
}

enum LegalPageType { privacy, terms, accessibility }

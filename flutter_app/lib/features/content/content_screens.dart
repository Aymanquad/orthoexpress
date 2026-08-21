import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../core/widgets/content_page_scaffold.dart';
import '../../data/content_repository.dart';
import '../../data/nav_labels.dart';
import '../../data/portal_labels.dart';
import '../../providers/language_provider.dart';
import '../../providers/portal_auth_provider.dart';

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
            return FilterChip(
              selected: selected,
              showCheckmark: false,
              label: Text(s.label.forLang(lang)),
              selectedColor: AppColors.primarySoft,
              labelStyle: TextStyle(
                color: selected ? AppColors.primary : AppColors.textDark,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13,
              ),
              side: BorderSide(
                color: selected
                    ? AppColors.primary.withValues(alpha: 0.25)
                    : AppColors.border,
              ),
              onSelected: (_) => setState(() => _specialty = s.id),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        ...faqs.map(
          (faq) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.bgWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                title: Text(
                  faq.question.forLang(lang),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    faq.category.forLang(lang),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      faq.answer.forLang(lang),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textLight,
                            height: 1.45,
                          ),
                    ),
                  ),
                ],
              ),
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
        ContentSectionTitle(ContentRepository.label('info', 'insuranceHeading', lang)),
        Text(
          ContentRepository.label('info', 'insuranceLead', lang),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textLight,
                height: 1.45,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ContentRepository.insuranceProviders
              .map(
                (p) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    p,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 22),
        ContentSectionTitle(ContentRepository.label('info', 'selfPayHeading', lang)),
        Text(
          ContentRepository.label('info', 'selfPayLead', lang),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textLight,
                height: 1.45,
              ),
        ),
        const SizedBox(height: 12),
        ...ContentRepository.selfPayPricing.map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: AppColors.bgWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name.forLang(lang), style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 2),
                      Text(
                        item.note.forLang(lang),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textLight,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  item.price,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
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
        ContentSectionTitle(ContentRepository.patientLabel('telehealth', 'whenHeading', lang)),
        ...ContentRepository.telehealthWhen.map(
          (b) => FeatureTile(
            icon: Icons.check_circle_outline,
            title: b.title.forLang(lang),
            text: b.text.forLang(lang),
          ),
        ),
        const SizedBox(height: 8),
        ContentSectionTitle(ContentRepository.patientLabel('telehealth', 'stepsHeading', lang)),
        ...ContentRepository.telehealthSteps.map(
          (b) => FeatureTile(
            icon: Icons.playlist_add_check_circle_outlined,
            title: b.title.forLang(lang),
            text: b.text.forLang(lang),
          ),
        ),
        Text(
          ContentRepository.patientLabel('telehealth', 'walkInNote', lang),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
        ),
        ContentCtaRow(
          primaryLabel: ContentRepository.patientLabel('telehealth', 'ctaBook', lang),
          onPrimary: () => context.push('/more/book-appointment'),
          secondaryLabel: ContentRepository.patientLabel('telehealth', 'ctaAfterVisit', lang),
          onSecondary: () => context.push('/more/after-your-visit'),
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
        ContentSectionTitle(ContentRepository.patientLabel('afterVisit', 'stepsHeading', lang)),
        ...ContentRepository.afterVisitSteps.map((step) {
          return FeatureTile(
            icon: _stepIcon(step.icon),
            title: step.title.forLang(lang),
            text: step.text.forLang(lang),
            trailing: step.link == null
                ? null
                : Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => context.push(mapAppPath(step.link)),
                      child: Text(step.linkLabel.forLang(lang)),
                    ),
                  ),
          );
        }),
        ContentCtaRow(
          primaryLabel: ContentRepository.patientLabel('afterVisit', 'ctaContact', lang),
          onPrimary: () => context.push('/more/contact-us'),
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
    final signedIn = context.watch<PortalAuthProvider>().isAuthenticated;

    if (signedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/more/portal');
      });
      return ContentPageScaffold(
        title: PortalLabels.dashboardTitle.forLang(lang),
        children: const [
          Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator())),
        ],
      );
    }

    return ContentPageScaffold(
      eyebrow: ContentRepository.patientLabel('portal', 'eyebrow', lang),
      title: ContentRepository.patientLabel('portal', 'title', lang),
      lead: ContentRepository.patientLabel('portal', 'signInHelp', lang),
      children: [
        Card(
          color: AppColors.primarySoft,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton.icon(
                  onPressed: () => context.push('/more/portal/login'),
                  style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
                  icon: const Icon(Icons.login),
                  label: Text(PortalLabels.signInWithPhone.forLang(lang)),
                ),
                const SizedBox(height: 8),
                Text(
                  ContentRepository.patientLabel('portal', 'demoNote', lang),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textLight,
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          ContentRepository.patientLabel('portal', 'featuresHeading', lang),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ...ContentRepository.portalFeatures.take(3).map(
              (f) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.check_circle_outline, color: AppColors.accent),
                title: Text(f.title.forLang(lang)),
                subtitle: Text(f.text.forLang(lang)),
              ),
            ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton(
              onPressed: () => context.push('/more/book-appointment'),
              child: Text(NavLabels.bookAppointmentShort.forLang(lang)),
            ),
            OutlinedButton(
              onPressed: () => context.push('/more/contact-us'),
              child: Text(NavLabels.contact.forLang(lang)),
            ),
          ],
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
          (b) => FeatureTile(
            icon: Icons.memory_outlined,
            title: b.title.forLang(lang),
            text: b.text.forLang(lang),
          ),
        ),
        const SizedBox(height: 8),
        ContentSectionTitle(ContentRepository.patientLabel('technology', 'orthochatHeading', lang)),
        Text(
          ContentRepository.patientLabel('technology', 'orthochatLead', lang),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textLight,
                height: 1.45,
              ),
        ),
        const SizedBox(height: 12),
        ...ContentRepository.orthochatFeatures.map(
          (b) => FeatureTile(
            icon: Icons.chat_bubble_outline_rounded,
            title: b.title.forLang(lang),
            text: b.text.forLang(lang),
          ),
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
            icon: Icons.favorite_border_rounded,
            title: ContentRepository.label('info', 'accessibilityCommitment', lang),
            text: ContentRepository.label('info', 'accessibilityLead', lang),
          ),
          FeatureTile(
            icon: Icons.tune_rounded,
            title: ContentRepository.label('info', 'accessibilityTools', lang),
            text: ContentRepository.label('info', 'accessibilityToolsText', lang),
          ),
          FeatureTile(
            icon: Icons.support_agent_outlined,
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../core/widgets/asset_image.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/clinic.dart';
import '../../data/locations.dart';
import '../../data/page_labels.dart';
import '../../providers/language_provider.dart';

class LocationsScreen extends StatelessWidget {
  const LocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;

    return ResponsiveScrollPage(
      onRefresh: () async {
        await Future<void>.delayed(const Duration(milliseconds: 400));
      },
      children: [
        Text(
          LocationsLabels.label.forLang(lang),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
              ),
        ),
        const SizedBox(height: 8),
        Text(LocationsLabels.title.forLang(lang), style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 20),
        ResponsiveCardGrid(
          itemCount: locations.length,
          itemBuilder: (context, i) => _LocationCard(location: locations[i], lang: lang),
        ),
        const SizedBox(height: 12),
        Card(
          color: AppColors.primarySoft,
          child: ListTile(
            leading: const Icon(Icons.phone, color: AppColors.primary),
            title: Text(
              '${LocationsLabels.headquarters.forLang(lang)} — ${ClinicData.headquartersLabel}',
            ),
            subtitle: Text(ClinicData.headquartersPhone),
            onTap: () async {
              final uri = Uri.parse(ClinicData.telLink(ClinicData.headquartersPhone));
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            },
          ),
        ),
      ],
    );
  }
}

class _LocationCard extends StatelessWidget {
  final LocationItem location;
  final String lang;

  const _LocationCard({required this.location, required this.lang});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => context.push('/locations/${location.slug}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AssetImageWithFallback(
              assetPath: location.imagePath,
              height: 140,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(location.address, style: Theme.of(context).textTheme.bodyMedium),
                  Text(location.city, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined, size: 16, color: AppColors.textLight),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          location.phone,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.schedule, size: 16, color: AppColors.textLight),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          location.hours,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () async {
                      final uri = Uri.parse(
                        ClinicData.mapsSearchUrl('${location.address}, ${location.city}'),
                      );
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                    icon: const Icon(Icons.directions_outlined, size: 18),
                    label: Text(LocationsLabels.directions.forLang(lang)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

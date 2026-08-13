import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../core/widgets/asset_image.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/clinic.dart';
import '../../data/locations.dart';

class LocationsScreen extends StatelessWidget {
  const LocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScrollPage(
      children: [
        Text('Our Locations', style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 8),
        Text(
          'Find an OrthoExpress center near you.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        ResponsiveCardGrid(
          itemCount: locations.length,
          itemBuilder: (context, i) => _LocationCard(location: locations[i]),
        ),
        const SizedBox(height: 12),
        Card(
          color: AppColors.primarySoft,
          child: ListTile(
            leading: const Icon(Icons.phone, color: AppColors.primary),
            title: Text('Headquarters — ${ClinicData.headquartersLabel}'),
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

  const _LocationCard({required this.location});

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
                  Text(location.city, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: location.features
                        .map((f) => Chip(
                              label: Text(
                                f,
                                style: const TextStyle(fontSize: 11),
                                overflow: TextOverflow.ellipsis,
                              ),
                              visualDensity: VisualDensity.compact,
                            ))
                        .toList(),
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

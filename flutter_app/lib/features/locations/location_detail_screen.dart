import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/asset_image.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/clinic.dart';
import '../../data/locations.dart';

class LocationDetailScreen extends StatelessWidget {
  final String slug;

  const LocationDetailScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final location = getLocationBySlug(slug);
    if (location == null) {
      return const Center(child: Text('Location not found'));
    }

    final heroHeight = context.isTablet ? 280.0 : 200.0;
    final useHorizontalActions = context.isTablet;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AssetImageWithFallback(
            assetPath: location.imagePath,
            height: heroHeight,
            fit: BoxFit.cover,
          ),
          ResponsivePage(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(location.name, style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 8),
                Text(location.address, style: Theme.of(context).textTheme.bodyLarge),
                Text(location.city, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Text(location.hours, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 20),
                Text('Specialties', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                ...location.features.map(
                  (f) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.check, color: AppColors.accent, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(f)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (useHorizontalActions)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final uri = Uri.parse(ClinicData.telLink(location.phone));
                            if (await canLaunchUrl(uri)) await launchUrl(uri);
                          },
                          icon: const Icon(Icons.phone),
                          label: const Text('Call'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => context.push('/more/book-appointment'),
                          style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
                          icon: const Icon(Icons.calendar_month),
                          label: const Text('Book'),
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () async {
                          final uri = Uri.parse(ClinicData.telLink(location.phone));
                          if (await canLaunchUrl(uri)) await launchUrl(uri);
                        },
                        icon: const Icon(Icons.phone),
                        label: const Text('Call'),
                      ),
                      const SizedBox(height: 10),
                      FilledButton.icon(
                        onPressed: () => context.push('/more/book-appointment'),
                        style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
                        icon: const Icon(Icons.calendar_month),
                        label: const Text('Book Appointment'),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

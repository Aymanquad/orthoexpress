import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../core/widgets/responsive_page.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScrollPage(
      children: [
        Text('More', style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 20),
        _Section(
          title: 'Patient care',
          items: [
            _LinkItem('Telehealth', '/more/telehealth'),
            _LinkItem('After Your Visit', '/more/after-your-visit'),
            _LinkItem('Patient Portal', '/more/patient-portal'),
            _LinkItem('Technology', '/more/technology'),
          ],
        ),
        _Section(
          title: 'Company',
          items: [
            _LinkItem('About Us', '/more/about'),
            _LinkItem('Workers Comp', '/more/workers-comp'),
            _LinkItem('Careers', '/more/careers'),
            _LinkItem('News', '/more/news'),
          ],
        ),
        _Section(
          title: 'Resources',
          items: [
            _LinkItem('Blogs', '/more/blogs'),
            _LinkItem('FAQs', '/more/faqs'),
            _LinkItem('Payment & Insurance', '/more/payment'),
            _LinkItem('Contact Us', '/more/contact-us'),
            _LinkItem('Book Appointment', '/more/book-appointment'),
          ],
        ),
        _Section(
          title: 'Legal',
          items: [
            _LinkItem('Privacy Policy', '/more/privacy-policy'),
            _LinkItem('Terms of Service', '/more/terms'),
            _LinkItem('Accessibility', '/more/accessibility'),
          ],
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<_LinkItem> items;

  const _Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: items.map((item) {
              return ListTile(
                title: Text(
                  item.label,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                onTap: () => context.push(item.path),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _LinkItem {
  final String label;
  final String path;

  const _LinkItem(this.label, this.path);
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../config/theme.dart';
import '../../core/widgets/asset_image.dart';
import '../../core/widgets/content_page_scaffold.dart';
import '../../core/widgets/html_content.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/content_repository.dart';
import '../../features/shared/not_found_screen.dart';
import '../../data/nav_labels.dart';
import '../../providers/language_provider.dart';

class BlogsScreen extends StatelessWidget {
  const BlogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final blogs = ContentRepository.blogs;

    return ContentPageScaffold(
      title: ContentRepository.label('blogs', 'title', lang),
      lead: ContentRepository.label('blogs', 'subtitle', lang),
      onRefresh: refreshContent,
      children: blogs
          .map(
            (blog) => Card(
              margin: const EdgeInsets.only(bottom: 16),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => context.push('/more/blogs/${blog.slug}'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AssetImageWithFallback(
                      assetPath: blog.imagePath,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${blog.category.forLang(lang)} · ${blog.date.forLang(lang)}',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            blog.title.forLang(lang),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            blog.excerpt.forLang(lang),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textLight,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            ContentRepository.label('blogs', 'readMore', lang),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
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

class BlogDetailScreen extends StatelessWidget {
  final String slug;

  const BlogDetailScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final blog = ContentRepository.blogBySlug(slug);

    if (blog == null) {
      return const NotFoundScreen();
    }

    final title = blog.title.forLang(lang);
    final excerpt = blog.excerpt.forLang(lang);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AssetImageWithFallback(
            assetPath: blog.imagePath,
            height: 200,
            fit: BoxFit.cover,
          ),
          ResponsivePage(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    tooltip: NavLabels.share.forLang(lang),
                    onPressed: () => SharePlus.instance.share(
                      ShareParams(
                        text: '$title\n\n$excerpt',
                        subject: title,
                      ),
                    ),
                    icon: const Icon(Icons.share_outlined),
                  ),
                ),
                Text(
                  '${blog.category.forLang(lang)} · ${blog.date.forLang(lang)}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  blog.title.forLang(lang),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 16),
                HtmlContent(html: blog.content.forLang(lang)),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

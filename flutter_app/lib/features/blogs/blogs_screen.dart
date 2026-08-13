import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../core/widgets/asset_image.dart';
import '../../core/widgets/content_page_scaffold.dart';
import '../../core/widgets/html_content.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/content_repository.dart';
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
      return Center(
        child: Text(lang == 'es' ? 'Artículo no encontrado' : 'Article not found'),
      );
    }

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
                TextButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: Text(ContentRepository.label('blogs', 'backToBlogs', lang)),
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

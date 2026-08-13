import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Lightweight HTML renderer for blog content (`p`, `h3`, `ul`, `li`, `strong`).
class HtmlContent extends StatelessWidget {
  final String html;
  final TextStyle? bodyStyle;

  const HtmlContent({super.key, required this.html, this.bodyStyle});

  @override
  Widget build(BuildContext context) {
    final base = bodyStyle ?? Theme.of(context).textTheme.bodyLarge;
    final blocks = _parseBlocks(html);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks.map((b) {
        switch (b.type) {
          case _BlockType.h3:
            return Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text(
                b.text,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                    ),
              ),
            );
          case _BlockType.ul:
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: b.items
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('•  ', style: base),
                            Expanded(child: Text.rich(_span(item, base!))),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          case _BlockType.p:
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text.rich(_span(b.text, base!)),
            );
        }
      }).toList(),
    );
  }

  TextSpan _span(String raw, TextStyle style) {
    final parts = <InlineSpan>[];
    final re = RegExp(r'<strong>(.*?)</strong>', caseSensitive: false, dotAll: true);
    var last = 0;
    for (final m in re.allMatches(raw)) {
      if (m.start > last) {
        parts.add(TextSpan(text: _strip(raw.substring(last, m.start))));
      }
      parts.add(TextSpan(
        text: _strip(m.group(1) ?? ''),
        style: style.copyWith(fontWeight: FontWeight.w700),
      ));
      last = m.end;
    }
    if (last < raw.length) {
      parts.add(TextSpan(text: _strip(raw.substring(last))));
    }
    return TextSpan(style: style, children: parts);
  }

  String _strip(String s) => s
      .replaceAll(RegExp(r'<[^>]+>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .trim();
}

enum _BlockType { p, h3, ul }

class _Block {
  final _BlockType type;
  final String text;
  final List<String> items;

  _Block.p(this.text)
      : type = _BlockType.p,
        items = const [];
  _Block.h3(this.text)
      : type = _BlockType.h3,
        items = const [];
  _Block.ul(this.items)
      : type = _BlockType.ul,
        text = '';
}

List<_Block> _parseBlocks(String html) {
  final cleaned = html.replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  final blocks = <_Block>[];
  final re = RegExp(
    r'<(p|h3|ul)[^>]*>(.*?)</\1>',
    caseSensitive: false,
    dotAll: true,
  );
  for (final m in re.allMatches(cleaned)) {
    final tag = (m.group(1) ?? 'p').toLowerCase();
    final inner = m.group(2) ?? '';
    if (tag == 'h3') {
      blocks.add(_Block.h3(inner.replaceAll(RegExp(r'<[^>]+>'), '').trim()));
    } else if (tag == 'ul') {
      final items = RegExp(r'<li[^>]*>(.*?)</li>', caseSensitive: false, dotAll: true)
          .allMatches(inner)
          .map((li) => li.group(1) ?? '')
          .toList();
      blocks.add(_Block.ul(items));
    } else {
      blocks.add(_Block.p(inner));
    }
  }
  if (blocks.isEmpty && cleaned.isNotEmpty) {
    blocks.add(_Block.p(cleaned));
  }
  return blocks;
}

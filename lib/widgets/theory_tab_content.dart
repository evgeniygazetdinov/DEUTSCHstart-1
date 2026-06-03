import 'package:flutter/material.dart';

import '../data/theory_section.dart';
import '../l10n/app_locale_scope.dart';

/// Вкладка «Теория»: заголовок, вступление и раскрывающиеся секции.
class TheoryTabContent extends StatelessWidget {
  const TheoryTabContent({
    super.key,
    required this.headline,
    required this.intro,
    required this.sections,
  });

  final String headline;
  final String intro;
  final List<TheorySection> sections;

  @override
  Widget build(BuildContext context) {
    final lang = context.localeController.language;
    final scheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Text(
          headline,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          intro,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 16),
        for (final sec in sections)
          Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ExpansionTile(
              initiallyExpanded: sec.title(lang).startsWith('1.'),
              title: Text(
                sec.title(lang),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: SelectableText(
                      sec.body(lang),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.45,
                            fontFamily: 'monospace',
                            fontFamilyFallback: const ['monospace'],
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

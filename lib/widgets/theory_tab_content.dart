import 'package:flutter/material.dart';

import '../data/theory_section.dart';
import '../l10n/app_locale_scope.dart';
import '../theme/apple_theme.dart';

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

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        Text(
          headline,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          intro,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppleTheme.secondaryLabel,
              ),
        ),
        const SizedBox(height: 20),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppleTheme.cornerRadius),
          child: Material(
            color: AppleTheme.secondaryGrouped,
            child: Column(
              children: [
                for (var i = 0; i < sections.length; i++) ...[
                  if (i > 0) const Divider(height: 0.5, thickness: 0.5),
                  Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      childrenPadding: EdgeInsets.zero,
                      initiallyExpanded:
                          sections[i].title(lang).startsWith('1.'),
                      title: Text(
                        sections[i].title(lang),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SelectableText(
                              sections[i].body(lang),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    height: 1.45,
                                    fontFamily: 'monospace',
                                    fontFamilyFallback: const ['monospace'],
                                    color: AppleTheme.secondaryLabel,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

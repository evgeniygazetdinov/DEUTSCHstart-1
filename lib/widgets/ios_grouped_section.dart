import 'package:flutter/material.dart';

import '../theme/apple_theme.dart';

/// Секция списка в стиле iOS Settings (белый блок на сером фоне).
class IosGroupedSection extends StatelessWidget {
  const IosGroupedSection({
    super.key,
    this.header,
    this.footer,
    required this.children,
  });

  final String? header;
  final String? footer;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final visible = children.where((c) => c is! SizedBox).toList();
    if (visible.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                header!.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.08,
                      color: AppleTheme.secondaryLabel,
                    ),
              ),
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppleTheme.cornerRadius),
            child: Material(
              color: AppleTheme.secondaryGrouped,
              child: Column(
                children: _withDividers(visible),
              ),
            ),
          ),
          if (footer != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Text(
                footer!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppleTheme.secondaryLabel,
                      height: 1.35,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _withDividers(List<Widget> items) {
    final out = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      out.add(items[i]);
      if (i < items.length - 1) {
        out.add(const Divider(height: 0.5, thickness: 0.5));
      }
    }
    return out;
  }
}

/// Строка меню в стиле iOS.
class IosListRow extends StatelessWidget {
  const IosListRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.iconColor,
    this.iconBackground,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? iconBackground;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: AppleTheme.secondaryGrouped,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: iconBackground ?? AppleTheme.blue,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: iconColor ?? Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                              color: AppleTheme.secondaryLabel,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: AppleTheme.tertiaryLabel.withValues(alpha: 0.9),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../services/grammar_stats_service.dart';
import '../theme/apple_theme.dart';

/// Зелёная полоска прогресса (только если есть ответы).
class ModuleStatsBar extends StatelessWidget {
  const ModuleStatsBar({
    super.key,
    required this.stats,
    required this.answersLabel,
    this.label,
  });

  final GrammarModuleStats stats;
  final String answersLabel;

  /// Подпись слева над полоской (например, название темы в миксе).
  final String? label;

  @override
  Widget build(BuildContext context) {
    if (stats.total == 0) return const SizedBox.shrink();

    final acc = stats.accuracy.clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Text(
              label!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppleTheme.primaryLabel,
                  ),
            ),
            const SizedBox(height: 4),
          ],
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: acc,
              minHeight: 5,
              backgroundColor: const Color(0xFFE5E5EA),
              color: AppleTheme.green,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            answersLabel,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppleTheme.secondaryLabel,
                  fontSize: 12,
                ),
          ),
        ],
      ),
    );
  }
}

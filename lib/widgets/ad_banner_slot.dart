import 'package:flutter/material.dart';

/// Placeholder slot for the bottom banner ad.
/// Will be replaced with actual AdMob banner in Phase 7.
class AdBannerSlot extends StatelessWidget {
  const AdBannerSlot({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Fixed height as specified in the plan (50px)
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Center(
        child: Text(
          'Ad Space',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
      ),
    );
  }
}

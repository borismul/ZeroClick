import 'package:flutter/material.dart';

/// Data class for feature items in onboarding
class FeatureItem {
  const FeatureItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String description;
}

/// A card widget that displays a setup step with icon, title, description,
/// and optional action button for onboarding flows.
class SetupStepCard extends StatelessWidget {
  const SetupStepCard({
    required this.stepNumber,
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    super.key,
    this.buttonText,
    this.onPressed,
    this.isOptional = false,
  });

  final String stepNumber;
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final String? buttonText;
  final VoidCallback? onPressed;
  final bool isOptional;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Step number circle
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    stepNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              // Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isOptional) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Optioneel',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Description
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          // Action button if provided
          if (buttonText != null && onPressed != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: Text(buttonText!),
                style: OutlinedButton.styleFrom(
                  foregroundColor: color,
                  side: BorderSide(color: color),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

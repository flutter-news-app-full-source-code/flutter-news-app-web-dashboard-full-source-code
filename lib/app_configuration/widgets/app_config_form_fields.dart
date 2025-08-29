import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template app_config_int_field}
/// A reusable widget for integer input fields in the application configuration.
/// {@endtemplate}
class AppConfigIntField extends StatelessWidget {
  /// {@macro app_config_int_field}
  const AppConfigIntField({
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
    this.controller,
    super.key,
  });

  /// The label text for the input field.
  final String label;

  /// A descriptive text providing more context for the field.
  final String description;

  /// The current integer value of the field.
  final int value;

  /// Callback function when the value of the field changes.
  final ValueChanged<int> onChanged;

  /// Optional text editing controller for more control.
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Ensure alignment to start
        children: [
          Text(label, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.start, // Ensure text aligns to start
          ),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            controller: controller,
            initialValue: controller == null ? value.toString() : null,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (text) {
              final parsedValue = int.tryParse(text);
              if (parsedValue != null) {
                onChanged(parsedValue);
              }
            },
          ),
        ],
      ),
    );
  }
}

/// {@template app_config_text_field}
/// A reusable widget for general text input fields in the application configuration.
/// {@endtemplate}
class AppConfigTextField extends StatelessWidget {
  /// {@macro app_config_text_field}
  const AppConfigTextField({
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
    this.controller,
    super.key,
  });

  /// The label text for the input field.
  final String label;

  /// A descriptive text providing more context for the field.
  final String description;

  /// The current string value of the field.
  final String? value;

  /// Callback function when the value of the field changes.
  final ValueChanged<String?> onChanged;

  /// Optional text editing controller for more control.
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Ensure alignment to start
        children: [
          Text(label, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.start, // Ensure text aligns to start
          ),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            controller: controller,
            initialValue: controller == null ? value : null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

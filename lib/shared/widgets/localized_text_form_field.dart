import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/supported_language_l10n.dart';

/// {@template localized_text_form_field}
/// A form field for entering text in a specific language, designed to be used
/// within a form that manages multiple languages via a shared `TabController`.
///
/// This widget displays a single [TextFormField] for the [selectedLanguage]
/// and calls back with the updated map of all language values.
/// {@endtemplate}
class LocalizedTextFormField extends StatefulWidget {
  /// {@macro localized_text_form_field}
  const LocalizedTextFormField({
    required this.label,
    required this.values,
    required this.onChanged,
    required this.enabledLanguages,
    required this.selectedLanguage,
    this.readOnly = false,
    this.validator,
    super.key,
  });

  /// The label text for the input field.
  final String label;

  /// The current map of values, keyed by [SupportedLanguage].
  final Map<SupportedLanguage, String> values;

  /// Callback when a value for a specific language changes.
  final void Function(Map<SupportedLanguage, String> values) onChanged;

  /// The list of languages to display tabs for.
  final List<SupportedLanguage> enabledLanguages;

  /// The currently selected language to display the text field for.
  final SupportedLanguage selectedLanguage;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Optional validator function.
  /// It receives the *entire map* of values to allow for cross-language validation
  /// (e.g., "English is required").
  final String? Function(Map<SupportedLanguage, String>? value)? validator;

  @override
  State<LocalizedTextFormField> createState() => _LocalizedTextFormFieldState();
}

class _LocalizedTextFormFieldState extends State<LocalizedTextFormField> {
  // A single controller for the currently visible text field.
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.values[widget.selectedLanguage] ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant LocalizedTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the selected language changes, or if the value for the current
    // language is updated from an external source (like BLoC state change),
    // update the controller's text.
    if (widget.selectedLanguage != oldWidget.selectedLanguage ||
        widget.values[widget.selectedLanguage] != _controller.text) {
      final newText = widget.values[widget.selectedLanguage] ?? '';
      _controller.text = newText;
      // Move cursor to the end.
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: newText.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        labelText: '${widget.label} (${widget.selectedLanguage.l10n(context)})',
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: null, // Allow multiline for descriptions
      onChanged: (value) {
        final newValues = Map<SupportedLanguage, String>.from(
          widget.values,
        );
        if (value.isEmpty) {
          newValues.remove(widget.selectedLanguage);
        } else {
          newValues[widget.selectedLanguage] = value;
        }
        widget.onChanged(newValues);
      },
      // The FormField's validator is called on the parent Form, so we can
      // still validate the entire map of values even though we only see one
      // field at a time.
      validator: (_) {
        if (widget.validator != null) {
          return widget.validator!(widget.values);
        }
        return null;
      },
    );
  }
}

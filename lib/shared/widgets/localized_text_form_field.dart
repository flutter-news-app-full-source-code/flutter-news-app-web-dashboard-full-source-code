import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/supported_language_l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template localized_text_form_field}
/// A form field that provides a tabbed interface for entering text in multiple
/// languages.
///
/// It displays a [TabBar] with the [enabledLanguages] and a [TextFormField]
/// for the currently selected language.
/// {@endtemplate}
class LocalizedTextFormField extends StatefulWidget {
  /// {@macro localized_text_form_field}
  const LocalizedTextFormField({
    required this.label,
    required this.values,
    required this.onChanged,
    required this.enabledLanguages,
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

  /// Whether the field is read-only.
  final bool readOnly;

  /// Optional validator function.
  /// It receives the *entire map* of values to allow for cross-language validation
  /// (e.g., "English is required").
  final String? Function(Map<SupportedLanguage, String>? value)? validator;

  @override
  State<LocalizedTextFormField> createState() => _LocalizedTextFormFieldState();
}

class _LocalizedTextFormFieldState extends State<LocalizedTextFormField>
    with TickerProviderStateMixin {
  late TabController _tabController;
  // We keep a local map of controllers to preserve cursor position when switching tabs.
  final Map<SupportedLanguage, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.enabledLanguages.length,
      vsync: this,
    );
    _tabController.addListener(_handleTabSelection);
    _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant LocalizedTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabledLanguages != oldWidget.enabledLanguages) {
      _tabController
        ..removeListener(_handleTabSelection)
        ..dispose();
      _tabController = TabController(
        length: widget.enabledLanguages.length,
        vsync: this,
      );
      _tabController.addListener(_handleTabSelection);
    }
    _updateControllers();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  void _initializeControllers() {
    for (final lang in widget.enabledLanguages) {
      _controllers[lang] = TextEditingController(
        text: widget.values[lang] ?? '',
      );
    }
  }

  void _updateControllers() {
    for (final lang in widget.enabledLanguages) {
      final text = widget.values[lang] ?? '';
      final controller = _controllers.putIfAbsent(
        lang,
        TextEditingController.new,
      );
      if (controller.text != text) {
        controller
          ..text = text
          // Preserve cursor at end if possible, or reset if text changed drastically
          ..selection = TextSelection.collapsed(offset: text.length);
      }
    }
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_handleTabSelection)
      ..dispose();
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Ensure we have at least one language to prevent errors
    if (widget.enabledLanguages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Custom TabBar looking like a segmented control or simple tabs
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outlineVariant,
              ),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: widget.enabledLanguages.map((lang) {
              return Tab(
                text: lang.l10n(context),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        // We use an IndexedStack or just build the current field to maintain state
        // But since we are syncing with parent state, building just the active one is fine.
        Builder(
          builder: (context) {
            final currentLang = widget.enabledLanguages[_tabController.index];
            final controller = _controllers[currentLang]!;

            return TextFormField(
              controller: controller,
              readOnly: widget.readOnly,
              decoration: InputDecoration(
                labelText: '${widget.label} (${currentLang.l10n(context)})',
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: null, // Allow multiline for descriptions
              onChanged: (value) {
                final newValues = Map<SupportedLanguage, String>.from(
                  widget.values,
                );
                if (value.isEmpty) {
                  newValues.remove(currentLang);
                } else {
                  newValues[currentLang] = value;
                }
                widget.onChanged(newValues);
              },
              validator: (_) {
                // We delegate validation to the parent widget's validator
                // which checks the whole map.
                if (widget.validator != null) {
                  return widget.validator!(widget.values);
                }
                return null;
              },
            );
          },
        ),
      ],
    );
  }
}

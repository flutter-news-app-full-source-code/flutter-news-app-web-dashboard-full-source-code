import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app/bloc/app_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/edit_source/edit_source_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/extensions.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/image_upload_field.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/localized_text_form_field.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/searchable_selection_input.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:core_ui/core_ui.dart';

/// {@template edit_source_page}
/// A page for editing an existing source.
/// It uses a [BlocProvider] to create and provide an [EditSourceBloc].
/// {@endtemplate}
class EditSourcePage extends StatelessWidget {
  /// {@macro edit_source_page}
  const EditSourcePage({required this.sourceId, super.key});

  /// The ID of the source to be edited.
  final String sourceId;

  @override
  Widget build(BuildContext context) {
    final localizationConfig = context
        .read<AppBloc>()
        .state
        .remoteConfig
        ?.app
        .localization;

    return BlocProvider(
      create: (context) =>
          EditSourceBloc(
            sourcesRepository: context.read<DataRepository<Source>>(),
            languagesRepository: context.read<DataRepository<Language>>(),
            mediaRepository: context.read<MediaRepository>(),
            sourceId: sourceId,
            logger: Logger('EditSourceBloc'),
          )..add(
            EditSourceLoaded(
              enabledLanguages:
                  localizationConfig?.enabledLanguages ??
                  [SupportedLanguage.en],
              defaultLanguage:
                  localizationConfig?.defaultLanguage ?? SupportedLanguage.en,
            ),
          ),
      child: const EditSourceView(),
    );
  }
}

class EditSourceView extends StatefulWidget {
  const EditSourceView({super.key});

  @override
  State<EditSourceView> createState() => _EditSourceViewState();
}

class _EditSourceViewState extends State<EditSourceView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    final state = context.read<EditSourceBloc>().state;
    _urlController = TextEditingController(text: state.url);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  /// Shows a dialog to the user to choose between publishing or saving as draft.
  Future<ContentStatus?> _showSaveOptionsDialog(BuildContext context) async {
    final l10n = AppLocalizationsX(context).l10n;
    return showDialog<ContentStatus>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.updateSourceTitle),
        content: Text(l10n.updateSourceMessage), // Corrected l10n key
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(ContentStatus.draft),
            child: Text(l10n.saveAsDraft),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(ContentStatus.active),
            child: Text(l10n.publish),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final appState = context.read<AppBloc>().state;
    final userLanguage =
        appState.appSettings?.language ??
        appState.remoteConfig?.app.localization.defaultLanguage ??
        SupportedLanguage.en;
    final langCode = userLanguage.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editSource),
        actions: [
          BlocBuilder<EditSourceBloc, EditSourceState>(
            builder: (context, state) {
              if (state.status == EditSourceStatus.imageUploading ||
                  state.status == EditSourceStatus.entitySubmitting) {
                return const Padding(
                  padding: EdgeInsets.only(right: AppSpacing.lg),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                );
              }
              // The save button is enabled only if the form is valid.
              return IconButton(
                icon: const Icon(Icons.save),
                tooltip: l10n.saveChanges,
                onPressed: state.isFormValid
                    ? () => _handleSave(context)
                    : null,
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<EditSourceBloc, EditSourceState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == EditSourceStatus.success &&
              state.updatedSource != null &&
              ModalRoute.of(context)!.isCurrent) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(l10n.sourceUpdatedSuccessfully)),
              );
            context.pop();
          }
          if (state.status == EditSourceStatus.imageUploadFailure ||
              state.status == EditSourceStatus.entitySubmitFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.exception!.toFriendlyMessage(context)),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
          }
          // Update text controllers when data is loaded or changed
          if (state.status == EditSourceStatus.initial) {
            _urlController.text = state.url;
          }
        },
        builder: (context, state) {
          if (state.status == EditSourceStatus.loading) {
            return LoadingStateWidget(
              icon: Icons.source,
              headline: l10n.loadingSources,
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.status == EditSourceStatus.failure &&
              (state.name[SupportedLanguage.en]?.isEmpty ?? true)) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () => context.read<EditSourceBloc>().add(
                EditSourceLoaded(
                  enabledLanguages: state.enabledLanguages,
                  defaultLanguage: state.defaultLanguage,
                ),
              ),
            );
          }

          return DefaultTabController(
            length: state.enabledLanguages.length,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        onTap: (index) => context.read<EditSourceBloc>().add(
                          EditSourceLanguageTabChanged(
                            state.enabledLanguages[index],
                          ),
                        ),
                        tabs: state.enabledLanguages.map((lang) {
                          return Tab(
                            icon: Image.network(
                              lang.flagUrl,
                              width: 24,
                              errorBuilder: (_, _, _) =>
                                  const Icon(Icons.flag, size: 16),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      LocalizedTextFormField(
                        label: l10n.sourceName,
                        values: state.name,
                        enabledLanguages: state.enabledLanguages,
                        selectedLanguage: state.selectedLanguage,
                        onChanged: (values) =>
                            context.read<EditSourceBloc>().add(
                              EditSourceNameChanged(values),
                            ),
                        validator: (values) {
                          if (values?[state.defaultLanguage]?.isEmpty ?? true) {
                            return l10n.defaultLanguageRequired(
                              state.defaultLanguage.name.toUpperCase(),
                            );
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      LocalizedTextFormField(
                        label: l10n.description,
                        values: state.description,
                        enabledLanguages: state.enabledLanguages,
                        selectedLanguage: state.selectedLanguage,
                        onChanged: (values) =>
                            context.read<EditSourceBloc>().add(
                              EditSourceDescriptionChanged(values),
                            ),
                        validator: (values) {
                          if (values?[state.defaultLanguage]?.isEmpty ?? true) {
                            return l10n.defaultLanguageRequired(
                              state.defaultLanguage.name.toUpperCase(),
                            );
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: _urlController,
                        decoration: InputDecoration(
                          labelText: l10n.sourceUrl,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) =>
                            context.read<EditSourceBloc>().add(
                              EditSourceUrlChanged(value),
                            ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      ImageUploadField(
                        initialImageUrl: state.logoUrl,
                        isProcessing:
                            state.initialSource?.mediaAssetId != null &&
                            state.logoUrl == null,
                        onChanged: (bytes, fileName) {
                          if (bytes != null && fileName != null) {
                            context.read<EditSourceBloc>().add(
                              EditSourceImageChanged(
                                imageFileBytes: bytes,
                                imageFileName: fileName,
                              ),
                            );
                          } else {
                            context.read<EditSourceBloc>().add(
                              const EditSourceImageRemoved(),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SearchableSelectionInput<Language>(
                        label: l10n.language,
                        selectedItems: state.selectedLanguageEntity != null
                            ? [state.selectedLanguageEntity!]
                            : [],
                        itemBuilder: (context, language) =>
                            Text(language.name.values.firstOrNull ?? ''),
                        itemToString: (language) =>
                            language.name.values.firstOrNull ?? '',
                        onChanged: (items) {
                          final bloc = context.read<EditSourceBloc>();
                          if (items != null && items.isNotEmpty) {
                            // Map Language entity code to SupportedLanguage enum
                            final languageEntity = items.first;
                            try {
                              final supportedLang = SupportedLanguage.values
                                  .byName(languageEntity.code);
                              bloc.add(
                                EditSourceLanguageChanged(
                                  supportedLang,
                                  languageEntity: languageEntity,
                                ),
                              );
                            } catch (_) {
                              // Handle case where DB language code doesn't match enum
                            }
                          } else {
                            bloc.add(const EditSourceLanguageChanged(null));
                          }
                        },
                        repository: context.read<DataRepository<Language>>(),
                        filterBuilder: (searchTerm) => searchTerm == null
                            ? {}
                            : {
                                'name': {
                                  r'$regex': searchTerm,
                                  r'$options': 'i',
                                },
                              },
                        sortOptions: [
                          SortOption('name.$langCode', SortOrder.asc),
                        ],
                        limit: kDefaultRowsPerPage,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SearchableSelectionInput<SourceType>(
                        label: l10n.sourceType,
                        selectedItems: state.sourceType != null
                            ? [state.sourceType!]
                            : [],
                        staticItems: SourceType.values.toList(),
                        itemBuilder: (context, type) =>
                            Text(type.localizedName(l10n)),
                        itemToString: (type) => type.localizedName(l10n),
                        onChanged: (items) =>
                            context.read<EditSourceBloc>().add(
                              EditSourceTypeChanged(items?.first),
                            ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SearchableSelectionInput<Country>(
                        label: l10n.headquarters,
                        selectedItems: state.headquarters != null
                            ? [state.headquarters!]
                            : [],
                        itemBuilder: (context, country) => Row(
                          children: [
                            SizedBox(
                              width: 32,
                              height: 20,
                              child: Image.network(
                                country.flagUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.flag),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Text(country.name.values.firstOrNull ?? ''),
                          ],
                        ),
                        itemToString: (country) =>
                            country.name.values.firstOrNull ?? '',
                        onChanged: (items) =>
                            context.read<EditSourceBloc>().add(
                              EditSourceHeadquartersChanged(items?.first),
                            ),
                        repository: context.read<DataRepository<Country>>(),
                        filterBuilder: (searchTerm) => searchTerm == null
                            ? {}
                            : {
                                'name': {
                                  r'$regex': searchTerm,
                                  r'$options': 'i',
                                },
                              },
                        sortOptions: [
                          SortOption(
                            'name.$langCode',
                            SortOrder.asc,
                          ),
                        ],
                        limit: kDefaultRowsPerPage,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleSave(BuildContext context) async {
    final selectedStatus = await _showSaveOptionsDialog(context);

    if (selectedStatus == null || !context.mounted) return;

    if (selectedStatus == ContentStatus.active) {
      context.read<EditSourceBloc>().add(
        const EditSourcePublished(),
      );
    } else if (selectedStatus == ContentStatus.draft) {
      context.read<EditSourceBloc>().add(
        const EditSourceSavedAsDraft(),
      );
    }
  }
}

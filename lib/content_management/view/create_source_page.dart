import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:veritai_dashboard/app/bloc/app_bloc.dart';
import 'package:veritai_dashboard/content_management/bloc/create_source/create_source_bloc.dart';
import 'package:veritai_dashboard/l10n/l10n.dart';
import 'package:veritai_dashboard/shared/data/enrichment_repository.dart';
import 'package:veritai_dashboard/shared/extensions/extensions.dart';
import 'package:veritai_dashboard/shared/widgets/image_upload_field.dart';
import 'package:veritai_dashboard/shared/widgets/localized_text_form_field.dart';
import 'package:veritai_dashboard/shared/widgets/searchable_selection_input.dart';

/// {@template create_source_page}
/// A page for creating a new source.
/// It uses a [BlocProvider] to create and provide a [CreateSourceBloc].
/// {@endtemplate}
class CreateSourcePage extends StatelessWidget {
  /// {@macro create_source_page}
  const CreateSourcePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppBloc>().state;
    final localizationConfig = appState.remoteConfig?.app.localization;

    final defaultLanguage =
        localizationConfig?.defaultLanguage ?? SupportedLanguage.en;
    var enabledLanguages =
        localizationConfig?.enabledLanguages ?? [SupportedLanguage.en];

    // Sort enabled languages so the user's current app language
    // appears first in the tabs.
    final userLanguage = appState.appSettings?.language ?? defaultLanguage;
    if (enabledLanguages.contains(userLanguage)) {
      enabledLanguages = [
        userLanguage,
        ...enabledLanguages.where((l) => l != userLanguage),
      ];
    }

    return BlocProvider(
      create: (context) =>
          CreateSourceBloc(
            sourcesRepository: context.read<DataRepository<Source>>(),
            enrichmentRepository: context.read<EnrichmentRepository>(),
            mediaRepository: context.read<MediaRepository>(),
            logger: Logger('CreateSourceBloc'),
          )..add(
            CreateSourceInitialized(
              enabledLanguages: enabledLanguages,
              defaultLanguage: defaultLanguage,
            ),
          ),
      child: const CreateSourceView(),
    );
  }
}

class CreateSourceView extends StatefulWidget {
  const CreateSourceView({super.key});

  @override
  State<CreateSourceView> createState() => _CreateSourceViewState();
}

class _CreateSourceViewState extends State<CreateSourceView>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    final state = context.read<CreateSourceBloc>().state;
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
        title: Text(l10n.saveSourceTitle),
        content: Text(l10n.saveSourceMessage),
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
        title: Text(l10n.createSource),
        actions: [
          BlocBuilder<CreateSourceBloc, CreateSourceState>(
            builder: (context, state) {
              if (state.status == CreateSourceStatus.imageUploading ||
                  state.status == CreateSourceStatus.entitySubmitting ||
                  state.status == CreateSourceStatus.enriching) {
                return const Padding(
                  padding: EdgeInsets.only(right: AppSpacing.lg),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                );
              }
              return Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.auto_fix_high),
                    tooltip: l10n.aiEnrichment,
                    onPressed:
                        state.name.values.any((v) => v.isNotEmpty) &&
                            !state.isEnrichmentSuccessful
                        ? () => context.read<CreateSourceBloc>().add(
                            const CreateSourceEnrichmentRequested(),
                          )
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.save),
                    tooltip: l10n.saveChanges,
                    onPressed: state.isFormValid
                        ? () async {
                            final selectedStatus = await _showSaveOptionsDialog(
                              context,
                            );
                            if (selectedStatus == ContentStatus.active &&
                                context.mounted) {
                              context.read<CreateSourceBloc>().add(
                                const CreateSourcePublished(),
                              );
                            } else if (selectedStatus == ContentStatus.draft &&
                                context.mounted) {
                              context.read<CreateSourceBloc>().add(
                                const CreateSourceSavedAsDraft(),
                              );
                            }
                          }
                        : null,
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<CreateSourceBloc, CreateSourceState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == CreateSourceStatus.success &&
              state.createdSource != null &&
              ModalRoute.of(context)!.isCurrent) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(l10n.sourceCreatedSuccessfully)),
              );
            context.pop();
          }
          if (state.status == CreateSourceStatus.imageUploadFailure ||
              state.status == CreateSourceStatus.entitySubmitFailure ||
              state.status == CreateSourceStatus.enrichmentFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.exception!.toFriendlyMessage(context)),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
          }
        },
        builder: (context, state) {
          if (_urlController.text != state.url) {
            _urlController.text = state.url;
          }
          if (state.status == CreateSourceStatus.loading) {
            return LoadingStateWidget(
              icon: Icons.source,
              headline: l10n.loadingData,
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.status == CreateSourceStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.exception!.toFriendlyMessage(context)),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
          }

          return DefaultTabController(
            length: state.enabledLanguages.length,
            child: SafeArea(
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
                          onTap: (index) =>
                              context.read<CreateSourceBloc>().add(
                                CreateSourceLanguageTabChanged(
                                  state.enabledLanguages[index],
                                ),
                              ),
                          tabs: state.enabledLanguages.map((lang) {
                            final hasContent =
                                state.name[lang]?.isNotEmpty ??
                                state.description[lang]?.isNotEmpty ??
                                false;
                            return Tab(
                              icon: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Image.network(
                                    lang.flagUrl,
                                    width: 24,
                                    errorBuilder: (_, _, _) =>
                                        const Icon(Icons.flag, size: 16),
                                  ),
                                  if (hasContent &&
                                      state.isEnrichmentSuccessful &&
                                      lang != state.defaultLanguage)
                                    Positioned(
                                      top: -4,
                                      right: -4,
                                      child: Icon(
                                        Icons.auto_awesome,
                                        size: 12,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            LocalizedTextFormField(
                              label: l10n.sourceName,
                              values: state.name,
                              enabledLanguages: state.enabledLanguages,
                              selectedLanguage: state.selectedLanguage,
                              onChanged: (values) =>
                                  context.read<CreateSourceBloc>().add(
                                    CreateSourceNameChanged(values),
                                  ),
                              validator: (values) {
                                if (values?[state.defaultLanguage]?.isEmpty ??
                                    true) {
                                  return l10n.defaultLanguageRequired(
                                    state.defaultLanguage.name.toUpperCase(),
                                  );
                                }
                                return null;
                              },
                            ),
                            if (state.wasNameEnriched)
                              Positioned(
                                top: 6,
                                right: 8,
                                child: Icon(
                                  Icons.auto_awesome,
                                  size: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            LocalizedTextFormField(
                              label: l10n.description,
                              values: state.description,
                              enabledLanguages: state.enabledLanguages,
                              selectedLanguage: state.selectedLanguage,
                              onChanged: (values) =>
                                  context.read<CreateSourceBloc>().add(
                                    CreateSourceDescriptionChanged(values),
                                  ),
                              validator: (values) {
                                if (values?[state.defaultLanguage]?.isEmpty ??
                                    true) {
                                  return l10n.defaultLanguageRequired(
                                    state.defaultLanguage.name.toUpperCase(),
                                  );
                                }
                                return null;
                              },
                            ),
                            if (state.wasDescriptionEnriched)
                              Positioned(
                                top: 6,
                                right: 8,
                                child: Icon(
                                  Icons.auto_awesome,
                                  size: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            TextFormField(
                              controller: _urlController,
                              decoration: InputDecoration(
                                labelText: l10n.sourceUrl,
                                border: const OutlineInputBorder(),
                              ),
                              onChanged: (value) => context
                                  .read<CreateSourceBloc>()
                                  .add(CreateSourceUrlChanged(value)),
                            ),
                            if (state.wasUrlEnriched)
                              Positioned(
                                top: 6,
                                right: 8,
                                child: Icon(
                                  Icons.auto_awesome,
                                  size: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ImageUploadField(
                          onChanged: (bytes, fileName) {
                            if (bytes != null && fileName != null) {
                              context.read<CreateSourceBloc>().add(
                                CreateSourceImageChanged(
                                  imageFileBytes: bytes,
                                  imageFileName: fileName,
                                ),
                              );
                            } else {
                              context.read<CreateSourceBloc>().add(
                                const CreateSourceImageRemoved(),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            SearchableSelectionInput<Language>(
                              label: l10n.language,
                              selectedItems:
                                  state.selectedLanguageEntity != null
                                  ? [state.selectedLanguageEntity!]
                                  : [],
                              itemBuilder: (context, language) => Text(
                                language.name.values.firstOrNull ??
                                    language.nativeName,
                              ),
                              itemToString: (language) =>
                                  language.name.values.firstOrNull ??
                                  language.nativeName,
                              onChanged: (items) {
                                context.read<CreateSourceBloc>().add(
                                  CreateSourceLanguageChanged(
                                    items?.firstOrNull,
                                  ),
                                );
                              },
                              repository: context
                                  .read<DataRepository<Language>>(),
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
                            if (state.wasLanguageEnriched)
                              Positioned(
                                top: 6,
                                right: 8,
                                child: Icon(
                                  Icons.auto_awesome,
                                  size: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            SearchableSelectionInput<SourceType>(
                              label: l10n.sourceType,
                              selectedItems: state.sourceType != null
                                  ? [state.sourceType!]
                                  : [],
                              staticItems: SourceType.values.toList(),
                              itemBuilder: (context, type) =>
                                  Text(type.localizedName(l10n)),
                              itemToString: (type) => type.localizedName(l10n),
                              onChanged: (items) => context
                                  .read<CreateSourceBloc>()
                                  .add(CreateSourceTypeChanged(items?.first)),
                            ),
                            if (state.wasSourceTypeEnriched)
                              Positioned(
                                top: 6,
                                right: 8,
                                child: Icon(
                                  Icons.auto_awesome,
                                  size: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
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
                                      errorBuilder:
                                          (context, error, stackTrace) =>
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
                                  context.read<CreateSourceBloc>().add(
                                    CreateSourceHeadquartersChanged(
                                      items?.first,
                                    ),
                                  ),
                              repository: context
                                  .read<DataRepository<Country>>(),
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
                            if (state.wasHeadquartersEnriched)
                              Positioned(
                                top: 6,
                                right: 8,
                                child: Icon(
                                  Icons.auto_awesome,
                                  size: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

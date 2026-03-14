import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:veritai_dashboard/app/bloc/app_bloc.dart';
import 'package:veritai_dashboard/content_management/bloc/create_headline/create_headline_bloc.dart';
import 'package:veritai_dashboard/l10n/app_localizations.dart';
import 'package:veritai_dashboard/l10n/l10n.dart';
import 'package:veritai_dashboard/shared/shared.dart';

/// {@template create_headline_page}
/// A page for creating a new headline.
/// It uses a [BlocProvider] to create and provide a [CreateHeadlineBloc].
/// {@endtemplate}
class CreateHeadlinePage extends StatelessWidget {
  /// {@macro create_headline_page}
  const CreateHeadlinePage({super.key});

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
          CreateHeadlineBloc(
            enrichmentRepository: context.read<EnrichmentRepository>(),
            headlinesRepository: context.read<DataRepository<Headline>>(),
            mediaRepository: context.read<MediaRepository>(),
            logger: Logger('CreateHeadlineBloc'),
          )..add(
            CreateHeadlineInitialized(
              enabledLanguages: enabledLanguages,
              defaultLanguage: defaultLanguage,
            ),
          ),
      child: const CreateHeadlineView(),
    );
  }
}

/// The view for creating a new headline, containing the form and logic.
class CreateHeadlineView extends StatefulWidget {
  /// Creates a [CreateHeadlineView].
  const CreateHeadlineView({super.key});

  @override
  State<CreateHeadlineView> createState() => _CreateHeadlineViewState();
}

class _CreateHeadlineViewState extends State<CreateHeadlineView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    final state = context.read<CreateHeadlineBloc>().state;
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
        title: Text(l10n.saveHeadlineTitle),
        content: Text(l10n.saveHeadlineMessage),
        actions: [
          TextButton(
            onPressed: () {
              if (!context.mounted) return;
              Navigator.of(context).pop(ContentStatus.draft);
            },
            child: Text(l10n.saveAsDraft),
          ),
          TextButton(
            onPressed: () {
              if (!context.mounted) return;
              Navigator.of(context).pop(ContentStatus.active);
            },
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
        title: Text(l10n.createHeadline),
        actions: [
          BlocBuilder<CreateHeadlineBloc, CreateHeadlineState>(
            builder: (context, state) {
              if (state.status == CreateHeadlineStatus.imageUploading ||
                  state.status == CreateHeadlineStatus.entitySubmitting ||
                  state.status == CreateHeadlineStatus.enriching) {
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
                        (state.title[state.defaultLanguage]?.isNotEmpty ??
                                false) &&
                            !state.isEnrichmentSuccessful
                        ? () => context.read<CreateHeadlineBloc>().add(
                            const CreateHeadlineEnrichmentRequested(),
                          )
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.save),
                    tooltip: l10n.saveChanges,
                    onPressed: _isSaveButtonEnabled(state)
                        ? () => _handleSave(context, state, l10n)
                        : null,
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<CreateHeadlineBloc, CreateHeadlineState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == CreateHeadlineStatus.success &&
              state.createdHeadline != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(l10n.headlineCreatedSuccessfully)),
              );
            context.pop();
          }
          if (state.status == CreateHeadlineStatus.imageUploadFailure ||
              state.status == CreateHeadlineStatus.entitySubmitFailure ||
              state.status == CreateHeadlineStatus.enrichmentFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Builder(
                    builder: (context) => Text(
                      state.exception!.toFriendlyMessage(context),
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
          }
        },
        builder: (context, state) {
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
                        onTap: (index) =>
                            context.read<CreateHeadlineBloc>().add(
                              CreateHeadlineLanguageTabChanged(
                                state.enabledLanguages[index],
                              ),
                            ),
                        tabs: state.enabledLanguages.map((lang) {
                          final hasContent =
                              state.title[lang]?.isNotEmpty ?? false;
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
                                    state.wasTitleEnriched &&
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
                      LocalizedTextFormField(
                        label: l10n.headlineTitle,
                        values: state.title,
                        enabledLanguages: state.enabledLanguages,
                        selectedLanguage: state.selectedLanguage,
                        onChanged: (values) =>
                            context.read<CreateHeadlineBloc>().add(
                              CreateHeadlineTitleChanged(values),
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
                        onChanged: (value) => context
                            .read<CreateHeadlineBloc>()
                            .add(CreateHeadlineUrlChanged(value)),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      ImageUploadField(
                        onChanged: (Uint8List? bytes, String? fileName) {
                          final bloc = context.read<CreateHeadlineBloc>();
                          if (bytes == null || fileName == null) {
                            bloc.add(const CreateHeadlineImageRemoved());
                            return;
                          }
                          bloc.add(
                            CreateHeadlineImageChanged(
                              imageFileBytes: bytes,
                              imageFileName: fileName,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.isBreakingNewsLabel,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Switch(
                            value: state.isBreaking,
                            onChanged: (value) => context
                                .read<CreateHeadlineBloc>()
                                .add(CreateHeadlineIsBreakingChanged(value)),
                          ),
                        ],
                      ),
                      Text(l10n.isBreakingNewsDescription),
                      const SizedBox(height: AppSpacing.lg),
                      SearchableSelectionInput<Source>(
                        label: l10n.sourceName,
                        selectedItems: state.source != null
                            ? [state.source!]
                            : [],
                        itemBuilder: (context, source) =>
                            Text(source.name.getValue(context)),
                        itemToString: (source) => source.name.getValue(context),
                        onChanged: (items) => context
                            .read<CreateHeadlineBloc>()
                            .add(CreateHeadlineSourceChanged(items?.first)),
                        repository: context.read<DataRepository<Source>>(),
                        filterBuilder: (searchTerm) =>
                            searchTerm == null ? {} : {'q': searchTerm},
                        sortOptions: [
                          SortOption('name.$langCode', SortOrder.asc),
                        ],
                        limit: kDefaultRowsPerPage,
                        includeInactiveSelectedItem: false,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SearchableSelectionInput<Topic>(
                            label: l10n.topicName,
                            selectedItems: state.topic != null
                                ? [state.topic!]
                                : [],
                            itemBuilder: (context, topic) =>
                                Text(topic.name.getValue(context)),
                            itemToString: (topic) =>
                                topic.name.getValue(context),
                            onChanged: (items) => context
                                .read<CreateHeadlineBloc>()
                                .add(CreateHeadlineTopicChanged(items?.first)),
                            repository: context.read<DataRepository<Topic>>(),
                            filterBuilder: (searchTerm) =>
                                searchTerm == null ? {} : {'q': searchTerm},
                            sortOptions: [
                              SortOption('name.$langCode', SortOrder.asc),
                            ],
                            limit: kDefaultRowsPerPage,
                            includeInactiveSelectedItem: false,
                          ),
                          if (state.topic != null && state.wasTopicEnriched)
                            Positioned(
                              top: 6,
                              right: 40,
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
                            label: l10n.countryName,
                            isMultiSelect: true,
                            selectedItems: state.mentionedCountries,
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
                                Text(country.name.getValue(context)),
                              ],
                            ),
                            itemToString: (country) =>
                                country.name.getValue(context),
                            onChanged: (items) =>
                                context.read<CreateHeadlineBloc>().add(
                                  CreateHeadlineCountriesChanged(items ?? []),
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
                              SortOption('name.$langCode', SortOrder.asc),
                            ],
                            limit: kDefaultRowsPerPage,
                            includeInactiveSelectedItem: false,
                          ),
                          if (state.mentionedCountries.isNotEmpty &&
                              state.wereCountriesEnriched)
                            Positioned(
                              top: 6,
                              right: 40,
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
                          SearchableSelectionInput<Person>(
                            label: l10n.persons,
                            isMultiSelect: true,
                            selectedItems: state.mentionedPersons,
                            itemBuilder: (context, person) =>
                                Text(person.name.getValue(context)),
                            itemToString: (person) =>
                                person.name.getValue(context),
                            onChanged: (items) =>
                                context.read<CreateHeadlineBloc>().add(
                                  CreateHeadlinePersonsChanged(items ?? []),
                                ),
                            repository: context.read<DataRepository<Person>>(),
                            filterBuilder: (searchTerm) =>
                                searchTerm == null ? {} : {'q': searchTerm},
                            sortOptions: [
                              SortOption('name.$langCode', SortOrder.asc),
                            ],
                            limit: kDefaultRowsPerPage,
                            includeInactiveSelectedItem: true,
                          ),
                          if (state.mentionedPersons.isNotEmpty &&
                              state.werePersonsEnriched)
                            Positioned(
                              top: 6,
                              right: 40,
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
          );
        },
      ),
    );
  }

  /// Determines if the save button should be enabled.
  ///
  /// The button is enabled if the form is valid for drafting, or if all
  /// fields are filled for publishing (regardless of breaking news status).
  bool _isSaveButtonEnabled(CreateHeadlineState state) {
    final allFieldsFilled =
        (state.title[state.defaultLanguage]?.isNotEmpty ?? false) &&
        state.url.isNotEmpty &&
        state.imageFileBytes != null &&
        state.source != null &&
        state.topic != null &&
        state.mentionedCountries.isNotEmpty;

    return allFieldsFilled;
  }

  /// Handles the save logic, including showing save options and the
  /// confirmation dialog for breaking news.
  Future<void> _handleSave(
    BuildContext context,
    CreateHeadlineState state,
    AppLocalizations l10n,
  ) async {
    final selectedStatus = await _showSaveOptionsDialog(context);

    // If the user cancels the dialog, do nothing.
    if (selectedStatus == null) return;

    // If the user tries to save as draft but it's breaking news, show an error.
    if (selectedStatus == ContentStatus.draft && state.isBreaking) {
      if (!context.mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.invalidFormTitle),
          content: Text(l10n.cannotDraftBreakingNews),
          actions: [
            TextButton(
              onPressed: () {
                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
      return;
    }

    // If publishing as breaking news, show an extra confirmation.
    if (selectedStatus == ContentStatus.active && state.isBreaking) {
      if (!context.mounted) return;
      final confirmBreaking = await _showBreakingNewsConfirmationDialog(
        context,
        l10n,
      );
      if (confirmBreaking != true) return;
    }

    // Dispatch the appropriate event based on user's choice.
    if (selectedStatus == ContentStatus.active) {
      if (!context.mounted) return;
      context.read<CreateHeadlineBloc>().add(const CreateHeadlinePublished());
    } else if (selectedStatus == ContentStatus.draft) {
      if (!context.mounted) return;
      context.read<CreateHeadlineBloc>().add(
        const CreateHeadlineSavedAsDraft(),
      );
    }
  }

  /// Shows a confirmation dialog specifically for publishing breaking news.
  Future<bool?> _showBreakingNewsConfirmationDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmBreakingNewsTitle),
        content: Text(l10n.confirmBreakingNewsMessage),
        actions: [
          TextButton(
            onPressed: () {
              if (!context.mounted) return;
              Navigator.of(context).pop(false);
            },
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () {
              if (!context.mounted) return;
              Navigator.of(context).pop(true);
            },
            child: Text(l10n.confirmPublishButton),
          ),
        ],
      ),
    );
  }
}

import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app/bloc/app_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/edit_headline/edit_headline_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/supported_language_flag.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/image_upload_field.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/localized_text_form_field.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/searchable_selection_input.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:core_ui/core_ui.dart';

/// {@template edit_headline_page}
/// A page for editing an existing headline.
/// It uses a [BlocProvider] to create and provide an [EditHeadlineBloc].
/// {@endtemplate}
class EditHeadlinePage extends StatelessWidget {
  /// {@macro edit_headline_page}
  const EditHeadlinePage({
    required this.headlineId,
    super.key,
  });

  /// The ID of the headline to be edited.
  final String headlineId;

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
          EditHeadlineBloc(
            headlinesRepository: context.read<DataRepository<Headline>>(),
            mediaRepository: context.read<MediaRepository>(),
            headlineId: headlineId,
            logger: Logger('EditHeadlineBloc'),
          )..add(
            EditHeadlineLoaded(
              enabledLanguages:
                  localizationConfig?.enabledLanguages ??
                  [SupportedLanguage.en],
              defaultLanguage:
                  localizationConfig?.defaultLanguage ?? SupportedLanguage.en,
            ),
          ),
      child: const EditHeadlineView(),
    );
  }
}

class EditHeadlineView extends StatefulWidget {
  const EditHeadlineView({super.key});

  @override
  State<EditHeadlineView> createState() => _EditHeadlineViewState();
}

class _EditHeadlineViewState extends State<EditHeadlineView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    final state = context.read<EditHeadlineBloc>().state;
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
        title: Text(l10n.updateHeadlineTitle),
        content: Text(l10n.updateHeadlineMessage),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editHeadline),
        actions: [
          BlocBuilder<EditHeadlineBloc, EditHeadlineState>(
            builder: (context, state) {
              if (state.status == EditHeadlineStatus.imageUploading ||
                  state.status == EditHeadlineStatus.entitySubmitting) {
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
                    ? () => _handleSave(context, state, l10n)
                    : null,
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<EditHeadlineBloc, EditHeadlineState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == EditHeadlineStatus.success &&
              state.updatedHeadline != null &&
              ModalRoute.of(context)!.isCurrent) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(l10n.headlineUpdatedSuccessfully)),
              );
            context.pop();
          }
          if (state.status == EditHeadlineStatus.imageUploadFailure ||
              state.status == EditHeadlineStatus.entitySubmitFailure) {
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
          if (state.status == EditHeadlineStatus.initial) {
            _urlController.text = state.url;
            // No need to update a controller for `isBreaking` as it's a Switch.
          }
        },
        builder: (context, state) {
          if (state.status == EditHeadlineStatus.loading) {
            return LoadingStateWidget(
              icon: Icons.newspaper,
              headline: l10n.loadingHeadline,
              subheadline: l10n.pleaseWait,
            );
          }

          if ((state.status == EditHeadlineStatus.entitySubmitFailure ||
                  state.status == EditHeadlineStatus.failure) &&
              state.title.isEmpty) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () => context.read<EditHeadlineBloc>().add(
                EditHeadlineLoaded(
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
                        onTap: (index) => context.read<EditHeadlineBloc>().add(
                          EditHeadlineLanguageTabChanged(
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
                        label: l10n.headlineTitle,
                        values: state.title,
                        enabledLanguages: state.enabledLanguages,
                        selectedLanguage: state.selectedLanguage,
                        onChanged: (values) =>
                            context.read<EditHeadlineBloc>().add(
                              EditHeadlineTitleChanged(values),
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
                            .read<EditHeadlineBloc>()
                            .add(EditHeadlineUrlChanged(value)),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      ImageUploadField(
                        initialImageUrl: state.imageUrl,
                        isProcessing:
                            state.initialHeadline?.mediaAssetId != null &&
                            state.imageUrl == null,
                        onChanged: (Uint8List? bytes, String? fileName) {
                          final bloc = context.read<EditHeadlineBloc>();
                          if (bytes == null || fileName == null) {
                            bloc.add(const EditHeadlineImageRemoved());
                            return;
                          }
                          bloc.add(
                            EditHeadlineImageChanged(
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
                            onChanged:
                                state.initialHeadline?.status ==
                                    ContentStatus.active
                                ? null
                                : (value) =>
                                      context.read<EditHeadlineBloc>().add(
                                        EditHeadlineIsBreakingChanged(
                                          value,
                                        ),
                                      ),
                          ),
                        ],
                      ),
                      Text(
                        state.initialHeadline?.status == ContentStatus.active
                            ? l10n.isBreakingNewsDescriptionEdit
                            : l10n.isBreakingNewsDescription,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Existing SearchableSelectionInput widgets
                      SearchableSelectionInput<Source>(
                        label: l10n.sourceName,
                        selectedItems: state.source != null
                            ? [state.source!]
                            : [],
                        itemBuilder: (context, source) =>
                            Text(source.name.values.firstOrNull ?? ''),
                        itemToString: (source) =>
                            source.name.values.firstOrNull ?? '',
                        onChanged: (items) => context
                            .read<EditHeadlineBloc>()
                            .add(EditHeadlineSourceChanged(items?.first)),
                        repository: context.read<DataRepository<Source>>(),
                        filterBuilder: (searchTerm) =>
                            searchTerm == null ? {} : {'q': searchTerm},
                        sortOptions: const [
                          SortOption('name.en', SortOrder.asc),
                        ],
                        limit: kDefaultRowsPerPage,
                        includeInactiveSelectedItem: true,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SearchableSelectionInput<Topic>(
                        label: l10n.topicName,
                        selectedItems: state.topic != null
                            ? [state.topic!]
                            : [],
                        itemBuilder: (context, topic) =>
                            Text(topic.name.values.firstOrNull ?? ''),
                        itemToString: (topic) =>
                            topic.name.values.firstOrNull ?? '',
                        onChanged: (items) => context
                            .read<EditHeadlineBloc>()
                            .add(EditHeadlineTopicChanged(items?.first)),
                        repository: context.read<DataRepository<Topic>>(),
                        filterBuilder: (searchTerm) =>
                            searchTerm == null ? {} : {'q': searchTerm},
                        sortOptions: const [
                          SortOption('name.en', SortOrder.asc),
                        ],
                        limit: kDefaultRowsPerPage,
                        includeInactiveSelectedItem: true,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SearchableSelectionInput<Country>(
                        label: l10n.countryName,
                        selectedItems: state.eventCountry != null
                            ? [state.eventCountry!]
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
                        onChanged: (items) => context
                            .read<EditHeadlineBloc>()
                            .add(EditHeadlineCountryChanged(items?.first)),
                        repository: context.read<DataRepository<Country>>(),
                        filterBuilder: (searchTerm) => searchTerm == null
                            ? {}
                            : {
                                'name': {
                                  r'$regex': searchTerm,
                                  r'$options': 'i',
                                },
                              },
                        sortOptions: const [
                          SortOption('name.en', SortOrder.asc),
                        ],
                        limit: kDefaultRowsPerPage,
                        includeInactiveSelectedItem: true,
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

  /// Handles the save logic, including showing save options and the
  /// confirmation dialog for breaking news.
  Future<void> _handleSave(
    BuildContext context,
    EditHeadlineState state,
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
    // Only show if it wasn't already active (i.e. we are publishing a draft).
    if (selectedStatus == ContentStatus.active &&
        state.isBreaking &&
        state.initialHeadline?.status != ContentStatus.active) {
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
      context.read<EditHeadlineBloc>().add(const EditHeadlinePublished());
    } else if (selectedStatus == ContentStatus.draft) {
      if (!context.mounted) return;
      context.read<EditHeadlineBloc>().add(const EditHeadlineSavedAsDraft());
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
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.confirmPublishButton),
          ),
        ],
      ),
    );
  }
}

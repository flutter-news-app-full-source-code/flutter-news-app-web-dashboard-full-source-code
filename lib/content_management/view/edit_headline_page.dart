import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/edit_headline/edit_headline_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/shared.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

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
    return BlocProvider(
      create: (context) => EditHeadlineBloc(
        headlinesRepository: context.read<DataRepository<Headline>>(),
        headlineId: headlineId,
      ),
      child: const _EditHeadlineView(),
    );
  }
}

class _EditHeadlineView extends StatefulWidget {
  const _EditHeadlineView();

  @override
  State<_EditHeadlineView> createState() => _EditHeadlineViewState();
}

class _EditHeadlineViewState extends State<_EditHeadlineView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _excerptController;
  late final TextEditingController _urlController;
  late final TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _excerptController = TextEditingController();
    _urlController = TextEditingController();
    _imageUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _excerptController.dispose();
    _urlController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  /// Shows a dialog to the user when the form is invalid, offering options
  /// to complete the form or discard changes.
  Future<void> _showInvalidFormDialog(BuildContext context) async {
    final l10n = AppLocalizationsX(context).l10n;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.invalidFormTitle),
        content: Text(l10n.invalidFormMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.completeForm),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.discard),
          ),
        ],
      ),
    );

    if (result ?? false) {
      // If user chooses to discard, pop the page.
      if (context.mounted) {
        context.pop();
      }
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editHeadline),
        actions: [
          BlocBuilder<EditHeadlineBloc, EditHeadlineState>(
            builder: (context, state) {
              if (state.status == EditHeadlineStatus.submitting) {
                return const Padding(
                  padding: EdgeInsets.only(right: AppSpacing.lg),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.save),
                tooltip: l10n.saveChanges,
                onPressed: () async {
                  if (state.isFormValid) {
                    final selectedStatus = await _showSaveOptionsDialog(
                      context,
                    );
                    if (selectedStatus == ContentStatus.active) {
                      context.read<EditHeadlineBloc>().add(
                        const EditHeadlinePublished(),
                      );
                    } else if (selectedStatus == ContentStatus.draft) {
                      context.read<EditHeadlineBloc>().add(
                        const EditHeadlineSavedAsDraft(),
                      );
                    }
                  } else {
                    await _showInvalidFormDialog(context);
                  }
                },
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
          if (state.status == EditHeadlineStatus.failure) {
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
            _titleController.text = state.title;
            _excerptController.text = state.excerpt;
            _urlController.text = state.url;
            _imageUrlController.text = state.imageUrl;
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

          if (state.status == EditHeadlineStatus.failure &&
              state.title.isEmpty) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () => context.read<EditHeadlineBloc>().add(
                const EditHeadlineLoaded(),
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: l10n.headlineTitle,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<EditHeadlineBloc>()
                          .add(EditHeadlineTitleChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _excerptController,
                      decoration: InputDecoration(
                        labelText: l10n.excerpt,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (value) => context
                          .read<EditHeadlineBloc>()
                          .add(EditHeadlineExcerptChanged(value)),
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
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(
                        labelText: l10n.imageUrl,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<EditHeadlineBloc>()
                          .add(EditHeadlineImageUrlChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SearchableSelectionInput<Source>(
                      label: l10n.sourceName,
                      selectedItem: state.source,
                      itemBuilder: (context, source) => Text(source.name),
                      itemToString: (source) => source.name,
                      onChanged: (value) => context
                          .read<EditHeadlineBloc>()
                          .add(EditHeadlineSourceChanged(value)),
                      repository: context.read<DataRepository<Source>>(),
                      filterBuilder: (searchTerm) => searchTerm == null
                          ? {}
                          : {
                              'name': {
                                r'$regex': searchTerm,
                                r'$options': 'i',
                              },
                            },
                      sortOptions: const [
                        SortOption('name', SortOrder.asc),
                      ],
                      limit: kDefaultRowsPerPage,
                      includeInactiveSelectedItem: true,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SearchableSelectionInput<Topic>(
                      label: l10n.topicName,
                      selectedItem: state.topic,
                      itemBuilder: (context, topic) => Text(topic.name),
                      itemToString: (topic) => topic.name,
                      onChanged: (value) => context
                          .read<EditHeadlineBloc>()
                          .add(EditHeadlineTopicChanged(value)),
                      repository: context.read<DataRepository<Topic>>(),
                      filterBuilder: (searchTerm) => searchTerm == null
                          ? {}
                          : {
                              'name': {
                                r'$regex': searchTerm,
                                r'$options': 'i',
                              },
                            },
                      sortOptions: const [
                        SortOption('name', SortOrder.asc),
                      ],
                      limit: kDefaultRowsPerPage,
                      includeInactiveSelectedItem: true,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SearchableSelectionInput<Country>(
                      label: l10n.countryName,
                      selectedItem: state.eventCountry,
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
                          Text(country.name),
                        ],
                      ),
                      itemToString: (country) => country.name,
                      onChanged: (value) => context
                          .read<EditHeadlineBloc>()
                          .add(EditHeadlineCountryChanged(value)),
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
                        SortOption('name', SortOrder.asc),
                      ],
                      limit: kDefaultRowsPerPage,
                      includeInactiveSelectedItem: true,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

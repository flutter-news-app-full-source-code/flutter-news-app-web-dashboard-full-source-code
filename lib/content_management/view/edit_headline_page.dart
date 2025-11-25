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
  late final TextEditingController _urlController;
  late final TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _urlController = TextEditingController();
    _imageUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _imageUrlController.dispose();
    super.dispose();
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
              // The save button is enabled only if the form is valid.
              return IconButton(
                icon: const Icon(Icons.save),
                tooltip: l10n.saveChanges,
                onPressed: state.isFormValid
                    ? () async {
                        // On edit page, directly save without a prompt.
                        // The status (draft/active) is determined by the original headline
                        // and is not changed by this save action unless a specific
                        // "change status" UI element is introduced (out of scope).
                        // For now, we assume the current status is maintained.
                        final originalHeadline = await context
                            .read<DataRepository<Headline>>()
                            .read(id: state.headlineId);

                        if (context.mounted) {
                          if (originalHeadline.status == ContentStatus.active) {
                            context.read<EditHeadlineBloc>().add(
                              const EditHeadlinePublished(),
                            );
                          } else {
                            context.read<EditHeadlineBloc>().add(
                              const EditHeadlineSavedAsDraft(),
                            );
                          }
                        }
                      }
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
            _urlController.text = state.url;
            _imageUrlController.text = state.imageUrl;
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
                              .read<EditHeadlineBloc>()
                              .add(EditHeadlineIsBreakingChanged(value)),
                        ),
                      ],
                    ),
                    Text(l10n.isBreakingNewsDescriptionEdit),
                    const SizedBox(height: AppSpacing.lg),
                    // Existing SearchableSelectionInput widgets
                    SearchableSelectionInput<Source>(
                      label: l10n.sourceName,
                      selectedItems: state.source != null
                          ? [state.source!]
                          : [],
                      itemBuilder: (context, source) => Text(source.name),
                      itemToString: (source) => source.name,
                      onChanged: (items) => context
                          .read<EditHeadlineBloc>()
                          .add(EditHeadlineSourceChanged(items?.first)),
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
                      selectedItems: state.topic != null ? [state.topic!] : [],
                      itemBuilder: (context, topic) => Text(topic.name),
                      itemToString: (topic) => topic.name,
                      onChanged: (items) => context
                          .read<EditHeadlineBloc>()
                          .add(EditHeadlineTopicChanged(items?.first)),
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
                          Text(country.name),
                        ],
                      ),
                      itemToString: (country) => country.name,
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

import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
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
  const EditHeadlinePage({required this.headlineId, super.key});

  /// The ID of the headline to be edited.
  final String headlineId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditHeadlineBloc(
        headlinesRepository: context.read<DataRepository<Headline>>(),
        sourcesRepository: context.read<DataRepository<Source>>(),
        topicsRepository: context.read<DataRepository<Topic>>(),
        countriesRepository: context.read<DataRepository<Country>>(),
        headlineId: headlineId,
      )..add(const EditHeadlineLoaded()),
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
    final state = context.read<EditHeadlineBloc>().state;
    _titleController = TextEditingController(text: state.title);
    _excerptController = TextEditingController(text: state.excerpt);
    _urlController = TextEditingController(text: state.url);
    _imageUrlController = TextEditingController(text: state.imageUrl);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _excerptController.dispose();
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
              return IconButton(
                icon: const Icon(Icons.save),
                tooltip: l10n.saveChanges,
                onPressed: state.isFormValid
                    ? () => context.read<EditHeadlineBloc>().add(
                        const EditHeadlineSubmitted(),
                      )
                    : null,
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<EditHeadlineBloc, EditHeadlineState>(
        listenWhen: (previous, current) =>
            previous.status != current.status ||
            previous.initialHeadline != current.initialHeadline,
        listener: (context, state) {
          if (state.status == EditHeadlineStatus.success &&
              state.updatedHeadline != null &&
              ModalRoute.of(context)!.isCurrent) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(l10n.headlineUpdatedSuccessfully)),
              );
            context.read<ContentManagementBloc>().add(
              const LoadHeadlinesRequested(limit: kDefaultRowsPerPage),
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
          if (state.initialHeadline != null) {
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
              state.initialHeadline == null) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () => context.read<EditHeadlineBloc>().add(
                const EditHeadlineLoaded(),
              ),
            );
          }

          // Find the correct instances from the lists to ensure
          // the Dropdowns can display the selections correctly.
          Source? selectedSource;
          if (state.source != null) {
            try {
              selectedSource = state.sources.firstWhere(
                (s) => s.id == state.source!.id,
              );
            } catch (_) {
              selectedSource = null;
            }
          }

          Topic? selectedTopic;
          if (state.topic != null) {
            try {
              selectedTopic = state.topics.firstWhere(
                (t) => t.id == state.topic!.id,
              );
            } catch (_) {
              selectedTopic = null;
            }
          }

          Country? selectedCountry;
          if (state.eventCountry != null) {
            try {
              selectedCountry = state.countries.firstWhere(
                (c) => c.id == state.eventCountry!.id,
              );
            } catch (_) {
              selectedCountry = null;
            }
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
                    DropdownButtonFormField<Source?>(
                      value: selectedSource,
                      decoration: InputDecoration(
                        labelText: l10n.sourceName,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: null, child: Text(l10n.none)),
                        ...state.sources.map(
                          (source) => DropdownMenuItem(
                            value: source,
                            child: Text(source.name),
                          ),
                        ),
                      ],
                      onChanged: (value) => context
                          .read<EditHeadlineBloc>()
                          .add(EditHeadlineSourceChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    DropdownButtonFormField<Topic?>(
                      value: selectedTopic,
                      decoration: InputDecoration(
                        labelText: l10n.topicName,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: null, child: Text(l10n.none)),
                        ...state.topics.map(
                          (topic) => DropdownMenuItem(
                            value: topic,
                            child: Text(topic.name),
                          ),
                        ),
                      ],
                      onChanged: (value) => context
                          .read<EditHeadlineBloc>()
                          .add(EditHeadlineTopicChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    DropdownButtonFormField<Country?>(
                      value: selectedCountry,
                      decoration: InputDecoration(
                        labelText: l10n.countryName,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: null, child: Text(l10n.none)),
                        ...state.countries.map(
                          (country) => DropdownMenuItem(
                            value: country,
                            child: Row(
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
                                Text(country.name),
                              ],
                            ),
                          ),
                        ),
                        if (state.countriesHasMore)
                          DropdownMenuItem(
                            value: null,
                            child: const Center(
                              child: Text('Load More'),
                            ),
                            onTap: () => context.read<EditHeadlineBloc>().add(
                                  const EditHeadlineLoadMoreCountriesRequested(),
                                ),
                          ),
                      ],
                      onChanged: (value) => context
                          .read<EditHeadlineBloc>()
                          .add(EditHeadlineCountryChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    DropdownButtonFormField<ContentStatus>(
                      value: state.contentStatus,
                      decoration: InputDecoration(
                        labelText: l10n.status,
                        border: const OutlineInputBorder(),
                      ),
                      items: ContentStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status.l10n(context)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        context.read<EditHeadlineBloc>().add(
                          EditHeadlineStatusChanged(value),
                        );
                      },
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

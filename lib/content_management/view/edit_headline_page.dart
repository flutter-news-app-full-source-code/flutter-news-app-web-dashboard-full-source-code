import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/edit_headline/edit_headline_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/searchable_paginated_dropdown/searchable_paginated_dropdown_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/widgets/searchable_paginated_dropdown.dart';
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
    required this.headline,
    super.key,
  });

  /// The headline to be edited.
  final Headline headline;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditHeadlineBloc(
        headlinesRepository: context.read<DataRepository<Headline>>(),
        initialHeadline: headline,
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
          // Update text controllers if initialHeadline changes (e.g., due to hot reload)
          if (state.initialHeadline != null &&
              _titleController.text != state.title) {
            _titleController.text = state.title;
          }
          if (state.initialHeadline != null &&
              _excerptController.text != state.excerpt) {
            _excerptController.text = state.excerpt;
          }
          if (state.initialHeadline != null &&
              _urlController.text != state.url) {
            _urlController.text = state.url;
          }
          if (state.initialHeadline != null &&
              _imageUrlController.text != state.imageUrl) {
            _imageUrlController.text = state.imageUrl;
          }
        },
        builder: (context, state) {
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
                    BlocProvider<SearchablePaginatedDropdownBloc<Source>>(
                      create: (context) =>
                          SearchablePaginatedDropdownBloc<Source>(
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
                            initialSelectedItem: state.source,
                          ),
                      child: SearchablePaginatedDropdown<Source>(
                        label: l10n.sourceName,
                        selectedItem: state.source,
                        itemBuilder: (context, source) => Text(source.name),
                        itemToString: (source) => source.name,
                        onChanged: (value) => context
                            .read<EditHeadlineBloc>()
                            .add(EditHeadlineSourceChanged(value)),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    BlocProvider<SearchablePaginatedDropdownBloc<Topic>>(
                      create: (context) =>
                          SearchablePaginatedDropdownBloc<Topic>(
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
                            initialSelectedItem: state.topic,
                          ),
                      child: SearchablePaginatedDropdown<Topic>(
                        label: l10n.topicName,
                        selectedItem: state.topic,
                        itemBuilder: (context, topic) => Text(topic.name),
                        itemToString: (topic) => topic.name,
                        onChanged: (value) => context
                            .read<EditHeadlineBloc>()
                            .add(EditHeadlineTopicChanged(value)),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    BlocProvider<SearchablePaginatedDropdownBloc<Country>>(
                      create: (context) =>
                          SearchablePaginatedDropdownBloc<Country>(
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
                            initialSelectedItem: state.eventCountry,
                          ),
                      child: SearchablePaginatedDropdown<Country>(
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
                      ),
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

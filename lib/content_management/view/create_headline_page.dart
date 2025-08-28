import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/create_headline/create_headline_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/shared.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/searchable_selection_input.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template create_headline_page}
/// A page for creating a new headline.
/// It uses a [BlocProvider] to create and provide a [CreateHeadlineBloc].
/// {@endtemplate}
class CreateHeadlinePage extends StatelessWidget {
  /// {@macro create_headline_page}
  const CreateHeadlinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateHeadlineBloc(
        headlinesRepository: context.read<DataRepository<Headline>>(),
      ),
      child: const _CreateHeadlineView(),
    );
  }
}

class _CreateHeadlineView extends StatefulWidget {
  const _CreateHeadlineView();

  @override
  State<_CreateHeadlineView> createState() => _CreateHeadlineViewState();
}

class _CreateHeadlineViewState extends State<_CreateHeadlineView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _excerptController;
  late final TextEditingController _urlController;
  late final TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    final state = context.read<CreateHeadlineBloc>().state;
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
        title: Text(l10n.createHeadline),
        actions: [
          BlocBuilder<CreateHeadlineBloc, CreateHeadlineState>(
            builder: (context, state) {
              if (state.status == CreateHeadlineStatus.submitting) {
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
                    ? () => context.read<CreateHeadlineBloc>().add(
                        const CreateHeadlineSubmitted(),
                      )
                    : null,
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<CreateHeadlineBloc, CreateHeadlineState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == CreateHeadlineStatus.success &&
              state.createdHeadline != null &&
              ModalRoute.of(context)!.isCurrent) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(l10n.headlineCreatedSuccessfully)),
              );
            context.pop();
          }
          if (state.status == CreateHeadlineStatus.failure) {
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
                          .read<CreateHeadlineBloc>()
                          .add(CreateHeadlineTitleChanged(value)),
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
                          .read<CreateHeadlineBloc>()
                          .add(CreateHeadlineExcerptChanged(value)),
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
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(
                        labelText: l10n.imageUrl,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<CreateHeadlineBloc>()
                          .add(CreateHeadlineImageUrlChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SearchableSelectionInput<Source>(
                      label: l10n.sourceName,
                      selectedItem: state.source,
                      itemBuilder: (context, source) => Text(source.name),
                      itemToString: (source) => source.name,
                      onChanged: (value) => context
                          .read<CreateHeadlineBloc>()
                          .add(CreateHeadlineSourceChanged(value)),
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
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SearchableSelectionInput<Topic>(
                      label: l10n.topicName,
                      selectedItem: state.topic,
                      itemBuilder: (context, topic) => Text(topic.name),
                      itemToString: (topic) => topic.name,
                      onChanged: (value) => context
                          .read<CreateHeadlineBloc>()
                          .add(CreateHeadlineTopicChanged(value)),
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
                          .read<CreateHeadlineBloc>()
                          .add(CreateHeadlineCountryChanged(value)),
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
                        context.read<CreateHeadlineBloc>().add(
                          CreateHeadlineStatusChanged(value),
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

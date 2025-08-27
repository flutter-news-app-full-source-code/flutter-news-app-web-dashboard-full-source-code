import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/edit_source/edit_source_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/searchable_paginated_dropdown/searchable_paginated_dropdown_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/widgets/searchable_paginated_dropdown.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/shared.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template edit_source_page}
/// A page for editing an existing source.
/// It uses a [BlocProvider] to create and provide an [EditSourceBloc].
/// {@endtemplate}
class EditSourcePage extends StatelessWidget {
  /// {@macro edit_source_page}
  const EditSourcePage({required this.source, super.key});

  /// The source to be edited.
  final Source source;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditSourceBloc(
        sourcesRepository: context.read<DataRepository<Source>>(),
        initialSource: source,
      ),
      child: const _EditSourceView(),
    );
  }
}

class _EditSourceView extends StatefulWidget {
  const _EditSourceView();

  @override
  State<_EditSourceView> createState() => _EditSourceViewState();
}

class _EditSourceViewState extends State<_EditSourceView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    final state = context.read<EditSourceBloc>().state;
    _nameController = TextEditingController(text: state.name);
    _descriptionController = TextEditingController(text: state.description);
    _urlController = TextEditingController(text: state.url);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editSource),
        actions: [
          BlocBuilder<EditSourceBloc, EditSourceState>(
            builder: (context, state) {
              if (state.status == EditSourceStatus.submitting) {
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
                    ? () => context.read<EditSourceBloc>().add(
                        const EditSourceSubmitted(),
                      )
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
            // Removed ContentManagementBloc.add(LoadSourcesRequested) as per plan
            context.pop();
          }
          if (state.status == EditSourceStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.exception!.toFriendlyMessage(context)),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
          }
          if (state.initialSource != null) {
            _nameController.text = state.name;
            _descriptionController.text = state.description;
            _urlController.text = state.url;
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
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: l10n.sourceName,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context.read<EditSourceBloc>().add(
                        EditSourceNameChanged(value),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: l10n.description,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (value) => context.read<EditSourceBloc>().add(
                        EditSourceDescriptionChanged(value),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        labelText: l10n.sourceUrl,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context.read<EditSourceBloc>().add(
                        EditSourceUrlChanged(value),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    BlocProvider<SearchablePaginatedDropdownBloc<Language>>(
                      create: (context) =>
                          SearchablePaginatedDropdownBloc<Language>(
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
                            sortOptions: const [
                              SortOption('name', SortOrder.asc),
                            ],
                            limit: kDefaultRowsPerPage,
                            initialSelectedItem: state.language,
                          ),
                      child: SearchablePaginatedDropdown<Language>(
                        label: l10n.language,
                        selectedItem: state.language,
                        itemBuilder: (context, language) => Text(language.name),
                        itemToString: (language) => language.name,
                        onChanged: (value) =>
                            context.read<EditSourceBloc>().add(
                              EditSourceLanguageChanged(value),
                            ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    DropdownButtonFormField<SourceType?>(
                      value: state.sourceType,
                      decoration: InputDecoration(
                        labelText: l10n.sourceType,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: null, child: Text(l10n.none)),
                        ...SourceType.values.map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.localizedName(l10n)),
                          ),
                        ),
                      ],
                      onChanged: (value) => context.read<EditSourceBloc>().add(
                        EditSourceTypeChanged(value),
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
                            initialSelectedItem: state.headquarters,
                          ),
                      child: SearchablePaginatedDropdown<Country>(
                        label: l10n.headquarters,
                        selectedItem: state.headquarters,
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
                        onChanged: (value) =>
                            context.read<EditSourceBloc>().add(
                              EditSourceHeadquartersChanged(value),
                            ),
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
                        context.read<EditSourceBloc>().add(
                          EditSourceStatusChanged(value),
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

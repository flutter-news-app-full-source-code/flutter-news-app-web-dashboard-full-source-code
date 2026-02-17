import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/edit_source/edit_source_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/extensions.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/optimistic_image_cache_service.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/image_upload_field.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/searchable_selection_input.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

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
    return BlocProvider(
      create: (context) => EditSourceBloc(
        sourcesRepository: context.read<DataRepository<Source>>(),
        mediaRepository: context.read<MediaRepository>(),
        optimisticImageCacheService: context
            .read<OptimisticImageCacheService>(),
        sourceId: sourceId,
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
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _urlController = TextEditingController();
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
              // The save button is enabled only if the form is valid.
              return IconButton(
                icon: const Icon(Icons.save),
                tooltip: l10n.saveChanges,
                onPressed: state.isFormValid
                    ? () async {
                        // On edit page, directly save without a prompt.
                        // The status (draft/active) is determined by the original source
                        // and is not changed by this save action unless a specific
                        // "change status" UI element is introduced (out of scope).
                        // For now, we assume the current status is maintained.
                        final originalSource = await context
                            .read<DataRepository<Source>>()
                            .read(id: state.sourceId);

                        if (context.mounted) {
                          if (originalSource.status == ContentStatus.active) {
                            context.read<EditSourceBloc>().add(
                              const EditSourcePublished(),
                            );
                          } else {
                            context.read<EditSourceBloc>().add(
                              const EditSourceSavedAsDraft(),
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
          // Update text controllers when data is loaded or changed
          if (state.status == EditSourceStatus.initial) {
            _nameController.text = state.name;
            _descriptionController.text = state.description;
            _urlController.text = state.url;
          }
        },
        builder: (context, state) {
          if (state.status == EditSourceStatus.loading) {
            return LoadingStateWidget(
              icon: Icons.source,
              headline: l10n.loadingSource,
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.status == EditSourceStatus.failure && state.name.isEmpty) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () =>
                  context.read<EditSourceBloc>().add(const EditSourceLoaded()),
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
                    Text(
                      l10n.logoUrl,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ImageUploadField(
                      optimisticImageBytes: context
                          .read<OptimisticImageCacheService>()
                          .getImage(state.sourceId),
                      initialImageUrl: state.logoUrl,
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
                      selectedItems: state.language != null
                          ? [state.language!]
                          : [],
                      itemBuilder: (context, language) => Text(language.name),
                      itemToString: (language) => language.name,
                      onChanged: (items) => context.read<EditSourceBloc>().add(
                        EditSourceLanguageChanged(items?.first),
                      ),
                      repository: context.read<DataRepository<Language>>(),
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
                    SearchableSelectionInput<SourceType>(
                      label: l10n.sourceType,
                      selectedItems: state.sourceType != null
                          ? [state.sourceType!]
                          : [],
                      staticItems: SourceType.values.toList(),
                      itemBuilder: (context, type) =>
                          Text(type.localizedName(l10n)),
                      itemToString: (type) => type.localizedName(l10n),
                      onChanged: (items) => context.read<EditSourceBloc>().add(
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
                          Text(country.name),
                        ],
                      ),
                      itemToString: (country) => country.name,
                      onChanged: (items) => context.read<EditSourceBloc>().add(
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
                      sortOptions: const [
                        SortOption('name', SortOrder.asc),
                      ],
                      limit: kDefaultRowsPerPage,
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

import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/create_source/create_source_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/extensions.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/image_upload_field.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/searchable_selection_input.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template create_source_page}
/// A page for creating a new source.
/// It uses a [BlocProvider] to create and provide a [CreateSourceBloc].
/// {@endtemplate}
class CreateSourcePage extends StatelessWidget {
  /// {@macro create_source_page}
  const CreateSourcePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateSourceBloc(
        sourcesRepository: context.read<DataRepository<Source>>(),
        mediaRepository: context.read<MediaRepository>(),
        logger: Logger('CreateSourceBloc'),
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

class _CreateSourceViewState extends State<CreateSourceView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    final state = context.read<CreateSourceBloc>().state;
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
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createSource),
        actions: [
          BlocBuilder<CreateSourceBloc, CreateSourceState>(
            builder: (context, state) {
              if (state.status == CreateSourceStatus.imageUploading ||
                  state.status == CreateSourceStatus.entitySubmitting) {
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
              state.status == CreateSourceStatus.entitySubmitFailure) {
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
                      onChanged: (value) => context
                          .read<CreateSourceBloc>()
                          .add(CreateSourceNameChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: l10n.description,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (value) => context
                          .read<CreateSourceBloc>()
                          .add(CreateSourceDescriptionChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
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
                    SearchableSelectionInput<Language>(
                      label: l10n.language,
                      selectedItems: state.language != null
                          ? [state.language!]
                          : [],
                      itemBuilder: (context, language) => Text(language.name),
                      itemToString: (language) => language.name,
                      onChanged: (items) => context
                          .read<CreateSourceBloc>()
                          .add(CreateSourceLanguageChanged(items?.first)),
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
                      onChanged: (items) => context
                          .read<CreateSourceBloc>()
                          .add(CreateSourceTypeChanged(items?.first)),
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
                      onChanged: (items) => context
                          .read<CreateSourceBloc>()
                          .add(CreateSourceHeadquartersChanged(items?.first)),
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

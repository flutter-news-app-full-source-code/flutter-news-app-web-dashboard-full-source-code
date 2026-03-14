import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:verity_dashboard/app/bloc/app_bloc.dart';
import 'package:verity_dashboard/content_management/bloc/create_person/create_person_bloc.dart';
import 'package:verity_dashboard/l10n/l10n.dart';
import 'package:verity_dashboard/shared/data/enrichment_repository.dart';
import 'package:verity_dashboard/shared/extensions/supported_language_flag.dart';
import 'package:verity_dashboard/shared/widgets/image_upload_field.dart';
import 'package:verity_dashboard/shared/widgets/localized_text_form_field.dart';

class CreatePersonPage extends StatelessWidget {
  const CreatePersonPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppBloc>().state;
    final localizationConfig = appState.remoteConfig?.app.localization;

    final defaultLanguage =
        localizationConfig?.defaultLanguage ?? SupportedLanguage.en;
    var enabledLanguages =
        localizationConfig?.enabledLanguages ?? [SupportedLanguage.en];

    final userLanguage = appState.appSettings?.language ?? defaultLanguage;
    if (enabledLanguages.contains(userLanguage)) {
      enabledLanguages = [
        userLanguage,
        ...enabledLanguages.where((l) => l != userLanguage),
      ];
    }

    return BlocProvider(
      create: (context) =>
          CreatePersonBloc(
            personsRepository: context.read<DataRepository<Person>>(),
            enrichmentRepository: context.read<EnrichmentRepository>(),
            mediaRepository: context.read<MediaRepository>(),
            logger: Logger('CreatePersonBloc'),
          )..add(
            CreatePersonInitialized(
              enabledLanguages: enabledLanguages,
              defaultLanguage: defaultLanguage,
            ),
          ),
      child: const CreatePersonView(),
    );
  }
}

class CreatePersonView extends StatefulWidget {
  const CreatePersonView({super.key});

  @override
  State<CreatePersonView> createState() => _CreatePersonViewState();
}

class _CreatePersonViewState extends State<CreatePersonView> {
  final _formKey = GlobalKey<FormState>();

  Future<ContentStatus?> _showSaveOptionsDialog(BuildContext context) async {
    final l10n = AppLocalizationsX(context).l10n;
    return showDialog<ContentStatus>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.savePersonTitle),
        content: Text(l10n.savePersonMessage),
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
        title: Text(l10n.createPerson),
        actions: [
          BlocBuilder<CreatePersonBloc, CreatePersonState>(
            builder: (context, state) {
              if (state.status == CreatePersonStatus.imageUploading ||
                  state.status == CreatePersonStatus.entitySubmitting ||
                  state.status == CreatePersonStatus.enriching) {
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
                        state.name.values.any((v) => v.isNotEmpty) &&
                            !state.isEnrichmentSuccessful
                        ? () => context.read<CreatePersonBloc>().add(
                            const CreatePersonEnrichmentRequested(),
                          )
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.save),
                    tooltip: l10n.saveChanges,
                    onPressed: state.isFormValid
                        ? () async {
                            final status = await _showSaveOptionsDialog(
                              context,
                            );
                            if (status == ContentStatus.active &&
                                context.mounted) {
                              context.read<CreatePersonBloc>().add(
                                const CreatePersonPublished(),
                              );
                            } else if (status == ContentStatus.draft &&
                                context.mounted) {
                              context.read<CreatePersonBloc>().add(
                                const CreatePersonSavedAsDraft(),
                              );
                            }
                          }
                        : null,
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<CreatePersonBloc, CreatePersonState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == CreatePersonStatus.success &&
              state.createdPerson != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(l10n.personCreatedSuccessfully)),
              );
            context.pop();
          }
          if (state.status == CreatePersonStatus.imageUploadFailure ||
              state.status == CreatePersonStatus.entitySubmitFailure ||
              state.status == CreatePersonStatus.enrichmentFailure) {
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
          return DefaultTabController(
            length: state.enabledLanguages.length,
            child: SafeArea(
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
                              context.read<CreatePersonBloc>().add(
                                CreatePersonLanguageTabChanged(
                                  state.enabledLanguages[index],
                                ),
                              ),
                          tabs: state.enabledLanguages.map((lang) {
                            final hasContent =
                                state.name[lang]?.isNotEmpty ??
                                state.description[lang]?.isNotEmpty ??
                                false;
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
                                      state.isEnrichmentSuccessful &&
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
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            LocalizedTextFormField(
                              label: l10n.personName,
                              values: state.name,
                              enabledLanguages: state.enabledLanguages,
                              selectedLanguage: state.selectedLanguage,
                              onChanged: (values) => context
                                  .read<CreatePersonBloc>()
                                  .add(CreatePersonNameChanged(values)),
                              validator: (values) {
                                if (values?[state.defaultLanguage]?.isEmpty ??
                                    true) {
                                  return l10n.defaultLanguageRequired(
                                    state.defaultLanguage.name.toUpperCase(),
                                  );
                                }
                                return null;
                              },
                            ),
                            if (state.wasNameEnriched)
                              Positioned(
                                top: 6,
                                right: 8,
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
                            LocalizedTextFormField(
                              label: l10n.personDescription,
                              values: state.description,
                              enabledLanguages: state.enabledLanguages,
                              selectedLanguage: state.selectedLanguage,
                              onChanged: (values) => context
                                  .read<CreatePersonBloc>()
                                  .add(CreatePersonDescriptionChanged(values)),
                            ),
                            if (state.wasDescriptionEnriched)
                              Positioned(
                                top: 6,
                                right: 8,
                                child: Icon(
                                  Icons.auto_awesome,
                                  size: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        ImageUploadField(
                          onChanged: (Uint8List? bytes, String? fileName) {
                            final bloc = context.read<CreatePersonBloc>();
                            if (bytes == null || fileName == null) {
                              bloc.add(const CreatePersonImageRemoved());
                              return;
                            }
                            bloc.add(
                              CreatePersonImageChanged(
                                imageFileBytes: bytes,
                                imageFileName: fileName,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

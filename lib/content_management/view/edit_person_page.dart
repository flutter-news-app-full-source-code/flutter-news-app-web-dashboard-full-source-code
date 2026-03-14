import 'dart:typed_data';
import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:verity_dashboard/app/bloc/app_bloc.dart';
import 'package:verity_dashboard/content_management/bloc/edit_person/edit_person_bloc.dart';
import 'package:verity_dashboard/l10n/l10n.dart';
import 'package:verity_dashboard/shared/extensions/supported_language_flag.dart';
import 'package:verity_dashboard/shared/widgets/image_upload_field.dart';
import 'package:verity_dashboard/shared/widgets/localized_text_form_field.dart';

class EditPersonPage extends StatelessWidget {
  const EditPersonPage({required this.personId, super.key});

  final String personId;

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
          EditPersonBloc(
            personsRepository: context.read<DataRepository<Person>>(),
            mediaRepository: context.read<MediaRepository>(),
            personId: personId,
            logger: Logger('EditPersonBloc'),
          )..add(
            EditPersonLoaded(
              enabledLanguages: enabledLanguages,
              defaultLanguage: defaultLanguage,
            ),
          ),
      child: const EditPersonView(),
    );
  }
}

class EditPersonView extends StatefulWidget {
  const EditPersonView({super.key});

  @override
  State<EditPersonView> createState() => _EditPersonViewState();
}

class _EditPersonViewState extends State<EditPersonView> {
  final _formKey = GlobalKey<FormState>();

  Future<ContentStatus?> _showSaveOptionsDialog(BuildContext context) async {
    final l10n = AppLocalizationsX(context).l10n;
    return showDialog<ContentStatus>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.updatePersonTitle),
        content: Text(l10n.updatePersonMessage),
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
        title: Text(l10n.editPerson),
        actions: [
          BlocBuilder<EditPersonBloc, EditPersonState>(
            builder: (context, state) {
              if (state.status == EditPersonStatus.imageUploading ||
                  state.status == EditPersonStatus.entitySubmitting) {
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
                    ? () async {
                        final status = await _showSaveOptionsDialog(context);
                        if (status == ContentStatus.active && context.mounted) {
                          context.read<EditPersonBloc>().add(
                            const EditPersonPublished(),
                          );
                        } else if (status == ContentStatus.draft &&
                            context.mounted) {
                          context.read<EditPersonBloc>().add(
                            const EditPersonSavedAsDraft(),
                          );
                        }
                      }
                    : null,
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<EditPersonBloc, EditPersonState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == EditPersonStatus.success &&
              state.updatedPerson != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(l10n.personUpdatedSuccessfully)),
              );
            context.pop();
          }
          if (state.status == EditPersonStatus.imageUploadFailure ||
              state.status == EditPersonStatus.entitySubmitFailure) {
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
          if (state.status == EditPersonStatus.loading) {
            return LoadingStateWidget(
              icon: Icons.person,
              headline: l10n.loadingPerson,
              subheadline: l10n.pleaseWait,
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
                        onTap: (index) => context.read<EditPersonBloc>().add(
                          EditPersonLanguageTabChanged(
                            state.enabledLanguages[index],
                          ),
                        ),
                        tabs: state.enabledLanguages
                            .map(
                              (lang) => Tab(
                                icon: Image.network(
                                  lang.flagUrl,
                                  width: 24,
                                  errorBuilder: (_, _, _) =>
                                      const Icon(Icons.flag, size: 16),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      LocalizedTextFormField(
                        label: l10n.personName,
                        values: state.name,
                        enabledLanguages: state.enabledLanguages,
                        selectedLanguage: state.selectedLanguage,
                        onChanged: (values) => context
                            .read<EditPersonBloc>()
                            .add(EditPersonNameChanged(values)),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      LocalizedTextFormField(
                        label: l10n.personDescription,
                        values: state.description,
                        enabledLanguages: state.enabledLanguages,
                        selectedLanguage: state.selectedLanguage,
                        onChanged: (values) => context
                            .read<EditPersonBloc>()
                            .add(EditPersonDescriptionChanged(values)),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      ImageUploadField(
                        initialImageUrl: state.imageUrl,
                        onChanged: (Uint8List? bytes, String? fileName) {
                          if (bytes == null || fileName == null) {
                            context.read<EditPersonBloc>().add(
                              const EditPersonImageRemoved(),
                            );
                            return;
                          }
                          context.read<EditPersonBloc>().add(
                            EditPersonImageChanged(
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
          );
        },
      ),
    );
  }
}

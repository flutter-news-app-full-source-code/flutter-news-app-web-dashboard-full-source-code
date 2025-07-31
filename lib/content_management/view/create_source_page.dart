import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/create_source/create_source_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/extensions/source_type_l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/shared.dart';
import 'package:go_router/go_router.dart';
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
        countriesRepository: context.read<DataRepository<Country>>(),
        languagesRepository: context.read<DataRepository<Language>>(),
      )..add(const CreateSourceDataLoaded()),
      child: const _CreateSourceView(),
    );
  }
}

class _CreateSourceView extends StatefulWidget {
  const _CreateSourceView();

  @override
  State<_CreateSourceView> createState() => _CreateSourceViewState();
}

class _CreateSourceViewState extends State<_CreateSourceView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createSource),
        actions: [
          BlocBuilder<CreateSourceBloc, CreateSourceState>(
            builder: (context, state) {
              if (state.status == CreateSourceStatus.submitting) {
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
                    ? () => context.read<CreateSourceBloc>().add(
                        const CreateSourceSubmitted(),
                      )
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
            context.read<ContentManagementBloc>().add(
              // Refresh the list to show the new source
              const LoadSourcesRequested(limit: kDefaultRowsPerPage),
            );
            context.pop();
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
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () => context.read<CreateSourceBloc>().add(
                const CreateSourceDataLoaded(),
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
                      initialValue: state.name,
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
                      initialValue: state.description,
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
                      initialValue: state.url,
                      decoration: InputDecoration(
                        labelText: l10n.sourceUrl,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<CreateSourceBloc>()
                          .add(CreateSourceUrlChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    LanguageDropdownFormField(
                      labelText: l10n.language,
                      languages: state.languages,
                      initialValue: state.language,
                      onChanged: (value) => context
                          .read<CreateSourceBloc>()
                          .add(CreateSourceLanguageChanged(value)),
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
                      onChanged: (value) => context
                          .read<CreateSourceBloc>()
                          .add(CreateSourceTypeChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    CountryDropdownFormField(
                      labelText: l10n.headquarters,
                      countries: state.countries,
                      initialValue: state.headquarters,
                      onChanged: (value) => context
                          .read<CreateSourceBloc>()
                          .add(CreateSourceHeadquartersChanged(value)),
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
                        context.read<CreateSourceBloc>().add(
                          CreateSourceStatusChanged(value),
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

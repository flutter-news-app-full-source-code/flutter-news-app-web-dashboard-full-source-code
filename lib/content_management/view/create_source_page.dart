import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_dashboard/content_management/bloc/content_management_bloc.dart';
import 'package:ht_dashboard/content_management/bloc/create_source/create_source_bloc.dart';
import 'package:ht_dashboard/content_management/bloc/edit_source/edit_source_bloc.dart';
import 'package:ht_dashboard/l10n/l10n.dart';
import 'package:ht_dashboard/shared/constants/pagination_constants.dart';
import 'package:ht_dashboard/shared/shared.dart';
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_shared/ht_shared.dart';

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
        sourcesRepository: context.read<HtDataRepository<Source>>(),
        countriesRepository: context.read<HtDataRepository<Country>>(),
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
    final l10n = context.l10n;
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
              ModalRoute.of(context)!.isCurrent) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(l10n.sourceCreatedSuccessfully)),
              );
            context.read<ContentManagementBloc>().add(
              const LoadSourcesRequested(
                limit: kDefaultRowsPerPage,
              ),
            );
            context.pop();
          }
          if (state.status == CreateSourceStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? l10n.unknownError),
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

          if (state.status == CreateSourceStatus.failure &&
              state.countries.isEmpty) {
            return FailureStateWidget(
              message: state.errorMessage ?? l10n.unknownError,
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
                    TextFormField(
                      initialValue: state.language,
                      decoration: InputDecoration(
                        labelText: l10n.language,
                        border: const OutlineInputBorder(),
                      ),
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
                    DropdownButtonFormField<Country?>(
                      value: state.headquarters,
                      decoration: InputDecoration(
                        labelText: l10n.headquarters,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: null, child: Text(l10n.none)),
                        ...state.countries.map(
                          (country) => DropdownMenuItem(
                            value: country,
                            child: Text(country.name),
                          ),
                        ),
                      ],
                      onChanged: (value) => context
                          .read<CreateSourceBloc>()
                          .add(CreateSourceHeadquartersChanged(value)),
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

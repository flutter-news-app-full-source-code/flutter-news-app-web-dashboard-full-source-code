import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/create_headline/create_headline_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/dashboard/bloc/dashboard_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/shared.dart';
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
        sourcesRepository: context.read<DataRepository<Source>>(),
        topicsRepository: context.read<DataRepository<Topic>>(),
        countriesRepository: context.read<DataRepository<Country>>(),
      )..add(const CreateHeadlineDataLoaded()),
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
            context.read<ContentManagementBloc>().add(
              // Refresh the list to show the new headline
              const LoadHeadlinesRequested(limit: kDefaultRowsPerPage),
            );
            context.read<DashboardBloc>().add(DashboardSummaryLoaded());
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
          if (state.status == CreateHeadlineStatus.loading) {
            return LoadingStateWidget(
              icon: Icons.newspaper,
              headline: l10n.loadingData,
              subheadline: l10n.pleaseWait,
            );
          }

          if (state.status == CreateHeadlineStatus.failure &&
              state.sources.isEmpty &&
              state.topics.isEmpty) {
            return FailureStateWidget(
              exception: state.exception!,
              onRetry: () => context.read<CreateHeadlineBloc>().add(
                const CreateHeadlineDataLoaded(),
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
                      initialValue: state.title,
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
                      initialValue: state.excerpt,
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
                      initialValue: state.url,
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
                      initialValue: state.imageUrl,
                      decoration: InputDecoration(
                        labelText: l10n.imageUrl,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => context
                          .read<CreateHeadlineBloc>()
                          .add(CreateHeadlineImageUrlChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    DropdownButtonFormField<Source?>(
                      value: state.source,
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
                          .read<CreateHeadlineBloc>()
                          .add(CreateHeadlineSourceChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    DropdownButtonFormField<Topic?>(
                      value: state.topic,
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
                          .read<CreateHeadlineBloc>()
                          .add(CreateHeadlineTopicChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    DropdownButtonFormField<Country?>(
                      value: state.eventCountry,
                      decoration: InputDecoration(
                        labelText: l10n.countryName,
                        border: const OutlineInputBorder(),
                        helperText: state.countriesIsLoadingMore
                            ? l10n.loadingFullList
                            : null,
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
                      ],
                      onChanged: state.countriesIsLoadingMore
                          ? null
                          : (value) => context.read<CreateHeadlineBloc>().add(
                              CreateHeadlineCountryChanged(value),
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

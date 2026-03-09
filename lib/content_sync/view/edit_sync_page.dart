import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:verity_dashboard/content_sync/bloc/edit_sync/edit_sync_bloc.dart';
import 'package:verity_dashboard/l10n/l10n.dart';
import 'package:verity_dashboard/shared/extensions/multilingual_map_extension.dart';

class EditSyncPage extends StatelessWidget {
  const EditSyncPage({required this.syncId, super.key});
  final String syncId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditSyncBloc(
        automationRepository: context
            .read<DataRepository<NewsAutomationTask>>(),
        sourcesRepository: context.read<DataRepository<Source>>(),
        logger: Logger('EditSyncBloc'),
      )..add(EditSyncStarted(syncId)),
      child: const EditSyncView(),
    );
  }
}

class EditSyncView extends StatelessWidget {
  const EditSyncView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editSync),
        actions: [
          BlocBuilder<EditSyncBloc, EditSyncState>(
            builder: (context, state) {
              return IconButton(
                icon: state.status == EditSyncStatus.submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                onPressed:
                    state.isFormValid &&
                        state.status != EditSyncStatus.submitting
                    ? () => context.read<EditSyncBloc>().add(
                        const EditSyncSubmitted(),
                      )
                    : null,
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<EditSyncBloc, EditSyncState>(
        listener: (context, state) {
          if (state.status == EditSyncStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.syncUpdatedSuccessfully)),
            );
            context.pop();
          }
        },
        builder: (context, state) {
          if (state.status == EditSyncStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.task == null || state.source == null) {
            return const SizedBox.shrink();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundImage: state.source!.logoUrl != null
                        ? NetworkImage(state.source!.logoUrl!)
                        : null,
                    child: state.source!.logoUrl == null
                        ? const Icon(Icons.source)
                        : null,
                  ),
                  title: Text(state.source!.name.getValue(context)),
                  subtitle: Text(state.source!.url),
                ),
                const SizedBox(height: AppSpacing.xl),
                DropdownButtonFormField<FetchInterval>(
                  value: state.task!.fetchInterval,
                  decoration: InputDecoration(
                    labelText: l10n.syncFrequency,
                    border: const OutlineInputBorder(),
                  ),
                  items: FetchInterval.values.map((interval) {
                    return DropdownMenuItem(
                      value: interval,
                      child: Text(interval.name), // TODO: Localize
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      context.read<EditSyncBloc>().add(
                        EditSyncFrequencyChanged(value),
                      );
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                DropdownButtonFormField<IngestionStatus>(
                  value: state.task!.status,
                  decoration: InputDecoration(
                    labelText: l10n.syncStatus,
                    border: const OutlineInputBorder(),
                  ),
                  items: IngestionStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status.name), // TODO: Localize
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      context.read<EditSyncBloc>().add(
                        EditSyncStatusChanged(value),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:verity_dashboard/content_sync/bloc/create_sync/create_sync_bloc.dart';
import 'package:verity_dashboard/l10n/l10n.dart';
import 'package:verity_dashboard/shared/extensions/fetch_interval_extension.dart';
import 'package:verity_dashboard/shared/extensions/multilingual_map_extension.dart';
import 'package:verity_dashboard/shared/widgets/searchable_selection_input.dart';

class CreateSyncPage extends StatelessWidget {
  const CreateSyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createSync),
        actions: [
          BlocBuilder<CreateSyncBloc, CreateSyncState>(
            builder: (context, state) {
              return IconButton(
                icon: state.status == CreateSyncStatus.submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                onPressed:
                    state.isFormValid &&
                        state.status != CreateSyncStatus.submitting
                    ? () => context.read<CreateSyncBloc>().add(
                        const CreateSyncSubmitted(),
                      )
                    : null,
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<CreateSyncBloc, CreateSyncState>(
        listener: (context, state) {
          if (state.status == CreateSyncStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.syncCreatedSuccessfully)),
            );
            context.pop();
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchableSelectionInput<Source>(
                  label: l10n.source,
                  selectedItems: state.source != null ? [state.source!] : [],
                  itemBuilder: (context, source) => Text(
                    source.name.getValue(context),
                  ),
                  itemToString: (source) => source.name.getValue(context),
                  onChanged: (items) {
                    context.read<CreateSyncBloc>().add(
                      CreateSyncSourceChanged(items?.firstOrNull),
                    );
                  },
                  repository: context.read<DataRepository<Source>>(),
                  filterBuilder: (searchTerm) => searchTerm == null
                      ? {}
                      : {
                          'name': {
                            r'$regex': searchTerm,
                            r'$options': 'i',
                          },
                        },
                  limit: kDefaultRowsPerPage,
                ),
                const SizedBox(height: AppSpacing.lg),
                DropdownButtonFormField<FetchInterval>(
                  value: state.frequency,
                  decoration: InputDecoration(
                    labelText: l10n.syncFrequency,
                    border: const OutlineInputBorder(),
                  ),
                  items: FetchInterval.values.map((interval) {
                    return DropdownMenuItem(
                      value: interval,
                      child: Text(interval.localizedName(l10n)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      context.read<CreateSyncBloc>().add(
                        CreateSyncFrequencyChanged(value),
                      );
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  l10n.contentSyncDescription,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:verity_dashboard/content_sync/bloc/content_sync_bloc.dart';
import 'package:verity_dashboard/l10n/app_localizations.dart';
import 'package:verity_dashboard/router/routes.dart';
import 'package:verity_dashboard/shared/widgets/confirmation_dialog.dart';

class SyncActionButtons extends StatelessWidget {
  const SyncActionButtons({required this.task, required this.l10n, super.key});

  final NewsAutomationTask task;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, size: 20),
          tooltip: l10n.editSync,
          onPressed: () => context.goNamed(
            Routes.editSyncName,
            pathParameters: {'id': task.id},
          ),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, size: 20),
          onSelected: (value) => _handleAction(context, value),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'toggle',
              child: Text(
                task.status == IngestionStatus.active
                    ? l10n.stopSync
                    : l10n.resumeSync,
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text(
                l10n.deleteSync,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleAction(BuildContext context, String value) {
    final bloc = context.read<ContentSyncBloc>();
    if (value == 'toggle') {
      final newStatus = task.status == IngestionStatus.active
          ? IngestionStatus.paused
          : IngestionStatus.active;
      bloc.add(ContentSyncStatusToggled(task.id, newStatus));
    } else if (value == 'delete') {
      showDialog<void>(
        context: context,
        builder: (context) => ConfirmationDialog(
          title: l10n.deleteSync,
          content: l10n.confirmStopSyncMessage, // Reusing key or adding new
          confirmText: l10n.deleteSync,
          onConfirm: () => bloc.add(ContentSyncTaskDeleted(task.id)),
        ),
      );
    }
  }
}

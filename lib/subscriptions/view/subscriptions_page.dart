import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/about_icon.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/subscriptions/view/subscriptions_list_view.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_kit/ui_kit.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
        final l10n = AppLocalizationsX(context).l10n;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.subscriptionsName),
            const SizedBox(width: AppSpacing.xs),
            AboutIcon(
              dialogTitle: l10n.subscriptionsName,
              dialogDescription: l10n.subscriptionsPageDescription,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: l10n.filter,
            onPressed: () {
              context.pushNamed(Routes.subscriptionsFilterDialogName);
            },
          ),
        ],
      ),
      body: const SubscriptionsListView(),
    );
  }
}

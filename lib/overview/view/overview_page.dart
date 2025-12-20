import 'package:flutter/material.dart';

/// {@template overview_page}
/// The main dashboard overview page, displaying key statistics and quick actions.
/// {@endtemplate}
class OverviewPage extends StatefulWidget {
  /// {@macro overview_page}
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  @override
  Widget build(BuildContext context) {
    // final l10n = AppLocalizationsX(context).l10n;
    return const Scaffold(
      body: Placeholder(),
    );
  }
}

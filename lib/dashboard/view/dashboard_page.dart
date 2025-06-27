import 'package:flutter/material.dart';

/// {@template dashboard_page}
/// A placeholder page for the dashboard.
/// {@endtemplate}
class DashboardPage extends StatelessWidget {
  /// {@macro dashboard_page}
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Welcome to the Dashboard!'),
      ),
    );
  }
}

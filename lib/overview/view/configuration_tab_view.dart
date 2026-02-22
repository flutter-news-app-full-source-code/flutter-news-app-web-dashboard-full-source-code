import 'package:flutter/material.dart';

/// This widget is obsolete and has been replaced by the status view
/// in the main Overview tab. It is kept to avoid breaking file structures
/// and can be deleted.
class ConfigurationTabView extends StatelessWidget {
  const ConfigurationTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

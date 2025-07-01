import 'package:flutter/material.dart';

/// {@template placeholder_create_page}
/// A simple placeholder page for content creation forms.
/// {@endtemplate}
class PlaceholderCreatePage extends StatelessWidget {
  /// {@macro placeholder_create_page}
  const PlaceholderCreatePage({required this.title, super.key});

  /// The title to display on the page.
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('Form for "$title" will go here.'),
      ),
    );
  }
}

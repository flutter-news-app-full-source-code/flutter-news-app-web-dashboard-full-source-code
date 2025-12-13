import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/app_constants.dart';
import 'package:ui_kit/ui_kit.dart';

/// {@template auth_layout}
/// A responsive layout for authentication pages.
///
/// It centers the content and constrains its width for a better
/// visual experience on larger screens, while allowing it to be
/// scrollable on smaller screens.
/// {@endtemplate}
class AuthLayout extends StatelessWidget {
  /// {@macro auth_layout}
  const AuthLayout({required this.child, super.key});

  /// The child widget to display within the layout.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppConstants.kMaxAuthWidth,
          ),
          child: SingleChildScrollView(child: child),
        ),
      ),
    );
  }
}

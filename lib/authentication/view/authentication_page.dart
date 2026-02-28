import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/authentication/widgets/auth_layout.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:go_router/go_router.dart';

/// {@template authentication_page}
/// Displays authentication options for the dashboard.
///
/// This page provides a secure sign-in method for administrators and
/// publishers via email.
/// {@endtemplate}
class AuthenticationPage extends StatelessWidget {
  /// {@macro authentication_page}
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          // Listener remains crucial for feedback (errors)
          listener: (context, state) {
            if (state.status == AuthenticationStatus.failure &&
                state.exception != null) {
              final friendlyMessage = state.exception!.toFriendlyMessage(
                context,
              );
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(friendlyMessage),
                    backgroundColor: colorScheme.error,
                  ),
                );
            }
            // Success states (Google/Anonymous) are typically handled by
            // the AppBloc listening to repository changes and triggering
            // redirects. Email link success is handled in the dedicated
            // email flow pages.
          },
          builder: (context, state) {
            final isLoading =
                state.status == AuthenticationStatus.loading ||
                state.status == AuthenticationStatus.requestCodeLoading;

            return AuthLayout(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- Icon ---
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                    child: Icon(
                      Icons.newspaper,
                      size: AppSpacing.xxl * 2,
                      color: colorScheme.primary,
                    ),
                  ),
                  // --- Headline and Subheadline ---
                  Text(
                    l10n.authenticationPageHeadline,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.authenticationPageSubheadline,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // --- Email Sign-In Button ---
                  ElevatedButton.icon(
                    icon: const Icon(Icons.email_outlined),
                    onPressed: isLoading
                        ? null
                        : () => context.goNamed(Routes.requestCodeName),
                    label: Text(l10n.authenticationEmailSignInButton),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      textStyle: textTheme.labelLarge,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

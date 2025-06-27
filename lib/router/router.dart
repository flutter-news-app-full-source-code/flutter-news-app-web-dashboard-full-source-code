import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_auth_repository/ht_auth_repository.dart';
import 'package:ht_dashboard/app/bloc/app_bloc.dart';
import 'package:ht_dashboard/app/config/config.dart' as local_config;
import 'package:ht_dashboard/app/view/app_shell.dart';
import 'package:ht_dashboard/authentication/bloc/authentication_bloc.dart';
import 'package:ht_dashboard/authentication/view/authentication_page.dart';
import 'package:ht_dashboard/authentication/view/email_code_verification_page.dart';
import 'package:ht_dashboard/authentication/view/request_code_page.dart';
import 'package:ht_dashboard/l10n/l10n.dart';
import 'package:ht_dashboard/router/routes.dart';
import 'package:ht_dashboard/app_configuration/view/app_configuration_page.dart';
import 'package:ht_dashboard/content_management/view/categories_page.dart';
import 'package:ht_dashboard/content_management/view/content_management_page.dart';
import 'package:ht_dashboard/content_management/view/headlines_page.dart';
import 'package:ht_dashboard/content_management/view/sources_page.dart';
import 'package:ht_dashboard/dashboard/view/dashboard_page.dart';
import 'package:ht_dashboard/settings/view/settings_page.dart';
import 'package:ht_shared/ht_shared.dart';

/// Creates and configures the GoRouter instance for the application.
///
/// Requires an [authStatusNotifier] to trigger route re-evaluation when
/// authentication state changes.
GoRouter createRouter({
  required ValueNotifier<AppStatus> authStatusNotifier,
  required HtAuthRepository htAuthenticationRepository,
  required local_config.AppEnvironment environment,
}) {
  return GoRouter(
    refreshListenable: authStatusNotifier,
    initialLocation: Routes.authentication,
    debugLogDiagnostics: true,
    // --- Redirect Logic ---
    redirect: (BuildContext context, GoRouterState state) {
      final appStatus = context.read<AppBloc>().state.status;
      final currentLocation = state.matchedLocation;

      print(
        'GoRouter Redirect Check:\n'
        '  Current Location (Matched): $currentLocation\n'
        '  AppStatus: $appStatus\n',
      );

      // --- Define Key Paths ---
      const authenticationPath = Routes.authentication;
      const dashboardPath = Routes.dashboard;
      final isGoingToAuth = currentLocation.startsWith(authenticationPath);
      final isGoingToDashboard = currentLocation.startsWith(dashboardPath);

      // --- Case 1: Unauthenticated User ---
      if (appStatus == AppStatus.unauthenticated ||
          appStatus == AppStatus.initial) {
        print('  Redirect Decision: User is UNauthenticated or INITIAL.');
        if (!isGoingToAuth) {
          print(
            '    Action: Not going to auth. Redirecting to $authenticationPath',
          );
          return authenticationPath;
        }
        print('    Action: Already going to auth. Allowing navigation.');
        return null;
      }

      // --- Case 2: Authenticated User ---
      if (appStatus == AppStatus.authenticated) {
        print('  Redirect Decision: User is $appStatus.');

        // If an authenticated user is on any authentication-related path:
        if (isGoingToAuth) {
          print(
            '    Action: Authenticated user on auth path ($currentLocation). '
            'Redirecting to $dashboardPath',
          );
          return dashboardPath;
        }
        // Allow access to other routes (non-auth paths), which should only be dashboard for now
        print(
          '    Action: Allowing navigation to $currentLocation for $appStatus '
          'user (non-auth path).',
        );
        return null;
      }

      // Fallback (should ideally not be reached if all statuses are handled)
      print(
        '  Redirect Decision: Fallback, no specific condition met for $appStatus. '
        'Allowing navigation.',
      );
      return null;
    },
    // --- Routes ---
    routes: [
      GoRoute(
        path: Routes.authentication,
        name: Routes.authenticationName,
        builder: (BuildContext context, GoRouterState state) {
          final l10n = context.l10n;
          const String headline = 'Sign In to Dashboard';
          const String subHeadline =
              'Enter your email to get a verification code.';
          const bool showAnonymousButton = false;

          return BlocProvider(
            create: (context) => AuthenticationBloc(
              authenticationRepository: context.read<HtAuthRepository>(),
            ),
            child: const AuthenticationPage(
              headline: headline,
              subHeadline: subHeadline,
              showAnonymousButton: showAnonymousButton,
            ),
          );
        },
        routes: [
          GoRoute(
            path: Routes.requestCode,
            name: Routes.requestCodeName,
            builder: (context, state) =>
                const RequestCodePage(isLinkingContext: false),
          ),
          GoRoute(
            path: '${Routes.verifyCode}/:email',
            name: Routes.verifyCodeName,
            builder: (context, state) {
              final email = state.pathParameters['email']!;
              return EmailCodeVerificationPage(email: email);
            },
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.dashboard,
                name: Routes.dashboardName,
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.contentManagement,
                name: Routes.contentManagementName,
                builder: (context, state) => const ContentManagementPage(),
                routes: [
                  GoRoute(
                    path: Routes.headlines,
                    name: Routes.headlinesName,
                    builder: (context, state) => const HeadlinesPage(),
                  ),
                  GoRoute(
                    path: Routes.categories,
                    name: Routes.categoriesName,
                    builder: (context, state) => const CategoriesPage(),
                  ),
                  GoRoute(
                    path: Routes.sources,
                    name: Routes.sourcesName,
                    builder: (context, state) => const SourcesPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.appConfiguration,
                name: Routes.appConfigurationName,
                builder: (context, state) => const AppConfigurationPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settings,
                name: Routes.settingsName,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

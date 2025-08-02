import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app/bloc/app_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app/config/config.dart'
    as local_config;
import 'package:flutter_news_app_web_dashboard_full_source_code/app/view/app_shell.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/view/app_configuration_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/authentication/view/authentication_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/authentication/view/email_code_verification_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/authentication/view/request_code_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/content_management_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/create_headline_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/create_source_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/create_topic_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/edit_headline_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/edit_source_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/edit_topic_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/archived_content_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/dashboard/view/dashboard_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/settings/view/settings_page.dart';
import 'package:go_router/go_router.dart';

/// Creates and configures the GoRouter instance for the application.
///
/// Requires an [authStatusNotifier] to trigger route re-evaluation when
/// authentication state changes.
GoRouter createRouter({
  required ValueNotifier<AppStatus> authStatusNotifier,
  required AuthRepository authenticationRepository,
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
          return BlocProvider(
            create: (context) => AuthenticationBloc(
              authenticationRepository: context.read<AuthRepository>(),
            ),
            child: const AuthenticationPage(),
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
                routes: [
                  // The settings page is a sub-route of the dashboard.
                  // This allows it to be displayed within the AppShell
                  // (with sidebar and top bar visible) without adding
                  // a new item to the main navigation sidebar.
                  GoRoute(
                    path: Routes.settings,
                    name: Routes.settingsName,
                    builder: (context, state) => const SettingsPage(),
                  ),
                ],
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
                  // The create/edit routes are now direct children of
                  // content-management, so navigating back will always land on
                  // the ContentManagementPage with the correct AppBar/TabBar.
                  GoRoute(
                    path: Routes.createHeadline,
                    name: Routes.createHeadlineName,
                    builder: (context, state) => const CreateHeadlinePage(),
                  ),
                  GoRoute(
                    path: Routes.editHeadline,
                    name: Routes.editHeadlineName,
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return EditHeadlinePage(headlineId: id);
                    },
                  ),
                  GoRoute(
                    path: Routes.createTopic,
                    name: Routes.createTopicName,
                    builder: (context, state) => const CreateTopicPage(),
                  ),
                  GoRoute(
                    path: Routes.editTopic,
                    name: Routes.editTopicName,
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return EditTopicPage(topicId: id);
                    },
                  ),
                  GoRoute(
                    path: Routes.createSource,
                    name: Routes.createSourceName,
                    builder: (context, state) => const CreateSourcePage(),
                  ),
                  GoRoute(
                    path: Routes.editSource,
                    name: Routes.editSourceName,
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return EditSourcePage(sourceId: id);
                    },
                  ),
                  GoRoute(
                    path: Routes.archivedContent,
                    name: Routes.archivedContentName,
                    builder: (context, state) => const ArchivedContentPage(),
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
        ],
      ),
    ],
  );
}

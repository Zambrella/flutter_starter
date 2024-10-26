import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_template/authentication/presentation/pages/login_page.dart';
import 'package:flutter_starter_template/authentication/presentation/pages/register_page.dart';
import 'package:flutter_starter_template/authentication/providers/authentication_providers.dart';
import 'package:flutter_starter_template/home/presentation/home_page.dart';
import 'package:flutter_starter_template/routing/not_found_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

// private navigators
final _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'rootNavigator');

enum AppRoute {
  login,
  register,
  home,
  details,
}

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final path = state.uri.path;
      final isLoggedIn = ref.read(currentUserProvider) != null;

      // Redirect to home page if navigating to login pages while logged in
      if (isLoggedIn) {
        if (path.startsWith('/login') || path.startsWith('/register')) {
          return '/home';
        }
      }

      // Redirect to login page if navigating to protected pages while not logged in
      if (!isLoggedIn) {
        if (path.startsWith('/login') || path.startsWith('/register')) {
          return null;
        } else {
          return '/login';
        }
      }

      // No redirect
      return null;
    },
    routes: [
      GoRoute(
        path: '/startup',
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: SizedBox.shrink());
        },
      ),
      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: LoginPage(),
        ),
      ),
      GoRoute(
        path: '/register',
        name: AppRoute.register.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: RegisterPage(),
        ),
      ),
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: HomePage(),
        ),
        routes: [
          GoRoute(
            path: 'details',
            name: AppRoute.details.name,
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: Scaffold(
                  body: Center(
                    child: Text('Details Page'),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ],
    errorPageBuilder: (context, state) => const NoTransitionPage(
      child: NotFoundScreen(),
    ),
  );
}

extension GoRouterExtension on GoRouter {
  // Clear the stack and navigate to a new location
  void clearStackAndNavigate(String location) {
    while (canPop()) {
      pop();
    }
    pushReplacement(location);
  }
}

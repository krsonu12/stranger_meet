import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/route_constants.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/home/presentation/pages/home_page.dart';

/// Centralized GoRouter configuration with auth-based redirect guards.
/// Navigation logic lives here — never inside widgets or repositories.
class AppRouter {
  AppRouter._();

  static GoRouter createRouter(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: RouteConstants.splash,
      debugLogDiagnostics: true,
      refreshListenable: _AuthStateNotifier(authBloc),
      redirect: (context, state) {
        final authState = authBloc.state;
        final isSplash = state.matchedLocation == RouteConstants.splash;
        final isLogin = state.matchedLocation == RouteConstants.login;

        // Still loading — stay on splash
        if (authState is AuthInitial || authState is AuthLoading) {
          return isSplash ? null : RouteConstants.splash;
        }

        // Authenticated → go home
        if (authState is AuthAuthenticated) {
          if (isSplash || isLogin) return RouteConstants.home;
          return null;
        }

        // Unauthenticated or error → go to login
        if (authState is AuthUnauthenticated || authState is AuthError) {
          if (isLogin) return null;
          return RouteConstants.login;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: RouteConstants.splash,
          name: 'splash',
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: RouteConstants.login,
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: RouteConstants.home,
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
      ],
    );
  }
}

/// Bridges [AuthBloc] state changes to GoRouter's [Listenable] refresh mechanism.
class _AuthStateNotifier extends ChangeNotifier {
  _AuthStateNotifier(AuthBloc bloc) {
    bloc.stream.listen((_) => notifyListeners());
  }
}

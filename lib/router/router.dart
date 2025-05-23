import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'routes.dart';
import 'shell/scaffold.dart';

final rootKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

class BaseAppRouter {
  static BaseAppRouter? _instance;

  late final GoRouter router;

  /// Initially [currentRoute] is the [initialLocation] and will be updated
  /// in the redirect function
  BaseRoute get currentRoute =>
      <BaseRoute>[...AppRoute.values, ...TabAppRoute.values].firstWhere(
        (route) => route.fullPath == router.state.fullPath,
        orElse: () => TabAppRoute.dashboard,
      );

  BaseAppRouter._() {
    router = GoRouter(
      navigatorKey: rootKey,
      initialLocation: TabAppRoute.dashboard.fullPath,
      routes: [
        ..._routes(AppRoute.values),
        ShellRoute(
          navigatorKey: _shellKey,
          pageBuilder:
              (context, state, child) => NoTransitionPage(
                child: Title(
                  color: const Color.fromARGB(255, 170, 166, 166),
                  title: 'Imposti',
                  child: ShellScaffold(child: child),
                ),
              ),
          routes: _routes(TabAppRoute.values),
        ),
      ],
    );
  }

  factory BaseAppRouter() => _instance ??= BaseAppRouter._();

  void navigateTo(
    BuildContext context,
    BaseRoute route, {
    Map<String, String>? params,
  }) {
    String path = route.fullPath;
    if (params != null) {
      for (final param in params.keys) {
        path = path.replaceAll(param, params[param]!);
      }
    }

    context.push(path);
  }

  void navigateBack(BuildContext context) {
    if (context.canPop()) context.pop();
  }

  List<RouteBase> _routes(List<BaseRoute> routes, {int level = 0}) {
    final routesForLevel = List.from(
      routes.where((route) {
        String paramRoute = route.fullPath.replaceAll('/:', ':');
        return paramRoute.split('/').length == level + 2;
      }),
    );

    return List.from(
      routesForLevel.map((route) {
        String paramRoute = route.fullPath.replaceAll('/:', ':');
        return GoRoute(
          // parentNavigatorKey: route.fullscreen ? _shellKey : null,
          path:
              '/${paramRoute.split('/').skip(level + 1).take(1).join('').replaceAll(':', '/:')}',
          name: route.name,
          pageBuilder:
              (context, state) =>
                  route.isRoot || kIsWeb
                      ? _webPage(route, state)
                      : _mobilePage(route, state),
          routes: _routes(
            List.from(
              routes.where(
                (innerRoute) =>
                    innerRoute.fullPath.split('/')[1] ==
                    route.fullPath.split('/')[1],
              ),
            ),
            level: level + 1,
          ),
        );
      }),
    );
  }

  Page _mobilePage(BaseRoute route, GoRouterState state) =>
      MaterialPage(child: route.view(state));

  Page _webPage(BaseRoute route, GoRouterState state) => NoTransitionPage(
    child: Title(
      title: 'Imposti | ${route.name}',
      color: Colors.white,

      /// TODO: needs to be tested. On mobile, swiping back should not work
      child: AnimatedBuilder(
        animation:
            rootKey.currentState?.userGestureInProgressNotifier ??
            ValueNotifier(true),
        builder:
            (context, child) => PopScope(
              canPop: !(rootKey.currentState?.userGestureInProgress ?? true),
              child: route.view(state),
            ),
      ),
    ),
  );
}

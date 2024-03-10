import 'package:client/core/presentation/screens/splash_screen.dart';
import 'package:client/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:client/notifications/presentation/screens/notifications_screen.dart';
import 'package:client/shelf/presentation/screens/shelf_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

@TypedGoRoute<SplashRoute>(path: '/splash')
class SplashRoute extends GoRouteData {
  const SplashRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const NoTransitionPage(child: SplashScreen());
}

@TypedGoRoute<DashboardRoute>(
  path: '/',
  routes: [
    TypedGoRoute<ShelfRoute>(path: 'shelf'),
    TypedGoRoute<NotificationsRoute>(path: 'notifications'),
  ],
)
class DashboardRoute extends GoRouteData {
  const DashboardRoute({this.id});

  final String? id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      NoTransitionPage(child: DashboardScreen(id: id));
}

class ShelfRoute extends GoRouteData {
  const ShelfRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const NoTransitionPage(child: ShelfScreen());
}

class NotificationsRoute extends GoRouteData {
  const NotificationsRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const NoTransitionPage(child: NotificationsScreen());
}

import 'package:client/core/presentation/applications/isar_client.dart';
import 'package:client/core/presentation/applications/realtime.dart';
import 'package:client/core/presentation/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  final socketConnected = ValueNotifier<bool>(false);

  final socketStatusStream = ref
      .read(isarClientProvider)
      .settings
      .watchObject(
        Isar.fastHash(SettingsKey.socketStatus.name),
        fireImmediately: true,
      )
      .listen((event) {
    socketConnected.value = event?.value == 'connected';
  });

  ref.onDispose(() {
    socketConnected.dispose();
    socketStatusStream.cancel();
  });

  final router = GoRouter(
    refreshListenable: socketConnected,
    initialLocation: const SplashRoute().location,
    debugLogDiagnostics: true,
    routes: $appRoutes,
    redirect: (context, state) async {
      if (socketConnected.value) {
        if (state.matchedLocation == const SplashRoute().location) {
          return const DashboardRoute().location;
        } else {
          return null;
        }
      } else {
        return const SplashRoute().location;
      }
    },
  );
  ref.onDispose(router.dispose);

  return router;
}

String getCurrentLocation(BuildContext context) {
  final lastMatch = GoRouter.of(context).routerDelegate.currentConfiguration.last;
  final matchList = lastMatch is ImperativeRouteMatch
      ? lastMatch.matches
      : GoRouter.of(context).routerDelegate.currentConfiguration;
  return matchList.uri.toString();
}

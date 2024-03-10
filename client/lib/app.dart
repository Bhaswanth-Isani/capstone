import 'package:client/core/presentation/applications/realtime.dart';
import 'package:client/core/presentation/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    useEffect(
      () {
        Future(() => ref.read(realtimeProvider.notifier).connect());
        return null;
      },
      [],
    );

    return MaterialApp.router(
      theme: ThemeData.light(useMaterial3: false).copyWith(
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          checkColor: MaterialStateProperty.resolveWith((states) => Colors.black),
          overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
        ),
        splashColor: Colors.transparent,
        dividerTheme: const DividerThemeData(color: Color(0xFFEDEDED), thickness: 1, space: 1),
      ),
      darkTheme: ThemeData.dark(useMaterial3: false).copyWith(
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          checkColor: MaterialStateProperty.resolveWith((states) => Colors.white),
          overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
        ),
        splashColor: Colors.transparent,
        dividerTheme: const DividerThemeData(color: Color(0xFF2E2E2E), thickness: 1, space: 1),
      ),
      debugShowCheckedModeBanner: false,
      title: 'IWOS',
      routerConfig: router,
    );
  }
}

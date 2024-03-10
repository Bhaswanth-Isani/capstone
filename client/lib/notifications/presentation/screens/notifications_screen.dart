import 'dart:math';

import 'package:client/core/presentation/components/app_progress_indicator.dart';
import 'package:client/core/presentation/components/es_widgets.dart';
import 'package:client/core/presentation/components/layout.dart';
import 'package:client/core/presentation/theme/editor_theme.dart';
import 'package:client/notifications/model/shelf_logs.dart';
import 'package:client/notifications/presentation/components/notification_component.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shelfLogs = ref.watch(shelfLogProvider);

    return Layout(
      tab: AppTab.notifications,
      child: switch (shelfLogs) {
        AsyncValue(:final value?) => Builder(
            builder: (context) {
              if (value.isEmpty) {
                return Center(
                  child: Text(
                    'There are no malfunctions at the moment.',
                    style: EditorTheme.text(context).bodyMedium,
                  ),
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: max(1, constraints.maxWidth ~/ 400),
                      childAspectRatio: 3.5 / 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      final shelfLog = value[index];
                      return NotificationComponent(shelfLog: shelfLog);
                    },
                  );
                },
              ).padding(EditorTheme.p4);
            },
          ),
        _ => const Center(child: AppProgressIndicator()),
      },
    );
  }
}

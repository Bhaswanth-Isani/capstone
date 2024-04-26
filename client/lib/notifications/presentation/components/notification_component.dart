import 'package:client/core/presentation/components/es_widgets.dart';
import 'package:client/core/presentation/components/svg_icon.dart';
import 'package:client/core/presentation/theme/editor_icons.dart';
import 'package:client/core/presentation/theme/editor_theme.dart';
import 'package:client/notifications/model/shelf_logs.dart';
import 'package:client/shelf/presentation/applications/shelves_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationComponent extends ConsumerWidget {
  const NotificationComponent({required this.shelfLog, super.key});

  final ShelfLog shelfLog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shelf =
        ref.watch(shelvesProvider)?.where((element) => element.id == shelfLog.id).firstOrNull;

    return Container(
      padding: EditorTheme.p4,
      decoration: BoxDecoration(
        color: EditorTheme.colors(context).surface,
        borderRadius: EditorTheme.r2,
        border: Border.all(color: EditorTheme.colors(context).outline),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: EditorTheme.colors(context).secondaryBackground,
                  borderRadius: EditorTheme.r1,
                  border: Border.all(color: EditorTheme.colors(context).outline),
                ),
                padding: EditorTheme.p2,
                child: SvgIcon(
                  asset: EditorIcons.shelf,
                  color: EditorTheme.colors(context).onSurface,
                ),
              ),
              EditorTheme.sX3,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(shelf?.name ?? 'Shelf', style: EditorTheme.text(context).labelLarge),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            shelf?.id ?? shelfLog.id,
                            style: EditorTheme.text(context).bodySmall.copyWith(
                                  color: EditorTheme.colors(context).onSurface,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              EditorTheme.sX2,
              MoreWidget(
                items: [
                  ESMenuSingleItem(
                    onTap: () {
                      ref.read(shelvesProvider.notifier).deleteShelfLog(shelf!.id);
                    },
                    child: (hover) => Text(
                      'Delete',
                      style: EditorTheme.text(context)
                          .bodySmall
                          .copyWith(color: hover ? EditorTheme.colors(context).onPrimary : null),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Text(
                'There is some malfunction with the sensor in the shelf. Please check the shelf.',
                style: EditorTheme.text(context).bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

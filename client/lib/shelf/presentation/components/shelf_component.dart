import 'dart:math';

import 'package:client/core/presentation/components/button.dart';
import 'package:client/core/presentation/components/es_widgets.dart';
import 'package:client/core/presentation/components/form_dialog.dart';
import 'package:client/core/presentation/components/svg_icon.dart';
import 'package:client/core/presentation/theme/editor_icons.dart';
import 'package:client/core/presentation/theme/editor_theme.dart';
import 'package:client/dashboard/api/product_api.dart';
import 'package:client/shelf/api/shelf_api.dart';
import 'package:client/shelf/presentation/applications/shelves_provider.dart';
import 'package:client/shelf/presentation/forms/shelf_form.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShelfComponent extends ConsumerWidget {
  const ShelfComponent({required this.shelf, super.key, this.product, this.basic = false});

  final Shelf shelf;
  final Product? product;
  final bool basic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shelfTotalQuantity = product != null ? shelf.size / product!.size : null;

    return Container(
      padding: EditorTheme.p4,
      decoration: BoxDecoration(
        color: basic ? EditorTheme.colors(context).surface : EditorTheme.colors(context).background,
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
                    Text(shelf.name, style: EditorTheme.text(context).labelLarge),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            shelf.id,
                            style: EditorTheme.text(context).bodySmall.copyWith(
                                  color: EditorTheme.colors(context).onSurface,
                                ),
                          ),
                        ),
                        Button.noFocus(
                          onTap: () {
                            FlutterClipboard.copy(shelf.id).then(
                              (value) => ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: EditorTheme.colors(context).secondaryBackground,
                                  content: Text(
                                    'Copied',
                                    style: EditorTheme.text(context).bodyMedium,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: (hover) => SvgIcon(
                            asset: EditorIcons.copy,
                            size: 16,
                            color: EditorTheme.colors(context).onBackground,
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
                    onTap: () => showFormDialog(context: context, child: ShelfForm(shelf: shelf)),
                    child: (hover) => Text(
                      'Edit',
                      style: EditorTheme.text(context).bodySmall.copyWith(
                            color: hover ? EditorTheme.colors(context).onPrimary : null,
                          ),
                    ),
                  ),
                  ESMenuSingleItem(
                    onTap: () => ref.read(shelvesProvider.notifier).deleteShelf(shelf),
                    child: (hover) => Text(
                      'Delete',
                      style: EditorTheme.text(context).bodySmall.copyWith(
                            color: hover ? EditorTheme.colors(context).onPrimary : null,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          if (product != null)
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    minHeight: 50,
                    borderRadius: EditorTheme.r1,
                    backgroundColor: EditorTheme.colors(context).secondaryBackground,
                    value: min(1, shelf.quantity / shelfTotalQuantity!),
                    color: EditorTheme.colors(context).primary,
                  ),
                ),
                EditorTheme.sX2,
                Text(
                  '${shelf.quantity} / ${shelfTotalQuantity.toStringAsFixed(0)}',
                  style: EditorTheme.text(context).bodyMedium,
                ),
              ],
            )
          else
            Expanded(
              child: Center(
                child: Text(
                  'No Product',
                  style: EditorTheme.text(context).bodyLarge,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

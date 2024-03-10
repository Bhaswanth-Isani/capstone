import 'dart:math';

import 'package:client/core/presentation/components/app_progress_indicator.dart';
import 'package:client/core/presentation/components/es_widgets.dart';
import 'package:client/core/presentation/components/form_dialog.dart';
import 'package:client/core/presentation/components/layout.dart';
import 'package:client/core/presentation/theme/editor_theme.dart';
import 'package:client/dashboard/presentation/applications/products_provider.dart';
import 'package:client/shelf/presentation/applications/shelves_provider.dart';
import 'package:client/shelf/presentation/components/shelf_component.dart';
import 'package:client/shelf/presentation/forms/shelf_form.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShelfScreen extends HookConsumerWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shelves = ref.watch(shelvesProvider);
    final products = ref.watch(productsProvider);

    useEffect(
      () {
        if (ref.read(shelvesProvider) == null) {
          Future(() async => ref.read(shelvesProvider.notifier).getData());
        }

        if (ref.read(productsProvider) == null) {
          Future(() async => ref.read(productsProvider.notifier).getData());
        }

        return null;
      },
      [],
    );

    if (shelves == null || products == null) {
      return const Layout(tab: AppTab.shelf, child: Center(child: AppProgressIndicator()));
    }

    return Layout(
      tab: AppTab.shelf,
      child: Padding(
        padding: EditorTheme.p4,
        child: () {
          if (shelves.isEmpty) {
            return EmptyFilesWidget(
              title: 'No shelves yet',
              message: 'Get started by adding a new shelf',
              buttonText: 'Add shelf',
              onTap: () => showFormDialog(context: context, child: const ShelfForm()),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ESButton.basic(
                  label: 'Add shelf',
                  onTap: () => showFormDialog(context: context, child: const ShelfForm()),
                  isDense: true,
                ),
                EditorTheme.sY4,
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: max(1, constraints.maxWidth ~/ 400),
                          childAspectRatio: 3 / 1,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: shelves.length,
                        itemBuilder: (context, index) {
                          final shelf = shelves[index];
                          final product =
                              products.firstWhereOrNull((product) => product.id == shelf.productID);

                          return ShelfComponent(shelf: shelf, product: product, basic: true);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        }(),
      ),
    );
  }
}

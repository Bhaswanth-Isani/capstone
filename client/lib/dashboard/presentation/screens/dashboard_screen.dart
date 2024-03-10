import 'package:client/core/presentation/components/app_progress_indicator.dart';
import 'package:client/core/presentation/components/es_widgets.dart';
import 'package:client/core/presentation/components/form_dialog.dart';
import 'package:client/core/presentation/components/layout.dart';
import 'package:client/core/presentation/components/svg_icon.dart';
import 'package:client/core/presentation/router/routes.dart';
import 'package:client/core/presentation/theme/editor_icons.dart';
import 'package:client/core/presentation/theme/editor_theme.dart';
import 'package:client/dashboard/presentation/applications/products_provider.dart';
import 'package:client/dashboard/presentation/components/product_chart.dart';
import 'package:client/dashboard/presentation/forms/product_form.dart';
import 'package:client/shelf/presentation/applications/shelves_provider.dart';
import 'package:client/shelf/presentation/components/shelf_component.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DashboardScreen extends HookConsumerWidget {
  const DashboardScreen({required this.id, super.key});

  final String? id;

  Widget _loading() =>
      const Layout(tab: AppTab.dashboard, child: Center(child: AppProgressIndicator()));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);
    final shelves = ref.watch(shelvesProvider);

    useEffect(
      () {
        if (ref.read(productsProvider) == null) {
          Future(() async => ref.read(productsProvider.notifier).getData());
        }

        if (ref.read(shelvesProvider) == null) {
          Future(() async => ref.read(shelvesProvider.notifier).getData());
        }

        return null;
      },
      [],
    );

    if (products == null || shelves == null) return _loading();

    if (products.isEmpty) {
      return Layout(
        tab: AppTab.dashboard,
        child: EmptyFilesWidget(
          title: 'No products yet',
          message: 'Get started by adding a new product',
          buttonText: 'Add product',
          onTap: () => showFormDialog(context: context, child: const ProductForm()),
        ).padding(EditorTheme.p4),
      );
    }

    if (id == null || products.firstWhereOrNull((element) => element.id == id) == null) {
      DashboardRoute(id: products.first.id).go(context);
      return _loading();
    }

    final product = products.firstWhere((product) => product.id == id);
    final productShelves = shelves.where((shelf) => shelf.productID == id).toList();

    final productStock = ref.watch(productStockProvider(id!));

    return Layout(
      tab: AppTab.dashboard,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 200,
                      child: ESSelect(
                        decoration: EditorTheme.outlineTextField(context, select: true),
                        menuColor: EditorTheme.colors(context).surface,
                        style: EditorTheme.text(context).bodyMedium,
                        selected: product.id,
                        items: products
                            .map((e) => ESSelectSingleItem(value: e.id, label: e.name))
                            .toList(),
                        onChanged: (value) => DashboardRoute(id: value).go(context),
                        selectIcon: SvgIcon(
                          asset: EditorIcons.down,
                          size: 16,
                          color: EditorTheme.colors(context).onBackground,
                        ),
                      ),
                    ),
                    EditorTheme.sX4,
                    ESButton.basic(
                      label: 'Add product',
                      onTap: () => showFormDialog(context: context, child: const ProductForm()),
                      isDense: true,
                    ),
                    EditorTheme.sX4,
                    ESButton.outline(
                      label: 'Delete Product',
                      onTap: () => ref.read(productsProvider.notifier).deleteProduct(product),
                    ),
                  ],
                ).padding(EditorTheme.pX4 + EditorTheme.pYT4),
                Container(
                  padding: EditorTheme.p4,
                  margin: EditorTheme.p4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: EditorTheme.colors(context).surface,
                    borderRadius: EditorTheme.r2,
                    border: Border.all(color: EditorTheme.colors(context).outline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: EditorTheme.text(context)
                            .labelSmall
                            .copyWith(color: EditorTheme.colors(context).onSurface),
                      ),
                      Text(product.name, style: EditorTheme.text(context).bodyMedium),
                      EditorTheme.sY4,
                      Text(
                        'Product ID',
                        style: EditorTheme.text(context)
                            .labelSmall
                            .copyWith(color: EditorTheme.colors(context).onSurface),
                      ),
                      Text(product.id, style: EditorTheme.text(context).bodyMedium),
                    ],
                  ),
                ),
                Container(
                  padding: EditorTheme.p4,
                  margin: EditorTheme.p4,
                  decoration: BoxDecoration(
                    color: EditorTheme.colors(context).surface,
                    borderRadius: EditorTheme.r2,
                    border: Border.all(color: EditorTheme.colors(context).outline),
                  ),
                  child: ProductChart(productStock.valueOrNull ?? []),
                ),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 2,
            child: Container(
              height: double.infinity,
              color: EditorTheme.colors(context).surface,
              child: SingleChildScrollView(
                padding: EditorTheme.p4,
                child: Column(
                  children: productShelves
                      .map(
                        (shelf) => SizedBox(
                          height: 160,
                          child: ShelfComponent(shelf: shelf, product: product),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

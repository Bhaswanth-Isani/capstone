import 'package:client/core/presentation/components/es_widgets.dart';
import 'package:client/core/presentation/components/svg_icon.dart';
import 'package:client/core/presentation/theme/editor_icons.dart';
import 'package:client/core/presentation/theme/editor_theme.dart';
import 'package:client/dashboard/presentation/applications/products_provider.dart';
import 'package:client/shelf/api/shelf_api.dart';
import 'package:client/shelf/presentation/applications/shelves_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShelfForm extends HookConsumerWidget {
  const ShelfForm({this.shelf, super.key});

  final Shelf? shelf;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = useState(false);
    final showErrors = useState(false);

    final shelfDetails = useState(
      shelf ??
          Shelf(id: generateID(prefix: 'shelf'), name: '', productID: null, size: 0, quantity: 0),
    );

    final products = ref.watch(productsProvider)!;

    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EditorTheme.pX6 + EditorTheme.pY4,
            child: Text(
              shelf == null ? 'Create a shelf' : 'Update a shelf',
              style: EditorTheme.text(context).labelLarge,
            ),
          ),
          const Divider(),
          Padding(
            padding: EditorTheme.pX6 + EditorTheme.pY4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ESWidgetWithLabel(
                  label: 'Name',
                  style: EditorTheme.text(context).bodyMedium,
                  child: ESFormField(
                    onSubmitted: (value) =>
                        shelfDetails.value = shelfDetails.value.copyWith(name: value),
                    initialValue: shelfDetails.value.name,
                    style: EditorTheme.text(context).bodyMedium,
                    decoration: EditorTheme.outlineTextField(context),
                  ),
                ),
                EditorTheme.sY4,
                ESWidgetWithLabel(
                  label: 'Size',
                  style: EditorTheme.text(context).bodyMedium,
                  child: ESNumberFormField(
                    onSubmitted: (value) =>
                        shelfDetails.value = shelfDetails.value.copyWith(size: value ?? 0),
                    initialValue: shelfDetails.value.size,
                    style: EditorTheme.text(context).bodyMedium,
                    decoration: EditorTheme.outlineTextField(context),
                  ),
                ),
                EditorTheme.sY4,
                ESWidgetWithLabel(
                  label: 'Product',
                  style: EditorTheme.text(context).bodyMedium,
                  child: ESSelect(
                    decoration: EditorTheme.outlineTextField(context, select: true),
                    selected: shelfDetails.value.productID,
                    items: [null, ...products]
                        .map(
                          (product) => ESSelectSingleItem(
                            value: product?.id,
                            label: product?.name ?? 'None',
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        shelfDetails.value = shelfDetails.value.copyWith(productID: value),
                    menuColor: EditorTheme.colors(context).surface,
                    style: EditorTheme.text(context).bodyMedium,
                    selectIcon: SvgIcon(
                      asset: EditorIcons.down,
                      size: 16,
                      color: EditorTheme.colors(context).onBackground,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const Divider(),
          Padding(
            padding: EditorTheme.pX6 + EditorTheme.pY4,
            child: ESFormSubmission(
              loading: loading.value,
              submitText: 'Save',
              onSubmit: () async {
                if (shelfDetails.value.name.isEmpty) {
                  showErrors.value = true;
                  return;
                }

                loading.value = true;
                String? error;

                if (shelf == null) {
                  error = await ref.read(shelvesProvider.notifier).createShelf(shelfDetails.value);
                } else {
                  error = await ref.read(shelvesProvider.notifier).updateShelf(shelfDetails.value);
                }

                loading.value = false;
                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: EditorTheme.errorColor,
                      content: Text(error, style: EditorTheme.text(context).bodyMedium),
                    ),
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

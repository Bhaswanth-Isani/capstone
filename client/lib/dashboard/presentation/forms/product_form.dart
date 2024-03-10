import 'package:client/core/presentation/components/es_widgets.dart';
import 'package:client/core/presentation/theme/editor_theme.dart';
import 'package:client/dashboard/api/product_api.dart';
import 'package:client/dashboard/presentation/applications/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductForm extends HookConsumerWidget {
  const ProductForm({this.product, super.key});

  final Product? product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = useState(false);
    final showErrors = useState(false);

    final productDetails =
        useState(product ?? Product(id: generateID(prefix: 'product'), name: '', size: 0));

    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EditorTheme.pX6 + EditorTheme.pY4,
            child: Text(
              product == null ? 'Create a product' : 'Update a product',
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
                        productDetails.value = productDetails.value.copyWith(name: value),
                    initialValue: productDetails.value.name,
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
                        productDetails.value = productDetails.value.copyWith(size: value ?? 0),
                    initialValue: productDetails.value.size,
                    style: EditorTheme.text(context).bodyMedium,
                    decoration: EditorTheme.outlineTextField(context),
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
                if (productDetails.value.name.isEmpty) {
                  showErrors.value = true;
                  return;
                }

                loading.value = true;
                String? error;

                if (product == null) {
                  error =
                      await ref.read(productsProvider.notifier).createProduct(productDetails.value);
                } else {
                  error =
                      await ref.read(productsProvider.notifier).updateProduct(productDetails.value);
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

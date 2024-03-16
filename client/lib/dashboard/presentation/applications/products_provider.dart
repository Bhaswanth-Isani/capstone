import 'package:client/core/helpers/env.dart';
import 'package:client/core/presentation/applications/dio_client.dart';
import 'package:client/core/presentation/applications/isar_client.dart';
import 'package:client/dashboard/api/product_api.dart';
import 'package:client/shelf/presentation/applications/shelves_provider.dart';
import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'products_provider.g.dart';

@riverpod
ProductAPI productAPI(ProductAPIRef ref) {
  return ProductAPI(ref.read(dioClientProvider), baseUrl: ENV.serverUrl);
}

@riverpod
Future<List<int>> productStock(ProductStockRef ref, String id) async {
  final shelves = ref.watch(shelvesProvider);
  if (shelves == null) {
    await ref.read(shelvesProvider.notifier).getData();
  }

  final stock = await ref.read(productAPIProvider).getStock(id);
  return stock;
}

@riverpod
class Products extends _$Products {
  @override
  List<Product>? build() => null;

  Future<void> getData() async {
    final isar = ref.read(isarClientProvider);

    var products = isar.products.where().findAll();
    if (products.isEmpty) {
      products = await ref.read(productAPIProvider).getProducts();
      isar.write((isar) => isar.products.putAll(products));
    }

    final productStream = isar.products.watchLazy(fireImmediately: true).listen((event) {
      state = isar.products.where().findAll();
    });

    ref.onDispose(productStream.cancel);
  }

  Future<String?> createProduct(Product product) async {
    final isar = ref.read(isarClientProvider)..write((isar) => isar.products.put(product));
    try {
      await ref.read(productAPIProvider).createProduct(product);
      return null;
    } on DioException catch (error) {
      isar.write((isar) => isar.products.delete(product.isarID));
      return (error.response is String) ? error.response.toString() : 'Something went wrong';
    } catch (_) {
      isar.write((isar) => isar.products.delete(product.isarID));
      return 'Something went wrong';
    }
  }

  Future<String?> updateProduct(Product product) async {
    final isar = ref.read(isarClientProvider)..write((isar) => isar.products.put(product));
    try {
      await ref.read(productAPIProvider).updateProduct(product.id, product);
      return null;
    } on DioException catch (error) {
      isar.write((isar) => isar.products.delete(product.isarID));
      return (error.response is String) ? error.response.toString() : 'Something went wrong';
    } catch (_) {
      isar.write((isar) => isar.products.delete(product.isarID));
      return 'Something went wrong';
    }
  }

  Future<String?> deleteProduct(Product product) async {
    final isar = ref.read(isarClientProvider);
    final previousProduct = isar.products.get(product.isarID)!;

    isar.write((isar) => isar.products.delete(product.isarID));
    try {
      await ref.read(productAPIProvider).deleteProduct(product.id);
      return null;
    } on DioException catch (error) {
      isar.write((isar) => isar.products.put(previousProduct));
      return (error.response is String) ? error.response.toString() : 'Something went wrong';
    } catch (_) {
      isar.write((isar) => isar.products.put(previousProduct));
      return 'Something went wrong';
    }
  }
}

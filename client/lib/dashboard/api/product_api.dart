import 'package:dio/dio.dart' hide Headers;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart' hide id;
import 'package:retrofit/retrofit.dart';

part 'product_api.freezed.dart';
part 'product_api.g.dart';

@Freezed(equal: true)
@Collection(accessor: 'products')
class Product with _$Product {
  factory Product({
    required String id,
    required String name,
    required double size,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Product._();

  @Id()
  int get isarID => Isar.fastHash(id);
}

@RestApi()
abstract class ProductAPI {
  factory ProductAPI(Dio dio, {String? baseUrl}) = _ProductAPI;

  @GET('/products')
  @Headers({'Content-Type': 'application/json'})
  Future<List<Product>> getProducts();

  @POST('/products')
  @Headers({'Content-Type': 'application/json'})
  Future<Product> createProduct(@Body() Product product);

  @PATCH('/products/{id}')
  @Headers({'Content-Type': 'application/json'})
  Future<Product> updateProduct(@Path('id') String id, @Body() Product product);

  @DELETE('/products/{id}')
  @Headers({'Content-Type': 'application/json'})
  Future<void> deleteProduct(@Path('id') String id);

  @GET('/quantity/{id}')
  @Headers({'Content-Type': 'application/json'})
  Future<List<int>> getStock(@Path() String id);
}

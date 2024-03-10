import 'package:dio/dio.dart' hide Headers;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart' hide id;
import 'package:retrofit/retrofit.dart';

part 'shelf_api.freezed.dart';
part 'shelf_api.g.dart';

@Freezed(equal: true)
@Collection(accessor: 'shelves')
class Shelf with _$Shelf {
  factory Shelf({
    required String id,
    required String name,
    required String? productID,
    required double size,
    required int quantity,
  }) = _Shelf;

  factory Shelf.fromJson(Map<String, dynamic> json) => _$ShelfFromJson(json);

  Shelf._();

  @Id()
  int get isarID => Isar.fastHash(id);
}

@RestApi()
abstract class ShelfAPI {
  factory ShelfAPI(Dio dio, {String? baseUrl}) = _ShelfAPI;

  @GET('/shelves')
  @Headers({'Content-Type': 'application/json'})
  Future<List<Shelf>> getShelves();

  @POST('/shelves')
  @Headers({'Content-Type': 'application/json'})
  Future<Shelf> createShelf(@Body() Shelf shelf);

  @PATCH('/shelves/{id}')
  @Headers({'Content-Type': 'application/json'})
  Future<Shelf> updateShelf(@Path('id') String id, @Body() Shelf shelf);

  @DELETE('/shelves/{id}')
  @Headers({'Content-Type': 'application/json'})
  Future<void> deleteShelf(@Path('id') String id);
}

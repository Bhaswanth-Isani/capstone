import 'package:client/core/helpers/env.dart';
import 'package:client/core/presentation/applications/dio_client.dart';
import 'package:client/core/presentation/applications/isar_client.dart';
import 'package:client/shelf/api/shelf_api.dart';
import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shelves_provider.g.dart';

@riverpod
ShelfAPI shelfAPI(ShelfAPIRef ref) {
  return ShelfAPI(ref.read(dioClientProvider), baseUrl: ENV.serverUrl);
}

@riverpod
class Shelves extends _$Shelves {
  @override
  List<Shelf>? build() => null;

  Future<void> getData() async {
    final isar = ref.read(isarClientProvider);

    var shelves = isar.shelves.where().findAll();
    if (shelves.isEmpty) {
      shelves = await ref.read(shelfAPIProvider).getShelves();
      isar.write((isar) => isar.shelves.putAll(shelves));
    }

    final shelfStream = isar.shelves.watchLazy(fireImmediately: true).listen((event) {
      state = isar.shelves.where().findAll();
    });

    ref.onDispose(shelfStream.cancel);
  }

  Future<String?> createShelf(Shelf shelf) async {
    final isar = ref.read(isarClientProvider)..write((isar) => isar.shelves.put(shelf));
    try {
      await ref.read(shelfAPIProvider).createShelf(shelf);
      return null;
    } on DioException catch (error) {
      isar.write((isar) => isar.shelves.delete(shelf.isarID));
      return (error.response is String) ? error.response.toString() : 'Something went wrong';
    } catch (_) {
      isar.write((isar) => isar.shelves.delete(shelf.isarID));
      return 'Something went wrong';
    }
  }

  Future<String?> updateShelf(Shelf shelf) async {
    final isar = ref.read(isarClientProvider);
    final previousShelf = isar.shelves.get(shelf.isarID)!;

    isar.write((isar) => isar.shelves.put(shelf));
    try {
      await ref.read(shelfAPIProvider).updateShelf(shelf.id, shelf);
      return null;
    } on DioException catch (error) {
      print(error.response);
      isar.write((isar) => isar.shelves.put(previousShelf));
      return (error.response is String) ? error.response.toString() : 'Something went wrong';
    } catch (_) {
      isar.write((isar) => isar.shelves.put(previousShelf));
      return 'Something went wrong';
    }
  }

  Future<String?> deleteShelf(Shelf shelf) async {
    final isar = ref.read(isarClientProvider);
    final previousShelf = isar.shelves.get(shelf.isarID)!;

    isar.write((isar) => isar.shelves.delete(shelf.isarID));
    try {
      await ref.read(shelfAPIProvider).deleteShelf(shelf.id);
      return null;
    } on DioException catch (error) {
      print(error.response);
      isar.write((isar) => isar.shelves.put(previousShelf));
      return (error.response is String) ? error.response.toString() : 'Something went wrong';
    } catch (_) {
      isar.write((isar) => isar.shelves.put(previousShelf));
      return 'Something went wrong';
    }
  }
}

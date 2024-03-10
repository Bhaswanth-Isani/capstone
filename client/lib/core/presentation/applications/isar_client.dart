import 'package:client/core/presentation/applications/realtime.dart';
import 'package:client/dashboard/api/product_api.dart';
import 'package:client/notifications/model/shelf_logs.dart';
import 'package:client/shelf/api/shelf_api.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'isar_client.g.dart';

@Riverpod(keepAlive: true)
Isar isarClient(IsarClientRef ref) {
  return Isar.get(schemas: []);
}

void deleteAllLocalData(Isar isar) {
  isar.write((isar) {
    isar.settings.put(Settings(key: SettingsKey.socketStatus, value: 'disconnected'));
    isar.products.where().deleteAll();
    isar.shelves.where().deleteAll();
    isar.shelfLogs.where().deleteAll();
  });
}

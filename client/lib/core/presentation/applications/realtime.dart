import 'dart:developer';

import 'package:client/core/helpers/env.dart';
import 'package:client/core/presentation/applications/isar_client.dart';
import 'package:client/dashboard/api/product_api.dart';
import 'package:client/notifications/model/shelf_logs.dart';
import 'package:client/shelf/api/shelf_api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

part 'realtime.freezed.dart';
part 'realtime.g.dart';

@Riverpod(keepAlive: true)
class Realtime extends _$Realtime {
  @override
  socket_io.Socket? build() => null;

  void connect() {
    final isar = ref.read(isarClientProvider);

    final socket = socket_io.io(
      ENV.socketUrl,
      socket_io.OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
    )
      ..connect()
      ..on('error', (error) => log(error.toString()))
      ..onConnect((_) {
        isar.write(
          (isar) => isar.settings.put(Settings(key: SettingsKey.socketStatus, value: 'connected')),
        );
      })
      ..onDisconnect((_) {
        isar.write(
          (isar) =>
              isar.settings.put(Settings(key: SettingsKey.socketStatus, value: 'disconnected')),
        );
      })
      ..on('shelf:save', (data) {
        final shelf = Shelf.fromJson(
          (data as Map<String, dynamic>)['shelf'] as Map<String, dynamic>,
        );

        isar.write((isar) => isar.shelves.put(shelf));
      })
      ..on('shelf:delete', (data) {
        final id = (data as Map<String, dynamic>)['id']! as String;

        isar.write((isar) => isar.shelves.delete(Isar.fastHash(id)));
      })
      ..on('shelf:malfunction', (data) {
        final shelfLogs = ((data as Map<String, dynamic>)['shelves'] as List<dynamic>)
            .map((e) => ShelfLog.fromJson(e as Map<String, dynamic>))
            .toList();
        isar.write((isar) => isar.shelfLogs.putAll(shelfLogs));
      })
      ..on('product:save', (data) {
        final product = Product.fromJson(
          (data as Map<String, dynamic>)['product'] as Map<String, dynamic>,
        );

        isar.write((isar) => isar.products.put(product));
      })
      ..on('product:delete', (data) {
        final id = (data as Map<String, dynamic>)['id']! as String;

        isar.write((isar) => isar.products.delete(Isar.fastHash(id)));
      });

    state = socket;

    ref.onDispose(() {
      state?.close();
    });
  }

  void disconnect() {
    state?.close();
    state = null;
  }
}

@Freezed(equal: true)
@Collection(accessor: 'settings')
class Settings with _$Settings {
  factory Settings({
    @enumValue required SettingsKey key,
    required String value,
  }) = _Settings;

  Settings._();
  int get id => Isar.fastHash(key.name);
}

enum SettingsKey { socketStatus }

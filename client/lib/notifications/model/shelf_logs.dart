import 'package:client/core/presentation/applications/isar_client.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart' hide id;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shelf_logs.freezed.dart';
part 'shelf_logs.g.dart';

@Freezed(equal: true)
@Collection(accessor: 'shelfLogs')
class ShelfLog with _$ShelfLog {
  factory ShelfLog({
    required String id,
    @utc required DateTime timestamp,
  }) = _ShelfLog;

  factory ShelfLog.fromJson(Map<String, dynamic> json) => _$ShelfLogFromJson(json);

  ShelfLog._();

  @Id()
  int get isarId => Isar.fastHash(id);
}

@riverpod
Stream<List<ShelfLog>> shelfLog(ShelfLogRef ref) {
  return ref
      .read(isarClientProvider)
      .shelfLogs
      .watchLazy(fireImmediately: true)
      .map((_) => ref.read(isarClientProvider).shelfLogs.where().findAll());
}

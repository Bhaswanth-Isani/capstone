import 'package:client/app.dart';
import 'package:client/core/presentation/applications/isar_client.dart';
import 'package:client/core/presentation/applications/realtime.dart';
import 'package:client/core/presentation/theme/ui_configuration.dart';
import 'package:client/dashboard/api/product_api.dart';
import 'package:client/notifications/model/shelf_logs.dart';
import 'package:client/shelf/api/shelf_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  if (UIHelper.isWindows) await Isar.initialize('isar_windows.dll');
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.openAsync(
    schemas: [SettingsSchema, ProductSchema, ShelfSchema, ShelfLogSchema],
    directory: dir.path,
  );

  deleteAllLocalData(isar);

  runApp(const ProviderScope(child: MyApp()));
}

import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
abstract class ENV {
  @EnviedField(varName: 'SERVER_URL')
  static const String serverUrl = _ENV.serverUrl;
  @EnviedField(varName: 'SOCKET_URL')
  static const String socketUrl = _ENV.socketUrl;
}

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UIHelperData {
  UIHelperData({required this.isTablet, required this.isDesktop});

  final bool isTablet;
  final bool isDesktop;
}

class UIHelper {
  static UIHelperData of(BuildContext context) => UIHelperData(
        isTablet: (Platform.isAndroid || Platform.isIOS) &&
            MediaQuery.of(context).size.shortestSide > 600,
        isDesktop: Platform.isWindows || Platform.isMacOS,
      );

  static final isAndroid = Platform.isAndroid;
  static final isIOS = Platform.isIOS;
  static final isWindows = Platform.isWindows;
  static final isMacOS = Platform.isMacOS;
  static final isTablet = Platform.isAndroid || Platform.isIOS;
  static final isDesktop = Platform.isWindows || Platform.isMacOS;
  static const inProduction = !kDebugMode;
}

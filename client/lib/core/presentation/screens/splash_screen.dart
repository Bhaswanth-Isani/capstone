import 'package:client/core/presentation/components/svg_icon.dart';
import 'package:client/core/presentation/theme/editor_icons.dart';
import 'package:client/core/presentation/theme/editor_theme.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EditorTheme.colors(context).background,
      body: Center(
        child: SvgIcon(
          asset: EditorIcons.logo,
          size: 300,
          color: EditorTheme.colors(context).primary,
        ),
      ),
    );
  }
}

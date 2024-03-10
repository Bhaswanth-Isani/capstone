import 'dart:math' as math;

import 'package:client/core/presentation/components/svg_icon.dart';
import 'package:client/core/presentation/theme/editor_icons.dart';
import 'package:client/core/presentation/theme/editor_theme.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/animation_builder/loop_animation_builder.dart';

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return LoopAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 360),
      curve: Curves.easeInOutCubic,
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return Transform.rotate(
          angle: math.pi * value / 180,
          child: child,
        );
      },
      child: SvgIcon(
        asset: EditorIcons.logo,
        size: 64,
        color: EditorTheme.colors(context).onBackground,
      ),
    );
  }
}

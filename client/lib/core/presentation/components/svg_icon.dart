import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  const SvgIcon({
    required this.asset,
    this.color,
    super.key,
    this.size = 24.0,
  });

  final String asset;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        color ?? Theme.of(context).colorScheme.onBackground,
        BlendMode.srcIn,
      ),
    );
  }
}

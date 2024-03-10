import 'package:client/core/presentation/theme/ui_configuration.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditorTheme {
  static const successColor = Color(0xFF06d6a0);
  static const errorColor = Color(0xFFf94144);
  static const warningColor = Color(0xFFF7B801);
  static const purpleColor = Color(0xFF6e79ff);
  static const blueColor = Color(0xFF1FA2FF);
  static const orangeColor = Color(0xFFF37335);

  static const onBasic = Colors.white;

  static const p1 = EdgeInsets.all(4);
  static const p2 = EdgeInsets.all(8);
  static const p3 = EdgeInsets.all(12);
  static const p4 = EdgeInsets.all(16);
  static const p5 = EdgeInsets.all(20);
  static const p6 = EdgeInsets.all(24);

  static const pX1 = EdgeInsets.symmetric(horizontal: 4);
  static const pX2 = EdgeInsets.symmetric(horizontal: 8);
  static const pX3 = EdgeInsets.symmetric(horizontal: 12);
  static const pX4 = EdgeInsets.symmetric(horizontal: 16);
  static const pX5 = EdgeInsets.symmetric(horizontal: 20);
  static const pX6 = EdgeInsets.symmetric(horizontal: 24);

  static const pY1 = EdgeInsets.symmetric(vertical: 4);
  static const pY2 = EdgeInsets.symmetric(vertical: 8);
  static const pY3 = EdgeInsets.symmetric(vertical: 12);
  static const pY4 = EdgeInsets.symmetric(vertical: 16);
  static const pY5 = EdgeInsets.symmetric(vertical: 20);
  static const pY6 = EdgeInsets.symmetric(vertical: 24);

  static const pYT1 = EdgeInsets.only(top: 4);
  static const pYT2 = EdgeInsets.only(top: 8);
  static const pYT3 = EdgeInsets.only(top: 12);
  static const pYT4 = EdgeInsets.only(top: 16);
  static const pYT5 = EdgeInsets.only(top: 20);
  static const pYT6 = EdgeInsets.only(top: 24);

  static const pYB1 = EdgeInsets.only(bottom: 4);
  static const pYB2 = EdgeInsets.only(bottom: 8);
  static const pYB3 = EdgeInsets.only(bottom: 12);
  static const pYB4 = EdgeInsets.only(bottom: 16);
  static const pYB5 = EdgeInsets.only(bottom: 20);
  static const pYB6 = EdgeInsets.only(bottom: 24);

  static const sX1 = SizedBox(width: 4);
  static const sX2 = SizedBox(width: 8);
  static const sX3 = SizedBox(width: 12);
  static const sX4 = SizedBox(width: 16);
  static const sX5 = SizedBox(width: 20);
  static const sX6 = SizedBox(width: 24);

  static const sY1 = SizedBox(height: 4);
  static const sY2 = SizedBox(height: 8);
  static const sY3 = SizedBox(height: 12);
  static const sY4 = SizedBox(height: 16);
  static const sY5 = SizedBox(height: 20);
  static const sY6 = SizedBox(height: 24);
  static const sY7 = SizedBox(height: 28);
  static const sY8 = SizedBox(height: 32);

  static const double s1 = 4;
  static const double s2 = 8;
  static const double s3 = 12;
  static const double s4 = 16;
  static const double s6 = 24;

  static final r05 = BorderRadius.circular(2);
  static final r1 = BorderRadius.circular(4);
  static final r2 = BorderRadius.circular(8);

  static const shadow = [
    BoxShadow(
      color: Color(0x11000000),
      blurRadius: 16,
      offset: Offset(0, 12),
      spreadRadius: -8,
    ),
  ];

  static InputDecoration outlineTextField(
    BuildContext context, {
    String? hintText,
    bool enabled = true,
    bool select = false,
    bool compact = false,
  }) =>
      InputDecoration(
        isDense: true,
        contentPadding: select
            ? compact
                ? pX2 + pY1
                : pX4 + pY2
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabled: enabled,
        hintText: hintText,
        hintStyle: EditorTheme.text(context)
            .bodyMedium
            .copyWith(color: EditorTheme.colors(context).onSurface),
        errorStyle: EditorTheme.text(context).bodySmall.copyWith(color: EditorTheme.errorColor),
        helperStyle: EditorTheme.text(context)
            .bodySmall
            .copyWith(color: EditorTheme.colors(context).onSurface),
        filled: true,
        fillColor: EditorTheme.colors(context).background,
        enabledBorder: OutlineInputBorder(
          borderRadius: compact ? r05 : r1,
          borderSide: BorderSide(color: EditorTheme.colors(context).outline),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: compact ? r05 : r1,
          borderSide: BorderSide(color: EditorTheme.colors(context).primary),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: compact ? r05 : r1,
          borderSide: BorderSide(
            color: EditorTheme.colors(context).secondaryBackground,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: compact ? r05 : r1,
          borderSide: const BorderSide(color: EditorTheme.errorColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: compact ? r05 : r1,
          borderSide: BorderSide(color: EditorTheme.colors(context).primary),
        ),
        border: OutlineInputBorder(
          borderRadius: compact ? r05 : r1,
          borderSide: BorderSide(color: EditorTheme.colors(context).outline),
        ),
        focusColor: EditorTheme.colors(context).background,
        hoverColor: EditorTheme.colors(context).background,
      );

  static InputDecoration panelOutlineBorder(BuildContext context) {
    return InputDecoration(
      isDense: true,
      isCollapsed: true,
      contentPadding: panelFieldPadding,
      filled: true,
      fillColor: EditorTheme.colors(context).background,
      hoverColor: EditorTheme.colors(context).background,
      border: OutlineInputBorder(
        borderRadius: r05,
        borderSide: BorderSide(color: EditorTheme.colors(context).outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: r05,
        borderSide: BorderSide(color: EditorTheme.colors(context).primary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: r05,
        borderSide: BorderSide(color: EditorTheme.colors(context).outline),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: r05,
        borderSide: BorderSide(color: EditorTheme.colors(context).outline),
      ),
    );
  }

  static InputDecoration panelWithoutBorder(
    BuildContext context, {
    String? hintText,
  }) {
    return InputDecoration.collapsed(
      hintText: hintText,
      hoverColor: Colors.transparent,
    );
  }

  static final panelFieldPadding = UIHelper.isDesktop
      ? const EdgeInsets.symmetric(horizontal: 12, vertical: 13.5)
      : const EdgeInsets.symmetric(horizontal: 12, vertical: 10);

  static EditorColors colors(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? EditorColors(
              primary: Colors.black,
              onPrimary: const Color(0xFFEDEDED),
              surface: Colors.white,
              onSurface: const Color(0xFF707070),
              background: const Color(0xFFF8F8F8),
              onBackground: const Color(0xFF171717),
              divider: const Color(0xFFEDEDED),
              outline: const Color(0xFFE8E8E8),
              secondaryBackground: const Color(0xFFF0F0F0),
            )
          : EditorColors(
              primary: Colors.white,
              onPrimary: const Color(0xFF171717),
              surface: const Color(0xFF232323),
              onSurface: const Color(0xFF7E7E7E),
              background: const Color(0xFF1C1C1C),
              onBackground: const Color(0xFFEDEDED),
              divider: const Color(0xFF2E2E2E),
              outline: const Color(0xFF282828),
              secondaryBackground: const Color(0xFF2C2C2C),
            );

  static EditorText text(BuildContext context) {
    final titleMedium = GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.w500,
    );
    final titleSmall = GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    );
    final bodyLarge = GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
    final bodyMedium = GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
    final bodySmall = GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w400,
    );
    final labelLarge = GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );
    final labelMedium = GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
    final labelSmall = GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );
    final labelVerySmall = GoogleFonts.poppins(
      fontSize: 10,
      fontWeight: FontWeight.w500,
    );

    return EditorText(
      titleMedium: titleMedium.copyWith(color: colors(context).onBackground),
      titleSmall: titleSmall.copyWith(color: colors(context).onBackground),
      bodyLarge: bodyLarge.copyWith(color: colors(context).onBackground),
      bodyMedium: bodyMedium.copyWith(color: colors(context).onBackground),
      bodySmall: bodySmall.copyWith(color: colors(context).onBackground),
      labelLarge: labelLarge.copyWith(color: colors(context).onBackground),
      labelMedium: labelMedium.copyWith(color: colors(context).onBackground),
      labelSmall: labelSmall.copyWith(color: colors(context).onBackground),
      labelVerySmall: labelVerySmall.copyWith(color: colors(context).onBackground),
    );
  }
}

class EditorText {
  EditorText({
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
    required this.labelVerySmall,
  });

  final TextStyle titleMedium;
  final TextStyle titleSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;
  final TextStyle labelVerySmall;
}

class EditorColors {
  EditorColors({
    required this.primary,
    required this.onPrimary,
    required this.surface,
    required this.onSurface,
    required this.background,
    required this.onBackground,
    required this.divider,
    required this.outline,
    required this.secondaryBackground,
  });

  final Color primary;
  final Color onPrimary;
  final Color surface;
  final Color onSurface;
  final Color background;
  final Color onBackground;
  final Color divider;
  final Color outline;
  final Color secondaryBackground;
}

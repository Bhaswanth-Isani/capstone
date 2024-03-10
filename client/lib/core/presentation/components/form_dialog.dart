import 'package:client/core/presentation/theme/editor_theme.dart';
import 'package:flutter/material.dart';

void showFormDialog({
  required BuildContext context,
  required Widget child,
  double width = 480,
}) {
  showGeneralDialog<void>(
    barrierDismissible: true,
    barrierLabel: 'Form',
    context: context,
    transitionBuilder: (context, animation, _, child) {
      return Opacity(
        opacity: animation.value,
        child: Transform.translate(
          offset: Offset(
            width -
                (width *
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOutCubic,
                    ).value),
            0,
          ),
          child: child,
        ),
      );
    },
    pageBuilder: (context, _, __) {
      return Dialog(
        insetPadding: EdgeInsets.zero,
        alignment: Alignment.centerRight,
        elevation: 0,
        backgroundColor: EditorTheme.colors(context).surface,
        shape: const RoundedRectangleBorder(),
        child: SizedBox(
          width: width,
          height: double.infinity,
          child: child,
        ),
      );
    },
  );
}

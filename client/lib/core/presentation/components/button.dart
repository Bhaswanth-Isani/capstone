import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Button extends HookWidget {
  const Button({
    required this.child,
    this.enabled = true,
    this.cursor = SystemMouseCursors.click,
    super.key,
    this.onTap,
    this.onDoubleTap,
    this.onSecondaryTap,
    this.onLongPress,
    this.onHoverChange,
    this.autoFocus = false,
    this.firstFocus = false,
    this.lastFocus = false,
  });

  final Widget Function(bool hover, bool focus) child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final void Function(TapDownDetails)? onSecondaryTap;
  final void Function(LongPressDownDetails)? onLongPress;
  final void Function(bool hover)? onHoverChange;
  final bool enabled;
  final MouseCursor cursor;
  final bool autoFocus;
  final bool firstFocus;
  final bool lastFocus;

  static Widget noFocus({
    required Widget Function(bool hover) child,
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    void Function(TapDownDetails)? onSecondaryTap,
    void Function(LongPressDownDetails)? onLongPress,
    void Function(bool hover)? onHoverChange,
    bool enabled = true,
    MouseCursor cursor = SystemMouseCursors.click,
  }) =>
      _ButtonNoFocus(
        child: child,
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        onSecondaryTap: onSecondaryTap,
        onHoverChange: onHoverChange,
        enabled: enabled,
        cursor: cursor,
      );

  @override
  Widget build(BuildContext context) {
    final focus = useState(false);
    final hover = useState(false);

    final focusNode = useFocusNode();

    useEffect(
      () {
        if (autoFocus) {
          focusNode.requestFocus();
        } else {
          focusNode.unfocus();
        }
        return null;
      },
      [autoFocus],
    );

    final tapDownDetails = useState<TapDownDetails?>(null);
    final longPressDownDetails = useState<LongPressDownDetails?>(null);

    return FocusableActionDetector(
      autofocus: autoFocus,
      focusNode: focusNode,
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<Intent>(onInvoke: (_) => onTap?.call()),
        NextFocusIntent: CallbackAction<Intent>(
          onInvoke: (_) {
            if (!lastFocus) FocusScope.of(context).nextFocus();
            return null;
          },
        ),
        PreviousFocusIntent: CallbackAction<Intent>(
          onInvoke: (_) {
            if (!firstFocus) FocusScope.of(context).previousFocus();
            return null;
          },
        ),
      },
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
      },
      mouseCursor: enabled ? cursor : MouseCursor.defer,
      enabled: enabled,
      onShowFocusHighlight: (value) => focus.value = value,
      onShowHoverHighlight: (value) {
        hover.value = value;
        onHoverChange?.call(value);
      },
      child: GestureDetector(
        onTap: enabled && onTap != null
            ? () {
                onTap!.call();
                focusNode.requestFocus();
              }
            : null,
        onDoubleTap: enabled ? onDoubleTap : null,
        onSecondaryTapDown:
            onSecondaryTap != null ? (details) => tapDownDetails.value = details : null,
        onSecondaryTap: enabled && onSecondaryTap != null
            ? () {
                onSecondaryTap?.call(tapDownDetails.value!);
              }
            : null,
        onLongPressDown:
            onLongPress != null ? (details) => longPressDownDetails.value = details : null,
        onLongPress: enabled && onLongPress != null
            ? () {
                onLongPress?.call(longPressDownDetails.value!);
              }
            : null,
        child: child(hover.value, focus.value),
      ),
    );
  }
}

class _ButtonNoFocus extends HookWidget {
  const _ButtonNoFocus({
    required this.child,
    this.enabled = true,
    this.cursor = SystemMouseCursors.click,
    this.onTap,
    this.onDoubleTap,
    this.onSecondaryTap,
    this.onLongPress,
    this.onHoverChange,
  });

  final Widget Function(bool hover) child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final void Function(TapDownDetails)? onSecondaryTap;
  final void Function(LongPressDownDetails)? onLongPress;
  final void Function(bool hover)? onHoverChange;
  final bool enabled;
  final MouseCursor cursor;

  @override
  Widget build(BuildContext context) {
    final hover = useState(false);
    final tapDownDetails = useState<TapDownDetails?>(null);
    final longPressDownDetails = useState<LongPressDownDetails?>(null);

    return MouseRegion(
      cursor: enabled ? cursor : MouseCursor.defer,
      onEnter: (_) {
        hover.value = true;
        onHoverChange?.call(true);
      },
      onExit: (_) {
        hover.value = false;
        onHoverChange?.call(false);
      },
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        onDoubleTap: enabled ? onDoubleTap : null,
        onSecondaryTapDown:
            enabled && onSecondaryTap != null ? (details) => tapDownDetails.value = details : null,
        onSecondaryTap: enabled && onSecondaryTap != null
            ? () => onSecondaryTap?.call(tapDownDetails.value!)
            : null,
        onLongPressDown: enabled && onLongPress != null
            ? (details) => longPressDownDetails.value = details
            : null,
        onLongPress: enabled && onLongPress != null
            ? () => onLongPress?.call(longPressDownDetails.value!)
            : null,
        child: child(hover.value),
      ),
    );
  }
}

// Intents
class NextFocusIntent extends Intent {
  const NextFocusIntent();
}

class PreviousFocusIntent extends Intent {
  const PreviousFocusIntent();
}

import 'dart:math';

import 'package:client/core/presentation/components/button.dart';
import 'package:client/core/presentation/components/svg_icon.dart';
import 'package:client/core/presentation/theme/editor_icons.dart';
import 'package:client/core/presentation/theme/editor_theme.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:uuid/uuid.dart';

class ESFormSubmission extends StatelessWidget {
  const ESFormSubmission({
    this.enabled = true,
    this.loading = false,
    super.key,
    this.submitText = 'Create',
    this.cancelText = 'Cancel',
    this.onSubmit,
    this.onCancel,
  });

  final VoidCallback? onSubmit;
  final VoidCallback? onCancel;
  final String submitText;
  final String cancelText;
  final bool enabled;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ESButton.outline(
          label: cancelText,
          enabled: enabled,
          onTap: onCancel ?? () => context.pop(),
        ),
        EditorTheme.sX4,
        ESButton(
          label: submitText,
          onTap: onSubmit,
          enabled: enabled,
          loading: loading,
        ),
      ],
    );
  }
}

class ESButton extends StatelessWidget {
  const ESButton({
    required this.label,
    this.enabled = true,
    this.loading = false,
    super.key,
    this.onTap,
    this.danger = false,
  });

  final VoidCallback? onTap;
  final String label;
  final bool enabled;
  final bool loading;
  final bool danger;

  static Widget basic({
    required String label,
    bool enabled = true,
    VoidCallback? onTap,
    bool isDense = false,
  }) {
    return _ESBasicButton(
      label: label,
      enabled: enabled,
      onTap: onTap,
      isDense: isDense,
    );
  }

  static Widget outline({
    required String label,
    bool enabled = true,
    bool loading = false,
    VoidCallback? onTap,
  }) {
    return _ESButtonOutline(
      label: label,
      enabled: enabled,
      loading: loading,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Button(
      enabled: enabled,
      onTap: onTap,
      child: (hover, focus) => AnimatedContainer(
        duration: const Duration(milliseconds: 70),
        curve: Curves.easeInOut,
        padding: EditorTheme.pY1 + EditorTheme.pX3,
        decoration: BoxDecoration(
          color: enabled
              ? danger
                  ? EditorTheme.errorColor
                  : hover
                      ? EditorTheme.colors(context).onBackground
                      : EditorTheme.colors(context).primary
              : EditorTheme.colors(context).secondaryBackground,
          borderRadius: EditorTheme.r1,
        ),
        child: Row(
          children: [
            if (loading) ...[
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  color: danger ? EditorTheme.onBasic : EditorTheme.colors(context).onPrimary,
                  strokeWidth: 2,
                ),
              ),
              EditorTheme.sX2,
            ],
            Text(
              label,
              style: EditorTheme.text(context).bodyMedium.copyWith(
                    color: danger
                        ? EditorTheme.onBasic
                        : !enabled
                            ? EditorTheme.colors(context).onSurface
                            : EditorTheme.colors(context).onPrimary,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ESBasicButton extends StatelessWidget {
  const _ESBasicButton({
    required this.label,
    this.enabled = true,
    this.onTap,
    this.isDense = false,
  });

  final VoidCallback? onTap;
  final String label;
  final bool enabled;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    return Button(
      enabled: enabled,
      onTap: onTap,
      child: (hover, focus) => AnimatedContainer(
        duration: const Duration(milliseconds: 70),
        width: isDense ? null : double.infinity,
        curve: Curves.easeInOut,
        padding: EditorTheme.pY1 + EditorTheme.pX3,
        decoration: BoxDecoration(
          color: enabled
              ? hover
                  ? EditorTheme.colors(context).onBackground
                  : EditorTheme.colors(context).primary
              : EditorTheme.colors(context).secondaryBackground,
          borderRadius: EditorTheme.r1,
        ),
        child: Text(
          label,
          style: EditorTheme.text(context).bodyMedium.copyWith(
                color: enabled
                    ? EditorTheme.colors(context).onPrimary
                    : EditorTheme.colors(context).onSurface,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ESButtonOutline extends StatelessWidget {
  const _ESButtonOutline({
    required this.label,
    this.enabled = true,
    this.loading = false,
    this.onTap,
  });

  final VoidCallback? onTap;
  final String label;
  final bool enabled;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Button(
      enabled: enabled,
      onTap: onTap,
      child: (hover, focus) => AnimatedContainer(
        duration: const Duration(milliseconds: 70),
        curve: Curves.easeInOut,
        padding: EditorTheme.pY1 + EditorTheme.pX3,
        decoration: BoxDecoration(
          border: Border.all(
            color: enabled
                ? EditorTheme.colors(context).divider
                : EditorTheme.colors(context).secondaryBackground,
          ),
          borderRadius: EditorTheme.r1,
        ),
        child: Row(
          children: [
            if (loading) ...[
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  color: EditorTheme.colors(context).onPrimary,
                  strokeWidth: 2,
                ),
              ),
              EditorTheme.sX2,
            ],
            Text(
              label,
              style: EditorTheme.text(context).bodyMedium.copyWith(
                    color: !enabled
                        ? EditorTheme.colors(context).onSurface
                        : EditorTheme.colors(context).onBackground,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ESWidgetWithLabel extends StatelessWidget {
  const ESWidgetWithLabel({
    required this.label,
    required this.child,
    super.key,
    this.horizontal = false,
    this.otherEnd = false,
    this.style,
    this.description,
  });

  final String label;
  final Widget child;
  final bool horizontal;
  final bool otherEnd;
  final TextStyle? style;
  final String? description;

  @override
  Widget build(BuildContext context) {
    if (horizontal) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: style ?? EditorTheme.text(context).bodySmall,
              textAlign: otherEnd ? TextAlign.end : null,
            ),
          ),
          EditorTheme.sX1,
          Expanded(flex: 2, child: child),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: style ?? EditorTheme.text(context).bodySmall),
        if (description != null) Text(description!),
        EditorTheme.sY1,
        child,
      ],
    );
  }
}

class EmptyFilesWidget extends StatelessWidget {
  const EmptyFilesWidget({
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onTap,
    super.key,
  });

  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      padding: EditorTheme.p6,
      decoration: BoxDecoration(
        color: EditorTheme.colors(context).background,
        borderRadius: EditorTheme.r2,
        border: Border.all(color: EditorTheme.colors(context).outline),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: EditorTheme.text(context).bodyLarge),
            Text(
              message,
              style: EditorTheme.text(context)
                  .bodyMedium
                  .copyWith(color: EditorTheme.colors(context).onSurface),
              textAlign: TextAlign.center,
            ),
            EditorTheme.sY4,
            ESButton.basic(label: buttonText, onTap: onTap, isDense: true),
          ],
        ),
      ),
    );
  }
}

class ESFormField extends HookWidget {
  const ESFormField({
    this.initialValue = '',
    this.onSubmitted,
    this.validator,
    this.decoration = const InputDecoration(),
    this.maxLines = 1,
    this.autofocus = false,
    this.style,
    super.key,
  });

  final String initialValue;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;
  final InputDecoration decoration;
  final int? maxLines;
  final TextStyle? style;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final field = useTextEditingController(text: initialValue);

    final enabled = decoration.enabled;

    useEffect(
      () {
        Future(() => field.text = initialValue);
        return null;
      },
      [initialValue],
    );

    return Focus(
      onFocusChange: (focus) {
        if (!focus) {
          onSubmitted?.call(field.text);
        }
      },
      child: TextFormField(
        autofocus: autofocus,
        controller: field,
        decoration: decoration,
        cursorColor: EditorTheme.colors(context).primary,
        validator: validator,
        style: (style ?? EditorTheme.text(context).bodySmall)
            .copyWith(color: enabled ? null : EditorTheme.colors(context).onSurface),
        maxLines: maxLines,
        enabled: enabled,
      ),
    );
  }
}

class ESNumberFormField<T> extends HookWidget {
  const ESNumberFormField({
    required this.initialValue,
    this.onSubmitted,
    this.decoration = const InputDecoration(),
    this.style,
    super.key,
  });

  final T? initialValue;
  final void Function(T? value)? onSubmitted;
  final InputDecoration decoration;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final field = useTextEditingController(
      text: switch (initialValue) {
        final int value => value.toString(),
        final double value => value.toStringTruncate(),
        _ => '0',
      },
    );

    useEffect(
      () {
        field.text = switch (initialValue) {
          final int value => value.toString(),
          final double value => value.toStringTruncate(),
          _ => '0',
        };

        return null;
      },
      [initialValue],
    );

    return Row(
      children: [
        Expanded(
          child: Focus(
            onFocusChange: (focus) {
              if (!focus) {
                try {
                  final value = switch (T) {
                    int => int.parse(field.text) as T,
                    double => double.parse(field.text) as T,
                    _ => null,
                  };

                  onSubmitted?.call(value);
                } catch (_) {
                  field.text = switch (initialValue) {
                    final int value => value.toString(),
                    final double value => value.toStringTruncate(),
                    _ => '',
                  };
                }
              }
            },
            child: TextFormField(
              controller: field,
              decoration: decoration,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?\d+\.?\d*'))],
            ),
          ),
        ),
      ],
    );
  }
}

extension DoubleHelpers on double {
  String toStringTruncate() {
    return (truncateToDouble() == this ? truncate() : this).toString();
  }

  double precision(int value) {
    return double.parse(toStringAsFixed(value));
  }
}

const uuid = Uuid();

String generateID({required String prefix}) {
  return '${prefix}_${uuid.v4()}';
}

class ESSelect<T> extends HookWidget {
  const ESSelect({
    required this.selected,
    required this.items,
    required this.onChanged,
    this.align = ESMenuAlign.bottomCenter,
    this.selectIcon,
    this.groupSeparatorPadding,
    this.menuColor,
    this.menuWidth,
    this.menuMaxHeight,
    this.offset,
    this.decoration = const InputDecoration(),
    this.style,
    super.key,
  });

  final T selected;
  final List<ESSelectItem<T>> items;
  final void Function(T) onChanged;
  final ESMenuAlign align;
  final Widget? selectIcon;
  final EdgeInsets? groupSeparatorPadding;
  final Color? menuColor;
  final double? menuWidth;
  final double? menuMaxHeight;
  final Offset? offset;
  final InputDecoration decoration;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final selectController = useOverlayPortalController();
    final layerLink = useLayerLink();

    // Items
    final selectedItem = useState<ESSelectSingleItem<T>?>(null);
    final singleItems = <ESSelectSingleItem<T>>[];

    useEffect(
      () {
        for (final item in items) {
          switch (item) {
            case final ESSelectSingleItem<T> item:
              singleItems.add(item);
            case final ESSelectGroupItem<T> item:
              singleItems.addAll(item.children);
            case final ESSelectButtonItem<T> _:
              break;
          }
        }

        return null;
      },
      [items],
    );

    useEffect(
      () {
        selectedItem.value = singleItems.firstWhere((element) => element.value == selected);
        return null;
      },
      [selected],
    );

    // Animation
    final animationControl = useState(Control.play);

    // Menu
    final width = useState<double?>(null);
    final childOffset = useState<Offset?>(null);
    final childSize = useState<Size?>(null);

    Future<void> toggleMenu() async {
      if (selectController.isShowing) {
        animationControl.value = Control.playReverse;
        await Future.delayed(const Duration(milliseconds: 100), selectController.toggle);
      } else {
        width.value = context.size?.width;
        childOffset.value = (context.findRenderObject()! as RenderBox).localToGlobal(Offset.zero);
        childSize.value = (context.findRenderObject()! as RenderBox).size;
        selectController.toggle();
        animationControl.value = Control.play;
      }
    }

    return OverlayPortal(
      controller: selectController,
      overlayChildBuilder: (context) {
        final appSize = MediaQuery.of(context).size;

        final menuOffset = offset ?? align.getMenuOffset();

        final calculatedMaxHeight = switch (align) {
          ESMenuAlign.leftTop ||
          ESMenuAlign.rightTop =>
            appSize.height - childOffset.value!.dy - menuOffset.dy - 16,
          ESMenuAlign.leftBottom ||
          ESMenuAlign.rightBottom =>
            childOffset.value!.dy + childSize.value!.height + menuOffset.dy - 16,
          ESMenuAlign.leftCenter || ESMenuAlign.rightCenter => min(
                    appSize.height -
                        childOffset.value!.dy -
                        childSize.value!.height / 2 -
                        menuOffset.dy,
                    childOffset.value!.dy + childSize.value!.height / 2 - menuOffset.dy,
                  ) *
                  2 -
              16,
          ESMenuAlign.bottomCenter ||
          ESMenuAlign.bottomLeft ||
          ESMenuAlign.bottomRight ||
          ESMenuAlign.bottomRightCorner ||
          ESMenuAlign.bottomLeftCorner =>
            appSize.height - childOffset.value!.dy - childSize.value!.height - menuOffset.dy - 16,
          ESMenuAlign.topCenter ||
          ESMenuAlign.topLeft ||
          ESMenuAlign.topRight ||
          ESMenuAlign.topRightCorner ||
          ESMenuAlign.topLeftCorner =>
            childOffset.value!.dy + menuOffset.dy - 16,
        };

        return Button.noFocus(
          cursor: MouseCursor.defer,
          onTap: toggleMenu,
          child: (_) => Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
            child: CompositedTransformFollower(
              link: layerLink,
              offset: offset ?? align.getMenuOffset(),
              targetAnchor: align.getTargetAlignment(),
              followerAnchor: align.getFollowerAlignment(),
              showWhenUnlinked: false,
              child: Align(
                alignment: align.getFollowerAlignment(),
                child: CustomAnimationBuilder(
                  control: animationControl.value,
                  tween: _kMenuTween,
                  duration: const Duration(milliseconds: 100),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value.get(_kMenuScale),
                      alignment: align.getFollowerAlignment(),
                      child: Opacity(opacity: value.get(_kMenuOpacity), child: child),
                    );
                  },
                  child: Container(
                    width: menuWidth ?? width.value,
                    constraints: BoxConstraints(
                      maxHeight: min(menuMaxHeight ?? double.infinity, calculatedMaxHeight),
                    ),
                    decoration: ShapeDecoration(
                      color: menuColor ?? Theme.of(context).colorScheme.background,
                      shape: RoundedRectangleBorder(
                        side: decoration.border?.borderSide ?? BorderSide.none,
                        borderRadius: getRadius(decoration.border) ?? BorderRadius.zero,
                      ),
                      shadows: _kShadow,
                    ),
                    child: FocusScope(
                      autofocus: true,
                      child: _SelectList(
                        items: items,
                        onChanged: onChanged,
                        selectedItem: selectedItem,
                        decoration: decoration,
                        style: style,
                        groupSeparatorPadding: groupSeparatorPadding,
                        toggleMenu: toggleMenu,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CompositedTransformTarget(
            link: layerLink,
            child: _SelectButton(
              selectedItem: selectedItem,
              selectIcon: selectIcon,
              toggleMenu: toggleMenu,
              decoration: decoration,
              style: style,
            ),
          ),
          if (decoration.helperText != null)
            Text(decoration.helperText!, style: decoration.helperStyle)
                .padding(decoration.contentPadding ?? EdgeInsets.zero),
        ],
      ),
    );
  }
}

enum ESMenuAlign {
  topLeftCorner,
  topRightCorner,
  bottomLeftCorner,
  bottomRightCorner,
  topLeft,
  topCenter,
  topRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
  leftTop,
  leftCenter,
  leftBottom,
  rightTop,
  rightCenter,
  rightBottom
}

extension AlignmentHelper on ESMenuAlign {
  Alignment getTargetAlignment() {
    return switch (this) {
      ESMenuAlign.bottomCenter => Alignment.bottomCenter,
      ESMenuAlign.bottomLeft => Alignment.bottomLeft,
      ESMenuAlign.bottomLeftCorner => Alignment.bottomLeft,
      ESMenuAlign.bottomRight => Alignment.bottomRight,
      ESMenuAlign.bottomRightCorner => Alignment.bottomRight,
      ESMenuAlign.leftBottom => Alignment.bottomLeft,
      ESMenuAlign.leftCenter => Alignment.centerLeft,
      ESMenuAlign.leftTop => Alignment.topLeft,
      ESMenuAlign.rightBottom => Alignment.bottomRight,
      ESMenuAlign.rightCenter => Alignment.centerRight,
      ESMenuAlign.rightTop => Alignment.topRight,
      ESMenuAlign.topCenter => Alignment.topCenter,
      ESMenuAlign.topLeft => Alignment.topLeft,
      ESMenuAlign.topLeftCorner => Alignment.topLeft,
      ESMenuAlign.topRight => Alignment.topRight,
      ESMenuAlign.topRightCorner => Alignment.topRight,
    };
  }

  Alignment getFollowerAlignment() {
    return switch (this) {
      ESMenuAlign.bottomCenter => Alignment.topCenter,
      ESMenuAlign.bottomLeft => Alignment.topLeft,
      ESMenuAlign.bottomLeftCorner => Alignment.topRight,
      ESMenuAlign.bottomRight => Alignment.topRight,
      ESMenuAlign.bottomRightCorner => Alignment.topLeft,
      ESMenuAlign.leftBottom => Alignment.bottomRight,
      ESMenuAlign.leftCenter => Alignment.centerRight,
      ESMenuAlign.leftTop => Alignment.topRight,
      ESMenuAlign.rightBottom => Alignment.bottomLeft,
      ESMenuAlign.rightCenter => Alignment.centerLeft,
      ESMenuAlign.rightTop => Alignment.topLeft,
      ESMenuAlign.topCenter => Alignment.bottomCenter,
      ESMenuAlign.topLeft => Alignment.bottomLeft,
      ESMenuAlign.topLeftCorner => Alignment.bottomRight,
      ESMenuAlign.topRight => Alignment.bottomRight,
      ESMenuAlign.topRightCorner => Alignment.bottomLeft,
    };
  }

  Offset getMenuOffset() {
    return switch (this) {
      ESMenuAlign.topRightCorner => const Offset(8, -8),
      ESMenuAlign.topLeftCorner => const Offset(-8, -8),
      ESMenuAlign.bottomRightCorner => const Offset(8, 8),
      ESMenuAlign.bottomLeftCorner => const Offset(-8, 8),
      ESMenuAlign.topLeft || ESMenuAlign.topCenter || ESMenuAlign.topRight => const Offset(0, -8),
      ESMenuAlign.bottomLeft ||
      ESMenuAlign.bottomCenter ||
      ESMenuAlign.bottomRight =>
        const Offset(0, 8),
      ESMenuAlign.leftTop ||
      ESMenuAlign.leftCenter ||
      ESMenuAlign.leftBottom =>
        const Offset(-8, 0),
      ESMenuAlign.rightTop ||
      ESMenuAlign.rightCenter ||
      ESMenuAlign.rightBottom =>
        const Offset(8, 0),
    };
  }
}

class _SelectButton<T> extends StatelessWidget {
  const _SelectButton({
    required this.selectedItem,
    required this.selectIcon,
    required this.toggleMenu,
    required this.decoration,
    required this.style,
  });

  final ValueNotifier<ESSelectSingleItem<T>?> selectedItem;
  final Widget? selectIcon;
  final VoidCallback toggleMenu;
  final InputDecoration decoration;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Button(
      enabled: decoration.enabled,
      onTap: toggleMenu,
      child: (hover, focus) {
        final border = switch (decoration.enabled) {
          false => decoration.disabledBorder,
          true => switch (focus) {
              false => decoration.border,
              true => decoration.focusedBorder,
            }
        };

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: (decoration.filled ?? false) ? decoration.fillColor : null,
            borderRadius: getRadius(border),
            border: getBorder(border?.borderSide),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(selectedItem.value!.label, style: style)
                    .padding(decoration.contentPadding ?? EdgeInsets.zero),
              ),
              (selectIcon ?? Icon(Icons.arrow_downward_rounded, color: style?.color))
                  .padding(decoration.contentPadding ?? EdgeInsets.zero),
            ],
          ),
        );
      },
    );
  }
}

class _SelectMenuItem<T> extends StatelessWidget {
  const _SelectMenuItem({
    required this.onChanged,
    required this.item,
    required this.toggleMenu,
    required this.selectedItem,
    required this.first,
    required this.last,
    required this.decoration,
    required this.style,
  });

  final void Function(T value) onChanged;
  final ESSelectSingleItem<T> item;
  final VoidCallback toggleMenu;
  final ESSelectSingleItem<T>? selectedItem;
  final bool first;
  final bool last;
  final InputDecoration decoration;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Button(
      firstFocus: first,
      lastFocus: last,
      onTap: () {
        onChanged(item.value);
        toggleMenu();
      },
      child: (hover, focus) {
        final border = switch (decoration.enabled) {
          false => decoration.disabledBorder,
          true => switch (focus) {
              false => decoration.border,
              true => decoration.focusedBorder,
            }
        };

        return Container(
          padding: decoration.contentPadding,
          width: double.infinity,
          decoration: BoxDecoration(
            color: hover ? decoration.hoverColor : Colors.transparent,
            border: Border.all(
              color:
                  (focus ? decoration.focusedBorder?.borderSide.color : null) ?? Colors.transparent,
            ),
            borderRadius: getRadius(border),
          ),
          child: Row(
            children: [
              Expanded(child: Text(item.label, style: style)),
              if (selectedItem?.value == item.value) const Icon(Icons.check_rounded, size: 16),
            ],
          ),
        );
      },
    );
  }
}

class _SelectList<T> extends StatelessWidget {
  const _SelectList({
    required this.items,
    required this.onChanged,
    required this.selectedItem,
    required this.decoration,
    required this.style,
    required this.groupSeparatorPadding,
    required this.toggleMenu,
  });

  final List<ESSelectItem<T>> items;
  final void Function(T) onChanged;
  final ValueNotifier<ESSelectSingleItem<T>?> selectedItem;
  final InputDecoration decoration;
  final TextStyle? style;
  final EdgeInsets? groupSeparatorPadding;
  final VoidCallback toggleMenu;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EditorTheme.p1,
      children: items.mapIndexed(
        (index, item) {
          switch (item) {
            case final ESSelectSingleItem<T> item:
              return _SelectMenuItem(
                onChanged: onChanged,
                item: item,
                toggleMenu: toggleMenu,
                selectedItem: selectedItem.value,
                first: index == 0,
                last: index == items.length - 1,
                decoration: decoration,
                style: style,
              );
            case final ESSelectGroupItem<T> groupItem:
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  groupItem.separator.padding(groupSeparatorPadding ?? EditorTheme.p1),
                  ...groupItem.children.mapIndexed(
                    (subIndex, item) => _SelectMenuItem(
                      onChanged: onChanged,
                      item: item,
                      toggleMenu: toggleMenu,
                      selectedItem: selectedItem.value,
                      first: index == 0 && subIndex == 0,
                      last: index == items.length - 1 && subIndex == groupItem.children.length - 1,
                      decoration: decoration,
                      style: style,
                    ),
                  ),
                ],
              );
            case final ESSelectButtonItem<T> item:
              return Button(
                onTap: () {
                  item.onTap();
                  toggleMenu();
                },
                child: (_, __) => Container(
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.background,
                  child: item.child,
                ),
              );
          }
        },
      ).toList(),
    );
  }
}

sealed class ESSelectItem<T> {
  const ESSelectItem();
}

class ESSelectSingleItem<T> extends ESSelectItem<T> {
  const ESSelectSingleItem({required this.value, required this.label});

  final T value;
  final String label;
}

class ESSelectGroupItem<T> extends ESSelectItem<T> {
  const ESSelectGroupItem({required this.children, required this.separator});

  final List<ESSelectSingleItem<T>> children;
  final Widget separator;
}

class ESSelectButtonItem<T> extends ESSelectItem<T> {
  const ESSelectButtonItem({
    required this.onTap,
    required this.child,
  });

  final void Function() onTap;
  final Widget child;
}

BorderRadius? getRadius(InputBorder? border) {
  return switch (border) {
    UnderlineInputBorder(borderRadius: final radius) => radius,
    OutlineInputBorder(borderRadius: final radius) => radius,
    _ => null,
  };
}

Border? getBorder(BorderSide? borderSide) {
  return borderSide != null ? Border.fromBorderSide(borderSide) : null;
}

extension WidgetHelpers on Widget {
  Widget returnIfChild(bool condition, Widget Function(Widget child) widget) {
    if (condition) {
      return widget(this);
    }
    return this;
  }

  Widget returnIf(bool condition, Widget widget) {
    if (condition) {
      return widget;
    }
    return this;
  }

  Widget padding(EdgeInsetsGeometry padding) {
    return Padding(
      padding: padding,
      child: this,
    );
  }
}

final _kMenuScale = MovieTweenProperty<double>();
final _kMenuOpacity = MovieTweenProperty<double>();

final _kMenuTween = MovieTween()
  ..scene(curve: Curves.easeOutCubic, duration: const Duration(milliseconds: 100))
      .tween(_kMenuScale, Tween<double>(begin: 0.8, end: 1))
      .tween(_kMenuOpacity, Tween<double>(begin: 0, end: 1));

OverlayPortalController useOverlayPortalController() {
  return use(const _OverlayPortalControllerHook());
}

class _OverlayPortalControllerHook extends Hook<OverlayPortalController> {
  const _OverlayPortalControllerHook();

  @override
  _OverlayPortalControllerHookState createState() => _OverlayPortalControllerHookState();
}

class _OverlayPortalControllerHookState
    extends HookState<OverlayPortalController, _OverlayPortalControllerHook> {
  late OverlayPortalController controller;

  @override
  void initHook() {
    super.initHook();
    controller = OverlayPortalController();
  }

  @override
  OverlayPortalController build(BuildContext context) {
    return controller;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

final _kShadow = [
  const BoxShadow(
    color: Color(0x57000000),
    blurRadius: 16,
    offset: Offset(0, 8),
    spreadRadius: -8,
  ),
];

LayerLink useLayerLink() {
  return use(const _LayerLinkHook());
}

class _LayerLinkHook extends Hook<LayerLink> {
  const _LayerLinkHook();

  @override
  _LayerLinkHookState createState() => _LayerLinkHookState();
}

class _LayerLinkHookState extends HookState<LayerLink, _LayerLinkHook> {
  late LayerLink controller;

  @override
  void initHook() {
    super.initHook();
    controller = LayerLink();
  }

  @override
  LayerLink build(BuildContext context) {
    return controller;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class MoreWidget extends StatelessWidget {
  const MoreWidget({required this.items, this.isDense = false, super.key});

  final List<ESMenuItem> items;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    return ESDropdownMenu(
      menuColor: EditorTheme.colors(context).surface,
      decoration: EditorTheme.outlineTextField(context, select: true, compact: true)
          .copyWith(hoverColor: EditorTheme.colors(context).primary),
      items: items,
      child: (hover) => AnimatedContainer(
        padding: EdgeInsets.all(isDense ? 4 : 10),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: hover ? EditorTheme.colors(context).secondaryBackground : null,
          borderRadius: EditorTheme.r1,
        ),
        child: SvgIcon(
          asset: EditorIcons.more,
          size: 20,
          color: hover
              ? EditorTheme.colors(context).onBackground
              : EditorTheme.colors(context).onSurface,
        ),
      ),
    );
  }
}

class ESDropdownMenu extends HookWidget {
  const ESDropdownMenu({
    required this.items,
    required this.child,
    this.menuColor,
    this.width = 180,
    this.align = ESMenuAlign.bottomRight,
    this.offset,
    this.decoration = const InputDecoration(),
    super.key,
  });

  final List<ESMenuItem> items;
  final Color? menuColor;
  final double width;
  final Widget Function(bool hover) child;
  final ESMenuAlign align;
  final Offset? offset;
  final InputDecoration decoration;

  @override
  Widget build(BuildContext context) {
    final dropdownMenuController = useOverlayPortalController();
    final layerLink = useLayerLink();

    // Animation
    final animationControl = useState(Control.play);

    Future<void> toggleMenu() async {
      if (dropdownMenuController.isShowing) {
        animationControl.value = Control.playReverse;
        await Future.delayed(const Duration(milliseconds: 100), dropdownMenuController.toggle);
      } else {
        dropdownMenuController.toggle();
        animationControl.value = Control.play;
      }
    }

    return OverlayPortal(
      controller: dropdownMenuController,
      overlayChildBuilder: (context) {
        return Button.noFocus(
          cursor: MouseCursor.defer,
          onTap: toggleMenu,
          child: (_) => Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
            child: CompositedTransformFollower(
              link: layerLink,
              targetAnchor: align.getTargetAlignment(),
              followerAnchor: align.getFollowerAlignment(),
              showWhenUnlinked: false,
              offset: offset ?? align.getMenuOffset(),
              child: Align(
                alignment: align.getFollowerAlignment(),
                child: CustomAnimationBuilder(
                  control: animationControl.value,
                  tween: _kMenuTween,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeIn,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value.get(_kMenuOpacity),
                      child: Transform.scale(
                        alignment: align.getFollowerAlignment(),
                        scale: value.get(_kMenuScale),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    width: width,
                    decoration: ShapeDecoration(
                      color: menuColor ?? Theme.of(context).colorScheme.background,
                      shape: RoundedRectangleBorder(
                        side: decoration.border?.borderSide ?? BorderSide.none,
                        borderRadius: getRadius(decoration.border) ?? BorderRadius.zero,
                      ),
                      shadows: _kShadow,
                    ),
                    child: FocusScope(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        shrinkWrap: true,
                        children: items
                            .mapIndexed(
                              (index, element) => switch (element) {
                                final ESMenuSingleItem item => Button(
                                    enabled: item.enabled,
                                    onTap: () {
                                      item.onTap();
                                      toggleMenu();
                                    },
                                    child: (hover, focus) {
                                      final border = switch (decoration.enabled) {
                                        false => decoration.disabledBorder,
                                        true => switch (focus) {
                                            false => decoration.border,
                                            true => decoration.focusedBorder,
                                          }
                                      };

                                      return Container(
                                        padding: decoration.contentPadding,
                                        margin: const EdgeInsets.symmetric(horizontal: 4),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: hover ? decoration.hoverColor : Colors.transparent,
                                          border: Border.all(
                                            color: (focus
                                                    ? decoration.focusedBorder?.borderSide.color
                                                    : null) ??
                                                Colors.transparent,
                                          ),
                                          borderRadius: getRadius(border),
                                        ),
                                        child: item.child(hover),
                                      );
                                    },
                                  ),
                                ESMenuDividerItem() => const Divider(thickness: 1)
                                    .padding(const EdgeInsets.symmetric(horizontal: 4)),
                                final ESMenuWidgetItem item =>
                                  item.child.padding(const EdgeInsets.symmetric(vertical: 4)),
                              },
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: CompositedTransformTarget(
        link: layerLink,
        child: Button.noFocus(enabled: decoration.enabled, onTap: toggleMenu, child: child),
      ),
    );
  }
}

sealed class ESMenuItem {
  const ESMenuItem();
}

class ESMenuSingleItem extends ESMenuItem {
  const ESMenuSingleItem({required this.onTap, required this.child, this.enabled = true});

  final VoidCallback onTap;
  final Widget Function(bool hover) child;
  final bool enabled;
}

class ESMenuDividerItem extends ESMenuItem {
  const ESMenuDividerItem();
}

class ESMenuWidgetItem extends ESMenuItem {
  ESMenuWidgetItem({required this.child});

  final Widget child;
}

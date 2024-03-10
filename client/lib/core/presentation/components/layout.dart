import 'package:client/core/presentation/components/button.dart';
import 'package:client/core/presentation/components/svg_icon.dart';
import 'package:client/core/presentation/router/routes.dart';
import 'package:client/core/presentation/theme/editor_icons.dart';
import 'package:client/core/presentation/theme/editor_theme.dart';
import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  const Layout({required this.tab, required this.child, super.key});

  final AppTab tab;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EditorTheme.colors(context).background,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Sidebar(tab),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar(this.currentTab);

  final AppTab currentTab;

  Widget _button(BuildContext context, AppTab tab) {
    final selected = tab == currentTab;

    return Button(
      onTap: () {
        switch (tab) {
          case AppTab.dashboard:
            const DashboardRoute().push<dynamic>(context);
          case AppTab.shelf:
            const ShelfRoute().push<dynamic>(context);
          case AppTab.notifications:
            const NotificationsRoute().push<dynamic>(context);
        }
      },
      child: (hover, focus) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? EditorTheme.colors(context).divider : null,
          borderRadius: EditorTheme.r1,
          border:
              Border.all(color: focus ? EditorTheme.colors(context).primary : Colors.transparent),
        ),
        child: SvgIcon(
          asset: switch (tab) {
            AppTab.dashboard => EditorIcons.product,
            AppTab.shelf => EditorIcons.shelf,
            AppTab.notifications => EditorIcons.notification,
          },
          size: 20,
          color: selected || hover
              ? EditorTheme.colors(context).onBackground
              : EditorTheme.colors(context).onSurface,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      padding: EditorTheme.p2,
      height: double.infinity,
      color: EditorTheme.colors(context).surface,
      child: FocusScope(
        child: Column(
          children: [
            _button(context, AppTab.dashboard),
            EditorTheme.sY1,
            _button(context, AppTab.shelf),
            EditorTheme.sY1,
            const Divider(),
            EditorTheme.sY1,
            _button(context, AppTab.notifications),
          ],
        ),
      ),
    );
  }
}

enum AppTab { dashboard, shelf, notifications }

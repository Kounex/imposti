import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:imposti/router/router.dart';

import '../routes.dart';

class ShellTabs extends StatefulWidget {
  const ShellTabs({super.key});

  @override
  State<ShellTabs> createState() => _ShellTabsState();
}

class _ShellTabsState extends State<ShellTabs> {
  int _currentIndex = 0;

  int _getCurrentIndex() {
    if (BaseAppRouter().currentRoute is TabAppRoute) {
      final tabRootRoutes = List<TabAppRoute>.from(
        TabAppRoute.values.where((route) => route.isRoot),
      );
      String currentRootTabPath =
          '/${BaseAppRouter().currentRoute.fullPath.split('/').skip(1).take(1).join('')}';
      _currentIndex = tabRootRoutes.indexWhere(
        (route) => route.fullPath == currentRootTabPath,
      );
    }
    return _currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    /// Hack to reference the locale here so this subtree gets rebuild
    /// when the locale changes
    context.locale;

    return BottomNavigationBar(
      currentIndex: _getCurrentIndex(),
      items: List.from(
        TabAppRoute.values
            .where((route) => route.isRoot)
            .map(
              (route) => BottomNavigationBarItem(
                icon: Icon(route.icon),
                label: route.name.tr(),
              ),
            ),
      ),

      onTap: (index) {
        if (_getCurrentIndex() == index &&
            TabAppRoute.values
                    .where((route) => route.isRoot)
                    .elementAt(index) !=
                BaseAppRouter().currentRoute) {
          context.pop();
        } else {
          BaseAppRouter().navigateTo(
            context,
            TabAppRoute.values.where((route) => route.isRoot).elementAt(index),
          );
        }
      },
    );
  }
}

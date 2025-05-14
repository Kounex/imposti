import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:imposti/views/intro/intro.dart';
import 'package:imposti/views/lobby/game/game.dart';
import 'package:imposti/views/lobby/lobby.dart';
import 'package:imposti/views/tabs/settings/custom_categories/custom_categories.dart';

import '../views/tabs/dashboard/dashboard.dart';
import '../views/tabs/settings/settings.dart';
import 'view.dart';

abstract class BaseRoute {
  bool get isRoot;
  String get fullPath;
  String get name;
  IconData? get icon;

  RouterStatefulView view(GoRouterState state);
}

enum AppRoute implements BaseRoute {
  intro,
  lobby,
  game;

  @override
  bool get isRoot => switch (this) {
    AppRoute.intro => true,
    AppRoute.lobby => false,
    AppRoute.game => false,
  };

  @override
  String get fullPath => switch (this) {
    AppRoute.intro => '/intro',
    AppRoute.lobby => '/lobby',
    AppRoute.game => '/game/:groupUuid',
  };

  @override
  String get name => switch (this) {
    AppRoute.intro => 'Intro',
    AppRoute.lobby => 'Lobby',
    AppRoute.game => 'Game',
  };

  @override
  IconData? get icon => switch (this) {
    AppRoute.intro => null,
    AppRoute.lobby => null,
    AppRoute.game => null,
  };

  @override
  RouterStatefulView view(GoRouterState state) => switch (this) {
    AppRoute.intro => const IntroView(),
    AppRoute.lobby => const LobbyView(),
    AppRoute.game => GameView(data: GameViewData(state: state)),
  };
}

enum TabAppRoute implements BaseRoute {
  dashboard,
  settings,
  settingsCustomCategories;

  @override
  bool get isRoot => switch (this) {
    TabAppRoute.dashboard => true,
    TabAppRoute.settings => true,
    TabAppRoute.settingsCustomCategories => false,
  };

  @override
  String get fullPath => switch (this) {
    TabAppRoute.dashboard => '/',
    TabAppRoute.settings => '/settings',
    TabAppRoute.settingsCustomCategories => '/settings/custom-categories',
  };

  @override
  String get name => switch (this) {
    TabAppRoute.dashboard => 'gGame',
    TabAppRoute.settings => 'gMore',
    TabAppRoute.settingsCustomCategories => 'sharedCustomCategoryTitle',
  };

  @override
  IconData? get icon => switch (this) {
    TabAppRoute.dashboard => Icons.gamepad,
    TabAppRoute.settings => Icons.more_horiz,
    TabAppRoute.settingsCustomCategories => null,
  };

  @override
  RouterStatefulView view(GoRouterState state) => switch (this) {
    TabAppRoute.dashboard => const DashboardView(),
    TabAppRoute.settings => const SettingsView(),
    TabAppRoute.settingsCustomCategories => const CustomCategoriesView(),
  };
}

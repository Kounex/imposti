import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:imposti/models/hive_adapters.dart';
import 'package:imposti/widgets/builder/hive_builder.dart';

import 'router/router.dart';
import 'utils/theme.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return HiveBuilder<dynamic>(
      hiveKey: HiveKey.settings,
      rebuildKeys: [HiveSettingsKey.darkMode, HiveSettingsKey.languageCode],
      builder: (context, settingsBox, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          scaffoldMessengerKey: scaffoldMessengerKey,
          routerConfig: BaseAppRouter().router,
          themeMode:
              settingsBox.get(HiveSettingsKey.darkMode.name)
                  ? ThemeMode.dark
                  : ThemeMode.light,
          theme: ThemeUtils.impostiLightTheme,
          darkTheme: ThemeUtils.impostiDarkTheme,
        );
      },
    );
  }
}

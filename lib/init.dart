import 'package:base_components/base_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:imposti/models/hive_adapters.dart';
import 'package:imposti/utils/hive.dart';
import 'package:imposti/utils/theme.dart';
import 'package:imposti/widgets/builder/hive_builder.dart';

class Init extends StatefulWidget {
  final Widget child;

  const Init({super.key, required this.child});

  @override
  State<Init> createState() => _InitState();
}

class _InitState extends State<Init> {
  Future<void>? _init;

  // @override
  // void initState() {
  //   super.initState();

  //   _init = _initApp();
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _init ??= _initApp();
  }

  Future<void> _initApp() async {
    if (mounted) {
      await HiveUtils.setSavedLanguage(context, true);
    }
    if (mounted) {
      await HiveUtils.setInitialThemeMode(context);
    }
    await Future.wait([
      HiveUtils.setBaseCategories(),
      Future.delayed(const Duration(seconds: 1)),
    ]);

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return HiveBuilder<dynamic>(
      hiveKey: HiveKey.settings,
      rebuildKeys: [HiveSettingsKey.darkMode],
      builder: (context, settingsBox, child) {
        final darkMode = settingsBox.get(
          HiveSettingsKey.darkMode.name,
          defaultValue: false,
        );

        return CupertinoTheme(
          data: CupertinoThemeData(
            brightness: darkMode ? Brightness.dark : Brightness.light,
            primaryColor:
                (darkMode
                        ? ThemeUtils.impostiDarkTheme
                        : ThemeUtils.impostiLightTheme)
                    .colorScheme
                    .primary,
            applyThemeToAll: true,
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Material(
              color: Color(0xFF406459),
              child: BaseFutureBuilder(
                future: _init,
                loading: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/prots/0-0.png',
                      height: DesignSystem.size.x92,
                    ),
                    SizedBox(height: DesignSystem.spacing.x24),
                    BaseProgressIndicator(color: Colors.white),
                  ],
                ),
                data: (_) => widget.child,
              ),
            ),
          ),
        );
      },
    );
  }
}

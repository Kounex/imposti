import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_ce/hive.dart';
import 'package:imposti/app.dart';
import 'package:imposti/models/hive_registrar.g.dart';

import 'init.dart';
import 'utils/hive.dart';

void main() async {
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );

  await EasyLocalization.ensureInitialized();

  Hive
    ..init(Directory.systemTemp.path)
    ..registerAdapters();

  await HiveUtils.openHiveBoxes();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('de')],
      path: 'assets/jsons/locals',
      fallbackLocale: Locale('en'),
      child: Init(child: const App()),
    ),
  );
}

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_ce/hive.dart';

import '../models/category/category.dart';
import '../models/group/group.dart';
import '../models/hive_adapters.dart';

class HiveUtils {
  static Future<void> resetHive() async {
    await Hive.deleteFromDisk();
    await HiveUtils.openHiveBoxes();
    await HiveUtils.setBaseWords();
  }

  static Future<void> openHiveBoxes() async => await Future.wait([
    Hive.openBox<Category>(HiveKey.category.name),
    Hive.openBox<Group>(HiveKey.group.name),

    Hive.openBox<dynamic>(HiveKey.settings.name),
  ]);

  static Future<void> setBaseWords() async {
    final categoryBox = Hive.box<Category>(HiveKey.category.name);

    final jsonString = await rootBundle.loadString(
      'assets/jsons/word_data.json',
    );
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    final List<dynamic> categoriesJson = jsonData['categories'];

    for (final category in categoryBox.values) {
      if (category.base) {
        category.delete();
      }
    }

    Iterable<Category> categories = categoriesJson.map(
      (category) => Category.fromJson(category),
    );

    await categoryBox.addAll(categories);
  }

  static Future<void> setSavedLanguage(
    BuildContext context,
    bool initial,
  ) async {
    String? savedLanguageCode = Hive.box<dynamic>(
      HiveKey.settings.name,
    ).get(HiveSettingsKey.languageCode.name);
    if (savedLanguageCode != null) {
      context.setLocale(Locale(savedLanguageCode));
    } else if (!initial) {
      await context.resetLocale();
    }
  }

  static Future<void> setInitialThemeMode(BuildContext context) async {
    if (Hive.box<dynamic>(
          HiveKey.settings.name,
        ).get(HiveSettingsKey.darkMode.name) ==
        null) {
      await Hive.box<dynamic>(HiveKey.settings.name).put(
        HiveSettingsKey.darkMode.name,
        MediaQuery.of(context).platformBrightness == Brightness.dark,
      );
    }
  }
}

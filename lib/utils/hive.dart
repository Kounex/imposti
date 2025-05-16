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
    await HiveUtils.setBaseCategories();
  }

  static Future<void> openHiveBoxes() async => await Future.wait([
    Hive.openBox<Category>(HiveKey.category.name),
    Hive.openBox<Group>(HiveKey.group.name),

    Hive.openBox<dynamic>(HiveKey.settings.name),
  ]);

  static Future<void> setBaseCategories() async {
    final categoryBox = Hive.box<Category>(HiveKey.category.name);

    final jsonString = await rootBundle.loadString(
      'assets/jsons/word_data.json',
    );
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    final List<dynamic> categoriesJson = jsonData['categories'];

    for (final category in categoryBox.values) {
      if (category.base) {
        await category.delete();
      }
    }

    Iterable<Category> categories = categoriesJson.map(
      (category) => Category.fromJson(category),
    );

    await categoryBox.addAll(categories);

    await _updateGroupBaseCategories();
  }

  static Future<void> _updateGroupBaseCategories() async {
    final categoryBox = Hive.box<Category>(HiveKey.category.name);
    final groupBox = Hive.box<Group>(HiveKey.group.name);

    final baseCategories = categoryBox.values.where(
      (category) => category.base,
    );

    for (final group in groupBox.values) {
      for (final categoryUuid in group.categoryUuids) {
        final category = categoryBox.values.where(
          (category) => category.uuid == categoryUuid,
        );

        if (category.isEmpty) {
          group.categoryUuids.remove(categoryUuid);
        }
      }

      if (group.categoryUuids.isEmpty) {
        group.categoryUuids.addAll(
          baseCategories.map((category) => category.uuid),
        );
      }

      await group.save();
    }
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

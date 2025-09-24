import 'package:hive_ce/hive.dart';

import 'category/category.dart';
import 'group/group.dart';

part 'hive_adapters.g.dart';

enum HiveKey { settings, category, group }

enum HiveSettingsKey {
  /// [bool]
  darkMode,

  /// [String] code as reported by the intl package, usually
  /// 'en', 'de'
  languageCode,

  /// [bool]
  gradient,

  /// [bool] if the 'How to Play' sheet has been initially
  /// displayed
  initialHowToPlayShown,
}

@GenerateAdapters([
  AdapterSpec<Category>(),
  AdapterSpec<Group>(),
  AdapterSpec<PlayMode>(),
])
// ignore: unused_element
void _() {}

import 'package:hive_ce/hive.dart';

import 'category/category.dart';
import 'group/group.dart';

part 'hive_adapters.g.dart';

enum HiveKey { settings, category, group }

enum HiveSettingsKey { darkMode, languageCode }

@GenerateAdapters([AdapterSpec<Category>(), AdapterSpec<Group>()])
// ignore: unused_element
void _() {}

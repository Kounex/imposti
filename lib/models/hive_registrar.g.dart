// Generated by Hive CE
// Do not modify
// Check in to version control

import 'package:hive_ce/hive.dart';
import 'package:imposti/models/hive_adapters.dart';

extension HiveRegistrar on HiveInterface {
  void registerAdapters() {
    registerAdapter(CategoryAdapter());
    registerAdapter(GroupAdapter());
    registerAdapter(PlayModeAdapter());
  }
}

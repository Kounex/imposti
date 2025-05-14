import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../models/hive_adapters.dart';

class HiveBuilder<T> extends StatelessWidget {
  final HiveKey hiveKey;
  final List<HiveSettingsKey>? rebuildKeys;
  final Widget? child;
  final Widget Function(BuildContext context, Box<T> box, Widget? child)
  builder;

  const HiveBuilder({
    super.key,
    required this.hiveKey,
    this.child,
    required this.builder,
    this.rebuildKeys,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<T>(
        this.hiveKey.name,
      ).listenable(keys: this.rebuildKeys?.map((key) => key.name).toList()),
      builder: this.builder,
      child: this.child,
    );
  }
}

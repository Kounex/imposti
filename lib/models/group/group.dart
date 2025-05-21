import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:imposti/models/hive_adapters.dart';

import '../category/category.dart';

part 'group.freezed.dart';
part 'group.g.dart';

enum PlayMode {
  freestyle,
  time,
  tap;

  String get name => switch (this) {
    PlayMode.freestyle => 'playModeFreestyleName'.tr(),
    PlayMode.tap => 'playModeTapName'.tr(),
    PlayMode.time => 'playModeTimeName'.tr(),
  };

  String get description => switch (this) {
    PlayMode.freestyle => 'playModeFreestyleDescription'.tr(),
    PlayMode.tap => 'playModeTapDescription'.tr(),
    PlayMode.time => 'playModeTimeDescription'.tr(),
  };
}

@freezed
@JsonSerializable()
class Group extends HiveObject with _$Group {
  @override
  final String uuid;

  @override
  final String? name;

  @override
  final List<String> players;

  @override
  final int amountMinImposters;

  @override
  final int amountMaxImposters;

  @override
  final List<String> categoryUuids;

  @override
  final bool imposterSeesCategoryName;

  @override
  final bool zeroImposterMode;

  @override
  final PlayMode mode;

  @override
  final int modeTimeSeconds;

  @override
  final int modeTapMinTaps;

  @override
  final int modeTapMaxTaps;

  List<Category> get categories => List.from(
    Hive.box<Category>(HiveKey.category.name).values.where(
      (category) => categoryUuids.any((uuid) => uuid == category.uuid),
    ),
  );

  Group({
    required this.uuid,
    this.name,
    this.players = const [],
    this.amountMinImposters = 1,
    this.amountMaxImposters = 1,
    required this.categoryUuids,
    this.imposterSeesCategoryName = false,
    this.zeroImposterMode = false,
    this.mode = PlayMode.freestyle,
    this.modeTimeSeconds = 60,
    this.modeTapMinTaps = 10,
    this.modeTapMaxTaps = 30,
  });

  factory Group.fromJson(Map<String, Object?> json) => _$GroupFromJson(json);

  Map<String, Object?> toJson() => _$GroupToJson(this);
}

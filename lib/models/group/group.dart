import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:imposti/models/hive_adapters.dart';

import '../category/category.dart';

part 'group.freezed.dart';
part 'group.g.dart';

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
  });

  factory Group.fromJson(Map<String, Object?> json) => _$GroupFromJson(json);

  Map<String, Object?> toJson() => _$GroupToJson(this);
}

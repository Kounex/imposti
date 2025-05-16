import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
@JsonSerializable()
class Category extends HiveObject with _$Category {
  @override
  final String uuid;

  @override
  final Map<String, String> name;

  @override
  final bool base;

  @override
  final String? emojiUnicode;

  @override
  final Map<String, List<String>> words;

  Category({
    required this.uuid,
    required this.name,
    this.base = false,
    this.emojiUnicode,
    this.words = const {},
  });

  factory Category.fromJson(Map<String, Object?> json) =>
      _$CategoryFromJson(json);

  Map<String, Object?> toJson() => _$CategoryToJson(this);
}

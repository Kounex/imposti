// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Group {

 String get uuid; String? get name; List<String> get players; int get amountMinImposters; int get amountMaxImposters; List<String> get categoryUuids; bool get imposterSeesCategoryName; bool get zeroImposterMode; PlayMode get mode; int get modeTimeSeconds; int get modeTapMinTaps; int get modeTapMaxTaps;
/// Create a copy of Group
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupCopyWith<Group> get copyWith => _$GroupCopyWithImpl<Group>(this as Group, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Group&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.players, players)&&(identical(other.amountMinImposters, amountMinImposters) || other.amountMinImposters == amountMinImposters)&&(identical(other.amountMaxImposters, amountMaxImposters) || other.amountMaxImposters == amountMaxImposters)&&const DeepCollectionEquality().equals(other.categoryUuids, categoryUuids)&&(identical(other.imposterSeesCategoryName, imposterSeesCategoryName) || other.imposterSeesCategoryName == imposterSeesCategoryName)&&(identical(other.zeroImposterMode, zeroImposterMode) || other.zeroImposterMode == zeroImposterMode)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.modeTimeSeconds, modeTimeSeconds) || other.modeTimeSeconds == modeTimeSeconds)&&(identical(other.modeTapMinTaps, modeTapMinTaps) || other.modeTapMinTaps == modeTapMinTaps)&&(identical(other.modeTapMaxTaps, modeTapMaxTaps) || other.modeTapMaxTaps == modeTapMaxTaps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,name,const DeepCollectionEquality().hash(players),amountMinImposters,amountMaxImposters,const DeepCollectionEquality().hash(categoryUuids),imposterSeesCategoryName,zeroImposterMode,mode,modeTimeSeconds,modeTapMinTaps,modeTapMaxTaps);

@override
String toString() {
  return 'Group(uuid: $uuid, name: $name, players: $players, amountMinImposters: $amountMinImposters, amountMaxImposters: $amountMaxImposters, categoryUuids: $categoryUuids, imposterSeesCategoryName: $imposterSeesCategoryName, zeroImposterMode: $zeroImposterMode, mode: $mode, modeTimeSeconds: $modeTimeSeconds, modeTapMinTaps: $modeTapMinTaps, modeTapMaxTaps: $modeTapMaxTaps)';
}


}

/// @nodoc
abstract mixin class $GroupCopyWith<$Res>  {
  factory $GroupCopyWith(Group value, $Res Function(Group) _then) = _$GroupCopyWithImpl;
@useResult
$Res call({
 String uuid, String? name, List<String> players, int amountMinImposters, int amountMaxImposters, List<String> categoryUuids, bool imposterSeesCategoryName, bool zeroImposterMode, PlayMode mode, int modeTimeSeconds, int modeTapMinTaps, int modeTapMaxTaps
});




}
/// @nodoc
class _$GroupCopyWithImpl<$Res>
    implements $GroupCopyWith<$Res> {
  _$GroupCopyWithImpl(this._self, this._then);

  final Group _self;
  final $Res Function(Group) _then;

/// Create a copy of Group
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = null,Object? name = freezed,Object? players = null,Object? amountMinImposters = null,Object? amountMaxImposters = null,Object? categoryUuids = null,Object? imposterSeesCategoryName = null,Object? zeroImposterMode = null,Object? mode = null,Object? modeTimeSeconds = null,Object? modeTapMinTaps = null,Object? modeTapMaxTaps = null,}) {
  return _then(Group(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<String>,amountMinImposters: null == amountMinImposters ? _self.amountMinImposters : amountMinImposters // ignore: cast_nullable_to_non_nullable
as int,amountMaxImposters: null == amountMaxImposters ? _self.amountMaxImposters : amountMaxImposters // ignore: cast_nullable_to_non_nullable
as int,categoryUuids: null == categoryUuids ? _self.categoryUuids : categoryUuids // ignore: cast_nullable_to_non_nullable
as List<String>,imposterSeesCategoryName: null == imposterSeesCategoryName ? _self.imposterSeesCategoryName : imposterSeesCategoryName // ignore: cast_nullable_to_non_nullable
as bool,zeroImposterMode: null == zeroImposterMode ? _self.zeroImposterMode : zeroImposterMode // ignore: cast_nullable_to_non_nullable
as bool,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as PlayMode,modeTimeSeconds: null == modeTimeSeconds ? _self.modeTimeSeconds : modeTimeSeconds // ignore: cast_nullable_to_non_nullable
as int,modeTapMinTaps: null == modeTapMinTaps ? _self.modeTapMinTaps : modeTapMinTaps // ignore: cast_nullable_to_non_nullable
as int,modeTapMaxTaps: null == modeTapMaxTaps ? _self.modeTapMaxTaps : modeTapMaxTaps // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


// dart format on

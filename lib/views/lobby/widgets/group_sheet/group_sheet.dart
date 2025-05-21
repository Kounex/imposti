import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:imposti/models/group/group.dart';
import 'package:imposti/models/hive_adapters.dart';
import 'package:imposti/router/router.dart';
import 'package:imposti/router/routes.dart';
import 'package:imposti/views/lobby/widgets/group_sheet/category_sheet.dart';
import 'package:imposti/views/lobby/widgets/group_sheet/imposter_sheet.dart';
import 'package:imposti/views/lobby/widgets/group_sheet/play_mode_sheet.dart';
import 'package:imposti/views/lobby/widgets/group_sheet/player_sheet/player_sheet.dart';
import 'package:imposti/widgets/ui/sheet.dart';
import 'package:uuid/v4.dart';

import '../../../../models/category/category.dart';

class GroupSheet extends StatefulWidget {
  final Group? group;

  const GroupSheet({super.key, this.group});

  @override
  State<GroupSheet> createState() => _GroupSheetState();
}

class _GroupSheetState extends State<GroupSheet> {
  late Group _group;

  late final CustomValidationTextEditingController _name;

  @override
  void initState() {
    super.initState();

    if (widget.group != null) {
      _group = widget.group!;
    } else {
      _group = Group(
        uuid: UuidV4().generate(),
        players: [
          '${'gPlayer'.plural(1)} 1',
          '${'gPlayer'.plural(1)} 2',
          '${'gPlayer'.plural(1)} 3',
        ],
        categoryUuids: List.from(
          Hive.box<Category>(
            HiveKey.category.name,
          ).values.where((words) => words.base).map((words) => words.uuid),
        ),
      );
    }

    _name = CustomValidationTextEditingController(
      text: _group.name,
      check:
          (text) =>
              text != null &&
                      Hive.box<Group>(HiveKey.group.name).values.any(
                        (group) =>
                            group.name?.toLowerCase() ==
                                text.trim().toLowerCase() &&
                            group.uuid != _group.uuid,
                      )
                  ? 'sharedInputDialogExistsError'.plural(
                    1,
                    args: ['gGroup'.plural(1)],
                  )
                  : null,
    );
  }

  void _saveGroupAndStart() async {
    if (_name.isValid) {
      if (_name.textAtSubmission.trim().isNotEmpty) {
        _group = _group.copyWith(name: _name.textAtSubmission);
      }
      if (widget.group != null) {
        await Hive.box<Group>(
          HiveKey.group.name,
        ).put(widget.group!.key, _group);
      } else {
        await Hive.box<Group>(HiveKey.group.name).add(_group);
      }
      if (mounted) {
        Navigator.of(context).pop();
        BaseAppRouter().navigateTo(
          context,
          AppRoute.game,
          params: {':groupUuid': _group.uuid},
        );
      }
    }
  }

  void _handlePlayerTile() => ModalUtils.showExpandedModalBottomSheet(
    context,
    PlayerSheet(
      group: _group,
      onSave:
          (players) => setState(
            () =>
                _group = _group.copyWith(
                  players: players,
                  amountMaxImposters:
                      _group.amountMaxImposters > players.length
                          ? players.length
                          : _group.amountMaxImposters,
                ),
          ),
    ),
  );

  void _handleImposterTile() => ModalUtils.showExpandedModalBottomSheet(
    context,
    ImposterSheet(
      group: _group,
      onSave:
          (group) => setState(
            () =>
                _group = _group.copyWith(
                  amountMinImposters: group.amountMinImposters,
                  amountMaxImposters: group.amountMaxImposters,
                  zeroImposterMode: group.zeroImposterMode,
                ),
          ),
    ),
  );

  void _handleCategoryTile() => ModalUtils.showExpandedModalBottomSheet(
    context,
    CategorySheet(
      group: _group,
      onSave:
          (categoryUuids) => setState(
            () => _group = _group.copyWith(categoryUuids: categoryUuids),
          ),
    ),
  );

  String _amountImpostersString() {
    String amount = '${_group.amountMinImposters}';
    if (_group.amountMinImposters != _group.amountMaxImposters) {
      amount += '-${_group.amountMaxImposters}';
    }
    return amount;
  }

  void _deleteGroup() {
    ModalUtils.showBaseDialog(
      context,
      BaseConfirmationDialog(
        title: 'lobbyDialogDeleteGroupTitle'.tr(),
        body: 'lobbyDialogDeleteGroupBody'.tr(),
        noText: 'gNo'.tr(),
        yesText: 'gYes'.tr(),
        isYesDestructive: true,
        onYes: (_) async {
          await widget.group!.delete();
          if (mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  String _getCategoryNames() {
    final firstCategory =
        _group.categories.first.name[_group.categories.first.base
            ? context.locale.languageCode
            : 'custom']!;

    return _group.categories
        .skip(1)
        .fold(
          firstCategory,
          (prev, curr) =>
              '$prev, ${curr.name[curr.base ? context.locale.languageCode : 'custom']!}',
        );
  }

  @override
  Widget build(BuildContext context) {
    return BaseSheet(
      onAction: _saveGroupAndStart,
      onDelete: widget.group != null ? _deleteGroup : null,
      title: 'gGroup'.plural(1),
      actionText: 'lobbyBtnStart'.tr(),
      children: [
        Text('lobbyGroupNameDescription'.tr()),
        SizedBox(height: DesignSystem.spacing.x8),
        BaseAdaptiveTextField(
          controller: _name,
          clearButton: true,
          placeholder: '(${'gOptional'.tr()}) ${'gName'.tr()}',
        ),
        SizedBox(height: DesignSystem.spacing.x24),
        BaseCupertinoListSection(
          tiles: [
            BaseCupertinoListTile(
              onTap: _handlePlayerTile,
              leadingIcon: CupertinoIcons.person_solid,
              additionalInfo: Row(
                children: [
                  Text('${_group.players.length}'),
                  CupertinoListTileChevron(),
                ],
              ),
              title: Text('gPlayer'.plural(2)),
              subtitle:
                  _group.players.isNotEmpty
                      ? Text(
                        _group.players
                            .skip(1)
                            .fold(
                              _group.players.first,
                              (prev, curr) => '$prev, $curr',
                            ),
                      )
                      : null,
            ),
            BaseCupertinoListTile(
              onTap: _handleImposterTile,
              leadingIcon: Icons.android,
              leadingIconBackgroundColor: Colors.red,
              title: Text('lobbyAmountImpostersTitle'.tr()),
              additionalInfo: Row(
                children: [
                  Text(_amountImpostersString()),
                  CupertinoListTileChevron(),
                ],
              ),
            ),
            BaseCupertinoListTile(
              onTap: _handleCategoryTile,
              leadingIcon: Icons.category,
              leadingIconBackgroundColor: Colors.green,
              title: Text('gCategory'.plural(2)),
              subtitle:
                  _group.categoryUuids.isNotEmpty
                      ? Text(_getCategoryNames())
                      : null,
              additionalInfo: Row(
                children: [
                  Text('${_group.categoryUuids.length}'),
                  CupertinoListTileChevron(),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: DesignSystem.spacing.x24),
        BaseCupertinoListSection(
          footerText: 'lobbyImposterSeesCategoryHelp'.tr(),
          tiles: [
            BaseCupertinoListTile(
              title: Text('lobbyImposterSeesCategory'.tr()),

              leadingIcon: CupertinoIcons.search,
              leadingIconBackgroundColor: Colors.orange,
              additionalInfo: BaseAdaptiveSwitch(
                value: _group.imposterSeesCategoryName,
                onChanged:
                    (change) => setState(
                      () =>
                          _group = _group.copyWith(
                            imposterSeesCategoryName: change,
                          ),
                    ),
              ),
            ),
          ],
        ),
        SizedBox(height: DesignSystem.spacing.x12),
        BaseCupertinoListSection(
          tiles: [
            BaseCupertinoListTile(
              onTap:
                  () => ModalUtils.showExpandedModalBottomSheet(
                    context,
                    PlayModeSheet(
                      group: _group,
                      onSave:
                          (group) => setState(
                            () =>
                                _group = _group.copyWith(
                                  mode: group.mode,
                                  modeTimeSeconds: group.modeTimeSeconds,
                                  modeTapMinTaps: group.modeTapMinTaps,
                                  modeTapMaxTaps: group.modeTapMaxTaps,
                                ),
                          ),
                    ),
                  ),
              title: Text('lobbyPlayModeTitle'.tr()),
              additionalInfo: Row(
                children: [Text(_group.mode.name), CupertinoListTileChevron()],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

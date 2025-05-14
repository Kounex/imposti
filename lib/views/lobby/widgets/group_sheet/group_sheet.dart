import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:imposti/models/group/group.dart';
import 'package:imposti/models/hive_adapters.dart';
import 'package:imposti/router/router.dart';
import 'package:imposti/router/routes.dart';
import 'package:imposti/views/lobby/widgets/group_sheet/widgets/category_sheet.dart';
import 'package:imposti/views/lobby/widgets/group_sheet/widgets/imposter_sheet.dart';
import 'package:imposti/views/lobby/widgets/group_sheet/widgets/player_sheet/player_sheet.dart';
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
  }

  void _saveGroupAndStart() async {
    if (widget.group != null && widget.group!.isInBox) {
      await Hive.box<Group>(
        HiveKey.group.name,
      ).put(widget.group!.key, _group.copyWith(uuid: widget.group!.uuid));
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
          (minMax) => setState(
            () =>
                _group = _group.copyWith(
                  amountMinImposters: minMax.$1,
                  amountMaxImposters: minMax.$2,
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

  Future<void> _deleteGroup() async {
    ModalUtils.showBaseDialog(
      context,
      BaseConfirmationDialog(
        title: 'lobbyDialogDeleteGroupTitle'.tr(),
        body: 'lobbyDialogDeleteGroupBody'.tr(),
        noText: 'gNo'.tr(),
        yesText: 'gYes'.tr(),
        isYesDestructive: true,
        onYes: (_) {
          widget.group!.delete();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            EdgeInsets.all(DesignSystem.spacing.x24) +
            EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'gGroup'.plural(1),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Expanded(
              child: ListView(
                children: [
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
                                ? Text(
                                  _group.categories
                                      .skip(1)
                                      .fold(
                                        _group.categories.first.name[context
                                            .locale
                                            .languageCode]!,
                                        (prev, curr) =>
                                            '$prev, ${curr.name[context.locale.languageCode]!}',
                                      ),
                                )
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
                    tiles: [
                      BaseCupertinoListTile(
                        title: Row(
                          children: [
                            Text('lobbyImposterSeesCategory'.tr()),
                            SizedBox(width: DesignSystem.spacing.x12),
                            QuestionMarkTooltip(
                              message: 'lobbyImposterSeesCategoryHelp'.tr(),
                            ),
                          ],
                        ),
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
                ],
              ),
            ),
            SizedBox(height: DesignSystem.spacing.x24),
            if (widget.group != null) ...[
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  onPressed: _deleteGroup,
                  color: Theme.of(context).colorScheme.error,
                  child: Text(
                    'gDelete'.tr(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onError,
                    ),
                  ),
                ),
              ),
              SizedBox(height: DesignSystem.spacing.x24),
            ],
            SizedBox(
              width: double.infinity,
              child: CupertinoButton.filled(
                onPressed: _saveGroupAndStart,
                child: Text('lobbyBtnStart'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

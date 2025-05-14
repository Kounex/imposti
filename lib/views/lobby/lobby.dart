import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imposti/models/hive_adapters.dart';
import 'package:imposti/router/view.dart';
import 'package:imposti/utils/prots.dart';
import 'package:imposti/views/lobby/widgets/group_sheet/group_sheet.dart';
import 'package:imposti/widgets/builder/hive_builder.dart';
import 'package:imposti/widgets/ui/imposti_scaffold.dart';

import '../../models/group/group.dart';

class LobbyView extends RouterStatefulView {
  const LobbyView({super.key});

  @override
  State<LobbyView> createState() => _LobbyViewState();
}

class _LobbyViewState extends State<LobbyView> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ImpostiScaffold(
      includeBackButton: true,
      body: Stack(
        alignment: Alignment.bottomCenter,
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: DesignSystem.spacing.x256 + DesignSystem.spacing.x24,
            left: 0,
            right: 0,
            child: Image.asset(ProtsUtils.getRandomProts(1)[0]),
          ),
          Positioned(
            bottom: DesignSystem.spacing.x48 + DesignSystem.spacing.x24,
            left: 0,
            right: 0,
            child: BaseCard(
              title: 'gGroup'.plural(2),
              backgroundColor:
                  Theme.of(context).bottomSheetTheme.backgroundColor,
              leftPadding: 0,
              rightPadding: 0,
              paddingChild:
                  EdgeInsets.zero +
                  EdgeInsets.only(left: DesignSystem.spacing.x8),
              constrained: false,
              child: SizedBox(
                height: DesignSystem.size.x128 + DesignSystem.size.x92,
                child: HiveBuilder<Group>(
                  hiveKey: HiveKey.group,
                  builder:
                      (context, groupBox, child) => switch (groupBox.isEmpty) {
                        true => Center(
                          child: BasePlaceholder(
                            text: 'lobbyGroupCardEmpty'.tr(),
                          ),
                        ),
                        false => Scrollbar(
                          controller: _controller,
                          thumbVisibility: true,
                          child: ListView(
                            controller: _controller,
                            padding: EdgeInsets.zero,
                            children: List.from(
                              groupBox.values.map(
                                (group) => ListTile(
                                  onTap:
                                      () =>
                                          ModalUtils.showExpandedModalBottomSheet(
                                            context,
                                            GroupSheet(group: group),
                                          ),
                                  title: Text(
                                    group.name ??
                                        group.players
                                            .skip(1)
                                            .fold<String>(
                                              group.players.first,
                                              (prev, curr) => '$prev, $curr',
                                            ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      },
                ),
              ),
            ),
          ),
          Positioned(
            bottom: DesignSystem.spacing.x12,
            left: 0,
            right: 0,
            child: CupertinoButton.filled(
              onPressed:
                  () => ModalUtils.showExpandedModalBottomSheet(
                    context,
                    GroupSheet(),
                    onClose: () {},
                  ),
              child: Text('lobbyBtnNewGroup'.tr()),
            ),
          ),
        ],
      ),
    );
  }
}

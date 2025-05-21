import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:imposti/widgets/ui/count_stepper.dart';
import 'package:imposti/widgets/ui/sheet.dart';

import '../../../../models/group/group.dart';

class ImposterSheet extends StatefulWidget {
  final Group group;

  final void Function(Group group) onSave;

  const ImposterSheet({super.key, required this.group, required this.onSave});

  @override
  State<ImposterSheet> createState() => _ImposterSheetState();
}

class _ImposterSheetState extends State<ImposterSheet> {
  late int _amountMinImposters;
  late int _amountMaxImposters;
  late bool _zeroImposterMode;

  @override
  void initState() {
    super.initState();

    _amountMinImposters = widget.group.amountMinImposters;
    _amountMaxImposters = widget.group.amountMaxImposters;
    _zeroImposterMode = widget.group.zeroImposterMode;
  }

  @override
  Widget build(BuildContext context) {
    return BaseSheet(
      onAction: () {
        widget.onSave(
          Group(
            uuid: '',
            categoryUuids: [],
            amountMinImposters: _amountMinImposters,
            amountMaxImposters: _amountMaxImposters,
            zeroImposterMode: _zeroImposterMode,
          ),
        );
        Navigator.of(context).pop();
      },
      title: 'gImposter'.plural(2),
      children: [
        Text('lobbyAmountImpostersDescription'.tr()),
        SizedBox(height: DesignSystem.spacing.x24),
        BaseCupertinoListSection(
          hasLeading: false,
          tiles: [
            BaseCupertinoListTile(
              title: Text('lobbyAmountImpostersMinText'.tr()),
              additionalInfo: CountStepper(
                count: _amountMinImposters,
                onDecrement:
                    _amountMinImposters > 0
                        ? () => setState(() => _amountMinImposters--)
                        : null,
                onIncrement:
                    _amountMinImposters < _amountMaxImposters
                        ? () => setState(() => _amountMinImposters++)
                        : null,
              ),
            ),
          ],
        ),
        SizedBox(height: DesignSystem.spacing.x24),
        BaseCupertinoListSection(
          hasLeading: false,
          tiles: [
            BaseCupertinoListTile(
              title: Text('lobbyAmountImpostersMaxText'.tr()),
              additionalInfo: CountStepper(
                count: _amountMaxImposters,
                onDecrement:
                    _amountMaxImposters > _amountMinImposters
                        ? () => setState(() => _amountMaxImposters--)
                        : null,
                onIncrement:
                    _amountMaxImposters < widget.group.players.length
                        ? () => setState(() => _amountMaxImposters++)
                        : null,
              ),
            ),
          ],
        ),
        SizedBox(height: DesignSystem.spacing.x24),
        BaseCupertinoListSection(
          footerText: 'lobbyImposterZeroHelp'.tr(),
          tiles: [
            BaseCupertinoListTile(
              title: Text('lobbyImposterZeroTitle'.tr()),
              additionalInfo: BaseAdaptiveSwitch(
                value: _zeroImposterMode,
                onChanged:
                    _amountMinImposters > 0
                        ? (change) => setState(() => _zeroImposterMode = change)
                        : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

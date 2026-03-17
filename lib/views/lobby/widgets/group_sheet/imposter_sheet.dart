import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:imposti/widgets/ui/count_stepper.dart';
import 'package:imposti/widgets/ui/sheet.dart';

import '../../../../models/group/group.dart';

class ImposterSheet extends StatefulWidget {
  final Group group;

  final void Function(Group group) onSave;
  final void Function(bool isDirty)? onDirtyChanged;

  const ImposterSheet({
    super.key,
    required this.group,
    required this.onSave,
    this.onDirtyChanged,
  });

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

  void _checkDirty() {
    widget.onDirtyChanged?.call(
      _amountMinImposters != widget.group.amountMinImposters ||
          _amountMaxImposters != widget.group.amountMaxImposters ||
          _zeroImposterMode != widget.group.zeroImposterMode,
    );
  }

  void _onDecrementMinImposters() {
    setState(() {
      if (_amountMinImposters > 0) {
        _amountMinImposters--;
      }
    });
    _checkDirty();
  }

  void _onIncrementMinImposters() {
    setState(() {
      if (_amountMinImposters < _amountMaxImposters) {
        _amountMinImposters++;
      }
    });
    _checkDirty();
  }

  void _onDecrementMaxImposters() {
    setState(() {
      if (_amountMaxImposters > _amountMinImposters) {
        _amountMaxImposters--;
      }
    });
    _checkDirty();
  }

  void _onIncrementMaxImposters() {
    setState(() {
      if (_amountMaxImposters < widget.group.players.length) {
        _amountMaxImposters++;
      }
    });
    _checkDirty();
  }

  void _onZeroImposterModeChanged(bool change) {
    setState(() => _zeroImposterMode = change);
    _checkDirty();
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
                    _amountMinImposters > 0 ? _onDecrementMinImposters : null,
                onIncrement:
                    _amountMinImposters < _amountMaxImposters
                        ? _onIncrementMinImposters
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
                        ? _onDecrementMaxImposters
                        : null,
                onIncrement:
                    _amountMaxImposters < widget.group.players.length
                        ? _onIncrementMaxImposters
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
                onChanged: _onZeroImposterModeChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

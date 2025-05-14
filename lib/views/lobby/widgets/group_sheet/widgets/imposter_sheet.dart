import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imposti/widgets/ui/count_stepper.dart';

import '../../../../../models/group/group.dart';

class ImposterSheet extends StatefulWidget {
  final Group group;

  final void Function((int min, int max) minMax) onSave;

  const ImposterSheet({super.key, required this.group, required this.onSave});

  @override
  State<ImposterSheet> createState() => _ImposterSheetState();
}

class _ImposterSheetState extends State<ImposterSheet> {
  late int _amountMinImposters;
  late int _amountMaxImposters;

  @override
  void initState() {
    super.initState();

    _amountMinImposters = widget.group.amountMinImposters;
    _amountMaxImposters = widget.group.amountMaxImposters;
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
              'gImposter'.plural(2),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Expanded(
              child: ListView(
                children: [
                  SizedBox(height: DesignSystem.spacing.x24),
                  Text('lobbyAmountImpostersDescription'.tr()),
                  SizedBox(height: DesignSystem.spacing.x24),
                  BaseCupertinoListSection(
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
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton.filled(
                onPressed: () {
                  widget.onSave((_amountMinImposters, _amountMaxImposters));
                  Navigator.of(context).pop();
                },
                child: Text('gSave'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

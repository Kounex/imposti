import 'dart:math';

import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imposti/views/lobby/game/widgets/game/player_card%20copy.dart';

class StartPlayerStage extends StatefulWidget {
  final List<String> players;
  final List<String> prots;

  final void Function()? onStageDone;

  const StartPlayerStage({
    super.key,
    required this.players,
    required this.prots,
    this.onStageDone,
  });

  @override
  State<StartPlayerStage> createState() => _StartPlayerStageState();
}

class _StartPlayerStageState extends State<StartPlayerStage> {
  late int _startPlayerIndex;

  @override
  void initState() {
    super.initState();

    _startPlayerIndex = Random().nextInt(widget.players.length);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          left: 0,
          right: 0,
          child: Column(
            children: [
              SizedBox(height: DesignSystem.spacing.x48),
              Container(
                height: min(
                  (MediaQuery.sizeOf(context).height / 100) * 65,
                  DesignSystem.size.x256 + DesignSystem.size.x128,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: DesignSystem.spacing.x64,
                ),
                child: PlayerCard(
                  player: widget.players[_startPlayerIndex],
                  prot: widget.prots[_startPlayerIndex],
                ),
              ),
              SizedBox(height: DesignSystem.spacing.x64),
              Text(
                'Startet die Runde!',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              SizedBox(height: DesignSystem.spacing.x64),
              Builder(
                builder: (context) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: DesignSystem.spacing.x24,
                    ),
                    child: CupertinoButton.filled(
                      onPressed: widget.onStageDone,
                      child: Text('lobbyBtnStart'.tr()),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'dart:math';

import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:imposti/views/lobby/game/widgets/game/play_stage/start_player.dart';

import '../unknown_player_card.dart';

class FreestyleMode extends StatelessWidget {
  final String startPlayer;

  final void Function() onStageDone;

  const FreestyleMode({
    super.key,
    required this.startPlayer,
    required this.onStageDone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StartPlayer(player: startPlayer),
        SizedBox(height: DesignSystem.spacing.x24),
        Stack(
          children: [
            Transform(
              transform:
                  Matrix4.identity()
                    ..translate(0.0, -18.0, 0.0)
                    ..rotateZ(-pi / 24),
              alignment: Alignment.bottomCenter,
              child: UnknownPlayerCard(),
            ),
            Transform(
              transform:
                  Matrix4.identity()
                    ..translate(0.0, -18.0, 0.0)
                    ..rotateZ(pi / 24),
              alignment: Alignment.bottomCenter,
              child: UnknownPlayerCard(),
            ),
            UnknownPlayerCard(),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: DesignSystem.spacing.x12),
          child: SizedBox(
            width: double.infinity,
            child: CupertinoButton.filled(
              onPressed: onStageDone,
              child: Text('gamePlayBtnReveal'.tr()),
            ),
          ),
        ),
      ],
    );
  }
}

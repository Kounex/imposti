import 'dart:math';

import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imposti/views/lobby/game/widgets/game/play_stage/unknown_player_card.dart';

class PlayStage extends StatelessWidget {
  final void Function()? onStageDone;

  const PlayStage({super.key, this.onStageDone});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(DesignSystem.spacing.x24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            Text(
              'gamePlayDescription'.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
            SizedBox(height: DesignSystem.spacing.x42),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: DesignSystem.spacing.x32,
              ),
              width: double.infinity,
              child: CupertinoButton.filled(
                onPressed: () => onStageDone?.call(),
                child: Text('gamePlayBtnReveal'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

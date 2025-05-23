import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:imposti/views/lobby/game/widgets/game/play_stage/countdown.dart';
import 'package:imposti/views/lobby/game/widgets/game/play_stage/start_player.dart';

class TimeMode extends StatelessWidget {
  final String startPlayer;

  final int timeSeconds;

  final void Function(bool imposterWon) onStageDone;

  const TimeMode({
    super.key,
    required this.startPlayer,
    required this.timeSeconds,
    required this.onStageDone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(height: DesignSystem.spacing.x24),
        StartPlayer(player: startPlayer),
        Countdown(
          text: 'gamePlayTimeEnd'.tr(),
          countdown: timeSeconds,
          onCountdownDone: () => onStageDone(true),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: DesignSystem.spacing.x12),
          child: SizedBox(
            width: double.infinity,
            child: CupertinoButton.filled(
              onPressed: () => onStageDone(false),
              child: Text('gamePlayBtnReveal'.tr()),
            ),
          ),
        ),
        SizedBox(height: DesignSystem.spacing.x24),
      ],
    );
  }
}

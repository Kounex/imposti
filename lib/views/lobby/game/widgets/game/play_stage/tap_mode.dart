import 'dart:math';

import 'package:animated_digit/animated_digit.dart';
import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:imposti/views/lobby/game/widgets/game/play_stage/countdown.dart';
import 'package:imposti/views/lobby/game/widgets/game/play_stage/start_player.dart';

enum TapStage { tap, reveal }

class TapMode extends StatefulWidget {
  final String startPlayer;

  final int minTaps;
  final int maxTaps;

  final void Function(bool imposterWon) onStageDone;

  const TapMode({
    super.key,
    required this.startPlayer,
    required this.minTaps,
    required this.maxTaps,
    required this.onStageDone,
  });

  @override
  State<TapMode> createState() => _TapModeState();
}

class _TapModeState extends State<TapMode> {
  final GlobalKey _tapKey = GlobalKey();
  final GlobalKey _revealKey = GlobalKey();

  late final OverlayEntry _entry;

  final AnimatedDigitController _controller = AnimatedDigitController(0);

  TapStage _stage = TapStage.tap;

  late final int _lastTap;

  @override
  void initState() {
    super.initState();

    _lastTap =
        Random().nextInt(widget.maxTaps - widget.minTaps + 1) + widget.minTaps;

    _entry = OverlayEntry(
      builder:
          (context) => Positioned.fill(
            child: Stack(
              children: [
                IgnorePointer(child: SizedBox.expand()),

                Listener(
                  behavior: HitTestBehavior.translucent,
                  onPointerDown: (event) => _handleTap(),
                  child: const SizedBox.expand(),
                ),
              ],
            ),
          ),
    );

    SchedulerBinding.instance.addPostFrameCallback(
      (_) => Overlay.of(context).insert(_entry),
    );
  }

  void _handleTap() {
    _controller.value++;

    if (_controller.value >= _lastTap) {
      _entry.remove();
      _stage = TapStage.reveal;
    }

    setState(() {});
  }

  @override
  void dispose() {
    _entry.remove();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
      child: AnimatedSwitcher(
        duration: DesignSystem.animation.defaultDurationMS250,
        child: switch (_stage) {
          TapStage.tap => Column(
            key: _tapKey,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: DesignSystem.spacing.x24),
              StartPlayer(player: widget.startPlayer),
              Column(
                children: [
                  AnimatedDigitWidget(
                    controller: _controller,
                    loop: false,
                    textStyle: Theme.of(
                      context,
                    ).textTheme.displaySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                  Text('Taps'),
                ],
              ),
              Text('gamePlayTapDescription'.tr()),
              SizedBox(
                width: DesignSystem.size.x128 + DesignSystem.size.x92,
                child: CupertinoButton.filled(
                  onPressed: () => widget.onStageDone(false),
                  child: Text('gamePlayBtnReveal'.tr()),
                ),
              ),
              SizedBox(height: DesignSystem.spacing.x24),
            ],
          ),
          TapStage.reveal => Column(
            key: _revealKey,
            mainAxisSize: MainAxisSize.min,
            children: [
              Countdown(
                text: 'gamePlayTapTimerDescription'.tr(),
                textStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                onCountdownDone: () => widget.onStageDone(true),
                countdown: 10,
                spacing: DesignSystem.spacing.x64,
                valueColors: [
                  BaseValueColor(
                    condition: (value) => value <= 10,
                    color: Colors.orange,
                  ),
                  BaseValueColor(
                    condition: (value) => value <= 5,
                    color: Colors.red,
                  ),
                ],
              ),
              SizedBox(height: DesignSystem.spacing.x64),
              SizedBox(
                width: DesignSystem.size.x128 + DesignSystem.size.x92,
                child: CupertinoButton.filled(
                  onPressed: () => widget.onStageDone(false),
                  child: Text('gamePlayBtnReveal'.tr()),
                ),
              ),
            ],
          ),
        },
      ),
    );
  }
}

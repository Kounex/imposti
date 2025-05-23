import 'dart:math';

import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:imposti/models/group/group.dart';
import 'package:imposti/views/lobby/game/widgets/game/play_stage/countdown.dart';
import 'package:imposti/views/lobby/game/widgets/game/play_stage/freestyle_mode.dart';
import 'package:imposti/views/lobby/game/widgets/game/play_stage/start_player.dart';

import 'tap_mode.dart';
import 'time_mode.dart';

enum Stage { startPlayer, mode }

class PlayStage extends StatefulWidget {
  final List<String> players;
  final List<String> prots;

  final PlayMode mode;

  final int modeTimeSeconds;

  final int modeTapMinTaps;
  final int modeTapMaxTaps;

  final void Function(bool imposterWon) onStageDone;

  const PlayStage({
    super.key,
    required this.players,
    required this.prots,
    required this.mode,
    required this.modeTimeSeconds,
    required this.modeTapMinTaps,
    required this.modeTapMaxTaps,
    required this.onStageDone,
  });

  @override
  State<PlayStage> createState() => _PlayStageState();
}

class _PlayStageState extends State<PlayStage> with TickerProviderStateMixin {
  final GlobalKey _startPlayerKey = GlobalKey();
  final GlobalKey _modeKey = GlobalKey();

  late int _startPlayerIndex;

  Stage _stage = Stage.startPlayer;

  @override
  void initState() {
    super.initState();

    _startPlayerIndex = Random().nextInt(widget.players.length);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(DesignSystem.spacing.x24),
      child: Center(
        child: AnimatedSwitcher(
          duration: DesignSystem.animation.defaultDurationMS500,
          child: switch (_stage) {
            Stage.startPlayer => Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                Center(
                  child: StartPlayer(
                    key: _startPlayerKey,
                    player: widget.players[_startPlayerIndex],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: DesignSystem.spacing.x24,
                  child: Countdown(
                    countdown: 3,
                    showCountdownDelay: 3,
                    text: 'gamePlayStartCountdownDescription'.tr(),
                    onCountdownDone: () => setState(() => _stage = Stage.mode),
                  ),
                ),
              ],
            ),
            Stage.mode => switch (widget.mode) {
              PlayMode.freestyle => FreestyleMode(
                key: _modeKey,
                startPlayer: widget.players[_startPlayerIndex],
                onStageDone: () => widget.onStageDone(false),
              ),
              PlayMode.time => TimeMode(
                key: _modeKey,
                startPlayer: widget.players[_startPlayerIndex],
                timeSeconds: widget.modeTimeSeconds,
                onStageDone: widget.onStageDone,
              ),
              PlayMode.tap => TapMode(
                key: _modeKey,
                startPlayer: widget.players[_startPlayerIndex],
                minTaps: widget.modeTapMinTaps,
                maxTaps: widget.modeTapMaxTaps,
                onStageDone: widget.onStageDone,
              ),
            },
          },
        ),
      ),
    );
  }
}

/// OLD AS REFERENCE FOR PRECISE ANIMATION

// import 'package:base_components/base_components.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:imposti/views/lobby/game/widgets/game/play_stage/unknown_player_card.dart';

// class PlayStageOld extends StatefulWidget {
//   final List<String> players;
//   final List<String> prots;

//   final void Function()? onStageDone;

//   const PlayStageOld({
//     super.key,
//     required this.players,
//     required this.prots,
//     this.onStageDone,
//   });

//   @override
//   State<PlayStageOld> createState() => _PlayStageOldState();
// }

// class _PlayStageOldState extends State<PlayStageOld>
//     with TickerProviderStateMixin {
//   late final AnimationController _controllerText;
//   late Animation<Offset> _position;

//   late final AnimationController _controllerColumn;
//   late final Animation<double> _opacity;

//   final GlobalKey _textKey = GlobalKey();
//   final GlobalKey _columnKey = GlobalKey();

//   late int _startPlayerIndex;

//   @override
//   void initState() {
//     super.initState();

//     _startPlayerIndex = Random().nextInt(widget.players.length);

//     _controllerText = AnimationController(
//       vsync: this,
//       // duration: DesignSystem.animation.defaultDurationMS500,
//       duration: Duration(seconds: 1),
//     );

//     _controllerColumn = AnimationController(
//       vsync: this,
//       duration: DesignSystem.animation.defaultDurationMS500,
//     );

//     _position = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 0)).animate(
//       CurvedAnimation(parent: _controllerText, curve: Curves.easeInOut),
//     );

//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       final columnBox =
//           _columnKey.currentContext?.findRenderObject() as RenderBox?;
//       final textBox = _textKey.currentContext?.findRenderObject() as RenderBox?;

//       final sizeToSubtract =
//           textBox!.size.height +
//           View.of(context).viewPadding.top / View.of(context).devicePixelRatio;

//       _position = Tween<Offset>(
//         begin: Offset(
//           0,
//           MediaQuery.sizeOf(context).height / 2 - sizeToSubtract,
//         ),
//         end: Offset(
//           0,
//           (columnBox!.localToGlobal(Offset.zero).dy.abs() -
//               sizeToSubtract -
//               DesignSystem.spacing.x48),
//         ),
//       ).animate(
//         CurvedAnimation(parent: _controllerText, curve: Curves.easeInOut),
//       );

//       setState(() {});
//     });

//     _opacity = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(parent: _controllerColumn, curve: Curves.easeIn));

//     Future.delayed(Duration(seconds: 3)).then((_) {
//       _controllerText.forward();
//       Future.delayed(
//         Duration(milliseconds: 500),
//       ).then((__) => _controllerColumn.forward());
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(DesignSystem.spacing.x24),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           Positioned(
//             left: 0,
//             right: 0,
//             child: Padding(
//               padding: EdgeInsets.only(top: DesignSystem.spacing.x128),
//               child: FadeTransition(
//                 opacity: _opacity,
//                 child: Column(
//                   key: _columnKey,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Stack(
//                       children: [
//                         Transform(
//                           transform:
//                               Matrix4.identity()
//                                 ..translate(0.0, -18.0, 0.0)
//                                 ..rotateZ(-pi / 24),
//                           alignment: Alignment.bottomCenter,
//                           child: UnknownPlayerCard(),
//                         ),
//                         Transform(
//                           transform:
//                               Matrix4.identity()
//                                 ..translate(0.0, -18.0, 0.0)
//                                 ..rotateZ(pi / 24),
//                           alignment: Alignment.bottomCenter,
//                           child: UnknownPlayerCard(),
//                         ),
//                         UnknownPlayerCard(),
//                       ],
//                     ),
//                     // Text(
//                     //   'gamePlayDescription'.tr(),
//                     //   textAlign: TextAlign.center,
//                     //   style: Theme.of(
//                     //     context,
//                     //   ).textTheme.titleLarge?.copyWith(color: Colors.white),
//                     // ),
//                     // SizedBox(height: DesignSystem.spacing.x42),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: DesignSystem.spacing.x12,
//                       ),
//                       child: SizedBox(
//                         width: double.infinity,
//                         child: CupertinoButton.filled(
//                           onPressed: () => widget.onStageDone?.call(),
//                           child: Text('gamePlayBtnReveal'.tr()),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           AnimatedBuilder(
//             animation: _controllerText,
//             builder:
//                 (context, child) => Positioned(
//                   left: 0,
//                   right: 0,
//                   top: _position.value.dy,
//                   child: child!,
//                 ),
//             child: DefaultTextStyle(
//               style: TextStyle(color: Colors.white),
//               child: Column(
//                 key: _textKey,
//                 children: [
//                   Text('gPlayer'.plural(1)),
//                   Text(
//                     widget.players[_startPlayerIndex],
//                     textAlign: TextAlign.center,
//                     style: Theme.of(
//                       context,
//                     ).textTheme.displaySmall!.copyWith(color: Colors.white),
//                   ),
//                   SizedBox(height: DesignSystem.spacing.x8),
//                   Text('gamePlayStartDescription'.tr()),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

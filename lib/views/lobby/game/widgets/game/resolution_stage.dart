import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imposti/views/lobby/game/widgets/game/player_card.dart';
import 'package:imposti/views/lobby/game/widgets/game/unknown_player_card.dart';

class ResolutionStage extends StatefulWidget {
  final List<String> imposters;
  final List<String> prots;

  final bool imposterWon;

  final void Function()? onStageDone;

  const ResolutionStage({
    super.key,
    required this.imposters,
    required this.prots,
    required this.imposterWon,
    this.onStageDone,
  });

  @override
  State<ResolutionStage> createState() => _ResolutionStageState();
}

class _ResolutionStageState extends State<ResolutionStage> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(height: MediaQuery.sizeOf(context).height / 12),
          ...widget.imposters.isEmpty
              ? [UnknownPlayerCard()]
              : [
                SizedBox(
                  height:
                      (MediaQuery.sizeOf(context).width / 1.5) * 1.25 +
                      DesignSystem.spacing.x24,
                  child: RawScrollbar(
                    controller: _controller,
                    thickness: 6.0,
                    radius: const Radius.circular(4),
                    mainAxisMargin: DesignSystem.spacing.x24,
                    thumbVisibility: true,
                    padding: EdgeInsets.zero,
                    child: ListView(
                      controller: _controller,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(
                        horizontal: DesignSystem.spacing.x24,
                      ),
                      children: [
                        for (final (index, imposter)
                            in widget.imposters.indexed)
                          Center(
                            child: SizedBox(
                              height:
                                  (MediaQuery.sizeOf(context).width / 1.5) *
                                  1.25,
                              width: MediaQuery.sizeOf(context).width / 1.5,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right:
                                      index < widget.imposters.length - 1
                                          ? DesignSystem.spacing.x24
                                          : 0,
                                ),
                                child: PlayerCard(
                                  player: imposter,
                                  prot: widget.prots[index],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: DesignSystem.spacing.x32),
              ],
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DesignSystem.spacing.x24 + DesignSystem.spacing.x12,
            ),
            child: Text(
              widget.imposterWon
                  ? 'gameRevealImposterWonDescription'.tr()
                  : 'gameRevealDescription'.plural(widget.imposters.length),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
          SizedBox(height: DesignSystem.spacing.x48),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DesignSystem.spacing.x24 + DesignSystem.spacing.x12,
            ),
            child: SizedBox(
              width: double.infinity,
              child: CupertinoButton.filled(
                onPressed: () => widget.onStageDone?.call(),
                child: Text('gameRevealBtnAnotherRound'.tr()),
              ),
            ),
          ),
          // SizedBox(height: MediaQuery.sizeOf(context).height / 24),
        ],
      ),
    );
  }
}

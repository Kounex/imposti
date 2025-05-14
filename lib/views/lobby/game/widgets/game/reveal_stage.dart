import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cards_stage/player_card.dart';

class RevealStage extends StatefulWidget {
  final List<String> imposters;
  final List<String> prots;

  final void Function()? onStageDone;

  const RevealStage({
    super.key,
    required this.imposters,
    required this.prots,
    this.onStageDone,
  });

  @override
  State<RevealStage> createState() => _RevealStageState();
}

class _RevealStageState extends State<RevealStage> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height / 8),
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
                  for (final (index, imposter) in widget.imposters.indexed)
                    Center(
                      child: SizedBox(
                        height: (MediaQuery.sizeOf(context).width / 1.5) * 1.25,
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
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(DesignSystem.spacing.x24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'gameRevealDescription'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: DesignSystem.spacing.x32),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: DesignSystem.spacing.x32,
                    ),
                    width: double.infinity,
                    child: CupertinoButton.filled(
                      onPressed: () => widget.onStageDone?.call(),
                      child: Text('gameRevealBtnAnotherRound'.tr()),
                    ),
                  ),
                  SizedBox(height: DesignSystem.spacing.x24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

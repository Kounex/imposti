import 'dart:math';

import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'word_card.dart';

class CardsStage extends StatefulWidget {
  final List<String> players;
  final List<String> prots;
  final List<int> imposterIndices;
  final String word;
  final String categoryName;
  final bool imposterSeesCategoryName;

  final void Function()? onStageDone;

  const CardsStage({
    super.key,
    this.onStageDone,
    required this.players,
    required this.prots,
    required this.imposterIndices,
    required this.word,
    required this.categoryName,
    required this.imposterSeesCategoryName,
  });

  @override
  State<CardsStage> createState() => _CardsStageState();
}

class _CardsStageState extends State<CardsStage> {
  late final PageController _controller =
      PageController()..addListener(() => setState(() {}));

  int? _lastRevealedCardIndex;

  bool _isAtLastPlayer() =>
      (_controller.page ?? 0).round() >= widget.players.length - 1;

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
              SizedBox(
                height: min(
                  (MediaQuery.sizeOf(context).height / 100) * 65,
                  DesignSystem.size.x512,
                ),
                child: PageView(
                  controller: _controller,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    for (final (index, player) in widget.players.indexed)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              DesignSystem.spacing.x24 +
                              DesignSystem.spacing.x12,
                        ),
                        child: WordCard(
                          onWordFullyRevealed: () {
                            HapticFeedback.lightImpact();
                            setState(() => _lastRevealedCardIndex = index);
                          },
                          player: player,
                          word:
                              widget.imposterIndices.contains(index)
                                  ? widget.imposterSeesCategoryName
                                      ? widget.categoryName
                                      : 'Imposter'
                                  : widget.word,
                          prot: widget.prots[index],
                          imposter: widget.imposterIndices.contains(index),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: DesignSystem.spacing.x24),
              Builder(
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          DesignSystem.spacing.x24 + DesignSystem.spacing.x12,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: CupertinoButton.filled(
                        onPressed:
                            _lastRevealedCardIndex ==
                                    (_controller.page?.ceil() ?? -1)
                                ? () {
                                  if (!_isAtLastPlayer()) {
                                    _controller.nextPage(
                                      duration:
                                          DesignSystem
                                              .animation
                                              .defaultDurationMS250,
                                      curve: Curves.easeIn,
                                    );
                                  } else {
                                    widget.onStageDone?.call();
                                  }
                                }
                                : null,
                        child: Text(
                          (!_isAtLastPlayer()
                                  ? 'gameBtnNextPlayer'
                                  : 'lobbyBtnStart')
                              .tr(),
                        ),
                      ),
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

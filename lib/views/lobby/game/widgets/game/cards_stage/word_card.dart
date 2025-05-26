import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_components/base_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imposti/views/lobby/game/widgets/game/play_card.dart';
import 'package:imposti/views/lobby/game/widgets/game/player_card.dart';

class WordCard extends StatefulWidget {
  final String player;
  final String prot;

  final String word;
  final String category;

  final bool imposter;
  final bool imposterSeesCategoryName;

  final void Function()? onWordFullyRevealed;

  const WordCard({
    super.key,
    required this.player,
    required this.prot,
    required this.word,
    required this.category,
    required this.imposter,
    required this.imposterSeesCategoryName,
    this.onWordFullyRevealed,
  });

  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _size;

  final GlobalKey _wordKey = GlobalKey();
  final GlobalKey _playerCardKey = GlobalKey();

  bool _isRevealed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: DesignSystem.animation.defaultDurationMS150,
    );
    if (widget.onWordFullyRevealed != null) {
      _controller.addListener(_checkRevealProgress);
    }

    _size = CurvedAnimation(
      parent: _controller.drive(Tween(begin: 1, end: 1 / 1.75)),
      // curve: Curves.easeOutSine,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkRevealProgress() {
    final RenderBox? wordBox =
        _wordKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? playerCardBox =
        _playerCardKey.currentContext?.findRenderObject() as RenderBox?;

    if (wordBox != null && playerCardBox != null) {
      final Offset wordPosition = wordBox.localToGlobal(Offset.zero);
      final Offset playerCardPosition = playerCardBox.localToGlobal(
        Offset.zero,
      );

      if (!_isRevealed &&
          playerCardPosition.dy - wordPosition.dy >= wordBox.size.height) {
        _isRevealed = true;
        widget.onWordFullyRevealed?.call();
      } else if (_isRevealed &&
          playerCardPosition.dy - wordPosition.dy < wordBox.size.height) {
        _isRevealed = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: DesignSystem.spacing.x42),
      child: Listener(
        // onPointerDown: (event) => _controller.forward(),
        onPointerUp:
            (event) => _controller.animateBack(0, curve: Curves.easeIn),
        onPointerMove: (event) {
          _controller.value += event.delta.dy / 175;
        },
        child: ClipRRect(
          clipBehavior: Clip.hardEdge,
          borderRadius:
              (Theme.of(context).cardTheme.shape as RoundedRectangleBorder)
                  .borderRadius,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PlayCard(
                children: [
                  Positioned(
                    top: DesignSystem.spacing.x48,
                    left: DesignSystem.spacing.x24,
                    right: DesignSystem.spacing.x24,
                    child: FittedBox(
                      key: _wordKey,
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: DesignSystem.size.x92,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BaseCupertinoListTileIcon(
                                  widget.imposter
                                      ? Icons.android
                                      : CupertinoIcons.person_solid,
                                  size: DesignSystem.size.x32,
                                  iconSize: DesignSystem.size.x28,
                                  backgroundColor:
                                      widget.imposter
                                          ? Colors.red
                                          : Colors.blue,
                                ),
                                SizedBox(width: DesignSystem.spacing.x18),
                                AutoSizeText(
                                  widget.imposter ? 'Imposter' : widget.word,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                    textStyle: Theme.of(
                                      context,
                                    ).textTheme.displaySmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (widget.imposter &&
                                widget.imposterSeesCategoryName) ...[
                              SizedBox(height: DesignSystem.spacing.x8),
                              AutoSizeText(
                                widget.category,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  textStyle: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return SizeTransition(
                    axisAlignment: -1,
                    sizeFactor: _size,
                    child: PlayerCard(
                      key: _playerCardKey,
                      player: widget.player,
                      prot: widget.prot,
                    ),
                  );
                },
              ),
              PlayCard(color: Colors.transparent, child: SizedBox.expand()),
            ],
          ),
        ),
      ),
    );
  }
}

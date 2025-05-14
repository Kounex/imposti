import 'dart:math';

import 'package:base_components/base_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:imposti/models/category/category.dart';
import 'package:imposti/models/group/group.dart';
import 'package:imposti/views/lobby/game/widgets/game/cards_stage/cards_stage.dart';
import 'package:imposti/views/lobby/game/widgets/game/play_stage/play_stage.dart';
import 'package:imposti/views/lobby/game/widgets/game/reveal_stage.dart';

import '../../../../../utils/prots.dart';

enum GameStage { cards, play, reveal }

class Game extends StatefulWidget {
  final Group group;
  final List<Category> categories;

  final String languageCode;

  const Game({
    super.key,
    required this.group,
    required this.categories,
    required this.languageCode,
  });

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  GameStage _stage = GameStage.cards;

  String _currentWord = '';
  late Category _currentCategory;

  late List<String> _shuffledPlayers;
  late List<int> _imposterIndices;
  late List<String> _shuffledProts;

  @override
  void initState() {
    super.initState();

    _initGame();
  }

  void _initGame() {
    _setShuffledPlayers();
    _setShuffledProts();
    _setImposterPlayerIndices();
    _setRandomWord();
  }

  void _setShuffledProts() {
    _shuffledProts = ProtsUtils.getRandomProts(widget.group.players.length);
  }

  void _setImposterPlayerIndices() {
    final indices = List.generate(widget.group.players.length, (i) => i);
    indices.shuffle();

    _imposterIndices = List.from(
      indices.take(
        Random().nextInt(
              widget.group.amountMaxImposters -
                  widget.group.amountMinImposters +
                  1,
            ) +
            widget.group.amountMinImposters,
      ),
    );
  }

  _setShuffledPlayers() {
    _shuffledPlayers = [...widget.group.players]..shuffle();
  }

  _setRandomWord() {
    final randomCategoryNumber = Random().nextInt(widget.categories.length);
    final randomCategory = widget.categories[randomCategoryNumber];
    int randomWordNumber = Random().nextInt(
      randomCategory.words[widget.languageCode]?.length ?? -1,
    );
    if (randomWordNumber < 0) {
      _setRandomWord();
    } else {
      String newWord =
          randomCategory.words[widget.languageCode]![randomWordNumber];
      if (newWord == _currentWord) {
        _setRandomWord();
      } else {
        _currentWord = newWord;
        _currentCategory = randomCategory;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: DesignSystem.animation.defaultDurationMS200,
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: switch (_stage) {
        GameStage.cards => CardsStage(
          key: GlobalKey(),
          word: _currentWord,
          categoryName: _currentCategory.name[widget.languageCode]!,
          imposterIndices: _imposterIndices,
          imposterSeesCategoryName: widget.group.imposterSeesCategoryName,
          shuffledPlayers: _shuffledPlayers,
          shuffledProts: _shuffledProts,
          onStageDone: () => setState(() => _stage = GameStage.play),
        ),
        GameStage.play => PlayStage(
          key: GlobalKey(),
          onStageDone: () => setState(() => _stage = GameStage.reveal),
        ),
        GameStage.reveal => RevealStage(
          key: GlobalKey(),
          imposters: List.from(
            _imposterIndices.map((index) => _shuffledPlayers[index]),
          ),
          prots: List.from(
            _imposterIndices.map((index) => _shuffledProts[index]),
          ),
          onStageDone: () {
            _initGame();
            setState(() => _stage = GameStage.cards);
          },
        ),
      },
    );
  }
}

import 'dart:math';

import 'package:base_components/base_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:imposti/models/category/category.dart';
import 'package:imposti/models/group/group.dart';
import 'package:imposti/views/lobby/game/widgets/game/cards_stage/cards_stage.dart';
import 'package:imposti/views/lobby/game/widgets/game/resolution_stage.dart';

import '../../../../../utils/prots.dart';
import 'play_stage/play_stage.dart';

enum GameStage { cards, play, resolution }

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

  late List<Category> _categories;

  String _currentWord = '';
  late Category _currentCategory;

  late List<String> _shuffledPlayers;
  late List<int> _imposterIndices;
  late List<String> _shuffledProts;

  @override
  void initState() {
    super.initState();

    _setCopiedCategories();

    _initGame();
  }

  void _initGame() {
    _setShuffledPlayers();
    _setShuffledProts();
    _setImposterPlayerIndices();
    _setRandomWord();
  }

  /// We make a copy of our categories so we can mutate it which will allow
  /// us to remove played words so we go through all of them without repetition.
  /// Once we played through all words of the selected categories we will reset
  /// our local copy again
  void _setCopiedCategories() {
    _categories = [
      ...widget.categories.map(
        (category) => category.copyWith(
          words: {
            ...category.words.map((key, value) => MapEntry(key, [...value])),
          },
        ),
      ),
    ];
  }

  void _setShuffledProts() {
    _shuffledProts = ProtsUtils.getRandomProts(widget.group.players.length);
  }

  void _setImposterPlayerIndices() {
    if (widget.group.zeroImposterMode &&
        widget.group.amountMinImposters > 0 &&
        Random().nextInt(100) < 5) {
      _imposterIndices = [];
    } else {
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
  }

  _setShuffledPlayers() {
    _shuffledPlayers = [...widget.group.players]..shuffle();
  }

  _setRandomWord() {
    /// Check if we played through all available words -> reset our local
    /// copy then
    if (_categories.isEmpty) {
      _setCopiedCategories();
    }

    final randomCategoryNumber = Random().nextInt(_categories.length);
    final randomCategory = _categories[randomCategoryNumber];

    int randomWordNumber = Random().nextInt(
      randomCategory
          .words[randomCategory.base ? widget.languageCode : 'custom']!
          .length,
    );

    /// When retrieving the next random word, we remove it from our local copy
    /// of the category so we will naturally play through them
    String newWord = randomCategory
        .words[randomCategory.base ? widget.languageCode : 'custom']!
        .removeAt(randomWordNumber);

    /// Check if the category we used the word from is now empty, remove it
    /// from our local copy of categories then
    if (randomCategory
        .words[randomCategory.base ? widget.languageCode : 'custom']!
        .isEmpty) {
      _categories.remove(randomCategory);
    }

    _currentWord = newWord;
    _currentCategory = randomCategory;
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
          categoryName:
              _currentCategory.name[_currentCategory.base
                  ? widget.languageCode
                  : 'custom']!,
          imposterIndices: _imposterIndices,
          imposterSeesCategoryName: widget.group.imposterSeesCategoryName,
          players: _shuffledPlayers,
          prots: _shuffledProts,
          onStageDone: () => setState(() => _stage = GameStage.play),
        ),

        GameStage.play => PlayStage(
          key: GlobalKey(),
          players: _shuffledPlayers,
          prots: _shuffledProts,
          mode: widget.group.mode,
          modeTimeSeconds: widget.group.modeTimeSeconds,
          modeTapMinTaps: widget.group.modeTapMinTaps,
          modeTapMaxTaps: widget.group.modeTapMaxTaps,
          onStageDone: () => setState(() => _stage = GameStage.resolution),
        ),
        GameStage.resolution => ResolutionStage(
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

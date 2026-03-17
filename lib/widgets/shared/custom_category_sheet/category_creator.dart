import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imposti/widgets/ui/sheet.dart';

import '../../../services/intelligence_service.dart';

class CategoryCreatorSheet extends StatefulWidget {
  final List<String>? existingWords;
  final void Function(List<String> words) onSave;
  final void Function(bool isDirty)? onDirtyChanged;

  const CategoryCreatorSheet({
    super.key,
    this.existingWords,
    required this.onSave,
    this.onDirtyChanged,
  });

  @override
  State<CategoryCreatorSheet> createState() => _CategoryCreatorSheetState();
}

class _CategoryCreatorSheetState extends State<CategoryCreatorSheet> {
  late final CustomValidationTextEditingController _prompt;

  final List<String> _words = [];
  final List<String> _existingWords = [];

  @override
  void initState() {
    super.initState();

    _prompt = CustomValidationTextEditingController(
      check: (text) {
        if (text == null || text.trim().isEmpty) {
          return 'gRequiredError'.tr();
        }
        return null;
      },
    );

    if (widget.existingWords != null) {
      _existingWords.addAll(widget.existingWords!);
    }
  }

  Future<void> _generateWords() async {
    OverlayUtils.showStatusOverlay(
      context: context,
      content: BaseProgressIndicator(
        text: 'sharedCustomCategoryCreatorGenerating'.tr(),
      ),
      temporalOverlay: false,
    );
    try {
      final category =
          (await Future.wait([
            IntelligenceService.generateCategory(
              _prompt.text.trim(),
              existingItems: [..._existingWords, ..._words],
            ),
            Future.delayed(const Duration(seconds: 1)),
          ]))[0];

      setState(() {
        final newWords = category.words.entries.first.value;
        final existingLower = _words.map((w) => w.toLowerCase()).toSet();
        for (final word in newWords) {
          final wordLower = word.toLowerCase();
          if (!existingLower.contains(wordLower)) {
            _words.add(word);
            existingLower.add(wordLower);
          }
        }
        widget.onDirtyChanged?.call(_words.isNotEmpty);
      });
    } catch (e) {
      if (mounted) {
        ModalUtils.showBaseDialog(
          context,
          BaseInfoDialog(
            title: 'Error',
            body: (e as IntelligenceException).message,
          ),
        );
      }
    }
    OverlayUtils.closeAnyOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return BaseSheet(
      title: 'sharedCustomCategoryCreatorTitle'.tr(),
      onAction: () {
        widget.onSave(_words);
        Navigator.pop(context);
      },
      children: [
        Text('sharedCustomCategoryCreatorDescription'.tr()),
        SizedBox(height: DesignSystem.spacing.x16),
        BaseAdaptiveTextField(
          controller: _prompt,
          minLines: 3,
          placeholder: 'sharedCustomCategoryCreatorPrompt'.tr(),
        ),
        SizedBox(height: DesignSystem.spacing.x24),
        CupertinoButton.filled(
          onPressed: () {
            if (_prompt.isValid) {
              _generateWords();
            }
          },
          child: Text('sharedCustomCategoryCreatorGenerate'.tr()),
        ),
        SizedBox(height: DesignSystem.spacing.x16),
        Wrap(
          spacing: DesignSystem.spacing.x16,
          runSpacing: DesignSystem.spacing.x12,
          children:
              _words
                  .map(
                    (word) => BaseChip(
                      onDeleted: () {
                        setState(() => _words.remove(word));
                        widget.onDirtyChanged?.call(_words.isNotEmpty);
                      },
                      label: Text(word),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}

import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:imposti/models/category/category.dart';
import 'package:imposti/models/group/group.dart';
import 'package:imposti/models/hive_adapters.dart';
import 'package:imposti/widgets/shared/custom_category_sheet/word_dialog.dart';

class CustomCategorySheet extends StatefulWidget {
  final Category? category;

  final void Function(String name, List<String> words) onSave;

  const CustomCategorySheet({super.key, this.category, required this.onSave});

  @override
  State<CustomCategorySheet> createState() => _CustomCategorySheetState();
}

class _CustomCategorySheetState extends State<CustomCategorySheet> {
  final ScrollController _controller = ScrollController();

  late final CustomValidationTextEditingController _name;
  final List<String> _words = [];

  @override
  void initState() {
    super.initState();

    _name = CustomValidationTextEditingController(
      text: widget.category?.name['custom'],
      check: (text) {
        if (text == null || text.trim().isEmpty) {
          return 'sharedInputDialogRequiredError'.tr();
        }
        if (Hive.box<Category>(HiveKey.category.name).values.any(
          (category) =>
              category
                      .name[category.base
                          ? context.locale.languageCode
                          : 'custom']!
                      .toLowerCase() ==
                  text.trim().toLowerCase() &&
              (widget.category?.uuid != null
                  ? category.uuid != widget.category!.uuid
                  : true),
        )) {
          return 'sharedInputDialogExistsError'.tr();
        }
        return null;
      },
    );
    if (widget.category?.words['custom'] != null) {
      _words.addAll(widget.category!.words['custom']!);
    }
  }

  void _handleWordTap(String word) => ModalUtils.showBaseDialog(
    context,
    WordDialog(
      word: word,
      onDelete: () => _handleWordDialogDelete(word),
      onSave: (text) => _handleWordDialogSave(text, word),
    ),
  );

  void _handleWordDialogDelete(String word) {
    setState(() => _words.remove(word));
  }

  void _handleWordDialogSave(String? editWord, [String? ogWord]) {
    if (ogWord != null && editWord != null) {
      setState(() {
        _words.replaceRange(
          _words.indexOf(ogWord),
          _words.indexOf(ogWord) + 1,
          [editWord.trim()],
        );
      });
    } else if (editWord != null && editWord.trim().isNotEmpty) {
      setState(() {
        _words.add(editWord.trim());
      });
    }
  }

  Future<void> _deleteCategory() async {
    ModalUtils.showBaseDialog(
      context,
      BaseConfirmationDialog(
        title: 'sharedCustomCategoryDialogDeleteTitle'.tr(),
        body: 'sharedCustomCategoryDialogDeleteBody'.tr(),
        noText: 'gNo'.tr(),
        yesText: 'gYes'.tr(),
        isYesDestructive: true,
        onYes: (_) async {
          await widget.category!.delete();

          /// Go through all groups and remove the category we just
          /// deleted from their active category list
          for (final group in Hive.box<Group>(HiveKey.group.name).values) {
            group.categoryUuids.remove(widget.category!.uuid);

            /// Check if the to be deleted category is the only active
            /// category in a group -> then we need to set the default ones
            if (group.categoryUuids.isEmpty) {
              group.categoryUuids.addAll(
                Hive.box<Category>(HiveKey.category.name).values
                    .where((baseCategory) => baseCategory.base)
                    .map((baseCategory) => baseCategory.uuid),
              );

              await group.save();
            }
          }

          if (mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            EdgeInsets.all(DesignSystem.spacing.x24) +
            EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'sharedCustomCategoryTitle'.tr(),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Expanded(
              child: ListView(
                children: [
                  SizedBox(height: DesignSystem.spacing.x24),
                  Text('sharedCustomCategoryNameDescription'.tr()),
                  SizedBox(height: DesignSystem.spacing.x8),
                  BaseAdaptiveTextField(
                    controller: _name,
                    placeholder: 'Name',
                    clearButton: true,
                  ),
                  SizedBox(height: DesignSystem.spacing.x24),
                  Text('sharedCustomCategoryWordsDescription'.tr()),
                  SizedBox(height: DesignSystem.spacing.x24),
                  BaseCard(
                    topPadding: 0,
                    leftPadding: 0,
                    rightPadding: 0,
                    bottomPadding: 0,
                    constrained: false,
                    paintBorder: _name.submitted && _words.isEmpty,
                    borderColor: Theme.of(context).colorScheme.error,
                    paddingChild: EdgeInsets.zero,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: DesignSystem.size.x256,
                      ),
                      child: switch (_words.isEmpty) {
                        true => Padding(
                          padding: EdgeInsets.all(DesignSystem.spacing.x16),
                          child: BasePlaceholder(
                            text: 'sharedCustomCategoryWordsCardEmpty'.tr(),
                          ),
                        ),
                        false => Scrollbar(
                          controller: _controller,
                          thumbVisibility: true,
                          child: ListView(
                            controller: _controller,
                            shrinkWrap: true,
                            children: List.from(
                              _words.map(
                                (word) => ListTile(
                                  onTap: () => _handleWordTap(word),
                                  title: Text(word),
                                  trailing: Icon(Icons.edit),
                                ),
                              ),
                            ),
                          ),
                        ),
                      },
                    ),
                  ),
                  if (_name.submitted && _words.isEmpty) ...[
                    SizedBox(height: DesignSystem.spacing.x8),
                    Fader(
                      child: Text(
                        'sharedInputDialogRequiredError'.tr(),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: DesignSystem.spacing.x24),
                  CupertinoButton.filled(
                    onPressed:
                        () => ModalUtils.showBaseDialog(
                          context,
                          WordDialog(
                            onSave: (text) => _handleWordDialogSave(text),
                          ),
                        ),
                    child: Text('sharedCustomCategoryBtnNewWord'.tr()),
                  ),
                ],
              ),
            ),

            SizedBox(height: DesignSystem.spacing.x24),
            if (widget.category != null) ...[
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  onPressed: _deleteCategory,
                  color: Theme.of(context).colorScheme.error,
                  child: Text(
                    'gDelete'.tr(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onError,
                    ),
                  ),
                ),
              ),
              SizedBox(height: DesignSystem.spacing.x24),
            ],
            SizedBox(
              width: double.infinity,
              child: CupertinoButton.filled(
                onPressed: () {
                  setState(() {});
                  if (_name.isValid && _words.isNotEmpty) {
                    widget.onSave(_name.textAtSubmission.trim(), _words);
                    Navigator.of(context).pop();
                  }
                },
                child: Text('gSave'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

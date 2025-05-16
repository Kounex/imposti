import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class WordDialog extends StatelessWidget {
  final String? word;
  final List<String>? otherWords;

  final void Function(String? word) onSave;
  final void Function()? onDelete;

  const WordDialog({
    super.key,
    this.word,
    this.otherWords,
    required this.onSave,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return BaseInputDialog(
      inputText: word,
      title: 'gCategory'.plural(1),
      body: 'sharedCustomCategoryDialogDescription'.tr(),
      inputCheck:
          (text) =>
              text == null || text.trim().isEmpty
                  ? 'sharedInputDialogRequiredError'.tr()
                  : (otherWords?.any(
                        (word) =>
                            word.toLowerCase() == text.trim().toLowerCase(),
                      ) ??
                      false)
                  ? 'sharedInputDialogExistsError'.plural(
                    1,
                    args: ['gWord'.tr()],
                  )
                  : null,
      deleteText: 'gDelete'.tr(),
      cancelText: 'gCancel'.tr(),
      saveText: 'gSave'.tr(),
      onDelete: onDelete,
      onSave: onSave,
    );
  }
}

import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PlayerDialog extends StatelessWidget {
  final String? player;
  final List<String> otherPlayers;

  final void Function(String? text)? onSave;
  final void Function()? onDelete;

  const PlayerDialog({
    super.key,
    this.player,
    required this.otherPlayers,
    this.onSave,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return BaseInputDialog(
      title: 'gPlayer'.plural(1),
      body: 'lobbyDialogPlayerDescription'.tr(),
      inputText: player,
      inputCheck:
          (text) =>
              text == null || text.trim().isEmpty
                  ? 'sharedInputDialogRequiredError'.tr()
                  : otherPlayers.any(
                    (player) =>
                        player.toLowerCase() == text.trim().toLowerCase(),
                  )
                  ? 'sharedInputDialogExistsError'.tr()
                  : null,
      deleteText: 'gDelete'.tr(),
      cancelText: 'gCancel'.tr(),
      saveText: 'gSave'.tr(),
      onDelete: onDelete,
      onSave: onSave,
    );
  }
}

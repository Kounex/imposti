import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
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

  String? _nameCheck(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'gRequiredError'.tr();
    }

    if (otherPlayers.any(
      (player) => player.toLowerCase() == text.trim().toLowerCase(),
    )) {
      return 'sharedInputDialogExistsError'.plural(1, args: ['gName'.tr()]);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BaseInputDialog(
      title: 'gPlayer'.plural(1),
      body: 'lobbyDialogPlayerDescription'.tr(),
      inputText: player,
      inputCheck: _nameCheck,
      deleteText: 'gDelete'.tr(),
      cancelText: 'gCancel'.tr(),
      saveText: 'gSave'.tr(),
      onDelete: onDelete,
      onSave: onSave,
    );
  }
}

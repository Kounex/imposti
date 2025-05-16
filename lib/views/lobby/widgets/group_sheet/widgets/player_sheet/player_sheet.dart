import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imposti/models/group/group.dart';
import 'package:imposti/views/lobby/widgets/group_sheet/widgets/player_sheet/player_dialog.dart';
import 'package:imposti/widgets/ui/sheet.dart';

class PlayerSheet extends StatefulWidget {
  final Group group;
  final void Function(List<String> players) onSave;

  const PlayerSheet({super.key, required this.group, required this.onSave});

  @override
  State<PlayerSheet> createState() => _PlayerSheetState();
}

class _PlayerSheetState extends State<PlayerSheet> {
  final ScrollController _controller = ScrollController();

  final List<String> _players = [];

  @override
  void initState() {
    super.initState();

    _players.addAll(widget.group.players);
  }

  void _handlePlayerDialogDelete(String player) {
    if (_players.length > 3) {
      setState(() => _players.remove(player));
    } else {
      ModalUtils.showBaseDialog(
        context,
        BaseInfoDialog(body: 'lobbyPlayerListDeleteNotEnough'.tr()),
      );
    }
  }

  void _handlePlayerDialogSave(String? editPlayer, [String? ogPlayer]) {
    if (ogPlayer != null && editPlayer != null) {
      setState(() {
        _players.replaceRange(
          _players.indexOf(ogPlayer),
          _players.indexOf(ogPlayer) + 1,
          [editPlayer.trim()],
        );
      });
    } else if (editPlayer != null && editPlayer.trim().isNotEmpty) {
      setState(() {
        _players.add(editPlayer.trim());
      });
    }
  }

  void _handlePlayerTap(String player) => ModalUtils.showBaseDialog(
    context,
    PlayerDialog(
      player: player,
      otherPlayers: [..._players]..remove(player),
      onDelete: () => _handlePlayerDialogDelete(player),
      onSave: (text) => _handlePlayerDialogSave(text, player),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BaseSheet(
      onAction: () {
        widget.onSave(_players);
        Navigator.of(context).pop();
      },
      title: 'gPlayer'.plural(2),
      children: [
        Text('lobbyPlayerListDescription'.tr()),
        SizedBox(height: DesignSystem.spacing.x24),
        BaseCard(
          topPadding: 0,
          leftPadding: 0,
          rightPadding: 0,
          bottomPadding: 0,
          constrained: false,
          paddingChild: EdgeInsets.zero,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: DesignSystem.size.x256),
            child: switch (_players.isEmpty) {
              true => Padding(
                padding: EdgeInsets.all(DesignSystem.spacing.x16),
                child: BasePlaceholder(text: 'lobbyPlayerListEmpty'.tr()),
              ),
              false => Scrollbar(
                controller: _controller,
                thumbVisibility: true,
                child: ListView(
                  controller: _controller,
                  shrinkWrap: true,
                  children: List.from(
                    _players.map(
                      (player) => ListTile(
                        onTap: () => _handlePlayerTap(player),
                        title: Text(player),
                        trailing: Icon(Icons.edit),
                      ),
                    ),
                  ),
                ),
              ),
            },
          ),
        ),
        SizedBox(height: DesignSystem.spacing.x24),
        CupertinoButton.filled(
          onPressed:
              () => ModalUtils.showBaseDialog(
                context,
                PlayerDialog(
                  otherPlayers: _players,
                  onSave: (text) => _handlePlayerDialogSave(text),
                ),
              ),
          child: Text('lobbyBtnNewPlayer'.tr()),
        ),
      ],
    );
  }
}

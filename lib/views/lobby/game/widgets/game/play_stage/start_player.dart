import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class StartPlayer extends StatelessWidget {
  final String player;

  const StartPlayer({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('gPlayer'.plural(1)),
          Text(
            player,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.displaySmall!.copyWith(color: Colors.white),
          ),
          SizedBox(height: DesignSystem.spacing.x8),
          Text('gamePlayStartDescription'.tr()),
        ],
      ),
    );
  }
}

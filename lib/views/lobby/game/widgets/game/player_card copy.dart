import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_components/base_components.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imposti/views/lobby/game/widgets/game/play_card.dart';

class PlayerCard extends StatelessWidget {
  final String player;
  final String prot;

  const PlayerCard({super.key, required this.player, required this.prot});

  @override
  Widget build(BuildContext context) {
    return PlayCard(
      children: [
        Positioned(
          top: DesignSystem.spacing.x64 + DesignSystem.spacing.x8,
          left: 0,
          right: 0,
          bottom: 0,
          child: Image.asset(prot, fit: BoxFit.fitHeight),
        ),
        Positioned(
          top: DesignSystem.spacing.x24,
          left: DesignSystem.spacing.x24,
          right: DesignSystem.spacing.x24,
          child: AutoSizeText(
            player,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              textStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_components/base_components.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../widgets/ui/gradient_background.dart';

class PlayerCard extends StatelessWidget {
  final List<Widget>? children;

  final String? player;
  final String? prot;

  const PlayerCard({super.key, this.children, this.player, this.prot})
    : assert(children != null || (player != null && prot != null));

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GradientBackground(
            colors: [
              Theme.of(context).colorScheme.primary.darken(70),
              Colors.black.lighten(15),
              Theme.of(context).colorScheme.secondary.darken(70),
            ],
          ),
          ...children ??
              [
                Positioned(
                  top: DesignSystem.spacing.x64 + DesignSystem.spacing.x8,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Image.asset(prot!, fit: BoxFit.fitHeight),
                ),
                Positioned(
                  top: DesignSystem.spacing.x24,
                  left: DesignSystem.spacing.x24,
                  right: DesignSystem.spacing.x24,
                  child: AutoSizeText(
                    player!,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      textStyle: Theme.of(
                        context,
                      ).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
        ],
      ),
    );
  }
}

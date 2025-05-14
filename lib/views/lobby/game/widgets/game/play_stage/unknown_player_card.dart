import 'package:base_components/base_components.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../utils/prots.dart';

class UnknownPlayerCard extends StatefulWidget {
  const UnknownPlayerCard({super.key});

  @override
  State<UnknownPlayerCard> createState() => _UnknownPlayerCardState();
}

class _UnknownPlayerCardState extends State<UnknownPlayerCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      margin: EdgeInsets.all(DesignSystem.spacing.x48),
      child: Padding(
        padding: EdgeInsets.only(
          left: DesignSystem.spacing.x24,
          right: DesignSystem.spacing.x24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: DesignSystem.spacing.x24),
            Text(
              '???',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                textStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(height: DesignSystem.spacing.x24),
            Image.asset(ProtsUtils.getRandomProts(1)[0], color: Colors.white),
          ],
        ),
      ),
    );
  }
}

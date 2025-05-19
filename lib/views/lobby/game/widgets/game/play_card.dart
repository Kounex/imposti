import 'package:base_components/base_components.dart';
import 'package:flutter/material.dart';

import '../../../../../widgets/ui/gradient_background.dart';

class PlayCard extends StatelessWidget {
  final Widget? child;
  final List<Widget>? children;

  final Color? color;

  const PlayCard({super.key, this.child, this.children, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      child:
          child ??
          Stack(
            alignment: Alignment.center,
            children: [
              GradientBackground(
                colors: [
                  Theme.of(context).colorScheme.primary.darken(70),
                  Colors.black.lighten(15),
                  Theme.of(context).colorScheme.secondary.darken(70),
                ],
              ),
              ...children ?? [],
            ],
          ),
    );
  }
}

import 'package:base_components/base_components.dart';
import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final List<Color>? colors;
  final Alignment? begin;
  final Alignment? end;

  const GradientBackground({super.key, this.colors, this.begin, this.end});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                colors ??
                [
                  Theme.of(context).colorScheme.primary.darken(50),
                  Theme.of(context).colorScheme.secondary,
                ],
            begin: begin ?? Alignment.bottomLeft,
            end: end ?? Alignment.topRight,
          ),
        ),
      ),
    );
  }
}

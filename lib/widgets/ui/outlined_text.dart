import 'package:base_components/base_components.dart';
import 'package:flutter/material.dart';

class OutlinedText extends StatelessWidget {
  final String text;

  final TextStyle? style;

  final Color? color;
  final Color? outlineColor;

  final double? outlineWidth;

  final TextAlign? textAlign;

  const OutlinedText(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.outlineColor,
    this.outlineWidth,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          textAlign: textAlign,
          style: (style ?? Theme.of(context).textTheme.headlineSmall!).copyWith(
            foreground:
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = outlineWidth ?? 3
                  ..color =
                      outlineColor ??
                      DesignSystem.surroundingAwareAccent(
                        surroundingColor:
                            Theme.of(context).textTheme.bodyLarge?.color!,
                      ),
          ),
        ),
        Text(
          text,
          textAlign: textAlign,
          style: (style ?? Theme.of(context).textTheme.headlineSmall!).copyWith(
            color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }
}

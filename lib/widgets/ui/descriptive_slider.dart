import 'package:base_components/base_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DescriptiveSlider extends StatelessWidget {
  final double value;
  final String description;

  final double min;
  final double max;
  final int? divisions;

  final bool intMode;

  final void Function(double value)? onChanged;

  const DescriptiveSlider({
    super.key,
    required this.value,
    required this.description,
    required this.min,
    required this.max,
    this.divisions,
    this.intMode = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Text(description)),
            SizedBox(width: DesignSystem.spacing.x24),
            Text(
              '${intMode ? value.toInt() : value}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        SizedBox(height: DesignSystem.spacing.x24),
        Row(
          children: [
            Text('${intMode ? min.toInt() : min}'),
            Expanded(
              child: CupertinoSlider(
                value: value,
                onChanged: onChanged,
                min: min,
                max: max,
                divisions: divisions,
              ),
            ),
            Text('${intMode ? max.toInt() : max}'),
          ],
        ),
      ],
    );
  }
}

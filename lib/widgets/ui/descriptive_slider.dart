import 'package:base_components/base_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DescriptiveSlider extends StatelessWidget {
  final double value;
  final double? valueSize;
  final Color? valueColor;

  final String description;

  final double min;
  final double max;
  final int? divisions;

  final double? softMin;
  final double? softMax;

  final bool intMode;

  final bool feedback;

  final void Function(double value)? onChanged;

  const DescriptiveSlider({
    super.key,
    required this.value,
    this.valueSize,
    this.valueColor,
    required this.description,
    required this.min,
    required this.max,
    this.divisions,
    this.softMin,
    this.softMax,
    this.intMode = true,
    this.feedback = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localMin = softMin ?? min;
    final localMax = softMax ?? max;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Text(description)),
            SizedBox(width: DesignSystem.spacing.x24),
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: valueSize ?? DesignSystem.size.x32,
              ),
              child: Text(
                '${intMode ? value.toInt() : value}',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: valueColor ?? Theme.of(context).colorScheme.primary,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        SizedBox(height: DesignSystem.spacing.x24),
        Row(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: DesignSystem.size.x32),
              child: Text(
                '${intMode ? min.toInt() : min}',
                style: TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: CupertinoSlider(
                value: value,
                onChanged:
                    onChanged != null
                        ? (newValue) {
                          if (newValue.toInt() != value.toInt() &&
                              newValue.toInt() >= localMin &&
                              newValue.toInt() <= localMax) {
                            if (feedback) {
                              HapticFeedback.lightImpact();
                            }
                            onChanged!.call(newValue);
                          }
                        }
                        : null,
                min: min,
                max: max,
                divisions: divisions,
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: DesignSystem.size.x32),
              child: Text(
                '${intMode ? max.toInt() : max}',
                style: TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

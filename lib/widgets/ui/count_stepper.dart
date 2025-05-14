import 'package:base_components/base_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountStepper extends StatelessWidget {
  final int? count;

  final void Function()? onDecrement;
  final void Function()? onIncrement;

  const CountStepper({
    super.key,
    this.count,
    this.onDecrement,
    this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      shape: (Theme.of(context).cardTheme.shape as RoundedRectangleBorder)
          .copyWith(
            borderRadius: BorderRadius.circular(DesignSystem.border.radius6),
          ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: DesignSystem.size.x28,
                width: DesignSystem.size.x32,
                child: CupertinoButton.filled(
                  onPressed:
                      onDecrement != null
                          ? () {
                            HapticFeedback.lightImpact();
                            onDecrement?.call();
                          }
                          : null,
                  borderRadius: BorderRadius.circular(0),
                  child: SizedBox(),
                ),
              ),
              IgnorePointer(
                child: Icon(
                  CupertinoIcons.minus,
                  size: DesignSystem.size.x18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            width: DesignSystem.size.x32,
            child: Center(
              child: Text(
                '${count ?? "0"}',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: DesignSystem.size.x28,
                width: DesignSystem.size.x32,
                child: CupertinoButton.filled(
                  onPressed:
                      onIncrement != null
                          ? () {
                            HapticFeedback.lightImpact();
                            onIncrement?.call();
                          }
                          : null,
                  borderRadius: BorderRadius.circular(0),
                  child: SizedBox(),
                ),
              ),
              IgnorePointer(
                child: Icon(
                  CupertinoIcons.plus,
                  size: DesignSystem.size.x18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

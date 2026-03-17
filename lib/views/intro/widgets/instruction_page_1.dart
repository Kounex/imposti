import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class IntroInstructionPage1 extends StatelessWidget {
  const IntroInstructionPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(DesignSystem.spacing.x24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Icon(
            Icons.info_outline_rounded,
            size: DesignSystem.size.x92,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          SizedBox(height: DesignSystem.spacing.x24),
          Text(
            'sharedHowToSheetTitle'.tr(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: DesignSystem.spacing.x16),
          Text(
            'sharedHowToSheetDescription1'.tr(),
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class IntroInstructionPage2 extends StatelessWidget {
  const IntroInstructionPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(DesignSystem.spacing.x24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: DesignSystem.sigmaBlur,
                  offset: Offset(0, DesignSystem.spacing.x4),
                ),
              ],
              borderRadius: BorderRadius.circular(DesignSystem.border.radius12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(DesignSystem.border.radius12),
              child: Image.asset(
                'assets/images/group.png',
                height: DesignSystem.size.x256,
                fit: BoxFit.cover,
                alignment: const Alignment(0, -0.75),
              ),
            ),
          ),
          SizedBox(height: DesignSystem.spacing.x32),
          Text(
            'sharedHowToSheetDescription2'.tr(),
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

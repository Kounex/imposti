import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:imposti/widgets/ui/sheet.dart';

class HowToSheet extends StatefulWidget {
  const HowToSheet({super.key});

  @override
  State<HowToSheet> createState() => _HowToSheetState();
}

class _HowToSheetState extends State<HowToSheet> {
  @override
  Widget build(BuildContext context) {
    return BaseSheet(
      title: 'sharedHowToSheetTitle'.tr(),
      children: [
        // BaseCard(
        //   leftPadding: 0,
        //   rightPadding: 0,
        //   topPadding: 0,
        //   backgroundColor: Theme.of(context).colorScheme.secondary,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       Image.asset(
        //         'assets/images/splash.png',
        //         height: DesignSystem.size.x128,
        //       ),
        //       SizedBox(height: DesignSystem.spacing.x12),
        //       Text(
        //         'dashboardCardTitle'.tr(),
        //         style: Theme.of(context).textTheme.headlineSmall!.copyWith(
        //           color: Theme.of(context).colorScheme.onSecondary,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        Text(
          'sharedHowToSheetDescription1'.tr(),
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: DesignSystem.spacing.x24),
        ClipRRect(
          borderRadius: BorderRadius.circular(DesignSystem.border.radius12),
          child: Image.asset(
            'assets/images/group.png',
            height: DesignSystem.size.x256,
            fit: BoxFit.cover,
            alignment: Alignment(0, -0.75),
          ),
        ),
        SizedBox(height: DesignSystem.spacing.x24),
        Text(
          'sharedHowToSheetDescription2'.tr(),
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}

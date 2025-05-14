import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DonateSheet extends StatefulWidget {
  const DonateSheet({super.key});

  @override
  State<DonateSheet> createState() => _DonateSheetState();
}

class _DonateSheetState extends State<DonateSheet> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            EdgeInsets.all(DesignSystem.spacing.x24) +
            EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'settingsDonate'.tr(),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Expanded(
              child: ListView(
                children: [
                  SizedBox(height: DesignSystem.spacing.x24),
                  AutoSizeText(
                    'settingsDonateDescription'.tr(),
                    maxLines: 6,
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: DesignSystem.spacing.x24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

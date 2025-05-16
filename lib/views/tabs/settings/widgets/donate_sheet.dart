import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:imposti/widgets/ui/sheet.dart';

class DonateSheet extends StatefulWidget {
  const DonateSheet({super.key});

  @override
  State<DonateSheet> createState() => _DonateSheetState();
}

class _DonateSheetState extends State<DonateSheet> {
  @override
  Widget build(BuildContext context) {
    return BaseSheet(
      title: 'settingsDonate'.tr(),
      children: [
        AutoSizeText(
          'settingsDonateDescription'.tr(),
          maxLines: 6,
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}

import 'dart:io';

import 'package:base_components/base_components.dart';
import 'package:dough/dough.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imposti/models/hive_adapters.dart';
import 'package:imposti/router/router.dart';
import 'package:imposti/router/routes.dart';
import 'package:imposti/router/view.dart';
import 'package:imposti/utils/hive.dart';
import 'package:imposti/utils/launch.dart';
import 'package:imposti/views/tabs/settings/widgets/donate_sheet.dart';
import 'package:imposti/widgets/builder/hive_builder.dart';
import 'package:imposti/widgets/ui/imposti_scaffold.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:ionicons/ionicons.dart';

class SettingsView extends RouterStatefulView {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return HiveBuilder<dynamic>(
      hiveKey: HiveKey.settings,
      rebuildKeys: [HiveSettingsKey.darkMode, HiveSettingsKey.languageCode],
      builder: (context, settingsBox, child) {
        return ImpostiScaffold(
          contentVerticalPadding: false,
          children: [
            SizedBox(height: DesignSystem.spacing.x32),
            Center(
              child: PressableDough(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(DesignSystem.size.x172),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: DesignSystem.size.x172,
                  ),
                ),
              ),
            ),
            SizedBox(height: DesignSystem.spacing.x32),
            BaseCupertinoListSection(
              tiles: [
                BaseCupertinoListTile(
                  onTap:
                      () => BaseAppRouter().navigateTo(
                        context,
                        TabAppRoute.settingsCustomCategories,
                      ),
                  title: Text('settingsYourCategories'.tr()),
                  additionalInfo: CupertinoListTileChevron(),
                  leadingIcon: Icons.category,
                  leadingIconBackgroundColor: Colors.green,
                ),
                BaseCupertinoListTile(
                  title: Text('Dark Mode'),
                  additionalInfo: BaseAdaptiveSwitch(
                    value: settingsBox.get(HiveSettingsKey.darkMode.name),
                    onChanged:
                        (change) => settingsBox.put(
                          HiveSettingsKey.darkMode.name,
                          change,
                        ),
                  ),
                  leadingIcon: Ionicons.invert_mode,
                  leadingIconColor:
                      settingsBox.get(HiveSettingsKey.darkMode.name)
                          ? Colors.black
                          : Colors.white,
                  leadingIconBackgroundColor:
                      settingsBox.get(HiveSettingsKey.darkMode.name)
                          ? Colors.white
                          : Colors.black,
                ),
                BaseCupertinoListTile(
                  title: Row(
                    children: [
                      Text('gLanguage'.tr()),
                      SizedBox(width: DesignSystem.spacing.x12),
                      QuestionMarkTooltip(
                        message: 'settingsLanguageHelp'.tr(
                          namedArgs: {
                            'os': switch (Platform.operatingSystem) {
                              'android' => 'Android',
                              'ios' => 'iOS',
                              'macos' => 'macOS',
                              'windows' => 'Windows',
                              'linux' => 'Linux',
                              'fuchsia' => 'Fuchsia',
                              _ => 'OS',
                            },
                          },
                        ),
                      ),
                    ],
                  ),
                  additionalInfo: BaseDropdown<String?>(
                    value: settingsBox.get(HiveSettingsKey.languageCode.name),
                    items: [
                      BaseDropdownItem(value: 'de', text: 'gGerman'.tr()),
                      BaseDropdownItem(value: 'en', text: 'gEnglish'.tr()),
                      BaseDropdownItem(value: null, text: 'System'),
                    ],
                    onChanged: (languageCode) {
                      settingsBox
                          .put(HiveSettingsKey.languageCode.name, languageCode)
                          .then(
                            (_) => HiveUtils.setSavedLanguage(context, false),
                          );
                    },
                  ),
                  leadingIcon: Icons.language,
                ),
              ],
            ),
            SizedBox(height: DesignSystem.spacing.x24),
            BaseCupertinoListSection(
              tiles: [
                BaseCupertinoListTile(
                  onTap:
                      () => ModalUtils.showBaseDialog(
                        context,
                        BaseConfirmationDialog(
                          title: 'settingsGitDialogTitle'.tr(),
                          body: 'settingsGitDialogDescription'.tr(),
                          noText: 'gNo'.tr(),
                          yesText: 'gYes'.tr(),
                          onYes:
                              (_) => LaunchUtils.launchApp(
                                Uri.https('github.com', '/kounex'),
                              ),
                        ),
                      ),
                  title: Row(
                    children: [
                      Text('GitHub'),
                      SizedBox(width: DesignSystem.spacing.x12),
                      QuestionMarkTooltip(message: 'settingsGitHubHelp'.tr()),
                    ],
                  ),
                  leadingIcon: Ionicons.logo_github,
                  leadingIconColor:
                      settingsBox.get(HiveSettingsKey.darkMode.name)
                          ? Colors.black
                          : Colors.white,
                  leadingIconBackgroundColor:
                      settingsBox.get(HiveSettingsKey.darkMode.name)
                          ? Colors.white
                          : Colors.black,
                ),
                BaseCupertinoListTile(
                  onTap: () => InAppReview.instance.openStoreListing(),
                  title: Text('settingsRateApp'.tr()),
                  leadingIcon: Icons.star,
                  leadingIconBackgroundColor: Colors.indigoAccent,
                ),
                BaseCupertinoListTile(
                  onTap:
                      () => ModalUtils.showExpandedModalBottomSheet(
                        context,
                        DonateSheet(),
                      ),
                  title: Text('settingsDonate'.tr()),
                  leadingIcon: Icons.wallet,
                  leadingIconBackgroundColor: Colors.red,
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.all(DesignSystem.spacing.x8),
                child: BaseVersionText(
                  includeBuildNumber: false,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall!.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

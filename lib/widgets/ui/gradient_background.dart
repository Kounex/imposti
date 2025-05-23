import 'package:base_components/base_components.dart';
import 'package:flutter/material.dart';
import 'package:imposti/models/hive_adapters.dart';
import 'package:imposti/utils/theme.dart';
import 'package:imposti/widgets/builder/hive_builder.dart';

class GradientBackground extends StatelessWidget {
  final List<Color>? colors;
  final Alignment? begin;
  final Alignment? end;

  final bool forceGradient;

  const GradientBackground({
    super.key,
    this.colors,
    this.begin,
    this.end,
    this.forceGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: HiveBuilder<dynamic>(
        hiveKey: HiveKey.settings,
        rebuildKeys: [HiveSettingsKey.gradient],
        builder:
            (context, settingsBox, child) =>
                settingsBox.get(
                          HiveSettingsKey.gradient.name,
                          defaultValue: true,
                        ) ||
                        forceGradient
                    ? Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:
                              colors ??
                              [
                                Theme.of(context)
                                    .extension<ImpostiColors>()!
                                    .gradientMainSurface
                                    .darken(
                                      settingsBox.get(
                                            HiveSettingsKey.darkMode.name,
                                          )
                                          ? 60
                                          : 50,
                                    ),
                                Theme.of(context)
                                    .extension<ImpostiColors>()!
                                    .gradientSecondarySurface
                                    .darken(
                                      settingsBox.get(
                                            HiveSettingsKey.darkMode.name,
                                          )
                                          ? 40
                                          : 20,
                                    ),
                              ],
                          begin: begin ?? Alignment.bottomLeft,
                          end: end ?? Alignment.topRight,
                        ),
                      ),
                    )
                    : SizedBox(),
      ),
    );
  }
}

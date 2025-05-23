import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imposti/models/group/group.dart';
import 'package:imposti/widgets/ui/descriptive_slider.dart';
import 'package:imposti/widgets/ui/sheet.dart';

class PlayModeSheet extends StatefulWidget {
  final Group group;

  final void Function(Group group) onSave;

  const PlayModeSheet({super.key, required this.group, required this.onSave});

  @override
  State<PlayModeSheet> createState() => _PlayModeSheetState();
}

class _PlayModeSheetState extends State<PlayModeSheet> {
  late PlayMode _mode;
  late int _modeTimeSeconds;
  late int _modeTapMinTaps;
  late int _modeTapMaxTaps;

  final _freestyleKey = GlobalKey();
  final _timeKey = GlobalKey();
  final _tapKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _mode = widget.group.mode;
    _modeTimeSeconds = widget.group.modeTimeSeconds;
    _modeTapMinTaps = widget.group.modeTapMinTaps;
    _modeTapMaxTaps = widget.group.modeTapMaxTaps;
  }

  @override
  Widget build(BuildContext context) {
    return BaseSheet(
      onAction: () {
        widget.onSave(
          Group(
            uuid: '',
            categoryUuids: [],
            mode: _mode,
            modeTimeSeconds: _modeTimeSeconds,
            modeTapMinTaps: _modeTapMinTaps,
            modeTapMaxTaps: _modeTapMaxTaps,
          ),
        );
        Navigator.of(context).pop();
      },
      title: 'lobbyPlayModeTitle'.tr(),
      children: [
        BaseCupertinoListSection(
          hasLeading: false,
          tiles: [
            ...PlayMode.values.map(
              (mode) => BaseCupertinoListTile(
                onTap: () {
                  if (mode != _mode) {
                    HapticFeedback.lightImpact();
                    setState(() => _mode = mode);
                  }
                },
                title: Padding(
                  padding: EdgeInsets.only(top: DesignSystem.spacing.x12),
                  child: Text(mode.name),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(
                    bottom: DesignSystem.spacing.x12,
                    right: DesignSystem.spacing.x24,
                  ),
                  child: Text(mode.description, maxLines: 10),
                ),
                additionalInfo: SizedBox(
                  width: DesignSystem.size.x32,
                  child:
                      _mode == mode
                          ? Icon(
                            CupertinoIcons.check_mark,
                            color: Theme.of(context).colorScheme.primary,
                          )
                          : null,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: DesignSystem.spacing.x48),
        AnimatedSwitcher(
          duration: DesignSystem.animation.defaultDurationMS500,
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeIn,
          child: switch (_mode) {
            PlayMode.freestyle => SizedBox(key: _freestyleKey),
            PlayMode.time => SizedBox(
              key: _timeKey,
              height: DesignSystem.size.x256,
              child: DescriptiveSlider(
                onChanged:
                    (time) => setState(() => _modeTimeSeconds = time.toInt()),
                value: _modeTimeSeconds.toDouble(),
                description: 'lobbyPlayModeTimeDescription'.tr(),
                min: 10,
                max: 120,
                divisions: ((120 - 10) / 10).toInt(),
              ),
            ),
            PlayMode.tap => SizedBox(
              key: _tapKey,
              height: DesignSystem.size.x256,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DescriptiveSlider(
                    onChanged: (taps) {
                      if (taps <= _modeTapMaxTaps) {
                        setState(() => _modeTapMinTaps = taps.toInt());
                      }
                    },
                    value: _modeTapMinTaps.toDouble(),
                    description: 'lobbyPlayModeTapMinDescription'.tr(),
                    min: 5,
                    max: 50,
                    divisions: 50 - 5,
                  ),
                  SizedBox(height: DesignSystem.spacing.x48),
                  DescriptiveSlider(
                    onChanged: (taps) {
                      if (taps >= _modeTapMinTaps) {
                        setState(() => _modeTapMaxTaps = taps.toInt());
                      }
                    },
                    value: _modeTapMaxTaps.toDouble(),
                    description: 'lobbyPlayModeTapMaxDescription'.tr(),
                    min: 5,
                    max: 50,
                    divisions: 50 - 5,
                  ),
                ],
              ),
            ),
          },
        ),
      ],
    );
  }
}

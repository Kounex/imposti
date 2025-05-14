import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:imposti/models/group/group.dart';
import 'package:imposti/models/hive_adapters.dart';
import 'package:imposti/router/router.dart';
import 'package:imposti/router/view.dart';
import 'package:imposti/views/lobby/game/widgets/game/game.dart';
import 'package:imposti/widgets/ui/imposti_scaffold.dart';

import '../../../models/category/category.dart';

class GameViewData extends RouterViewData {
  GameViewData({required super.state});

  Group? get group {
    String? groupUuid = state.pathParameters['groupUuid'];
    if (groupUuid != null) {
      return Hive.box<Group>(
        HiveKey.group.name,
      ).values.where((group) => group.uuid == groupUuid).firstOrNull;
    } else if (kIsWeb) {
      //     if (param == null && window.location.href.contains('?code=')) {
      //       param = window.location.href.split('?code=')[1].split('#')[0];
      //     }
    }

    return null;
  }
}

class GameView extends RouterStatefulView<GameViewData> {
  const GameView({super.key, required super.data});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  late final Group? _group;
  final List<Category> _categories = [];

  @override
  void initState() {
    super.initState();

    _group = widget.data?.group;
    if (_group != null) {
      _categories.addAll(_group.categories);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child:
          _group != null
              ? ImpostiScaffold(
                body: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: [
                    Game(
                      group: _group,
                      categories: _categories,
                      languageCode: context.locale.languageCode,
                    ),
                    Positioned(
                      top: DesignSystem.spacing.x24,
                      right: DesignSystem.spacing.x24,
                      child: IconButton.filled(
                        onPressed:
                            () => ModalUtils.showBaseDialog(
                              context,
                              BaseConfirmationDialog(
                                title: 'gameDialogExitGameTitle'.tr(),
                                body: 'gameDialogExitGameBody'.tr(),
                                isYesDestructive: true,
                                yesText: 'gYes'.tr(),
                                noText: 'gNo'.tr(),
                                onYes:
                                    (_) =>
                                        BaseAppRouter().navigateBack(context),
                              ),
                            ),
                        icon: Icon(CupertinoIcons.clear),
                      ),
                    ),
                  ],
                ),
              )
              : Center(child: Text('NO GROUP')),
    );
  }
}

import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../router/router.dart';
import 'gradient_background.dart';

class ImpostiScaffold extends StatelessWidget {
  final List<Widget>? children;
  final bool isContentScrollable;

  final Widget? body;

  final EdgeInsets? contentPadding;

  /// If the default [contentPadding] should also apply to top and bottom,
  /// defaults to true to keep being symmetrical. Makes sense to
  /// set to false if a bottom navigation bar is being used or the
  /// content is scrollable in general.
  final bool contentVerticalPadding;
  final EdgeInsets? additionalContentPadding;

  final bool includeBackButton;

  const ImpostiScaffold({
    super.key,
    this.children,
    this.isContentScrollable = true,
    this.body,
    this.contentPadding,
    this.contentVerticalPadding = true,
    this.additionalContentPadding,
    this.includeBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GradientBackground(),
          SafeArea(
            child: Padding(
              padding:
                  (contentPadding ??
                      EdgeInsets.symmetric(
                        horizontal: DesignSystem.spacing.x24,
                        vertical:
                            contentVerticalPadding
                                ? DesignSystem.spacing.x24
                                : 0,
                      )) +
                  (additionalContentPadding ?? EdgeInsets.zero),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  body ??
                      ListView(
                        physics:
                            !isContentScrollable
                                ? NeverScrollableScrollPhysics()
                                : null,
                        children: children ?? [],
                      ),
                  if (includeBackButton)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: CupertinoButton.filled(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_back_ios_new),
                            Text('gBack'.tr()),
                          ],
                        ),
                        onPressed: () => BaseAppRouter().navigateBack(context),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

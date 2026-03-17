import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IntroBottomBar extends StatelessWidget {
  final int currentPage;
  final VoidCallback onNext;

  const IntroBottomBar({
    super.key,
    required this.currentPage,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(DesignSystem.spacing.x24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Pagination Dots
          Row(children: List.generate(3, (index) => _buildDot(context, index))),
          // Action Button
          CupertinoButton.filled(
            onPressed: onNext,
            child: Text(currentPage == 2 ? 'gStart'.tr() : 'gNext'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(BuildContext context, int index) {
    final bool isActive = currentPage == index;
    return AnimatedContainer(
      duration: DesignSystem.animation.defaultDurationMS250,
      margin: EdgeInsets.only(right: DesignSystem.spacing.x8),
      height: DesignSystem.size.x8,
      width: isActive ? DesignSystem.size.x24 : DesignSystem.size.x8,
      decoration: BoxDecoration(
        color:
            isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(DesignSystem.border.radius6),
      ),
    );
  }
}

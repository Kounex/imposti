import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseSheet extends StatefulWidget {
  final String title;
  final List<Widget> children;

  final void Function()? onDelete;

  final String? actionText;
  final void Function()? onAction;

  const BaseSheet({
    super.key,
    required this.title,
    required this.children,
    this.onDelete,
    this.actionText,
    this.onAction,
  });

  @override
  State<BaseSheet> createState() => _BaseSheetState();
}

class _BaseSheetState extends State<BaseSheet> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: DesignSystem.spacing.x24),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: DesignSystem.spacing.x24,
              ),
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            SizedBox(height: DesignSystem.spacing.x24),
            Expanded(
              child: Scrollbar(
                controller: _controller,
                thumbVisibility: true,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: DesignSystem.spacing.x24,
                  ),
                  child: ListView(
                    controller: _controller,
                    physics: AlwaysScrollableScrollPhysics(),
                    children: widget.children,
                  ),
                ),
              ),
            ),
            if (widget.onDelete != null) ...[
              SizedBox(height: DesignSystem.spacing.x24),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: DesignSystem.spacing.x24,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    onPressed: () => widget.onDelete!.call(),
                    color: Theme.of(context).colorScheme.error,
                    child: Text(
                      'gDelete'.tr(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            if (widget.onAction != null) ...[
              SizedBox(height: DesignSystem.spacing.x24),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: DesignSystem.spacing.x24,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    onPressed: () => widget.onAction!.call(),
                    child: Text(widget.actionText ?? 'gSave'.tr()),
                  ),
                ),
              ),
            ],
            SizedBox(height: DesignSystem.spacing.x24),
          ],
        ),
      ),
    );
  }
}

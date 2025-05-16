import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imposti/router/view.dart';
import 'package:imposti/widgets/shared/custom_category_sheet/service.dart';
import 'package:imposti/widgets/ui/imposti_scaffold.dart';

import '../../../../models/category/category.dart';
import '../../../../models/hive_adapters.dart';
import '../../../../widgets/builder/hive_builder.dart';

class CustomCategoriesView extends RouterStatefulView {
  const CustomCategoriesView({super.key});

  @override
  State<CustomCategoriesView> createState() => _CustomCategoriesViewState();
}

class _CustomCategoriesViewState extends State<CustomCategoriesView> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ImpostiScaffold(
      includeBackButton: true,
      body: HiveBuilder<Category>(
        hiveKey: HiveKey.category,
        builder: (context, categoryBox, child) {
          Iterable<Category> customCategories = categoryBox.values.where(
            (category) => !category.base,
          );
          return BaseCard(
            topPadding: 0,
            leftPadding: 0,
            rightPadding: 0,
            bottomPadding: 0,
            paddingChild: EdgeInsets.zero,
            title: 'settingsYourCategories'.tr(),
            trailingTitleWidget: CupertinoButton(
              onPressed: () => CustomCategoryService.addEditSheet(context),
              padding: EdgeInsets.zero,
              minSize: DesignSystem.size.x18,
              child: Text('gAdd'.tr()),
            ),
            child: switch (customCategories.isNotEmpty) {
              true => ConstrainedBox(
                constraints: BoxConstraints(maxHeight: DesignSystem.size.x256),
                child: Scrollbar(
                  controller: _controller,
                  thumbVisibility: true,
                  child: ListView(
                    controller: _controller,
                    shrinkWrap: true,
                    children: List.from(
                      customCategories.map(
                        (category) => ListTile(
                          onTap:
                              () => CustomCategoryService.addEditSheet(
                                context,
                                category,
                              ),
                          title: Padding(
                            padding: EdgeInsets.only(
                              left: DesignSystem.spacing.x8,
                            ),
                            child: Text(category.name['custom']!),
                          ),
                          trailing: Icon(Icons.edit),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              false => Padding(
                padding: EdgeInsets.all(DesignSystem.spacing.x24),
                child: BasePlaceholder(text: 'lobbyCategoryListOwnEmpty'.tr()),
              ),
            },
          );
        },
      ),
    );
  }
}

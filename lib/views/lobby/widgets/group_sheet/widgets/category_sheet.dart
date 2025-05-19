import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:imposti/models/category/category.dart';
import 'package:imposti/models/group/group.dart';
import 'package:imposti/models/hive_adapters.dart';
import 'package:imposti/router/router.dart';
import 'package:imposti/router/routes.dart';
import 'package:imposti/widgets/shared/category_section.dart';
import 'package:imposti/widgets/ui/sheet.dart';

import '../../../../../widgets/builder/hive_builder.dart';

class CategorySheet extends StatefulWidget {
  final Group group;

  final void Function(List<String> categoryUuids) onSave;

  const CategorySheet({super.key, required this.group, required this.onSave});

  @override
  State<CategorySheet> createState() => _CategorySheetState();
}

class _CategorySheetState extends State<CategorySheet> {
  final List<String> _categoryUuids = [];

  @override
  void initState() {
    super.initState();

    _categoryUuids.addAll(widget.group.categoryUuids);
  }

  void _handleCategoryTap(Category category) {
    setState(() {
      if (_categoryUuids.contains(category.uuid)) {
        if (_categoryUuids.length > 1) {
          HapticFeedback.lightImpact();
          _categoryUuids.remove(category.uuid);
        } else {
          ModalUtils.showBaseDialog(
            context,
            BaseInfoDialog(body: 'lobbyCategoryListMinimum'.tr()),
          );
        }
      } else {
        HapticFeedback.lightImpact();
        _categoryUuids.add(category.uuid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return HiveBuilder<Category>(
      hiveKey: HiveKey.category,
      builder: (context, categoryBox, child) {
        Iterable<Category> customCategories = categoryBox.values.where(
          (category) => !category.base,
        );

        return BaseSheet(
          onAction: () {
            widget.onSave(_categoryUuids);
            Navigator.of(context).pop();
          },
          title: 'gCategory'.plural(2),
          children: [
            Text('lobbyCategoryListDescription'.tr()),
            SizedBox(height: DesignSystem.spacing.x24),
            CategorySection(
              onTap: _handleCategoryTap,
              categories: categoryBox.values.where((category) => category.base),
              categoryUuids: _categoryUuids,
            ),
            SizedBox(height: DesignSystem.spacing.x24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('lobbyCategoryListOwnDescription'.tr()),
                CupertinoButton(
                  onPressed:
                      () => BaseAppRouter().navigateTo(
                        context,
                        AppRoute.lobbyCustomCategories,
                      ),
                  padding: EdgeInsets.zero,
                  minSize: DesignSystem.size.x18,
                  child: Text('gEdit'.tr()),
                ),
              ],
            ),
            SizedBox(height: DesignSystem.spacing.x24),
            switch (customCategories.isNotEmpty) {
              true => CategorySection(
                onTap: _handleCategoryTap,
                categories: customCategories,
                categoryUuids: _categoryUuids,
                hasLeading: false,
              ),
              false => BaseCard(
                topPadding: 0,
                leftPadding: 0,
                rightPadding: 0,
                bottomPadding: 0,
                child: BasePlaceholder(text: 'lobbyCategoryListOwnEmpty'.tr()),
              ),
            },
          ],
        );
      },
    );
    // return Center(
    //   child: Padding(
    //     padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),

    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         SizedBox(height: DesignSystem.spacing.x24),
    //         Padding(
    //           padding: EdgeInsets.symmetric(
    //             horizontal: DesignSystem.spacing.x24,
    //           ),
    //           child: Text(
    //             'gCategory'.plural(2),
    //             style: Theme.of(context).textTheme.headlineLarge,
    //           ),
    //         ),
    //         Expanded(
    //           child: HiveBuilder<Category>(
    //             hiveKey: HiveKey.category,
    //             builder: (context, categoryBox, child) {
    //               Iterable<Category> customCategories = categoryBox.values
    //                   .where((category) => !category.base);

    //               return Scrollbar(
    //                 controller: _controller,
    //                 thumbVisibility: true,
    //                 child: Padding(
    //                   padding: EdgeInsets.symmetric(
    //                     horizontal: DesignSystem.spacing.x24,
    //                   ),
    //                   child: ListView(
    //                     controller: _controller,
    //                     children: [
    //                       SizedBox(height: DesignSystem.spacing.x24),
    //                       Text('lobbyCategoryListDescription'.tr()),
    //                       SizedBox(height: DesignSystem.spacing.x24),
    //                       CategorySection(
    //                         onTap: _handleCategoryTap,
    //                         categories: categoryBox.values.where(
    //                           (category) => category.base,
    //                         ),
    //                         categoryUuids: _categoryUuids,
    //                       ),
    //                       SizedBox(height: DesignSystem.spacing.x24),
    //                       Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           Text('lobbyCategoryListOwnDescription'.tr()),
    //                           CupertinoButton(
    //                             onPressed:
    //                                 () => CustomCategoryService.addEditSheet(
    //                                   context,
    //                                 ),
    //                             padding: EdgeInsets.zero,
    //                             minSize: DesignSystem.size.x18,
    //                             child: Text('gAdd'.tr()),
    //                           ),
    //                         ],
    //                       ),
    //                       SizedBox(height: DesignSystem.spacing.x24),
    //                       switch (customCategories.isNotEmpty) {
    //                         true => CategorySection(
    //                           onTap: _handleCategoryTap,
    //                           categories: customCategories,
    //                           categoryUuids: _categoryUuids,
    //                           hasLeading: false,
    //                         ),
    //                         false => BaseCard(
    //                           topPadding: 0,
    //                           leftPadding: 0,
    //                           rightPadding: 0,
    //                           bottomPadding: 0,
    //                           child: BasePlaceholder(
    //                             text: 'lobbyCategoryListOwnEmpty'.tr(),
    //                           ),
    //                         ),
    //                       },
    //                     ],
    //                   ),
    //                 ),
    //               );
    //             },
    //           ),
    //         ),
    //         SizedBox(height: DesignSystem.spacing.x24),
    //         SizedBox(
    //           width: double.infinity,
    //           child: CupertinoButton.filled(
    //             onPressed: () {
    //               widget.onSave(_categoryUuids);
    //               Navigator.of(context).pop();
    //             },
    //             child: Text('gSave'.tr()),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

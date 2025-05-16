import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/category/category.dart';

class CategorySection extends StatelessWidget {
  final Iterable<Category> categories;

  final List<String>? categoryUuids;
  final Widget? additionalInfo;

  final void Function(Category category)? onTap;

  const CategorySection({
    super.key,
    required this.categories,
    this.categoryUuids,
    this.additionalInfo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCupertinoListSection(
      hasLeading: false,
      tiles: List.from(
        categories.map(
          (category) => BaseCupertinoListTile(
            onTap: () => onTap?.call(category),
            title: Text(
              category.name[category.base
                  ? context.locale.languageCode
                  : 'custom']!,
            ),
            additionalInfo:
                additionalInfo ??
                ((categoryUuids?.contains(category.uuid) ?? false)
                    ? Icon(
                      CupertinoIcons.check_mark,
                      color: Theme.of(context).colorScheme.primary,
                    )
                    : null),
          ),
        ),
      ),
    );
  }
}

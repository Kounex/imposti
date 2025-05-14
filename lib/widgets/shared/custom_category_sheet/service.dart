import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_ce/hive.dart';
import 'package:uuid/v4.dart';

import '../../../models/category/category.dart';
import '../../../models/hive_adapters.dart';
import 'custom_category_sheet.dart';

class CustomCategoryService {
  static void addEditSheet(BuildContext context, [Category? category]) =>
      ModalUtils.showExpandedModalBottomSheet(
        context,
        CustomCategorySheet(
          category: category,
          languageCode: context.locale.languageCode,
          onSave: (name, words) {
            if (category != null) {
              Hive.box<Category>(HiveKey.category.name).put(
                category.key,
                category.copyWith(
                  name: {context.locale.languageCode: name},
                  words: {context.locale.languageCode: words},
                ),
              );
            } else {
              Hive.box<Category>(HiveKey.category.name).add(
                Category(
                  uuid: UuidV4().generate(),
                  name: {context.locale.languageCode: name},
                  words: {context.locale.languageCode: words},
                ),
              );
            }
          },
        ),
      );
}

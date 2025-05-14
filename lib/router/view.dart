import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

abstract class RouterStatefulView<T extends RouterViewData>
    extends StatefulWidget {
  final T? data;

  const RouterStatefulView({
    super.key,
    this.data,
  });
}

abstract class RouterViewData {
  final GoRouterState state;

  RouterViewData({required this.state});
}

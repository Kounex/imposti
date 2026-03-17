import 'package:base_components/base_components.dart';
import 'package:flutter/material.dart';
import 'package:imposti/router/router.dart';
import 'package:imposti/router/routes.dart';
import 'package:imposti/router/view.dart';
import 'package:imposti/widgets/ui/imposti_scaffold.dart';
import 'widgets/bottom_bar.dart';
import 'widgets/instruction_page_1.dart';
import 'widgets/instruction_page_2.dart';
import 'widgets/welcome_page.dart';

class IntroView extends RouterStatefulView {
  const IntroView({super.key});

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < 2) {
      _controller.nextPage(
        duration: DesignSystem.animation.defaultDurationMS250,
        curve: Curves.easeInOut,
      );
    } else {
      BaseAppRouter().navigateTo(context, TabAppRoute.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ImpostiScaffold(
      contentPadding: EdgeInsets.zero,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: const [
                IntroWelcomePage(),
                IntroInstructionPage1(),
                IntroInstructionPage2(),
              ],
            ),
          ),
          IntroBottomBar(currentPage: _currentPage, onNext: _onNext),
        ],
      ),
    );
  }
}

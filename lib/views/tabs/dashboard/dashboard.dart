import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_components/base_components.dart';
import 'package:dough/dough.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imposti/router/router.dart';
import 'package:imposti/router/routes.dart';
import 'package:imposti/router/view.dart';
import 'package:imposti/widgets/ui/gradient_background.dart';
import 'package:imposti/widgets/ui/imposti_scaffold.dart';

class DashboardView extends RouterStatefulView {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return ImpostiScaffold(
      body: PressableDough(
        child: GestureDetector(
          onTap: () => BaseAppRouter().navigateTo(context, AppRoute.lobby),
          child: Center(
            child: IntrinsicHeight(
              child: Card(
                color: Theme.of(context).colorScheme.primary.darken(85),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: DesignSystem.spacing.x12,
                        bottom: DesignSystem.spacing.x64,
                      ),
                      child: Transform.translate(
                        offset: Offset(0, 100),
                        child: Image.asset(
                          'assets/images/prots/dashboard.png',
                          height: 550,
                        ),
                      ),
                    ),
                    Positioned(
                      top: DesignSystem.spacing.x32,
                      left: DesignSystem.spacing.x12,
                      right: DesignSystem.spacing.x12,
                      child: Transform.rotate(
                        angle: -pi / 24,
                        child: Image.asset(
                          'assets/images/imposti.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    // Positioned(
                    //   bottom: 0,
                    //   left: 0,
                    //   right: 0,
                    //   child: Card(
                    //     color: Theme.of(context).colorScheme.primary,
                    //     margin: EdgeInsets.zero,
                    //     shape: BeveledRectangleBorder(
                    //       side: BorderSide(
                    //         color:
                    //             (Theme.of(context).cardTheme.shape
                    //                     as RoundedRectangleBorder?)!
                    //                 .side
                    //                 .color,
                    //         width: 1,
                    //       ),
                    //     ),
                    //     child: Center(
                    //       child: Padding(
                    //         padding: EdgeInsets.all(
                    //           DesignSystem.spacing.x24,
                    //         ),
                    //         child: OutlinedText(
                    //           'Finde den Hochstapler!',
                    //           textAlign: TextAlign.center,
                    //           color: Colors.white,
                    //           outlineColor: Colors.black,
                    //           outlineWidth: 01,
                    //           style: Theme.of(context).textTheme.titleLarge!
                    //               .copyWith(letterSpacing: 1.0),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    GradientBackground(
                      colors: [
                        Theme.of(context).colorScheme.primary.withAlpha(255),
                        Theme.of(context).colorScheme.primary.withAlpha(255),
                        Theme.of(context).colorScheme.primary.withAlpha(50),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    Positioned(
                      bottom: DesignSystem.spacing.x42,
                      left: DesignSystem.spacing.x12,
                      right: DesignSystem.spacing.x12,
                      child: AutoSizeText(
                        'dashboardCardTitle'.tr(),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: GoogleFonts.montserrat(
                          textStyle: Theme.of(
                            context,
                          ).textTheme.displayMedium!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

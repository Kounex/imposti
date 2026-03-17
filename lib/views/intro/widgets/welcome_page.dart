import 'package:base_components/base_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imposti/widgets/ui/aura.dart';

class IntroWelcomePage extends StatefulWidget {
  const IntroWelcomePage({super.key});

  @override
  State<IntroWelcomePage> createState() => _IntroWelcomePageState();
}

class _IntroWelcomePageState extends State<IntroWelcomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required by AutomaticKeepAliveClientMixin
    return Padding(
      padding: EdgeInsets.all(DesignSystem.spacing.x24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Hero(
            tag: 'splash_logo',
            child: Image.asset(
              'assets/images/splash.png',
              height: DesignSystem.size.x128 * 1.5,
              errorBuilder:
                  (context, error, stackTrace) => Icon(
                    Icons.local_police, // Fallback icon
                    size: DesignSystem.size.x92,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          SizedBox(height: DesignSystem.spacing.x32),
          Text(
            'Imposti',
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: DesignSystem.spacing.x12),
          Text(
            'sharedHowToSheetTitle'.tr(),
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

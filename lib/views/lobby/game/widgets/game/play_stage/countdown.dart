import 'dart:async';

import 'package:animated_digit/animated_digit.dart';
import 'package:base_components/base_components.dart';
import 'package:flutter/material.dart';

class Countdown extends StatefulWidget {
  final int countdown;
  final int? showCountdownDelay;

  final Widget? child;
  final String? text;

  final void Function()? onCountdownDone;

  const Countdown({
    super.key,
    required this.countdown,
    this.showCountdownDelay,
    this.child,
    this.text,
    this.onCountdownDone,
  });

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late final AnimatedDigitController _controller;
  late bool _showCountdown;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimatedDigitController(widget.countdown);

    _showCountdown = widget.showCountdownDelay == null;

    Future.delayed(Duration(seconds: widget.showCountdownDelay ?? 0), () {
      setState(() => _showCountdown = true);
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_controller.value > 0) {
          _controller.value--;
        } else {
          timer.cancel();
          widget.onCountdownDone?.call();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyLarge!,
      child: AnimatedOpacity(
        duration: DesignSystem.animation.defaultDurationMS250,
        opacity: _showCountdown ? 1 : 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.child != null || widget.text != null) ...[
              widget.child ?? Text(widget.text!),
              SizedBox(height: DesignSystem.spacing.x12),
            ],
            AnimatedDigitWidget(
              controller: _controller,
              loop: false,
              textStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

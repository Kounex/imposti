import 'package:flutter/material.dart';
import 'package:imposti/router/shell/tabs.dart';

class ShellScaffold extends StatefulWidget {
  final Widget child;

  const ShellScaffold({super.key, required this.child});

  @override
  State<ShellScaffold> createState() => _ShellScaffoldState();
}

class _ShellScaffoldState extends State<ShellScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: ShellTabs(),
    );
  }
}

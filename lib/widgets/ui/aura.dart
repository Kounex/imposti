import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// A widget that renders an animated, glowing aura effect around its [child].
///
/// The aura is rendered in the global [Overlay], making it immune to ancestor
/// layout constraints (padding, clipping, etc.). It uses a custom fragment
/// shader for a smooth, organic glow that conforms to the child's shape.
///
/// Works correctly inside scrollable containers ([PageView], [ListView], etc.)
/// and across route transitions.
///
/// Example:
/// ```dart
/// Aura(
///   auraColor: Theme.of(context).colorScheme.primary,
///   borderRadius: 12,
///   maxSpread: 80,
///   child: CupertinoButton.filled(
///     onPressed: () {},
///     child: Text('Get Started'),
///   ),
/// )
/// ```
class Aura extends StatefulWidget {
  /// The widget to wrap with the aura effect.
  final Widget child;

  /// Corner radius of the aura shape. Should match the child's border radius.
  final double borderRadius;

  /// How far the glow extends beyond the child's bounds (in logical pixels).
  final double maxSpread;

  /// The color of the aura glow.
  final Color auraColor;

  /// Animation speed multiplier. Lower = calmer.
  /// Default `0.3` gives a gentle, breathing effect.
  final double speed;

  /// Overall glow strength (0.0 = invisible, 1.0 = full brightness).
  final double intensity;

  /// When `false` (default), the glow only renders outside the child's bounds —
  /// ideal for buttons and individual widgets.
  /// When `true`, the glow also fills the inside of the child's bounds —
  /// ideal for wrapping a Column or group of widgets.
  final bool fillCenter;

  const Aura({
    super.key,
    required this.child,
    this.borderRadius = 12.0,
    this.maxSpread = 40.0,
    this.auraColor = Colors.deepOrangeAccent,
    this.speed = 0.3,
    this.intensity = 1.0,
    this.fillCenter = false,
  });

  @override
  State<Aura> createState() => _AuraState();
}

class _AuraState extends State<Aura> with SingleTickerProviderStateMixin {
  static const _shaderAsset = 'assets/shaders/aura.frag';

  ui.FragmentShader? _shader;
  late final AnimationController _controller;
  final GlobalKey _childKey = GlobalKey();

  // Position & visibility tracking.
  Size? _childSize;
  Offset? _childCenter;
  bool _isVisible = false;
  Duration _lastFrameTime = Duration.zero;

  // Random initial offset so the animation starts from a unique phase each
  // time the widget is created (or hot reloaded). Range 0–100 covers many
  // full wave cycles for all frequencies used in the shader.
  late double _elapsedTime = Random().nextDouble() * 100.0;

  // Scroll-compensation for off-screen tracking.
  // When the child scrolls out of view (e.g. PageView), we save the last known
  // good position and the scroll offset at that moment. On each frame, we apply
  // the scroll delta to keep the aura sliding naturally with the scroll.
  Offset? _frozenCenter;
  double? _frozenScrollOffset;

  OverlayEntry? _auraOverlay;
  OverlayEntry? _childOverlay;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _loadShader();
    // Duration is irrelevant — we only use the controller as a ticker
    // to drive per-frame updates, not its 0→1 value.
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..addListener(_onTick)
          ..repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onTick();
      _insertOverlays();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // When the page is pushed behind another (tab switch, modal push, etc.),
    // Flutter disables its tickers via TickerMode. Since _onTick stops running,
    // we catch the change here and hide the overlays immediately.
    // Deferred to post-frame to avoid markNeedsBuild() during the build phase.
    if (!TickerMode.of(context)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _setVisible(false);
      });
    }
  }

  @override
  void didUpdateWidget(covariant Aura oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onTick());
  }

  @override
  void reassemble() {
    super.reassemble();
    // Hot reload can leave stale overlay entries. Remove and re-insert cleanly.
    _removeOverlays();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _insertOverlays();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onTick);
    _removeOverlays();
    _controller.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Shader loading
  // ---------------------------------------------------------------------------

  Future<void> _loadShader() async {
    final program = await ui.FragmentProgram.fromAsset(_shaderAsset);
    if (mounted) {
      _shader = program.fragmentShader();
      _auraOverlay?.markNeedsBuild();
    }
  }

  // ---------------------------------------------------------------------------
  // Per-frame position tracking
  // ---------------------------------------------------------------------------

  /// Called every animation frame to recalculate the child's global position
  /// and update overlay visibility.
  void _onTick() {
    if (!mounted) return;

    // Accumulate smooth, continuous elapsed time (no jumps on repeat).
    final now = _controller.lastElapsedDuration ?? Duration.zero;
    final dt = (now - _lastFrameTime).inMicroseconds / 1e6; // seconds
    _lastFrameTime = now;
    if (dt > 0 && dt < 0.5) _elapsedTime += dt * widget.speed;

    final renderBox =
        _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached) {
      _setVisible(false);
      return;
    }

    final size = renderBox.size;
    final center = renderBox.localToGlobal(size.center(Offset.zero));
    final onScreen = _isWithinScreen(center, size);

    if (onScreen) {
      _updateOnScreen(center, size);
    } else {
      _updateOffScreen(center, size);
    }
  }

  /// Returns `true` if the child occupies any part of the visible screen.
  bool _isWithinScreen(Offset center, Size size) {
    final screen = MediaQuery.of(context).size;
    return center.dx > -size.width &&
        center.dx < screen.width + size.width &&
        center.dy > -size.height &&
        center.dy < screen.height + size.height;
  }

  /// Update state while the child is visible on screen.
  void _updateOnScreen(Offset center, Size size) {
    final changed = size != _childSize || center != _childCenter || !_isVisible;
    if (!changed) return;

    _childSize = size;
    _childCenter = center;
    _frozenCenter = null;
    _frozenScrollOffset = null;
    _isVisible = true;
    _rebuildOverlays();
  }

  /// Update state while the child is off-screen (inside a scrollable).
  /// Compensates for continued scrolling by applying the scroll delta to
  /// the last known good position.
  void _updateOffScreen(Offset center, Size size) {
    final wasVisible = _isVisible;

    if (wasVisible) {
      // Just went off-screen — snapshot the freeze point.
      _frozenCenter = _childCenter;
      _frozenScrollOffset = _currentScrollOffset;
      _isVisible = false;
      _childOverlay?.markNeedsBuild();
    }

    // Apply ongoing scroll delta to shift the frozen position.
    if (_frozenCenter != null && _frozenScrollOffset != null) {
      final scroll = _currentScrollOffset;
      if (scroll != null) {
        final delta = scroll - _frozenScrollOffset!;
        final scrollDirection = _currentScrollDirection;
        final adjusted =
            scrollDirection == Axis.horizontal
                ? Offset(_frozenCenter!.dx - delta, _frozenCenter!.dy)
                : Offset(_frozenCenter!.dx, _frozenCenter!.dy - delta);
        if (adjusted != _childCenter) {
          _childCenter = adjusted;
          _auraOverlay?.markNeedsBuild();
        }
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Scroll helpers
  // ---------------------------------------------------------------------------

  /// Returns the pixel offset of the nearest ancestor [Scrollable], if any.
  double? get _currentScrollOffset {
    try {
      return Scrollable.maybeOf(
        _childKey.currentContext ?? context,
      )?.position.pixels;
    } catch (_) {
      return null;
    }
  }

  /// Returns the scroll axis of the nearest ancestor [Scrollable].
  Axis get _currentScrollDirection {
    try {
      return Scrollable.maybeOf(
            _childKey.currentContext ?? context,
          )?.axisDirection.toAxis ??
          Axis.horizontal;
    } catch (_) {
      return Axis.horizontal;
    }
  }

  // ---------------------------------------------------------------------------
  // Overlay management
  // ---------------------------------------------------------------------------

  void _setVisible(bool visible) {
    if (visible == _isVisible) return;
    _isVisible = visible;
    _rebuildOverlays();
  }

  void _rebuildOverlays() {
    _auraOverlay?.markNeedsBuild();
    _childOverlay?.markNeedsBuild();
  }

  void _insertOverlays() {
    _removeOverlays();

    _auraOverlay = OverlayEntry(builder: (_) => _buildAuraLayer());
    _childOverlay = OverlayEntry(builder: (_) => _buildChildLayer());

    final overlay = Overlay.of(context);
    overlay.insert(_auraOverlay!);
    overlay.insert(_childOverlay!);
  }

  void _removeOverlays() {
    _auraOverlay?.remove();
    _auraOverlay?.dispose();
    _auraOverlay = null;
    _childOverlay?.remove();
    _childOverlay?.dispose();
    _childOverlay = null;
  }

  // ---------------------------------------------------------------------------
  // Overlay builders
  // ---------------------------------------------------------------------------

  Widget _buildAuraLayer() {
    if (!_isVisible ||
        _shader == null ||
        _childSize == null ||
        _childCenter == null) {
      return const SizedBox.shrink();
    }

    final canvasSize =
        _childSize! + Offset(widget.maxSpread * 2, widget.maxSpread * 2);
    final canvasOrigin =
        _childCenter! - Offset(canvasSize.width / 2, canvasSize.height / 2);

    // Skip rendering if the aura canvas is entirely off-screen.
    final screen = MediaQuery.of(context).size;
    final visible =
        canvasOrigin.dx + canvasSize.width > 0 &&
        canvasOrigin.dx < screen.width &&
        canvasOrigin.dy + canvasSize.height > 0 &&
        canvasOrigin.dy < screen.height;

    if (!visible) return const SizedBox.shrink();

    return Positioned(
      left: canvasOrigin.dx,
      top: canvasOrigin.dy,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _controller,
          builder:
              (_, __) => CustomPaint(
                size: canvasSize,
                painter: _AuraShaderPainter(
                  shader: _shader!,
                  time: _elapsedTime,
                  widgetSize: _childSize!,
                  borderRadius: widget.borderRadius,
                  maxSpread: widget.maxSpread,
                  color: widget.auraColor,
                  intensity: widget.intensity,
                  fillCenter: widget.fillCenter,
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildChildLayer() {
    if (!_isVisible || _childSize == null || _childCenter == null) {
      return const SizedBox.shrink();
    }

    // Wrap the child with inherited widgets from the original context
    // so text styling, icon themes, etc. are preserved in the overlay.
    final theme = Theme.of(context);
    final defaultTextStyle = DefaultTextStyle.of(context);

    return Positioned(
      left: _childCenter!.dx - _childSize!.width / 2,
      top: _childCenter!.dy - _childSize!.height / 2,
      child: SizedBox(
        width: _childSize!.width,
        height: _childSize!.height,
        child: Theme(
          data: theme,
          child: DefaultTextStyle(
            style: defaultTextStyle.style,
            child: widget.child,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Invisible placeholder that occupies layout space and provides
    // position tracking via its GlobalKey. The visible child is rendered
    // in the overlay on top of the aura glow.
    return Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: false,
      child: Container(key: _childKey, child: widget.child),
    );
  }
}

// =============================================================================
// Axis extension
// =============================================================================

extension on AxisDirection {
  Axis get toAxis =>
      this == AxisDirection.left || this == AxisDirection.right
          ? Axis.horizontal
          : Axis.vertical;
}

// =============================================================================
// Shader painter
// =============================================================================

/// Paints the aura glow using a fragment shader with a rounded-box SDF.
///
/// Uniform layout (must match `aura.frag`):
///   0-1:  u_resolution    (vec2)
///   2:    u_time           (float)
///   3-4:  u_center         (vec2)
///   5-6:  u_box_size       (vec2)
///   7:    u_border_radius  (float)
///   8:    u_max_spread     (float)
///   9-12: u_color          (vec4)
///   13:   u_intensity      (float)
///   14:   u_fill_center    (float, 0.0 or 1.0)
class _AuraShaderPainter extends CustomPainter {
  final ui.FragmentShader shader;
  final double time;
  final Size widgetSize;
  final double borderRadius;
  final double maxSpread;
  final Color color;
  final double intensity;
  final bool fillCenter;

  _AuraShaderPainter({
    required this.shader,
    required this.time,
    required this.widgetSize,
    required this.borderRadius,
    required this.maxSpread,
    required this.color,
    required this.intensity,
    required this.fillCenter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, time)
      ..setFloat(3, center.dx)
      ..setFloat(4, center.dy)
      ..setFloat(5, widgetSize.width)
      ..setFloat(6, widgetSize.height)
      ..setFloat(7, borderRadius)
      ..setFloat(8, maxSpread)
      ..setFloat(9, color.r)
      ..setFloat(10, color.g)
      ..setFloat(11, color.b)
      ..setFloat(12, color.a)
      ..setFloat(13, intensity)
      ..setFloat(14, fillCenter ? 1.0 : 0.0);

    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(covariant _AuraShaderPainter old) =>
      old.time != time ||
      old.intensity != intensity ||
      old.fillCenter != fillCenter;
}

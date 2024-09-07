import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Default indicator radius.
const double _kDefaultAntinnaIndicatorRadius = 35.0;

/// A custom activity indicator widget.
final class AntinnaActivityIndicator extends StatefulWidget {
  /// Creates an animated activity indicator.
  const AntinnaActivityIndicator({
    super.key,
    this.color,
    this.animating = true,
    this.radius = _kDefaultAntinnaIndicatorRadius,
    this.backgroundColor = const Color(0xFF303030),
    this.semanticsLabel = "loading",
    this.semanticsValue,
  })  : assert(radius > 0.0),
        progress = 1.0,
        bubbleRadius = (radius / 35) * 3;

  /// Creates a non-animated activity indicator that displays a partial count of ticks based on [progress].
  const AntinnaActivityIndicator.partiallyRevealed({
    super.key,
    this.color,
    this.radius = _kDefaultAntinnaIndicatorRadius,
    this.progress = 1.0,
    this.backgroundColor = const Color(0xFF303030),
    this.semanticsLabel,
    this.semanticsValue,
  })  : assert(radius > 0.0),
        assert(progress >= 0.0 && progress <= 1.0),
        animating = false,
        bubbleRadius = (radius / 35) * 3;

  /// The color of the activity indicator.
  final Color? color;

  /// Whether the activity indicator is animating.
  final bool animating;

  /// The radius of the activity indicator.
  final double radius;

  /// The progress value determining the percentage of ticks to be displayed.
  final double progress;

  /// The background color of the activity indicator.
  final Color backgroundColor;

  /// The radius of each bubble in the activity indicator.
  final double bubbleRadius;

  final String? semanticsLabel;
  final String? semanticsValue;

  @override
  State<AntinnaActivityIndicator> createState() =>
      _AntinnaActivityIndicatorState();
}

final class _AntinnaActivityIndicatorState
    extends State<AntinnaActivityIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    if (widget.animating) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(AntinnaActivityIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animating != oldWidget.animating) {
      if (widget.animating) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticsLabel,
      value: widget.semanticsValue,
      child: Container(
        width: widget.radius,
        height: widget.radius,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: widget.backgroundColor),
        child: CustomPaint(
          painter: _AntinnaActivityIndicatorPainter(
            bubbleRadius: widget.bubbleRadius,
            position: _controller,
            activeColor: widget.color ?? Colors.white.withOpacity(0.2),
            radius: widget.radius,
            progress: widget.progress,
          ),
        ),
      ),
    );
  }
}

/// Alpha values for the ticks in the activity indicator.
const List<int> _kAlphaValues = <int>[47, 47, 47, 47, 72, 97, 122, 147];

/// Custom painter for the AntinnaActivityIndicator.
final class _AntinnaActivityIndicatorPainter extends CustomPainter {
  _AntinnaActivityIndicatorPainter({
    required this.bubbleRadius,
    required this.position,
    required this.activeColor,
    required this.radius,
    required this.progress,
  })  : tickFundamentalRRect = RRect.fromLTRBXY(
          -radius / _kDefaultAntinnaIndicatorRadius,
          -radius / 3.0,
          radius / _kDefaultAntinnaIndicatorRadius,
          -radius,
          radius / _kDefaultAntinnaIndicatorRadius,
          radius / _kDefaultAntinnaIndicatorRadius,
        ),
        super(repaint: position);

  /// Animation controlling the position of the active bubble.
  final Animation<double> position;

  /// The active color of the bubbles.
  final Color activeColor;

  /// The radius of the activity indicator.
  final double radius;

  /// The progress value determining the percentage of ticks to be displayed.
  final double progress;

  /// The radius of each bubble in the activity indicator.
  final double bubbleRadius;

  /// The fundamental rounded rectangle for drawing ticks.
  final RRect tickFundamentalRRect;

  @override
  void paint(Canvas canvas, Size size) {
    final bubbleCount = _kAlphaValues.length;
    const int partiallyRevealedAlpha = 147;
    final arcBetweenBubbles = (2 * math.pi) / bubbleCount;
    final Paint paint = Paint();
    canvas.save();
    canvas.translate(size.width / 2.0, size.height / 2.0);
    final int activeBubble = (bubbleCount * position.value).floor();

    for (var i = 0; i < bubbleCount * progress; i += 1) {
      final int t = (i - activeBubble) % bubbleCount;
      paint.color = activeColor
          .withAlpha(progress < 1 ? partiallyRevealedAlpha : _kAlphaValues[t]);
      canvas.drawCircle(
        Offset(math.cos(i * arcBetweenBubbles) * radius / 4,
            math.sin(i * arcBetweenBubbles) * radius / 4),
        bubbleRadius,
        paint,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AntinnaActivityIndicatorPainter oldPainter) {
    return oldPainter.position != position ||
        oldPainter.activeColor != activeColor ||
        oldPainter.progress != progress ||
        oldPainter.bubbleRadius != bubbleRadius;
  }
}

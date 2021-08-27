import 'package:flutter/material.dart';

enum Edge { First, Last, Middle }

class AnimatedNavbarBackground extends StatefulWidget {
  final AnimationController animationController;

  final Edge edge;

  final Color backgroundColor;
  final double backgroundBorderRadius;
  final double backgroundHeight;
  final double animatedMaxHorizontalMargin;

  const AnimatedNavbarBackground(
      {Key? key,
      required this.animationController,
      required this.edge,
      required this.backgroundColor,
      required this.backgroundBorderRadius,
      required this.backgroundHeight,
      required this.animatedMaxHorizontalMargin})
      : super(key: key);

  @override
  _AnimatedNavbarBackgroundState createState() =>
      _AnimatedNavbarBackgroundState();
}

class _AnimatedNavbarBackgroundState extends State<AnimatedNavbarBackground> {
  late Animation<double> _containerOpacityAnimation;
  late Animation<double> _containerWidthAnimation;
  late Animation<double> _containerScaleAnimation;

  @override
  void initState() {
    super.initState();

    _containerOpacityAnimation = _buildOpacityAnimation();
    _containerWidthAnimation = _buildWidthAnimation();
    _containerScaleAnimation = _buildScaleAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _containerScaleAnimation.value,
      child: Opacity(
        opacity: _containerOpacityAnimation.value,
        child: Stack(
          children: [
            Container(
              height: widget.backgroundHeight,
              margin: EdgeInsets.only(
                  left: widget.edge == Edge.First
                      ? 0.0
                      : _containerWidthAnimation.value,
                  right: widget.edge == Edge.Last
                      ? 0.0
                      : _containerWidthAnimation.value),
              decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(widget.backgroundBorderRadius),
                    topRight: Radius.circular(widget.backgroundBorderRadius),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Animation<double> _buildScaleAnimation() {
    return TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(1),
          weight: 33.0,
        ),
        TweenSequenceItem<double>(
            tween: Tween<double>(begin: 1, end: 1.2)
                .chain(CurveTween(curve: Curves.ease)),
            weight: 33.0),
        TweenSequenceItem<double>(
            tween: Tween<double>(begin: 1.2, end: 1)
                .chain(CurveTween(curve: Curves.ease)),
            weight: 34.0),
      ],
    ).animate(widget.animationController);
  }

  Animation<double> _buildWidthAnimation() {
    return TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween:
              Tween<double>(begin: 0, end: widget.animatedMaxHorizontalMargin)
                  .chain(CurveTween(curve: Curves.ease)),
          weight: 33,
        ),
        TweenSequenceItem<double>(
          tween:
              Tween<double>(begin: widget.animatedMaxHorizontalMargin, end: 0)
                  .chain(CurveTween(curve: Curves.ease)),
          weight: 67,
        ),
      ],
    ).animate(widget.animationController);
  }

  Animation<double> _buildOpacityAnimation() {
    return TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 1)
              .chain(CurveTween(curve: Curves.ease)),
          weight: 16,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(1.0),
          weight: 54.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1, end: 0)
              .chain(CurveTween(curve: Curves.ease)),
          weight: 30,
        ),
      ],
    ).animate(widget.animationController);
  }
}

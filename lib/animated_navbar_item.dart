import 'package:flutter/material.dart';

class AnimatedNavbarItem extends StatefulWidget {
  final AnimationController animationController;
  final bool activeIcon;
  final Widget unselectedChild;
  final Widget selectedChild;
  final double leftOffset;
  final Color backgroundColor;
  final double backgroundHeight;

  const AnimatedNavbarItem({
    Key? key,
    required this.animationController,
    required this.activeIcon,
    required this.unselectedChild,
    required this.leftOffset,
    required this.selectedChild,
    required this.backgroundColor,
    required this.backgroundHeight,
  }) : super(key: key);

  @override
  _AnimatedNavbarItemState createState() => _AnimatedNavbarItemState();
}

class _AnimatedNavbarItemState extends State<AnimatedNavbarItem> {
  late Animation<double> _iconPositionAnimation;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _circleOpacityAnimation;
  late Animation<bool> _iconFilledAnimation;

  @override
  void initState() {
    super.initState();

    _iconFilledAnimation = _buildIconFilledAnimation();

    _iconPositionAnimation = _buildIconPositionAnimation();

    _iconScaleAnimation = _buildIconScaleAnimation();

    _circleOpacityAnimation = _buildCircleOpacityAnimation();
  }

  @override
  Widget build(BuildContext context) {
    print(_iconFilledAnimation.value && widget.activeIcon);
    return Positioned(
      left: widget.leftOffset,
      bottom: (widget.backgroundHeight - 48) / 2 +
          (widget.activeIcon ? _iconPositionAnimation.value : 0),
      child: Transform.scale(
          scale: widget.activeIcon ? _iconScaleAnimation.value : 1,
          child: Stack(
            children: [
              Opacity(
                opacity: _circleOpacityAnimation.value,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 48,
                    height: 48,
                    color: widget.activeIcon
                        ? widget.backgroundColor
                        : Colors.transparent,
                  ),
                ),
              ),
              _selectIfIconShouldBeFilled()
            ],
          )),
    );
  }

  Widget _selectIfIconShouldBeFilled() {
    if (widget.activeIcon) {
      if (widget.animationController.isAnimating) {
        if (_iconFilledAnimation.value) return widget.selectedChild;
      } else {
        return widget.selectedChild;
      }
    }

    return widget.unselectedChild;
  }

  Animation<bool> _buildIconFilledAnimation() {
    return TweenSequence<bool>(
      <TweenSequenceItem<bool>>[
        TweenSequenceItem<bool>(tween: ConstantTween<bool>(false), weight: 53),
        TweenSequenceItem<bool>(tween: ConstantTween<bool>(true), weight: 47),
      ],
    ).animate(widget.animationController);
  }

  Animation<double> _buildCircleOpacityAnimation() {
    return TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 1)
              .chain(CurveTween(curve: Curves.ease)),
          weight: 20,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(1),
          weight: 33,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(0),
          weight: 47,
        ),
      ],
    ).animate(widget.animationController);
  }

  Animation<double> _buildIconScaleAnimation() {
    return TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(1.0),
          weight: 33.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1, end: 0)
              .chain(CurveTween(curve: Curves.ease)),
          weight: 20,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 1)
              .chain(CurveTween(curve: Curves.ease)),
          weight: 12,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(1),
          weight: 35,
        ),
      ],
    ).animate(widget.animationController);
  }

  Animation<double> _buildIconPositionAnimation() {
    return TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: widget.backgroundHeight)
              .chain(CurveTween(curve: Curves.ease)),
          weight: 33,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(widget.backgroundHeight),
          weight: 17.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(0.0),
          weight: 50.0,
        ),
      ],
    ).animate(widget.animationController);
  }
}

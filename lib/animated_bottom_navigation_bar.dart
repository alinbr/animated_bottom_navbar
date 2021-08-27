import 'package:animated_bottom_navbar/animated_navbar_item.dart';
import 'package:animated_bottom_navbar/animated_navbar_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedBotomNavigationBar extends StatefulWidget {
  final Function onTap;
  final List<NavBarItem> items;
  final int initialPage;
  final Duration duration;
  final Color backgroundColor;
  final Color backgroundAnimatingColor;
  final double backgroundBorderRadius;
  final double backgroundHeight;
  final double horizontalMargin;
  final double animatedMaxHorizontalMargin;

  const AnimatedBotomNavigationBar({
    Key? key,
    required this.onTap,
    required this.items,
    this.initialPage = 0,
    this.duration = const Duration(seconds: 1),
    this.backgroundColor = Colors.white,
    this.backgroundBorderRadius = 24,
    this.backgroundHeight = 98.0,
    this.backgroundAnimatingColor = Colors.lightBlueAccent,
    this.horizontalMargin = 32.0,
    this.animatedMaxHorizontalMargin = 32,
  }) : super(key: key);

  @override
  _AnimatedBotomNavigationBarState createState() =>
      _AnimatedBotomNavigationBarState();
}

class _AnimatedBotomNavigationBarState extends State<AnimatedBotomNavigationBar>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> _rowWidthAnimation;

  late int _selected;
  bool isAnimating = false;

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(duration: widget.duration, vsync: this);

    _rowWidthAnimation = _buildRowWithAnimation();

    _rowWidthAnimation.addListener(() {
      setState(() {});
    });

    _rowWidthAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          animationController.reset();
          isAnimating = false;
        });
      }
    });

    _selected = widget.initialPage;
  }

  void onTap(int index) {
    // Prevent double taping
    if (animationController.isAnimating) return;

    setState(() {
      _selected = index;
      animationController.forward();
      isAnimating = true;
    });

    widget.onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    var items = _buildItems();

    return Container(
      height: widget.backgroundHeight * 2,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
              height: widget.backgroundHeight, color: widget.backgroundColor),
          AnimatedNavbarBackground(
            animatedMaxHorizontalMargin: widget.animatedMaxHorizontalMargin,
            backgroundHeight: widget.backgroundHeight,
            backgroundColor: widget.backgroundAnimatingColor,
            backgroundBorderRadius: widget.backgroundBorderRadius,
            animationController: animationController,
            edge: _getEdge(),
          ),
          ...items,
        ],
      ),
    );
  }

  Edge _getEdge() {
    if (_selected == 0) return Edge.First;
    if (_selected == widget.items.length - 1) return Edge.Last;
    return Edge.Middle;
  }

  List<double> _calculateLeftOffSets() {
    final spaceBetweenItems =
        ((MediaQuery.of(context).size.width - widget.horizontalMargin * 2) -
                48 * widget.items.length) /
            (widget.items.length - 1);

    final leftOffSets = List<double>.filled(widget.items.length, 0.0);
    for (int i = 0; i < leftOffSets.length; i++) {
      leftOffSets[i] = widget.horizontalMargin + (spaceBetweenItems + 48) * i;
    }

    if (isAnimating) {
      for (int i = 0; i < _selected; i++) {
        leftOffSets[i] += _rowWidthAnimation.value;
      }
      for (int i = _selected + 1; i < leftOffSets.length; i++) {
        leftOffSets[i] -= _rowWidthAnimation.value;
      }
    }
    return leftOffSets;
  }

  List<Widget> _buildItems() {
    final leftOffSets = _calculateLeftOffSets();

    List<Widget> items = [];
    for (int i = 0; i < leftOffSets.length; i++) {
      items.add(AnimatedNavbarItem(
        backgroundHeight: widget.backgroundHeight,
        backgroundColor: widget.backgroundAnimatingColor,
        animationController: animationController,
        unselectedChild: IconButton(
            onPressed: () => onTap(i), icon: widget.items[i].unselectedIcon),
        selectedChild: IconButton(
            onPressed: () => onTap(i), icon: widget.items[i].selectedIcon),
        activeIcon: _selected == i,
        leftOffset: leftOffSets[i],
      ));
    }
    return items;
  }

  Animation<double> _buildRowWithAnimation() {
    return TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween:
              Tween<double>(begin: 0, end: widget.animatedMaxHorizontalMargin)
                  .chain(CurveTween(curve: Curves.ease)),
          weight: 37,
        ),
        TweenSequenceItem<double>(
          tween:
              Tween<double>(begin: widget.animatedMaxHorizontalMargin, end: 0)
                  .chain(CurveTween(curve: Curves.ease)),
          weight: 63,
        ),
      ],
    ).animate(animationController);
  }
}

class NavBarItem {
  final Icon unselectedIcon;
  final Icon selectedIcon;

  NavBarItem({
    required this.selectedIcon,
    required this.unselectedIcon,
  });
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        color: Colors.blueGrey.withOpacity(0.2),
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedBotomNavigationBar(),
    );
  }
}

class AnimatedBotomNavigationBar extends StatefulWidget {
  @override
  _AnimatedBotomNavigationBarState createState() =>
      _AnimatedBotomNavigationBarState();
}

class _AnimatedBotomNavigationBarState extends State<AnimatedBotomNavigationBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _moveIconUpAnimation;
  late Animation<double> _reduceContainerWidthAnimation;
  late Animation<double> _containerIncreaseOpacityAnimation;
  late Animation<double> _scaleDownIconAnimation;
  late Animation<double> _translateIconBackToOriginAnimation;
  late Animation<double> _scaleIconBackAnimation;
  late Animation<double> _containerDecreaseOpacityAnimation;
  late Animation<double> _restoreContainerWidthAnimation;
  late Animation<double> _scaleUpContainerAnimation;
  late Animation<double> _scaleDownContainerAnimation;
  late Animation<double> _rowReduceMarginAnimation;
  late Animation<double> _rowIncreaseMarginAnimation;

  int _selected = 0;

  bool shrinking = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _moveIconUpAnimation = Tween<double>(begin: 0, end: 100).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.0,
            0.330,
            curve: Curves.easeIn,
          )),
    );

    _scaleDownIconAnimation = Tween<double>(begin: 1, end: 0.01).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.330,
            0.500,
            curve: Curves.easeIn,
          )),
    );

    _translateIconBackToOriginAnimation =
        Tween<double>(begin: 0, end: 100).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.500,
            0.510,
            curve: Curves.easeIn,
          )),
    );

    _scaleIconBackAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.510,
            0.660,
            curve: Curves.easeIn,
          )),
    );

    _reduceContainerWidthAnimation = Tween<double>(begin: 0, end: 32).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.0,
            0.375,
            curve: Curves.easeIn,
          )),
    );

    _restoreContainerWidthAnimation = Tween<double>(begin: 32, end: 0).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.375,
            0.5,
            curve: Curves.easeIn,
          )),
    );

    _containerIncreaseOpacityAnimation =
        Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.0,
            0.375,
            curve: Curves.ease,
          )),
    );

    _rowReduceMarginAnimation = Tween<double>(begin: 0, end: 24).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.0,
            0.375,
            curve: Curves.ease,
          )),
    );

    _containerDecreaseOpacityAnimation =
        Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.8,
            1,
            curve: Curves.ease,
          )),
    );

    _rowIncreaseMarginAnimation = Tween<double>(begin: 0, end: -24).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.375,
            1,
            curve: Curves.ease,
          )),
    );

    _scaleUpContainerAnimation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.5,
            0.700,
            curve: Curves.ease,
          )),
    );

    _scaleDownContainerAnimation = Tween<double>(begin: 1.2, end: 1).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.700,
            0.9,
            curve: Curves.ease,
          )),
    );

    _moveIconUpAnimation.addListener(() {
      setState(() {});
    });

    _moveIconUpAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
        shrinking = false;
      }
    });
  }

  void onPageSelected(int index) {
    print(index);

    setState(() {
      _selected = index;
      _animationController.forward();
      shrinking = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_scaleDownIconAnimation.value.toString() +
        " " +
        _scaleIconBackAnimation.value.toString());

    double horizMargin = 16.0;

    double inBetweenItems =
        ((MediaQuery.of(context).size.width - horizMargin * 2) - 48 * 5) / 4;

    var leftOffsets = [0.0, 0.0, 0.0, 0.0, 0.0];
    for (int i = 0; i < 5; i++) {
      leftOffsets[i] = horizMargin + (inBetweenItems + 48) * i;
    }

    if (shrinking) {
      // print("Cont anim color" + _containerAnimationColor.value.toString());
      // print("Cont revers anim color" +
      //     _reversecontainerAnimationColor.value.toString());

      for (int i = 0; i < _selected; i++) {
        leftOffsets[i] += _rowReduceMarginAnimation.value;
      }
      for (int i = _selected + 1; i < 5; i++) {
        leftOffsets[i] -= _rowReduceMarginAnimation.value;
      }

      if (_rowIncreaseMarginAnimation.value < 1) {
        for (int i = 0; i < _selected; i++) {
          leftOffsets[i] += _rowIncreaseMarginAnimation.value;
        }
        for (int i = _selected + 1; i < 5; i++) {
          leftOffsets[i] -= _rowIncreaseMarginAnimation.value;
        }
      }

      print(leftOffsets);
    }

    var icons = [
      NavbarItem(
        iconData: CupertinoIcons.house,
        onPressed: () => onPageSelected(0),
      ),
      NavbarItem(
          iconData: CupertinoIcons.bookmark,
          onPressed: () => onPageSelected(1)),
      NavbarItem(
        iconData: CupertinoIcons.smallcircle_circle,
        onPressed: () => onPageSelected(2),
      ),
      NavbarItem(
        iconData: CupertinoIcons.heart,
        onPressed: () => onPageSelected(3),
      ),
      NavbarItem(
        iconData: CupertinoIcons.person,
        onPressed: () => onPageSelected(4),
      ),
    ];

    var iconsFilled = [
      NavbarItem(
        iconData: CupertinoIcons.house_fill,
        onPressed: () => onPageSelected(0),
      ),
      NavbarItem(
          iconData: CupertinoIcons.bookmark_fill,
          onPressed: () => onPageSelected(1)),
      NavbarItem(
        iconData: CupertinoIcons.smallcircle_circle_fill,
        onPressed: () => onPageSelected(2),
      ),
      NavbarItem(
        iconData: CupertinoIcons.heart_fill,
        onPressed: () => onPageSelected(3),
      ),
      NavbarItem(
        iconData: CupertinoIcons.person_fill,
        onPressed: () => onPageSelected(4),
      ),
    ];

    var items = [];
    for (int i = 0; i < 5; i++) {
      items.add(Positioned(
        left: leftOffsets[i],
        bottom: 32 + (_selected == i ? _moveIconUpAnimation.value : 0),
        child: Transform.translate(
          offset: Offset(0,
              _selected == i ? _translateIconBackToOriginAnimation.value : 0),
          child: Transform.scale(
              scale: _selected == i
                  ? _scaleDownIconAnimation.value > 0.01
                      ? _scaleDownIconAnimation.value
                      : _scaleIconBackAnimation.value
                  : 1,
              child: _selected == i ? iconsFilled[i] : icons[i]),
        ),
      ));
    }

    var containerHorizPadding = [
      _reduceContainerWidthAnimation.value,
      _reduceContainerWidthAnimation.value
    ];
    if (_selected == 0) {
      containerHorizPadding[0] = 0;
    }

    if (_selected == 4) {
      containerHorizPadding[1] = 0;
    }

    if (_reduceContainerWidthAnimation.value == 32.0) {
      containerHorizPadding = [
        _restoreContainerWidthAnimation.value,
        _restoreContainerWidthAnimation.value
      ];
      if (_selected == 0) {
        containerHorizPadding[0] = 0;
      }

      if (_selected == 4) {
        containerHorizPadding[1] = 0;
      }
    }

    return Container(
      height: 200,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Transform.scale(
            scale: _scaleUpContainerAnimation.value < 1.2
                ? _scaleUpContainerAnimation.value
                : _scaleDownContainerAnimation.value,
            child: Opacity(
              opacity: _containerIncreaseOpacityAnimation.value < 1
                  ? _containerIncreaseOpacityAnimation.value
                  : _containerDecreaseOpacityAnimation.value,
              child: Container(
                height: 98,
                margin: EdgeInsets.only(
                    left: containerHorizPadding[0],
                    right: containerHorizPadding[1]),
                decoration: BoxDecoration(
                    color: Color(0xffA7B2E4),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24))),
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }
}

class NavbarItem extends StatelessWidget {
  final IconData iconData;

  final Function onPressed;

  const NavbarItem({
    Key? key,
    required this.iconData,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 48,
        height: 48,
        child: IconButton(
          onPressed: () => onPressed(),
          icon: Icon(iconData),
        ));
  }
}

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
  late Animation _animation;
  late Animation _animation2;
  late Animation _animation3;

  int _selected = 0;
  bool _reappearing = false;
  bool _shrinking = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _animation = Tween<double>(begin: 0, end: 100).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.0,
            0.4,
            curve: Curves.easeIn,
          )),
    );

    _animation.addListener(() {
      setState(() {});
    });

    _animation2 = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.4,
            0.6,
            curve: Curves.easeIn,
          )),
    );

    _animation2.addListener(() {
      setState(() {});
    });

    _animation3 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.6,
            1,
            curve: Curves.easeIn,
          )),
    );

    _animation3.addListener(() {
      setState(() {});
    });

    _animation3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _reappearing = false;
          _animationController.reset();
        });
      }
    });
  }

  void onPageSelected(int index) {
    print(index);

    setState(() {
      _selected = index;
      _animationController.forward();
      _shrinking = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double horizontalMargin = 16.0;
    double iconWidth = 48.0;
    double spacing =
        ((MediaQuery.of(context).size.width - horizontalMargin * 2) -
                iconWidth * 5) /
            4;

    print(_animation.value.toString() +
        " " +
        _animation2.value.toString() +
        " " +
        _animation3.value.toString());

    if (_animation2.value == 0 && _reappearing == false) {
      setState(() {
        print("reappring");
        _reappearing = true;
      });
    }

    var leftOffsets = [0.0, 0.0, 0.0, 0.0, 0.0];
    for (int i = 0; i < 5; i++) {
      leftOffsets[i] = horizontalMargin + (iconWidth + spacing) * i;
    }

    if (_shrinking) {
      for (int i = 0; i < _selected; i++) {
        leftOffsets[i] += _animation.value / 5;
      }
      for (int i = _selected + 1; i < 5; i++) {
        leftOffsets[i] -= _animation.value / 5;
      }
    }

    var bottomOffsets = [0.0, 0.0, 0.0, 0.0, 0.0];
    for (int i = 0; i < 5; i++) {
      bottomOffsets[i] = _selected == i
          ? _reappearing
              ? 0
              : _animation.value
          : 0;
    }

    var scales = [0.0, 0.0, 0.0, 0.0, 0.0];
    for (int i = 0; i < 5; i++) {
      scales[i] = _selected == i
          ? _reappearing
              ? _animation3.value
              : _animation2.value
          : 1;
    }

    if (_shrinking) {
      horizontalMargin += _animation.value / 5;
    }

    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          NavbarItem(
            iconData: CupertinoIcons.home,
            left: leftOffsets[0],
            bottomOffset: bottomOffsets[0],
            scale: scales[0],
            onPressed: () => onPageSelected(0),
          ),
          NavbarItem(
            iconData: CupertinoIcons.bookmark,
            left: leftOffsets[1],
            bottomOffset: bottomOffsets[1],
            scale: scales[1],
            onPressed: () => onPageSelected(1),
          ),
          NavbarItem(
            iconData: CupertinoIcons.smallcircle_circle,
            left: leftOffsets[2],
            bottomOffset: bottomOffsets[2],
            scale: scales[2],
            onPressed: () => onPageSelected(2),
          ),
          NavbarItem(
            iconData: CupertinoIcons.heart,
            left: leftOffsets[3],
            bottomOffset: bottomOffsets[3],
            scale: scales[3],
            onPressed: () => onPageSelected(3),
          ),
          NavbarItem(
            iconData: CupertinoIcons.person,
            left: leftOffsets[4],
            bottomOffset: bottomOffsets[4],
            scale: scales[4],
            onPressed: () => onPageSelected(4),
          ),
        ],
      ),
    );
  }
}

class NavbarItem extends StatelessWidget {
  final IconData iconData;

  final Function onPressed;

  final double bottomOffset;

  final double scale;

  final double left;

  const NavbarItem(
      {Key? key,
      required this.iconData,
      required this.onPressed,
      required this.left,
      this.scale = 1,
      this.bottomOffset = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      bottom: 32 + bottomOffset,
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: 48,
          height: 48,
          child: IconButton(
            onPressed: () => onPressed(),
            icon: Icon(iconData),
          ),
        ),
      ),
    );
  }
}

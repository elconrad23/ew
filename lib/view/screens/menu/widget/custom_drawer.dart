import 'dart:math' show pi;
import 'package:enviroewatch/provider/localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class CustomDrawerController {
  late Function open;
  late Function close;
  late Function toggle;
  late Function isOpen;
  late ValueNotifier<DrawerState> stateNotifier;
}

class CustomDrawer extends StatefulWidget {
  CustomDrawer({
    required this.controller,
    required this.mainScreen,
    this.slideWidth = 275.0,
    this.borderRadius = 16.0,
    this.angle = -12.0,
    this.backgroundColor = Colors.white,
    this.showShadow = false,
    required this.openCurve,
    required this.closeCurve,
  }) : assert(angle <= 0.0 && angle >= -30.0);

  final CustomDrawerController controller;
  final Widget mainScreen;
  final double slideWidth;
  final double borderRadius;
  final double angle;
  final Color backgroundColor;
  final bool showShadow;
  final Curve openCurve;
  final Curve closeCurve;

  @override
  _CustomDrawerState createState() => new _CustomDrawerState();

  /// static function to provide the drawer state
  static State<CustomDrawer>? of(BuildContext context) {
    return context.findAncestorStateOfType<State<CustomDrawer>>();
  }

  /// Static function to determine the device text direction RTL/LTR
  ///
  /// 
  static bool isRTL(BuildContext context) {
    return !Provider.of<LocalizationProvider>(context, listen: false).isLtr;
  }
}

class _CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  final Curve _scaleDownCurve = Interval(0.0, 0.3, curve: Curves.easeOut);
  final Curve _scaleUpCurve = Interval(0.0, 1.0, curve: Curves.easeOut);
// Curves.bounceOut

  /// check the slide direction


  late AnimationController _animationController;
  DrawerState _state = DrawerState.closed;

  double get _percentOpen => _animationController.value;

  open() {
    _animationController.forward();
  }

  close() {
    _animationController.reverse();
  }

  toggle() {
    if (_state == DrawerState.open) {
      close();
    } else if (_state == DrawerState.closed) {
      open();
    }
  }

  bool isOpen() =>
      _state == DrawerState.open  /*|| _state == DrawerState.opening*/;

  /// Drawer state
  late ValueNotifier<DrawerState> stateNotifier;

  @override
  void initState() {
    super.initState();

    stateNotifier = ValueNotifier(_state);

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            _state = DrawerState.opening;
            _updateStatusNotifier();
            break;
          case AnimationStatus.reverse:
            _state = DrawerState.closing;
            _updateStatusNotifier();
            break;
          case AnimationStatus.completed:
            _state = DrawerState.open;
            _updateStatusNotifier();
            break;
          case AnimationStatus.dismissed:
            _state = DrawerState.closed;
            _updateStatusNotifier();
            break;
        }
      });

    /// assign controller function to the widget methods
    widget.controller.open = open;
    widget.controller.close = close;
    widget.controller.toggle = toggle;
    widget.controller.isOpen = isOpen;
    widget.controller.stateNotifier = stateNotifier;
    }

  _updateStatusNotifier() {
    stateNotifier.value = _state;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _zoomAndSlideContent(Widget container,BuildContext context,
      {required double angle, required double scale, double slide = 0}) {
    var slidePercent, scalePercent;

    /// determine current slide percent based on the MenuStatus
    switch (_state) {
      case DrawerState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case DrawerState.open:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;
      case DrawerState.opening:
        slidePercent =
            (widget.openCurve).transform(_percentOpen);
        scalePercent = _scaleDownCurve.transform(_percentOpen);
        break;
      case DrawerState.closing:
        slidePercent =
            (widget.closeCurve).transform(_percentOpen);
        scalePercent = _scaleUpCurve.transform(_percentOpen);
        break;
    }

    final int _rtlSlide = CustomDrawer.isRTL(context) ? -1 : 1;

    final slideAmount = (widget.slideWidth - slide) * slidePercent * _rtlSlide;
    final contentScale = (scale) - (0.4 * scalePercent);
    final cornerRadius = widget.borderRadius * _percentOpen;
    final rotationAngle =
        (((angle) * pi * _rtlSlide) / 180) * _percentOpen;

    return Transform(
      transform: Matrix4.translationValues(slideAmount, 0, 0)
        ..rotateZ(rotationAngle)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cornerRadius),
        child: container,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final slidePercent =
    CustomDrawer.isRTL(context) ? MediaQuery.of(context).size.width * .1 : 15.0;

    return Stack(
      children: [
     
        if (widget.showShadow) ...[
          /// Displaying the first shadow
          AnimatedBuilder(
            animation: _animationController,
            builder: (_, w) => _zoomAndSlideContent(w!,context,
                angle: (widget.angle == 0.0) ? 0.0 : widget.angle - 8,
                scale: .9,
                slide: slidePercent * 2),
            child: Container(
              color: widget.backgroundColor.withAlpha(31),
            ),
          ),

          /// Displaying the second shadow
          AnimatedBuilder(
            animation: _animationController,
            builder: (_, w) => _zoomAndSlideContent(w!,context,
                angle: (widget.angle == 0.0) ? 0.0 : widget.angle - 4.0,
                scale: .95,
                slide: slidePercent),
            child: Container(
              color: widget.backgroundColor,
            ),
          )
        ],

        /// Displaying the main screen
        AnimatedBuilder(
          animation: _animationController,
          builder: (_, w) => _zoomAndSlideContent(w!, context, angle: 0.0, scale: .95),
          child: widget.mainScreen,
        ),
      ],
    );
  }
}

/// Drawer State enum
enum DrawerState { opening, closing, open, closed }

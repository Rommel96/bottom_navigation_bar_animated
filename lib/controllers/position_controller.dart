import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import 'dart:math' as math;

class BoxPositionController extends ValueNotifier<BoxPositionState> {
  Curve defaultAnimationCurve = Curves.easeInOutQuart;
  Duration defaultAnimationDuration;
  // TODO remove vsync from here
  TickerProvider vsync;

  AnimationController _animationController;
  Animation<double> _positionAnimation;

  BoxPositionController({int initPosition})
      : super(BoxPositionState(lastPosition: initPosition));

  BoxPositionController.fromValue(BoxPositionState value)
      : super(value ?? BoxPositionState.init);

  void animateToPosition(int position, {Curve curve, Duration duration}) {
    _animationController = AnimationController(
      vsync: vsync,
      duration: duration ?? defaultAnimationDuration,
    );

    _positionAnimation =
        Tween(begin: lastPosition.toDouble(), end: position.toDouble()).animate(
            CurvedAnimation(
                parent: _animationController,
                curve: curve ?? defaultAnimationCurve));

    _positionAnimation.addListener(() {
      absolutePosition = _positionAnimation.value;
    });

    targetPosition = position;
    _animationController.forward();
  }

  double get absolutePosition => value.absolutePosition;

  set absolutePosition(double newAbsolutePosition) {
    value = value.copyWith(absolutePosition: newAbsolutePosition);
  }

  int get lastPosition => value.lastPosition;

  set lastPosition(int newLastStablePosition) {
    value = value.copyWith(lastPosition: newLastStablePosition);
  }

  int get targetPosition => value.targetPosition;

  set targetPosition(int newTargetStablePosition) {
    value = value.copyWith(targetPosition: newTargetStablePosition ?? -1);
  }

  void findNearestTarget(double newAbsolutePosition) {
    double delta = newAbsolutePosition - value.lastPosition;
    int positionDelta = 0;
    if (delta < 0) positionDelta = -1;
    if (delta > 0) positionDelta = 1;
    value = value.copyWith(targetPosition: value.lastPosition + positionDelta);
  }

  double get movementDelta =>
      (value.targetPosition - value.lastPosition).toDouble();

  double get progressToTargetPosition =>
      (value.absolutePosition - value.lastPosition) / movementDelta;

  double itemSelectedProgress(int index) {
    if (selectionNotGoingAnywhere) {
      return value.lastPosition == index ? 1.0 : 0.0;
    }

    if (index == value.targetPosition) {
      return math.min(1, math.max(0, progressToTargetPosition));
    } else if (index == value.lastPosition) {
      return math.max(0, math.min(1, 1 - progressToTargetPosition));
    }
    return 0;
  }

  bool get selectionNotGoingAnywhere {
    return value.targetPosition == null ||
        value.targetPosition == value.lastPosition;
  }

  void clear() {
    value = BoxPositionState.init;
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }
}

class BoxPositionState {
  final double absolutePosition;
  final int lastPosition;
  final int targetPosition;

  BoxPositionState(
      {this.absolutePosition = 0,
      this.lastPosition = 0,
      this.targetPosition = 0})
      : assert(absolutePosition != null),
        assert(lastPosition != null);

  BoxPositionState copyWith(
      {double absolutePosition, int lastPosition, int targetPosition}) {
    return BoxPositionState(
      absolutePosition: absolutePosition ?? this.absolutePosition,
      lastPosition: lastPosition ?? this.lastPosition,
      targetPosition: targetPosition != null
          ? (targetPosition == -1 ? null : targetPosition)
          : this.targetPosition,
    );
  }

  static BoxPositionState init = BoxPositionState();
}

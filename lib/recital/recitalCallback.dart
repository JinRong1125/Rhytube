import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart';

import 'package:rhytube/model/Movement.dart';
import 'package:rhytube/recital/recital.dart';
import 'package:rhytube/recital/lighterTap.dart';
import 'package:rhytube/statics.dart';

class RecitalCallback implements PauseWidgetCallback, TraceWidgetCallback, RenderTraceCallback, LighterCallback {

  Recital recital;

  RecitalCallback(this.recital);

  @override
  bool getPaused() {
    return recital.paused;
  }

  Movement getMovement() {
    return recital.movement;
  }

  @override
  onPause() {
    recital.pause();
  }

  @override
  onResume() {
    recital.delayResume();
  }

  @override
  onStop() {
    recital.musicPlayer.release();
  }

  @override
  onUpdate(double deltaTime) {
    recital.update(deltaTime);
  }

  @override
  onPaint(Canvas canvas) {
    recital.render(canvas);
  }

  @override
  double getTime() {
    return recital.time;
  }

  @override
  double getDeltaTime() {
    return recital.deltaTime;
  }

  @override
  double getNoteRenderTime() {
    return recital.noteRenderTime;
  }

  @override
  double getTieRenderTime() {
    return recital.tieRenderTime;
  }

  @override
  double getSpeed() {
    return recital.speed;
  }

  @override
  Path getLinePath() {
    return recital.linePath;
  }

  @override
  Path getNotePath() {
    return recital.notePath;
  }

  @override
  Path getTiePath() {
    return recital.tiePath;
  }

  @override
  Path getLeftSlurPath() {
    return recital.leftSlurPath;
  }

  @override
  Path getRightSlurPath() {
    return recital.rightSlurPath;
  }

  @override
  onLeftTraceTapped(double lighterPoint, double time) {
    recital.playSound();
    recital.lighterTapSet.add(LighterTap(this, Offset(Constant.leftCenterPoint, lighterPoint), recital.measureColor(time)));
    recital.scoreRenderBox.addLeftDyne();
  }

  @override
  onRightTraceTapped(double lighterPoint, double time) {
    recital.playSound();
    recital.lighterTapSet.add(LighterTap(this, Offset(Constant.rightCenterPoint, lighterPoint), recital.measureColor(time)));
    recital.scoreRenderBox.addRightDyne();
  }

  @override
  onTappedPlaySound() {
    recital.playSound();
  }

  @override
  onLeftDyneAdd() {
    recital.scoreRenderBox.addLeftDyne();
  }

  @override
  onRightDyneAdd() {
    recital.scoreRenderBox.addRightDyne();
  }

  @override
  onLeftTraceHold(Offset offset) {
    recital.lighterHold.leftOffset = offset;
  }

  @override
  onRightTraceHold(Offset offset) {
    recital.lighterHold.rightOffset = offset;
  }

  @override
  onLeftDyneMinus() {
    recital.scoreRenderBox.minusLeftDyne();
  }

  @override
  onRightDyneMinus() {
    recital.scoreRenderBox.minusRightDyne();
  }

  @override
  onEnd(LighterTap lighterTap) {
    recital.lighterTapSet.remove(lighterTap);
  }
}

abstract class PauseWidgetCallback {

  bool getPaused();
  Movement getMovement();

  onPause();
  onResume();
  onStop();
}

abstract class TraceWidgetCallback {
  onUpdate(double deltaTime);
  onPaint(Canvas canvas);
}

abstract class RenderTraceCallback {

  double getTime();
  double getDeltaTime();
  double getNoteRenderTime();
  double getTieRenderTime();
  double getSpeed();
  Path getLinePath();
  Path getNotePath();
  Path getTiePath();
  Path getLeftSlurPath();
  Path getRightSlurPath();

  onLeftTraceTapped(double lighterPoint, double time);
  onRightTraceTapped(double lighterPoint, double time);
  onLeftTraceHold(Offset offset);
  onRightTraceHold(Offset offset);

  onTappedPlaySound();
  onLeftDyneAdd();
  onRightDyneAdd();
  onLeftDyneMinus();
  onRightDyneMinus();
}

abstract class LighterCallback {
  onEnd(LighterTap lighterTap);
}
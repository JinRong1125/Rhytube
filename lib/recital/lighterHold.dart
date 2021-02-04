
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:rhytube/statics.dart';

class LighterHold {

  Offset leftOffset, rightOffset;

  double radius;
  bool zoom, lightLeft, lightRight;

  LighterHold() {
    radius = Constant.holdStartRadius;
    zoom = false;
    lightLeft = false;
    lightRight = false;
  }

  render(Canvas canvas, double updateDistance) {
    if (leftOffset != null || rightOffset != null) {
      if (!zoom) {
        radius += updateDistance;
        if (radius >= Constant.holdEndRadius)
          zoom = true;
      }
      else {
        radius -= updateDistance;
        if (radius <= Constant.holdStartRadius)
          zoom = false;
      }

      if (leftOffset != null)
        draw(canvas, leftOffset);
      if (rightOffset != null)
        draw(canvas, rightOffset);
    }
  }

  draw(Canvas canvas, Offset offset) {
    canvas.drawCircle(offset, radius,
        Paint()..shader = Constant.lighterRadialGradient.createShader(Rect.fromCircle(center: offset, radius: radius)));
  }
}
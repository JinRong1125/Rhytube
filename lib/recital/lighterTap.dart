
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:rhytube/statics.dart';
import 'package:rhytube/recital/recitalCallback.dart';

class LighterTap {

  LighterCallback lighterCallback;
  Offset offset;
  Color color;
  double radius, opacity;
  Paint paint;

  LighterTap(this.lighterCallback, this.offset, this.color) {
    opacity = 1;
    radius = Constant.tapStartRadius;
    paint = Paint();
  }

  render(Canvas canvas, double updateRatio, double updateDistance) {
    opacity -= updateRatio;
    if (opacity >= 0) {
      radius += updateDistance;
      paint.shader = RadialGradient(colors: [
        color.withOpacity(opacity),
        color.withOpacity(0)
      ]).createShader(Rect.fromCircle(center: this.offset, radius: radius));
      canvas.drawCircle(offset, radius, paint);
    }
    else
      lighterCallback.onEnd(this);
  }
}
import 'dart:ui';

import 'package:flutter/material.dart';
import 'statics.dart';

class Flicker {

  Paint paint;
  RadialGradient radialGradient;

  Offset offset;
  double radius, speed;
  bool zoomed;

  Flicker(this.offset) {
    offset = Offset(Constant.windowWidth / 2, Constant.windowHeight / 2);
    radius = 0;
    speed = 500;
    zoomed = false;

    radialGradient = new RadialGradient(
      colors: [
        Colors.white,
        Colors.transparent
      ],
      stops: [0.1, 1],
    );
  }

  update(double deltaTime) {
    if (!zoomed) {
      radius += deltaTime * speed;
      if (radius >= 50)
        zoomed = true;
    }
    else {
      radius -= deltaTime * speed;
      if (radius < 0)
        zoomed = false;
    }
  }

  render(Canvas canvas) {
    paint = new Paint()
      ..style = PaintingStyle.fill
      ..shader = radialGradient.createShader(Rect.fromCircle(center: offset, radius: radius));
    canvas.drawCircle(offset, radius, paint);
  }
}
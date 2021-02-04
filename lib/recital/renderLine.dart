import 'package:rhytube/recital/recitalCallback.dart';
import 'package:rhytube/recital/renderTrace.dart';
import 'package:rhytube/statics.dart';

class RenderLine extends RenderTrace {

  RenderTraceCallback renderTraceCallback;
  double leftX, rightX, bottomY, topY;
  bool started;

  RenderLine(this.renderTraceCallback, double time) : super(time, time) {
    started = false;
  }

  @override
  update(double updateLength, double updateRatio, double outUpdateLength, double inUpdateLength) {
    if (leftX < 0 || rightX > Constant.windowWidth)
      started = false;
    else {
      leftX -= updateLength;
      rightX += updateLength;
      bottomY += outUpdateLength;
      topY -= outUpdateLength;
    }
  }

  initialize() {
    time += 0.256;
    started = true;
    leftX = Constant.centerWidth;
    rightX = Constant.centerWidth;
    bottomY = Constant.centerFirstPoint;
    topY = Constant.centerFifthPoint;
  }

  @override
  render() {
    renderTraceCallback.getLinePath()
      ..moveTo(leftX, bottomY)
      ..lineTo(leftX, topY)
      ..moveTo(rightX, bottomY)
      ..lineTo(rightX, topY);
  }

  @override
  bool passed() {
    return false;
  }

  @override
  tapDown(Number number, double dy) {}

  @override
  tapMove(Number number, double dy) {}

  @override
  tapUp(Number number, double dy) {}
}

import 'package:rhytube/statics.dart';

abstract class RenderTrace {

  double time, startTime, endTime, validStartTime, validEndTime, lighterPoint;
  bool destroyed = false;

  RenderTrace(this.startTime, this.endTime);

  bool passed();
  update(double updateLength, double updateRatio, double outUpdateLength, double inUpdateLength);
  render();

  tapDown(Number number, double dy);
  tapUp(Number number, double dy);
  tapMove(Number number, double dy);
}

class CompleteTrace extends RenderTrace {

  CompleteTrace(double time) : super(time, time) {
    this.time = time;
    validStartTime = time;
    validEndTime = time;
  }

  @override
  bool passed() {
    return false;
  }

  @override
  render() {}

  @override
  tapDown(Number number, double dy) {}

  @override
  tapMove(Number number, double dy) {}

  @override
  tapUp(Number number, double dy) {}

  @override
  update(double updateLength, double updateRatio, double outUpdateLength, double inUpdateLength) {}
}
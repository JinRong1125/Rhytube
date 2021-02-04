import 'dart:ui';

import 'package:rhytube/recital/renderTrace.dart';
import 'package:rhytube/statics.dart';
import 'package:rhytube/recital/recitalCallback.dart';

class RenderNote extends RenderTrace {

  RenderTraceCallback renderTraceCallback;
  Number number;
  double startBottom, startTop, endBottom, endTop, startX, endX;

  double bottomDistance, topDistance;

  RenderNote(this.renderTraceCallback, double time, this.number)
      : super(time, time) {
    startTime += Constant.startPlayTime;
    validStartTime = startTime - Constant.purpleRangeTime;
    validEndTime = startTime + Constant.purpleRangeTime;
    this.time = startTime - renderTraceCallback.getNoteRenderTime();
  }

  initialize() {
    startBottom = startTop - Constant.centerNoteWidth;
    endBottom = startBottom;
    endTop = startTop;
    startX = Constant.centerWidth;
    endX = Constant.centerWidth;
  }

  @override
  update(double updateLength, double updateRatio, double outUpdateLength, double inUpdateLength) {
  }

  @override
  render() {}

  draw(Path path) {
    List<Offset> offsetList = List()
      ..add(Offset(startX, startBottom))
      ..add(Offset(startX, startTop))
      ..add(Offset(endX, endTop))
      ..add(Offset(endX, endBottom));

    path.addPolygon(offsetList, true);
  }

  @override
  bool passed() {
    return false;
  }

  @override
  tapDown(Number number, double dy) {
    tap(number);
  }

  @override
  tapUp(Number number, double dy) {}

  @override
  tapMove(Number number, double dy) {}

  tap(Number number) {}
}

class LeftNote extends RenderNote {

  LeftNote(RenderTraceCallback renderTraceCallback, double time, Number number)
      : super(renderTraceCallback, time, number);

  @override
  update(double updateLength, double updateRatio, double outUpdateLength, double inUpdateLength) {
    endX -= updateLength;
    double distance = (endX - Constant.centerWidth).abs();
    if (distance > Constant.noteHeight) {
      startX = endX + Constant.noteHeight;
      startBottom = endBottom + bottomDistance;
      startTop = endTop + topDistance;
    }
  }

  @override
  render() {
    draw(renderTraceCallback.getNotePath());

//    if (renderTraceCallback.getTime() >= endTime) {
//      destroyed = true;
//      renderTraceCallback.onTappedPlaySound();
//      renderTraceCallback.onLeftDyneAdd();
//      return;
//    }
  }

  @override
  bool passed() {
    return startX <= 0;
  }

  @override
  tap(Number number) {
    if (this.number == number) {
      destroyed = true;
      renderTraceCallback.onLeftTraceTapped(lighterPoint, startTime);
    }
  }
}

class RightNote extends RenderNote {

  RightNote(RenderTraceCallback renderTraceCallback, double time, Number number)
      : super(renderTraceCallback, time, number);

  @override
  update(double updateLength, double updateRatio, double outUpdateLength, double inUpdateLength) {
    endX += updateLength;
    double distance = (endX - Constant.centerWidth).abs();
    if (distance > Constant.noteHeight) {
      startX = endX - Constant.noteHeight;
      startBottom = endBottom + bottomDistance;
      startTop = endTop + topDistance;
    }
  }

  @override
  render() {
    draw(renderTraceCallback.getNotePath());

//    if (renderTraceCallback.getTime() >= endTime) {
//      destroyed = true;
//      renderTraceCallback.onTappedPlaySound();
//      renderTraceCallback.onRightDyneAdd();
//      return;
//    }
  }

  @override
  bool passed() {
    return startX >= Constant.windowWidth;
  }

  @override
  tap(Number number) {
    if (this.number == number) {
      destroyed = true;
      renderTraceCallback.onRightTraceTapped(lighterPoint, startTime);
    }
  }
}

class FirstLeftNote extends LeftNote {

  FirstLeftNote(RenderTraceCallback renderTraceCallback, double time, Number number)
      : super(renderTraceCallback, time, number) {
    lighterPoint = Constant.lighterFirstPoint;
    startTop = Constant.centerFirstPoint;
    bottomDistance = -Constant.noteInDistance;
    topDistance = -Constant.noteOutDistance;
    initialize();
  }

  @override
  update(double updateLength, double updateRatio, double outUpdateLength, double inUpdateLength) {
    endBottom += inUpdateLength;
    endTop += outUpdateLength;
    super.update(updateLength, updateRatio, outUpdateLength, inUpdateLength);
  }
}

class FirstRightNote extends RightNote {

  FirstRightNote(RenderTraceCallback renderTraceCallback, double time, Number number)
      : super(renderTraceCallback, time, number) {
    lighterPoint = Constant.lighterFirstPoint;
    startTop = Constant.centerFirstPoint;
    bottomDistance = -Constant.noteInDistance;
    topDistance = -Constant.noteOutDistance;
    initialize();
  }

  @override
  update(double updateLength, double updateRatio, double outUpdateLength, double inUpdateLength) {
    endBottom += inUpdateLength;
    endTop += outUpdateLength;
    super.update(updateLength, updateRatio, outUpdateLength, inUpdateLength);
  }
}

class SecondLeftNote extends LeftNote {

  SecondLeftNote(RenderTraceCallback renderTraceCallback, double time, Number number)
      : super(renderTraceCallback, time, number) {
    lighterPoint = Constant.lighterSecondPoint;
    startTop = Constant.centerSecondPoint;
    bottomDistance = 0;
    topDistance = -Constant.noteInDistance;
    initialize();
  }

  @override
  update(double updateLength, double updateRatio, double outUpdateLength, double inUpdateLength) {
    endTop += inUpdateLength;
    super.update(updateLength, updateRatio, outUpdateLength, inUpdateLength);
  }
}

class SecondRightNote extends RightNote {

  SecondRightNote(RenderTraceCallback renderTraceCallback, double time, Number number)
      : super(renderTraceCallback, time, number) {
    lighterPoint = Constant.lighterSecondPoint;
    startTop = Constant.centerSecondPoint;
    bottomDistance = 0;
    topDistance = -Constant.noteInDistance;
    initialize();
  }

  @override
  update(double updateLength, double updateRatio, double outUpdateLength, double inUpdateLength) {
    endTop += inUpdateLength;
    super.update(updateLength, updateRatio, outUpdateLength, inUpdateLength);
  }
}

class ThirdLeftNote extends LeftNote {

  ThirdLeftNote(RenderTraceCallback renderTraceCallback, double time, Number number)
      : super(renderTraceCallback, time, number) {
    lighterPoint = Constant.lighterThirdPoint;
    startTop = Constant.centerThirdPoint;
    bottomDistance = Constant.noteInDistance;
    topDistance = 0;
    initialize();
  }

  @override
  update(double updateLength, double updateRatio, double outUpdateLength, double inUpdateLength) {
    endBottom -= inUpdateLength;
    super.update(updateLength, updateRatio, outUpdateLength, inUpdateLength);
  }
}

class ThirdRightNote extends RightNote {

  ThirdRightNote(RenderTraceCallback renderTraceCallback, double time, Number number)
      : super(renderTraceCallback, time, number) {
    lighterPoint = Constant.lighterThirdPoint;
    startTop = Constant.centerThirdPoint;
    bottomDistance = Constant.noteInDistance;
    topDistance = 0;
    initialize();
  }

  @override
  update(double updateLength, double updateRatio, double outUpdateLength, double inUpdateLength) {
    endBottom -= inUpdateLength;
    super.update(updateLength, updateRatio, outUpdateLength, inUpdateLength);
  }
}

class ForthLeftNote extends LeftNote {

  ForthLeftNote(RenderTraceCallback renderTraceCallback, double time, Number number)
      : super(renderTraceCallback, time, number) {
    lighterPoint = Constant.lighterForthPoint;
    startTop = Constant.centerForthPoint;
    bottomDistance = Constant.noteOutDistance;
    topDistance = Constant.noteInDistance;
    initialize();
  }

  @override
  update(double updateLength, double updateRatio, double outUpdateLength, double inUpdateLength) {
    endBottom -= outUpdateLength;
    endTop -= inUpdateLength;
    super.update(updateLength, updateRatio, outUpdateLength, inUpdateLength);
  }
}

class ForthRightNote extends RightNote {

  ForthRightNote(RenderTraceCallback renderTraceCallback, double time, Number number)
      : super(renderTraceCallback, time, number) {
    lighterPoint = Constant.lighterForthPoint;
    startTop = Constant.centerForthPoint;
    bottomDistance = Constant.noteOutDistance;
    topDistance = Constant.noteInDistance;
    initialize();
  }

  @override
  update(double updateLength, double updateRatio, double outUpdateLength, double inUpdateLength) {
    endBottom -= outUpdateLength;
    endTop -= inUpdateLength;
    super.update(updateLength, updateRatio, outUpdateLength, inUpdateLength);
  }
}








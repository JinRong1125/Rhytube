import 'dart:ui';

import 'package:rhytube/recital/recitalCallback.dart';
import 'package:rhytube/recital/renderTrace.dart';
import 'package:rhytube/statics.dart';

class RenderTie extends RenderTrace {

  RenderTraceCallback renderTraceCallback;
  Number number;

  double validTapTime, dyneTime, centerPoint, startBottomPoint, startTopPoint, endBottomPoint, endTopPoint,
      startBottom, startTop, endBottom, endTop, startX, endX, bottomDistance, topDistance,
      distanceX, length;
  bool tapping, tapped, reduced;

  RenderTie(this.renderTraceCallback, double startTime, double endTime, this.number)
      : super(startTime, endTime) {
    length = (this.endTime - this.startTime) * renderTraceCallback.getSpeed();
    this.startTime += Constant.startPlayTime;
    validStartTime = this.startTime - Constant.purpleRangeTime;
    validTapTime = this.startTime + Constant.purpleRangeTime;
    this.time = this.startTime - renderTraceCallback.getTieRenderTime();
    this.endTime += Constant.startPlayTime;
    validEndTime = this.endTime + Constant.purpleRangeTime;
  }

  initialize() {
    dyneTime = 0;
    startBottomPoint = startTopPoint - Constant.centerNoteWidth;
    endBottomPoint = endTopPoint - Constant.noteWidth;
    startBottom = startBottomPoint;
    startTop = startTopPoint;
    endBottom = startBottom;
    endTop = startTop;
    startX = Constant.centerWidth;
    endX = Constant.centerWidth;
    distanceX = Constant.centerWidth;
    tapping = false;
    tapped = false;
    reduced = false;
  }

  @override
  update(double updateLength, double updateRatio, double outUpdateLength, double inUpdateLength) {}

  updateStartY(double outUpdateLength, double inUpdateLength) {}

  updateEndY(double outUpdateLength, double inUpdateLength) {}

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
    if (this.number == number && !tapping) {
      validTap();
      hold();
      dyneTime = 0;
      tapping = true;
    }
  }

  @override
  tapUp(Number number, double dy) {
    if (this.number == number && tapping) {
      unhold();
      dyneTime = 0;
      tapping = false;
    }
  }

  @override
  tapMove(Number number, double dy) {
    if (this.number != number && tapping) {
      unhold();
      dyneTime = 0;
      tapping = false;
    }
  }
  
  validTap() {}

  hold() {}

  unhold() {}
}


class LeftTie extends RenderTie {

  LeftTie(RenderTraceCallback renderTraceCallback, double time, double endTime, Number number)
      : super(renderTraceCallback, time, endTime, number) {
    centerPoint = Constant.leftCenterPoint;
  }

  @override
  update(double updateLength, double updateRatio, double outUpdateLength, double inUpdateLength) {
    super.update(updateLength, updateRatio, outUpdateLength, inUpdateLength);

    distanceX -= updateLength;
    endX -= updateLength;
    if (reduced) {
      startX -= updateLength;
      updateStartY(outUpdateLength, inUpdateLength);
    }
    else {
      double distance = (distanceX - Constant.centerWidth).abs();
      if (distance > length) {
        updateLength = distance - length;
        startX = Constant.centerWidth - updateLength;
        updateRatio = updateLength / Constant.tieMoveDistance;
        startBottom = startBottomPoint + bottomDistance * updateRatio;
        startTop = startTopPoint + topDistance * updateRatio;
        reduced = true;
      }
    }
    updateEndY(outUpdateLength, inUpdateLength);
  }

  @override
  render() {
//    if (!tapping && renderTraceCallback.getTime() >= time + renderTraceCallback.getTieRenderTime()) {
//      tapping = true;
//      renderTraceCallback.onTappedPlaySound();
//      renderTraceCallback.onLeftDyneAdd();
//    }

    Path path = renderTraceCallback.getTiePath();
    if (tapping) {
      if (renderTraceCallback.getTime() < endTime) {
        endX = centerPoint;
        endBottom = endBottomPoint;
        endTop = endTopPoint;
        draw(path);

        dyneTime += renderTraceCallback.getDeltaTime();
        if (dyneTime >= Constant.dyneBaseTime) {
          renderTraceCallback.onLeftDyneAdd();
          dyneTime -= Constant.dyneBaseTime;
        }
      }
      else {
        destroyed = true;
        renderTraceCallback.onLeftTraceTapped(lighterPoint, endTime);
        unhold();
      }
    }
    else {
      draw(path);

      if (renderTraceCallback.getTime() >= validTapTime && renderTraceCallback.getTime() <= endTime) {
        dyneTime += renderTraceCallback.getDeltaTime();
        if (dyneTime >= Constant.dyneBaseTime) {
          renderTraceCallback.onLeftDyneMinus();
          dyneTime -= Constant.dyneBaseTime;
        }
      }
    }
  }

  @override
  bool passed() {
    return startX <= 0;
  }

  @override
  validTap() {
    if (!tapped && renderTraceCallback.getTime() <= validTapTime) {
      tapped = true;
      renderTraceCallback.onLeftTraceTapped(lighterPoint, startTime);
    }
  }

  @override
  hold() {
    renderTraceCallback.onLeftTraceHold(Offset(Constant.leftCenterPoint, lighterPoint));
  }

  @override
  unhold() {
    renderTraceCallback.onLeftTraceHold(null);
  }
}

class RightTie extends RenderTie {

  RightTie(RenderTraceCallback renderTraceCallback, double time, double endTime, Number number)
      : super(renderTraceCallback, time, endTime, number) {
    centerPoint = Constant.rightCenterPoint;
  }

  @override
  update(double updateLength, double updateRatio, double outUpdateLength, double inUpdateLength) {
    super.update(updateLength, updateRatio, outUpdateLength, inUpdateLength);

    distanceX += updateLength;
    endX += updateLength;
    if (reduced) {
      startX += updateLength;
      updateStartY(outUpdateLength, inUpdateLength);
    }
    else {
      double distance = (distanceX - Constant.centerWidth).abs();
      if (distance > length) {
        updateLength = distance - length;
        startX = Constant.centerWidth + updateLength;
        updateRatio = updateLength / Constant.tieMoveDistance;
        startBottom = startBottomPoint + bottomDistance * updateRatio;
        startTop = startTopPoint + topDistance * updateRatio;
        reduced = true;
      }
    }
    updateEndY(outUpdateLength, inUpdateLength);
  }

  @override
  render() {
//    if (!tapping && renderTraceCallback.getTime() >= time + renderTraceCallback.getTieRenderTime()) {
//      tapping = true;
//      renderTraceCallback.onTappedPlaySound();
//      renderTraceCallback.onRightDyneAdd();
//    }

    Path path = renderTraceCallback.getTiePath();
    if (tapping) {
      if (renderTraceCallback.getTime() < endTime) {
        endX = centerPoint;
        endBottom = endBottomPoint;
        endTop = endTopPoint;
        draw(path);

        dyneTime += renderTraceCallback.getDeltaTime();
        if (dyneTime >= Constant.dyneBaseTime) {
          renderTraceCallback.onRightDyneAdd();
          dyneTime -= Constant.dyneBaseTime;
        }
      }
      else {
        destroyed = true;
        renderTraceCallback.onRightTraceTapped(lighterPoint, endTime);
        unhold();
      }
    }
    else {
      draw(path);

      if (renderTraceCallback.getTime() >= validTapTime && renderTraceCallback.getTime() <= endTime) {
        dyneTime += renderTraceCallback.getDeltaTime();
        if (dyneTime >= Constant.dyneBaseTime) {
          renderTraceCallback.onRightDyneMinus();
          dyneTime -= Constant.dyneBaseTime;
        }
      }
    }
  }

  @override
  bool passed() {
    return startX >= Constant.windowWidth;
  }

  @override
  validTap() {
    if (!tapped && renderTraceCallback.getTime() <= validTapTime) {
      tapped = true;
      renderTraceCallback.onRightTraceTapped(lighterPoint, startTime);
    }
  }

  @override
  hold() {
    renderTraceCallback.onLeftTraceHold(Offset(Constant.rightCenterPoint, lighterPoint));
  }

  @override
  unhold() {
    renderTraceCallback.onLeftTraceHold(null);
  }
}

class FirstLeftTie extends LeftTie {

  FirstLeftTie(RenderTraceCallback renderTraceCallback, double time, double endTime, Number number)
      : super(renderTraceCallback, time, endTime, number) {
    lighterPoint = Constant.lighterFirstPoint;
    startTopPoint = Constant.centerFirstPoint;
    endTopPoint = Constant.bottomLine;
    bottomDistance = Constant.inLineDistance;
    topDistance = Constant.outLineDistance;
    initialize();
  }

  @override
  updateStartY(double outUpdateLength, double inUpdateLength) {
    startBottom += inUpdateLength;
    startTop += outUpdateLength;
  }

  @override
  updateEndY(double outUpdateLength, double inUpdateLength) {
    endBottom += inUpdateLength;
    endTop += outUpdateLength;
  }
}

class FirstRightTie extends RightTie {

  FirstRightTie(RenderTraceCallback renderTraceCallback, double time, double endTime, Number number)
      : super(renderTraceCallback, time, endTime, number) {
    lighterPoint = Constant.lighterFirstPoint;
    startTopPoint = Constant.centerFirstPoint;
    endTopPoint = Constant.windowHeight;
    bottomDistance = Constant.inLineDistance;
    topDistance = Constant.outLineDistance;
    initialize();
  }

  @override
  updateStartY(double outUpdateLength, double inUpdateLength) {
    startBottom += inUpdateLength;
    startTop += outUpdateLength;
  }

  @override
  updateEndY(double outUpdateLength, double inUpdateLength) {
    endBottom += inUpdateLength;
    endTop += outUpdateLength;
  }
}

class SecondLeftTie extends LeftTie {

  SecondLeftTie(RenderTraceCallback renderTraceCallback, double time, double endTime, Number number)
      : super(renderTraceCallback, time, endTime, number) {
    lighterPoint = Constant.lighterSecondPoint;
    startTopPoint = Constant.centerSecondPoint;
    endTopPoint = Constant.firstLine;
    bottomDistance = 0;
    topDistance = Constant.inLineDistance;
    initialize();
  }

  @override
  updateStartY(double outUpdateLength, double inUpdateLength) {
    startTop += inUpdateLength;
  }

  @override
  updateEndY(double outUpdateLength, double inUpdateLength) {
    endTop += inUpdateLength;
  }
}

class SecondRightTie extends RightTie {

  SecondRightTie(RenderTraceCallback renderTraceCallback, double time, double endTime, Number number)
      : super(renderTraceCallback, time, endTime, number) {
    lighterPoint = Constant.lighterSecondPoint;
    startTopPoint = Constant.centerSecondPoint;
    endTopPoint = Constant.firstLine;
    bottomDistance = 0;
    topDistance = Constant.inLineDistance;
    initialize();
  }

  @override
  updateStartY(double outUpdateLength, double inUpdateLength) {
    startTop += inUpdateLength;
  }

  @override
  updateEndY(double outUpdateLength, double inUpdateLength) {
    endTop += inUpdateLength;
  }
}

class ThirdLeftTie extends LeftTie {

  ThirdLeftTie(RenderTraceCallback renderTraceCallback, double time, double endTime, Number number)
      : super(renderTraceCallback, time, endTime, number) {
    lighterPoint = Constant.lighterThirdPoint;
    startTopPoint = Constant.centerThirdPoint;
    endTopPoint = Constant.secondLine;
    bottomDistance = -Constant.inLineDistance;
    topDistance = 0;
    initialize();
  }

  @override
  updateStartY(double outUpdateLength, double inUpdateLength) {
    startBottom -= inUpdateLength;
  }

  @override
  updateEndY(double outUpdateLength, double inUpdateLength) {
    endBottom -= inUpdateLength;
  }
}

class ThirdRightTie extends RightTie {

  ThirdRightTie(RenderTraceCallback renderTraceCallback, double time, double endTime, Number number)
      : super(renderTraceCallback, time, endTime, number) {
    lighterPoint = Constant.lighterThirdPoint;
    startTopPoint = Constant.centerThirdPoint;
    endTopPoint = Constant.secondLine;
    bottomDistance = -Constant.inLineDistance;
    topDistance = 0;
    initialize();
  }

  @override
  updateStartY(double outUpdateLength, double inUpdateLength) {
    startBottom -= inUpdateLength;
  }

  @override
  updateEndY(double outUpdateLength, double inUpdateLength) {
    endBottom -= inUpdateLength;
  }
}

class ForthLeftTie extends LeftTie {

  ForthLeftTie(RenderTraceCallback renderTraceCallback, double time, double endTime, Number number)
      : super(renderTraceCallback, time, endTime, number) {
    lighterPoint = Constant.lighterForthPoint;
    startTopPoint = Constant.centerForthPoint;
    endTopPoint = Constant.thirdLine;
    bottomDistance = -Constant.outLineDistance;
    topDistance = -Constant.inLineDistance;
    initialize();
  }

  @override
  updateStartY(double outUpdateLength, double inUpdateLength) {
    startBottom -= outUpdateLength;
    startTop -= inUpdateLength;
  }

  @override
  updateEndY(double outUpdateLength, double inUpdateLength) {
    endBottom -= outUpdateLength;
    endTop -= inUpdateLength;
  }
}

class ForthRightTie extends RightTie {

  ForthRightTie(RenderTraceCallback renderTraceCallback, double time, double endTime, Number number)
      : super(renderTraceCallback, time, endTime, number) {
    lighterPoint = Constant.lighterForthPoint;
    startTopPoint = Constant.centerForthPoint;
    endTopPoint = Constant.thirdLine;
    bottomDistance = -Constant.outLineDistance;
    topDistance = -Constant.inLineDistance;
    initialize();
  }

  @override
  updateStartY(double outUpdateLength, double inUpdateLength) {
    startBottom -= outUpdateLength;
    startTop -= inUpdateLength;
  }

  @override
  updateEndY(double outUpdateLength, double inUpdateLength) {
    endBottom -= outUpdateLength;
    endTop -= inUpdateLength;
  }
}

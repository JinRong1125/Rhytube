import 'dart:ui';

import 'package:rhytube/model/Slur.dart';
import 'package:rhytube/recital/recitalCallback.dart';
import 'package:rhytube/recital/renderTrace.dart';
import 'package:rhytube/statics.dart';

class RenderSlur extends RenderTrace {

  RenderTraceCallback renderTraceCallback;

  List<Slur> slurList;
  List<Offset> bottomOffsetList, topOffsetList;

  double validTapTime, dyneTime, centerPoint, totalLength, displayedLength, hiddenLength, startBottom, updateBottom,
      validBottomY, validTopY, tappingY, distanceX;
  int rangeLast, rangeStart, rangeEnd, validCount;

  bool tapping, tapped;

  RenderSlur(this.renderTraceCallback, double startTime, double endTime, this.slurList)
      : super(startTime, endTime) {
    this.startTime += Constant.startPlayTime;
    validStartTime = this.startTime - Constant.purpleRangeTime;
    validTapTime = this.startTime + Constant.purpleRangeTime;
    this.time = this.startTime - renderTraceCallback.getTieRenderTime();
    this.endTime += Constant.startPlayTime;
    validEndTime = this.endTime + Constant.purpleRangeTime;

    dyneTime = 0;

    bottomOffsetList = List();
    topOffsetList = List();

    totalLength = 0;
    slurList.forEach((slur) {
      totalLength += slur.length;
    });

    startBottom = slurList.first.bottomOffset.dy;
    updateBottom = slurList[1].bottomOffset.dy - slurList[0].bottomOffset.dy;

    validBottomY = 0;
    validTopY = 0;
    tappingY = 0;
    distanceX = Constant.centerWidth;
    rangeLast = slurList.length - 1;
    rangeStart = 0;
    rangeEnd = 1;
    validCount = 1;
    tapping = false;
    tapped = false;

    switch (slurList.last.number) {
      case Number.First:
        lighterPoint = Constant.lighterFirstPoint;
        break;
      case Number.Second:
        lighterPoint = Constant.lighterSecondPoint;
        break;
      case Number.Third:
        lighterPoint = Constant.lighterThirdPoint;
        break;
      case Number.Forth:
        lighterPoint = Constant.lighterForthPoint;
        break;
    }
  }

  @override
  update(double updateLength, double updateRatio, double outUpdateLength, double inUpdateLength) {
    topOffsetList.clear();
    bottomOffsetList.clear();

    for (int i = rangeStart; i < rangeEnd; i++) {
      Slur slur = slurList[i];
      double bottomUpdateLength;
      double topUpdateLength;

      switch (slur.number) {
        case Number.First:
          bottomUpdateLength = inUpdateLength;
          topUpdateLength = outUpdateLength;
          break;
        case Number.Second:
          bottomUpdateLength = 0;
          topUpdateLength = inUpdateLength;
          break;
        case Number.Third:
          bottomUpdateLength = -inUpdateLength;
          topUpdateLength = 0;
          break;
        case Number.Forth:
          bottomUpdateLength = -outUpdateLength;
          topUpdateLength = -inUpdateLength;
          break;
      }

      List<Offset> offsetList = processOffset(slur, updateLength, bottomUpdateLength, topUpdateLength);
      Offset bottomOffset = offsetList[0];
      Offset topOffset = offsetList[1];

      slurList[i].bottomOffset = bottomOffset;
      slurList[i].topOffset = topOffset;
      bottomOffsetList.add(bottomOffset);
      topOffsetList.add(topOffset);
    }
  }

  List<Offset> processOffset(Slur slur, double updateLength, double bottomUpdateLength, double topUpdateLength) {
    return null;
  }

  @override
  render() {
    Offset validStartOffset = slurList[validCount - 1].bottomOffset;
    Offset rangeEndOffset = slurList[validCount].bottomOffset;
    double validRatio = ((validStartOffset.dx - centerPoint) / (validStartOffset.dx - rangeEndOffset.dx)).abs();

    validBottomY = validStartOffset.dy - (validStartOffset.dy - rangeEndOffset.dy) * validRatio;
    validTopY = validBottomY + Constant.noteWidth;
  }

  draw(Path path) {
    List<Offset> offsetList = List();
    topOffsetList.forEach((offset) {
      offsetList.add(offset);
    });
    bottomOffsetList.reversed.forEach((offset) {
      offsetList.add(offset);
    });

    path.addPolygon(offsetList, true);
  }

  @override
  bool passed() {
    return false;
  }

  @override
  tapDown(Number number, double dy) {
    if (dy >= validBottomY && dy <= validTopY && !tapping) {
      validTap();
      hold();
      dyneTime = 0;
      tapping = true;
      tappingY = dy;
    }
  }

  @override
  tapUp(Number number, double dy) {
    if (dy >= validBottomY && dy <= validTopY && tapping) {
      unhold();
      dyneTime = 0;
      tapping = false;
    }
  }

  @override
  tapMove(Number number, double dy) {
    if (tapping) {
      if (dy >= validBottomY && dy <= validTopY)
        tappingY = dy;
      else {
        unhold();
        dyneTime = 0;
        tapping = false;
      }
    }
  }

  validTap() {}

  hold() {}

  unhold() {}
}

class LeftSlur extends RenderSlur {

  LeftSlur(RenderTraceCallback renderTraceCallback, double time, double endTime, List<Slur> slurList)
      : super(renderTraceCallback, time, endTime, slurList) {
    centerPoint = Constant.leftCenterPoint;

    totalLength = Constant.centerWidth - totalLength;
    displayedLength = Constant.centerWidth - slurList[1].length;
    hiddenLength = -slurList[1].length;
  }

  @override
  update(double updateLength, double updateRatio, double outUpdateLength, double inUpdateLength) {
    distanceX -= updateLength;

    if (rangeStart < rangeLast && distanceX <= hiddenLength) {
      rangeStart++;
      if (rangeStart < rangeLast)
        hiddenLength -= slurList[rangeStart + 1].length;
    }
    if (distanceX <= totalLength) {
      rangeEnd = rangeLast + 1;
      super.update(updateLength, updateRatio, outUpdateLength, inUpdateLength);
    }
    else {
      if (rangeEnd < rangeLast && distanceX <= displayedLength) {
        startBottom = slurList[rangeEnd].bottomOffset.dy;
        rangeEnd++;
        updateBottom = slurList[rangeEnd].bottomOffset.dy - startBottom;
        displayedLength -= slurList[rangeEnd].length;
      }

      super.update(updateLength, updateRatio, outUpdateLength, inUpdateLength);

      Slur slur = slurList[rangeEnd];
      double distance = displayedLength + slur.length - distanceX;
      double updateScale = distance / slur.length;
      double updateDistance = updateBottom * updateScale;

      bottomOffsetList.add(Offset(Constant.centerWidth, startBottom + updateDistance));
      topOffsetList.add(Offset(Constant.centerWidth, startBottom + Constant.centerNoteWidth + updateDistance));
    }
  }

  @override
  List<Offset> processOffset(Slur slur, double updateLength, double bottomUpdateLength, double topUpdateLength) {
    Offset bottomOffset = Offset(
        slur.bottomOffset.dx - updateLength,
        slur.bottomOffset.dy + bottomUpdateLength);
    Offset topOffset = Offset(
        slur.topOffset.dx - updateLength,
        slur.topOffset.dy + topUpdateLength);

    return [bottomOffset, topOffset];
  }

  @override
  render() {
    Path path = renderTraceCallback.getLeftSlurPath();
    super.render();

    if (tapping && tappingY >= validBottomY && tappingY <= validTopY) {
      if (renderTraceCallback.getTime() < endTime) {
        if (rangeStart < rangeLast && renderTraceCallback.getTime() >= slurList[rangeStart + 1].time) {
          renderTraceCallback.onTappedPlaySound();
          rangeStart++;
          if (rangeStart < rangeLast)
            hiddenLength -= slurList[rangeStart + 1].length;
        }
        slurList[validCount - 1].bottomOffset = Offset(centerPoint, validBottomY);
        slurList[validCount - 1].topOffset = Offset(centerPoint, validTopY);
        draw(path);
        hold();

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
    if (validCount < rangeLast && slurList[validCount].bottomOffset.dx < centerPoint)
      validCount++;
  }

  @override
  bool passed() {
    return slurList[rangeLast].bottomOffset.dx <= 0;
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
    renderTraceCallback.onLeftTraceHold(Offset(centerPoint, (validBottomY + validTopY) / 2));
  }

  @override
  unhold() {
    renderTraceCallback.onLeftTraceHold(null);
  }
}

class RightSlur extends RenderSlur {

  RightSlur(RenderTraceCallback renderTraceCallback, double time, double endTime, List<Slur> slurList)
      : super(renderTraceCallback, time, endTime, slurList) {
    centerPoint = Constant.rightCenterPoint;

    totalLength += Constant.centerWidth;
    displayedLength = slurList[1].length + Constant.centerWidth;
    hiddenLength = slurList[1].length + Constant.windowWidth;
  }
  
  @override
  update(double updateLength, double updateRatio, double outUpdateLength, double inUpdateLength) {
    distanceX += updateLength;

    if (rangeStart < rangeLast && distanceX >= hiddenLength) {
      rangeStart++;
      if (rangeStart < rangeLast)
        hiddenLength += slurList[rangeStart + 1].length;
    }
    if (distanceX >= totalLength) {
      rangeEnd = rangeLast + 1;
      super.update(updateLength, updateRatio, outUpdateLength, inUpdateLength);
    }
    else {
      if (rangeEnd < rangeLast && distanceX >= displayedLength) {
        startBottom = slurList[rangeEnd].bottomOffset.dy;
        rangeEnd++;
        updateBottom = slurList[rangeEnd].bottomOffset.dy - startBottom;
        displayedLength += slurList[rangeEnd].length;
      }

      super.update(updateLength, updateRatio, outUpdateLength, inUpdateLength);

      Slur slur = slurList[rangeEnd];
      double distance = distanceX - (displayedLength - slur.length);
      double updateScale = distance / slur.length;
      double updateDistance = updateBottom * updateScale;

      bottomOffsetList.add(Offset(Constant.centerWidth, startBottom + updateDistance));
      topOffsetList.add(Offset(Constant.centerWidth, startBottom + Constant.centerNoteWidth + updateDistance));
    }
  }

  @override
  List<Offset> processOffset(Slur slur, double updateLength, double bottomUpdateLength, double topUpdateLength) {
    Offset bottomOffset = Offset(
        slur.bottomOffset.dx + updateLength,
        slur.bottomOffset.dy + bottomUpdateLength);
    Offset topOffset = Offset(
        slur.topOffset.dx + updateLength,
        slur.topOffset.dy + topUpdateLength);

    return [bottomOffset, topOffset];
  }

  @override
  render() {
    Path path = renderTraceCallback.getRightSlurPath();
    super.render();

    if (tapping && tappingY >= validBottomY && tappingY <= validTopY) {
      if (renderTraceCallback.getTime() < endTime) {
        if (rangeStart < rangeLast && renderTraceCallback.getTime() >= slurList[rangeStart + 1].time) {
          renderTraceCallback.onTappedPlaySound();
          rangeStart++;
          if (rangeStart < rangeLast)
            hiddenLength += slurList[rangeStart + 1].length;
        }
        slurList[validCount - 1].bottomOffset = Offset(centerPoint, validBottomY);
        slurList[validCount - 1].topOffset = Offset(centerPoint, validTopY);
        draw(path);
        hold();

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
    if (validCount < rangeLast && slurList[validCount].bottomOffset.dx > centerPoint)
      validCount++;
  }

  @override
  bool passed() {
    return slurList[rangeLast].bottomOffset.dx >= Constant.windowWidth;
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
    renderTraceCallback.onRightTraceHold(Offset(centerPoint, (validBottomY + validTopY) / 2));
  }

  @override
  unhold() {
    renderTraceCallback.onRightTraceHold(null);
  }
}
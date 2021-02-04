import 'dart:ui';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/gestures.dart';

import 'package:rhytube/page/page.dart';
import 'package:rhytube/recital/recitalCallback.dart';
import 'package:rhytube/statics.dart';

class PauseWidget extends StatefulWidget {

  final PauseWidgetCallback pauseWidgetCallback;
  PauseWidget(this.pauseWidgetCallback);

  @override
  State<StatefulWidget> createState() {
    return PauseState(pauseWidgetCallback);
  }
}

class PauseState extends State<PauseWidget> with TickerProviderStateMixin {

  AnimationController animationController;
  Animation<double> animation;

  PauseWidgetCallback pauseWidgetCallback;
  bool paused;

  PauseState(this.pauseWidgetCallback);

  @override
  initState() {
    super.initState();
    animationController = AnimationController(duration: Duration(milliseconds: 250), vsync: this);
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          paused = false;
        });
        pauseWidgetCallback.onResume();
      }
    });

    paused = false;
    setSystemMessageHandler();
  }

  @override
  void dispose() {
    pauseWidgetCallback.onStop();
    super.dispose();
  }

  setSystemMessageHandler() {
    String statePaused = AppLifecycleState.paused.toString();
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (message == statePaused)
        pause();
    });
  }

  pause() {
    if (!pauseWidgetCallback.getPaused()) {
      pauseWidgetCallback.onPause();
      setState(() {
        paused = true;
      });
      animationController.forward();
    }
  }

  retry() {
    PageWidget.of(context).startPlay(pauseWidgetCallback.getMovement());
  }

  exit() {
    PageWidget.of(context).openSheet();
  }

  Widget updateWidget() {
    if (paused)
      return
        Stack(
          children: [
            buttonWidget(),
            pausedWidget()
          ]
        );
    return buttonWidget();
  }

  Widget pausedWidget() {
    return
      Positioned.fill(
        child: FadeTransition(
          opacity: animation,
          child: Container(
            color: Colors.white.withOpacity(0.97),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: retry,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)
                    ),
                    width: 100,
                    height: 50,
                    child: Text(
                      'RETRY',
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    animationController.reverse();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)
                    ),
                    width: 100,
                    height: 50,
                    child: Text(
                      'RESUME',
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: exit,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)
                    ),
                    width: 100,
                    height: 50,
                    child: Text(
                      'EXIT',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  Widget buttonWidget() {
    return
      Positioned(
        left: Constant.centerWidth - 10,
        top: Constant.gameHeight * 0.2 + Constant.ratioHeight - 10,
        child: GestureDetector(
          onTap: pause,
          child: Container(
              color: Colors.white,
              width: 20,
              height: 20
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return updateWidget();
  }
}

class BoardWidget extends SingleChildRenderObjectWidget {
  @override
  RenderObject createRenderObject(BuildContext context) {
    return BoardRenderBox();
  }
}

class TapWidget extends SingleChildRenderObjectWidget {

  final TapRenderBox tapRenderBox;
  TapWidget(this.tapRenderBox);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return tapRenderBox;
  }
}

class TraceWidget extends SingleChildRenderObjectWidget {

  final TraceRenderBox traceRenderBox;
  TraceWidget(this.traceRenderBox);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return traceRenderBox;
  }
}

class ScoreWidget extends SingleChildRenderObjectWidget {

  final ScoreRenderBox scoreRenderBox;
  ScoreWidget(this.scoreRenderBox);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return scoreRenderBox;
  }
}

class BoardRenderBox extends RenderBox {

  @override
  performLayout() {
    size = constraints.biggest;
  }

  @override
  paint(PaintingContext context, Offset offset) {
    render(context.canvas);
  }

  render(Canvas canvas) {
    Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = Constant.lineWidth;

    canvas
      ..drawLine(Offset(Constant.centerWidth, Constant.centerFirstPoint), Offset(Constant.centerWidth, Constant.centerFifthPoint), paint)

      ..drawLine(Offset(Constant.leftCenterPoint, Constant.bottomLine), Offset(Constant.centerWidth, Constant.centerFirstPoint), paint)
      ..drawLine(Offset(Constant.leftCenterPoint, Constant.firstLine), Offset(Constant.centerWidth, Constant.centerSecondPoint), paint)
      ..drawLine(Offset(Constant.leftCenterPoint, Constant.secondLine), Offset(Constant.centerWidth, Constant.centerThirdPoint), paint)
      ..drawLine(Offset(Constant.leftCenterPoint, Constant.thirdLine), Offset(Constant.centerWidth, Constant.centerForthPoint), paint)
      ..drawLine(Offset(Constant.leftCenterPoint, Constant.topLine), Offset(Constant.centerWidth, Constant.centerFifthPoint), paint)

      ..drawLine(Offset(Constant.leftCenterPoint, Constant.bottomLine), Offset(0, Constant.bottomLine), paint)
      ..drawLine(Offset(Constant.leftCenterPoint, Constant.firstLine), Offset(0, Constant.firstLine), paint)
      ..drawLine(Offset(Constant.leftCenterPoint, Constant.secondLine), Offset(0, Constant.secondLine), paint)
      ..drawLine(Offset(Constant.leftCenterPoint, Constant.thirdLine), Offset(0, Constant.thirdLine), paint)
      ..drawLine(Offset(Constant.leftCenterPoint, Constant.topLine), Offset(0, Constant.topLine), paint)

      ..drawLine(Offset(Constant.rightCenterPoint, Constant.bottomLine), Offset(Constant.centerWidth, Constant.centerFirstPoint), paint)
      ..drawLine(Offset(Constant.rightCenterPoint, Constant.firstLine), Offset(Constant.centerWidth, Constant.centerSecondPoint), paint)
      ..drawLine(Offset(Constant.rightCenterPoint, Constant.secondLine), Offset(Constant.centerWidth, Constant.centerThirdPoint), paint)
      ..drawLine(Offset(Constant.rightCenterPoint, Constant.thirdLine), Offset(Constant.centerWidth, Constant.centerForthPoint), paint)
      ..drawLine(Offset(Constant.rightCenterPoint, Constant.topLine), Offset(Constant.centerWidth, Constant.centerFifthPoint), paint)

      ..drawLine(Offset(Constant.rightCenterPoint, Constant.bottomLine), Offset(Constant.windowWidth, Constant.bottomLine), paint)
      ..drawLine(Offset(Constant.rightCenterPoint, Constant.firstLine), Offset(Constant.windowWidth, Constant.firstLine), paint)
      ..drawLine(Offset(Constant.rightCenterPoint, Constant.secondLine), Offset(Constant.windowWidth, Constant.secondLine), paint)
      ..drawLine(Offset(Constant.rightCenterPoint, Constant.thirdLine), Offset(Constant.windowWidth, Constant.thirdLine), paint)
      ..drawLine(Offset(Constant.rightCenterPoint, Constant.topLine), Offset(Constant.windowWidth, Constant.topLine), paint);

    paint
      ..color = Colors.grey
      ..strokeWidth = Constant.halfNoteHeight;

    canvas
      ..drawLine(Offset(Constant.leftCenterPoint, 0), Offset(Constant.leftCenterPoint, Constant.windowHeight), paint)
      ..drawLine(Offset(Constant.rightCenterPoint, 0), Offset(Constant.rightCenterPoint, Constant.windowHeight), paint);
  }
}

class TapRenderBox extends RenderBox {

  HashMap<int, Picture> tapLighterMap;
  HashMap<Number, Picture> leftLighterMap, rightLighterMap;

  TapRenderBox() {
    tapLighterMap = HashMap();

    leftLighterMap = HashMap()
      ..[Number.First] = createPicture(Number.First, Direction.Left)
      ..[Number.Second] = createPicture(Number.Second, Direction.Left)
      ..[Number.Third] = createPicture(Number.Third, Direction.Left)
      ..[Number.Forth] = createPicture(Number.Forth, Direction.Left);
    rightLighterMap = HashMap()
      ..[Number.First] = createPicture(Number.First, Direction.Right)
      ..[Number.Second] = createPicture(Number.Second, Direction.Right)
      ..[Number.Third] = createPicture(Number.Third, Direction.Right)
      ..[Number.Forth] = createPicture(Number.Forth, Direction.Right);
  }

  Picture createPicture(Number number, Direction direction) {
    double lighterPoint, inStart, inEnd, outStart, outEnd;

    switch (direction) {
      case Direction.Left:
        lighterPoint = Constant.leftLighterPoint;
        break;
      case Direction.Right:
        lighterPoint = Constant.rightLighterPoint;
        break;
    }
    switch (number) {
      case Number.First:
        inStart = Constant.centerFirstPoint;
        outStart = Constant.bottomLine;
        break;
      case Number.Second:
        inStart = Constant.centerSecondPoint;
        outStart = Constant.firstLine;
        break;
      case Number.Third:
        inStart = Constant.centerThirdPoint;
        outStart = Constant.secondLine;
        break;
      case Number.Forth:
        inStart = Constant.centerForthPoint;
        outStart = Constant.thirdLine;
        break;
    }
    inEnd = inStart - Constant.centerNoteWidth;
    outEnd = outStart - Constant.noteWidth;

    List<Offset> offsetList = List()
      ..add(Offset(Constant.centerWidth, inStart))
      ..add(Offset(Constant.centerWidth, inEnd))
      ..add(Offset(lighterPoint, outEnd))
      ..add(Offset(lighterPoint, outStart));
    Path path = Path()
      ..addPolygon(offsetList, true);

    PictureRecorder pictureRecorder = PictureRecorder();
    Canvas canvas = Canvas(pictureRecorder);
    canvas.drawPath(path, Constant.lighterPaint);

    return pictureRecorder.endRecording();
  }

  @override
  performLayout() {
    size = constraints.biggest;
  }

  @override
  paint(PaintingContext context, Offset offset) {
    render(context.canvas);
  }

  render(Canvas canvas) {
    tapLighterMap.forEach((pointer, picture) {
      if (picture != null)
        canvas.drawPicture(picture);
    });
  }

  tapLeft(int pointer, Number number) {
    tapLighterMap[pointer] = leftLighterMap[number];
    markNeedsPaint();
  }

  tapRight(int pointer, Number number) {
    tapLighterMap[pointer] = rightLighterMap[number];
    markNeedsPaint();
  }

  tapUp(int pointer) {
    tapLighterMap[pointer] = null;
    markNeedsPaint();
  }
}

class TraceRenderBox extends RenderBox {

  TraceWidgetCallback traceWidgetCallback;
  Duration previousDuration;
  int frameCallbackId;

  TraceRenderBox(this.traceWidgetCallback);

  @override
  performLayout() {
    size = constraints.biggest;
  }

  @override
  paint(PaintingContext context, Offset offset) {
    traceWidgetCallback.onPaint(context.canvas);
  }

  scheduleTick() {
    frameCallbackId = SchedulerBinding.instance.scheduleFrameCallback(tickTime);
  }

  unscheduleTick() {
    SchedulerBinding.instance.cancelFrameCallbackWithId(frameCallbackId);
  }

  tickTime(Duration duration) {
    scheduleTick();
    traceWidgetCallback.onUpdate(computeDeltaTime(duration));
    markNeedsPaint();
  }

  double computeDeltaTime(Duration duration) {
    if (previousDuration == null)
      previousDuration = duration;
    double deltaTime = (duration - previousDuration).inMicroseconds.toDouble() / Duration.microsecondsPerSecond;
    previousDuration = duration;
    return deltaTime;
  }
}

class ScoreRenderBox extends RenderBox {

  TextPainter textPainter;
  TextStyle textStyle;

  double dyneLeft, dyneRight, dyneAddBase, dyneMinusBase;
  int combo;

  ScoreRenderBox() {
    textPainter = TextPainter(textDirection: TextDirection.rtl, textAlign: TextAlign.center);
    textStyle = TextStyle(color: Colors.white, fontSize: Constant.comboTextSize);

    double halfScore = Constant.dyneFullScore * 0.5;
    dyneLeft = halfScore;
    dyneRight = halfScore;
    dyneAddBase = Constant.dyneFullScore * 0.005;
    dyneMinusBase = Constant.dyneFullScore * 0.05;
    combo = 0;
  }

  @override
  performLayout() {
    size = constraints.biggest;
  }

  @override
  paint(PaintingContext context, Offset offset) {
    renderCombo(context.canvas);
    renderDyne(context.canvas);
  }

  renderDyne(Canvas canvas) {
    canvas
      ..drawLine(
          Offset(Constant.centerWidth, Constant.dyneLinePoint),
          Offset(Constant.centerWidth - dyneLeft, Constant.dyneLinePoint),
          Constant.greenPaint)
      ..drawLine(
          Offset(Constant.centerWidth, Constant.dyneLinePoint),
          Offset(Constant.centerWidth + dyneRight, Constant.dyneLinePoint),
          Constant.redPaint);
  }

  renderCombo(Canvas canvas) {
    if (combo > 0) {
      textPainter
        ..text = TextSpan(style: textStyle, text: combo.toString())
        ..layout()
        ..paint(canvas, Offset(Constant.centerWidth - (textPainter.width * 0.5), Constant.comboTextHeight));
    }
  }

  addLeftDyne() {
    dyneLeft += dyneAddBase;
    combo++;
    checkLeftDyne();
    markNeedsPaint();
  }

  addRightDyne() {
    dyneRight += dyneAddBase;
    combo++;
    checkRightDyne();
    markNeedsPaint();
  }

  minusLeftDyne() {
    dyneLeft -= dyneMinusBase;
    combo = 0;
    checkLeftDyne();
    markNeedsPaint();
  }

  minusRightDyne() {
    dyneRight -= dyneMinusBase;
    combo = 0;
    checkRightDyne();
    markNeedsPaint();
  }

  checkLeftDyne() {
    if (dyneLeft > Constant.dyneFullScore)
      dyneLeft = Constant.dyneFullScore;
    else if (dyneLeft < 0)
      dyneLeft = 0;
  }

  checkRightDyne() {
    if (dyneRight > Constant.dyneFullScore)
      dyneRight = Constant.dyneFullScore;
    else if (dyneRight < 0)
      dyneRight = 0;
  }
}
import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:rhytube/recital/recitalCallback.dart';
import 'package:rhytube/recital/widget.dart';
import 'package:rhytube/recital/renderLine.dart';
import 'package:rhytube/recital/renderTrace.dart';
import 'package:rhytube/recital/lighterTap.dart';
import 'package:rhytube/recital/lighterHold.dart';
import 'package:rhytube/model/Movement.dart';
import 'package:rhytube/statics.dart';
import 'package:rhytube/mapReader.dart';
import 'package:rhytube/util.dart';

import 'package:rhytube/particle_system.dart';
import 'package:rhytube/color_sequence.dart';

class Recital {

  Movement movement;

  RecitalCallback recitalCallback;

  PointerRoute pointerRoute;

  TraceRenderBox traceRenderBox;
  TapRenderBox tapRenderBox;
  ScoreRenderBox scoreRenderBox;

  AudioPlayer musicPlayer;
  List<AudioPlayer> soundPlayerList;

  RenderLine renderLine;
  List<RenderTrace> leftTraceList, rightTraceList;

  Set<LighterTap> lighterTapSet;
  LighterHold lighterHold;

  Path linePath;
  Path notePath;
  Path tiePath;
  Path leftSlurPath;
  Path rightSlurPath;

  double time, deltaTime, speed, noteRenderTime, tieRenderTime;
  int leftDisplayStart, rightDisplayStart, leftDisplayEnd, rightDisplayEnd,
      leftValidStart, rightValidStart, leftValidEnd, rightValidEnd;
  bool started, paused;

  ParticleSystem particleSystem;

  Recital() {
    pointerRoute = (pointerEvent) {
      int pointer = pointerEvent.device;
      Offset offset = pointerEvent.position;
      if (pointerEvent is PointerDownEvent)
        tapDown(pointer, offset);
      else if (pointerEvent is PointerUpEvent)
        tapUp(pointer, offset);
      else if (pointerEvent is PointerMoveEvent)
        tapMove(pointer, offset);
    };
    addPointer();

    recitalCallback = RecitalCallback(this);

    traceRenderBox = TraceRenderBox(recitalCallback);
    tapRenderBox = TapRenderBox();
    scoreRenderBox = ScoreRenderBox();

    lighterTapSet = Set();
    lighterHold = LighterHold();

    linePath = Path();
    notePath = Path();
    tiePath = Path();
    leftSlurPath = Path();
    rightSlurPath = Path();

    time = 0;
    deltaTime = 0;
    speed = 500;
    noteRenderTime = Constant.noteMoveDistance / speed;
    tieRenderTime = Constant.tieMoveDistance / speed;
    leftValidStart = 0;
    rightValidStart = 0;
    leftValidEnd = 0;
    rightValidEnd = 0;
    leftDisplayStart = 0;
    rightDisplayStart = 0;
    leftDisplayEnd = 0;
    rightDisplayEnd = 0;
    started = false;
    paused = true;

//    loadParticle();
  }

  load(Movement movement) async {
    this.movement = movement;
    await loadMusic();
    await loadMap();
    startPlay();
  }

  loadMusic() async {
    AudioCache audioCache = AudioCache();
    String musicPath = (await audioCache.load(movement.music)).path;
    String soundPath = (await audioCache.load('hit.mp3')).path;

    musicPlayer = AudioPlayer()
      ..setUrl(musicPath)
      ..setVolume(1)
      ..onPlayerStateChanged.listen((audioPlayerState) {
        if (audioPlayerState == AudioPlayerState.COMPLETED) {
          traceRenderBox.unscheduleTick();
          musicPlayer.release();
        }
      });

    soundPlayerList = List()
      ..add(createSoundPlayer(soundPath))
      ..add(createSoundPlayer(soundPath))
      ..add(createSoundPlayer(soundPath))
      ..add(createSoundPlayer(soundPath));
  }

  AudioPlayer createSoundPlayer(String soundPath) {
    return AudioPlayer()
      ..setReleaseMode(ReleaseMode.STOP)
      ..setUrl(soundPath)
      ..setVolume(0.5);
  }

  playSound() {
    for (AudioPlayer audioPlayer in soundPlayerList) {
      if (audioPlayer.state != AudioPlayerState.PLAYING) {
        audioPlayer.resume();
        return;
      }
    }
  }

  loadMap() async {
    MapReader mapReader = MapReader(recitalCallback);
    List<List<RenderTrace>> renderTraceLists = await mapReader.load(movement.map);
    leftTraceList = renderTraceLists[0];
    rightTraceList = renderTraceLists[1];

    CompleteTrace completeTrace = CompleteTrace(movement.duration);
    leftTraceList.add(completeTrace);
    rightTraceList.add(completeTrace);

    renderLine = RenderLine(recitalCallback, leftTraceList[0].time);
  }

  startPlay() {
    musicPlayer.onPlayerCompletion.listen((_) {
      traceRenderBox.unscheduleTick();
    });
    traceRenderBox.scheduleTick();
  }

  delayResume() {
    Future.delayed(Duration(seconds: Constant.startPlayTime.toInt()), () {
      resume();
    });
  }

  resume() async {
    addPointer();
    await musicPlayer.seek(Duration(microseconds: ((time - Constant.startPlayTime) * 1000000).toInt()));
    await musicPlayer.resume();
    paused = false;
  }

  pause() {
    paused = true;
    musicPlayer.pause();
    removePointer();
  }

  addPointer() {
    GestureBinding.instance.pointerRouter.addGlobalRoute(pointerRoute);
  }
  
  removePointer() {
    GestureBinding.instance.pointerRouter.removeGlobalRoute(pointerRoute);
  }

  update(double deltaTime) {
    if (!paused) {
      time += deltaTime;
      this.deltaTime = deltaTime;
      updateTrace();
    }
    else if (!started) {
      time += deltaTime;
      this.deltaTime = deltaTime;
      if (time >= Constant.startPlayTime) {
        musicPlayer.resume();
        paused = false;
        started = true;
      }

      updateTrace();
    }
//    particleSystem.update(deltaTime);
  }

  updateTrace() {
    RenderTrace leftTrace = leftTraceList[leftValidStart];
    if (time > leftTrace.validEndTime) {
      if (!leftTrace.destroyed)
        scoreRenderBox.minusLeftDyne();
      leftValidStart++;
    }
    RenderTrace rightTrace = rightTraceList[rightValidStart];
    if (time > rightTrace.validEndTime) {
      if (!rightTrace.destroyed)
        scoreRenderBox.minusRightDyne();
      rightValidStart++;
    }
    if (time >= leftTraceList[leftValidEnd].validStartTime)
      leftValidEnd++;
    if (time >= rightTraceList[rightValidEnd].validStartTime)
      rightValidEnd++;

    linePath.reset();
    notePath.reset();
    tiePath.reset();
    leftSlurPath.reset();
    rightSlurPath.reset();

    if (leftTraceList[leftDisplayStart].passed())
      leftDisplayStart++;
    if (rightTraceList[rightDisplayStart].passed())
      rightDisplayStart++;

    double updateLength = deltaTime * speed;
    double updateRatio = updateLength / Constant.tieMoveDistance;
    double outUpdateLength = Constant.outLineDistance * updateRatio;
    double inUpdateLength = Constant.inLineDistance * updateRatio;

//    if (!renderLine.started) {
//      double time = renderLine.time;
//      if (this.time >= time) {
//        double updateLength = (this.time - time) * speed;
//        double outUpdateLength = Constant.outLineDistance * (updateLength / Constant.tieMoveDistance);
//        renderLine
//          ..initialize()
//          ..update(updateLength, 0, outUpdateLength, 0)
//          ..render();
//      }
//    }
//    else
//      renderLine
//        ..update(updateLength, 0, outUpdateLength, 0)
//        ..render();

    for (int i = leftDisplayStart; i < leftDisplayEnd; i++) {
      RenderTrace renderTrace = leftTraceList[i];
      if (!renderTrace.destroyed) {
        renderTrace
          ..update(updateLength, updateRatio, outUpdateLength, inUpdateLength)
          ..render();
      }
    }
    for (int i = rightDisplayStart; i < rightDisplayEnd; i++) {
      RenderTrace renderTrace = rightTraceList[i];
      if (!renderTrace.destroyed) {
        renderTrace
          ..update(updateLength, updateRatio, outUpdateLength, inUpdateLength)
          ..render();
      }
    }

    RenderTrace leftRenderTrace = leftTraceList[leftDisplayEnd];
    if (time >= leftRenderTrace.time) {
      addDisplayEnd(leftRenderTrace);
      leftDisplayEnd++;
    }
    RenderTrace rightRenderTrace = rightTraceList[rightDisplayEnd];
    if (time >= rightRenderTrace.time) {
      addDisplayEnd(rightRenderTrace);
      rightDisplayEnd++;
    }
  }

  addDisplayEnd(RenderTrace renderTrace) {
    double updateLength = (time - renderTrace.time) * speed;
    double updateRatio = updateLength / Constant.tieMoveDistance;
    double outUpdateLength = Constant.outLineDistance * updateRatio;
    double inUpdateLength = Constant.inLineDistance * updateRatio;

    renderTrace
      ..update(updateLength, updateRatio, outUpdateLength, inUpdateLength)
      ..render();
  }

  render(Canvas canvas) {
    canvas.drawPath(linePath, Constant.linePaint);
    canvas.drawPath(notePath, Constant.notePaint);
    canvas.drawPath(tiePath, Constant.tiePaint);
    canvas.drawPath(leftSlurPath, Constant.greenPaint);
    canvas.drawPath(rightSlurPath, Constant.redPaint);

    double holdUpdateDistance = (deltaTime / Constant.lighterHoldTime) * Constant.holdDistanceRadius;
    lighterHold.render(canvas, holdUpdateDistance);

    double tapUpdateRatio = deltaTime / Constant.lighterTapTime;
    double tapUpdateDistance = tapUpdateRatio * Constant.tapDistanceRadius;
    lighterTapSet.toSet().forEach((lighterTap) {
      lighterTap.render(canvas, tapUpdateRatio, tapUpdateDistance);
    });

//    particleSystem.paint(canvas);
  }

  TapType getTapType(double tapX) {
    if (tapX <= Constant.leftTapPoint)
      return TapType.Left;
    if (tapX >= Constant.rightTapPoint)
      return TapType.Right;
    return TapType.None;
  }

  Number getTapNumber(double tapY) {
    if (tapY >= Constant.firstLine)
      return Number.First;
    if (tapY >= Constant.secondLine)
      return Number.Second;
    if (tapY >= Constant.thirdLine)
      return Number.Third;
    return Number.Forth;
  }

  tapDown(int pointer, Offset offset) {
    Number number = getTapNumber(offset.dy);
    switch (getTapType(offset.dx)) {
      case TapType.None:
        break;
      case TapType.Left:
        tapDownTrace(number, offset.dy, leftTraceList, leftValidStart, leftValidEnd);
        tapRenderBox.tapLeft(pointer, number);
        break;
      case TapType.Right:
        tapDownTrace(number, offset.dy, rightTraceList, rightValidStart, rightValidEnd);
        tapRenderBox.tapRight(pointer, number);
        break;
    }
  }

  tapUp(int pointer, Offset offset) {
    Number number = getTapNumber(offset.dy);
    switch (getTapType(offset.dx)) {
      case TapType.None:
        break;
      case TapType.Left:
        tapUpTrace(number, offset.dy, leftTraceList, leftValidStart, leftValidEnd);
        break;
      case TapType.Right:
        tapUpTrace(number, offset.dy, rightTraceList, rightValidStart, rightValidEnd);
        break;
    }
    tapRenderBox.tapUp(pointer);
  }

  tapMove(int pointer, Offset offset) {
    Number number = getTapNumber(offset.dy);
    switch (getTapType(offset.dx)) {
      case TapType.None:
        tapRenderBox.tapUp(pointer);
        break;
      case TapType.Left:
        tapMoveTrace(number, offset.dy, leftTraceList, leftValidStart, leftValidEnd);
        tapRenderBox.tapLeft(pointer, number);
        break;
      case TapType.Right:
        tapMoveTrace(number, offset.dy, rightTraceList, rightValidStart, rightValidEnd);
        tapRenderBox.tapRight(pointer, number);
        break;
    }
  }

  tapDownTrace(Number number, double dy, List<RenderTrace> renderTraceList, int validStart, int validEnd) {
    for (int i = validStart; i < validEnd; i++) {
      RenderTrace renderTrace = renderTraceList[i];
      if (!renderTrace.destroyed)
        renderTrace.tapDown(number, dy);
    }
  }

  tapUpTrace(Number number, double dy, List<RenderTrace> renderTraceList, int validStart, int validEnd) {
    for (int i = validStart; i < validEnd; i++) {
      RenderTrace renderTrace = renderTraceList[i];
      if (!renderTrace.destroyed)
        renderTrace.tapUp(number, dy);
    }
  }

  tapMoveTrace(Number number, double dy, List<RenderTrace> renderTraceList, int validStart, int validEnd) {
    for (int i = validStart; i < validEnd; i++) {
      RenderTrace renderTrace = renderTraceList[i];
      if (!renderTrace.destroyed)
        renderTrace.tapMove(number, dy);
    }
  }

  Color measureColor(time) {
    double tapTime = (time - this.time).abs();
    if (tapTime <= Constant.whiteRangeTime)
      return Colors.white;
    if (tapTime <= Constant.orangeRangeTime)
      return Colors.orange;
    return Colors.purpleAccent;
  }

//  loadParticle() async {
//    Color startColor = _randomExplosionColor();
//    Color endColor = startColor.withAlpha(0);
//
//    particleSystem = ParticleSystem(await loadImage('assets/fire.png'),
//        rotateToMovement: true,
//        life: 0,
//        lifeVar: 0.5,
//        numParticlesToEmit: 0,
//        speed: 100.0,
//        speedVar: 10.0,
//        startSize: 1.5,
//        startSizeVar: 0.5,
//        endSize: 0.75,
//        colorSequence:
//        ColorSequence.fromStartAndEndColor(Colors.blue, Colors.white));
//  }
//
//  Color _randomExplosionColor() {
//    double rand = randomDouble();
//    if (rand < 0.25)
//      return Colors.pink[200];
//    else if (rand < 0.5)
//      return Colors.lightBlue[200];
//    else if (rand < 0.75)
//      return Colors.purple[200];
//    else
//      return Colors.cyan[200];
//  }
//
//  Future<ui.Image> loadImage(String url) async {
//    ImageStream stream = AssetImage(url).resolve(ImageConfiguration.empty);
//    Completer<ui.Image> completer = Completer<ui.Image>();
//    listener(ImageInfo frame, bool synchronousCall) {
//      final ui.Image image = frame.image;
//      completer.complete(image);
//      stream.removeListener(listener);
//    }
//    stream.addListener(listener);
//    return completer.future;
//  }
}
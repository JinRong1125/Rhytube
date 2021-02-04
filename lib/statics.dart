
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Constant {

  static double windowWidth;
  static double windowHeight;
  static double gameWidth;
  static double gameHeight;
  static double ratioWidth;
  static double ratioHeight;
  
  static double sheetPadding;
  static double sheetPaddingHalf;

  static double introductionJacket;
  static double introductionJacketPadding;

  static double movementHeight;
  static double movementPadding;
  static double movementTitlePadding;
  static double movementTitleSize;

  static double centerWidth;
  static double centerHeight;

  static double dyneLinePoint;
  static double dyneLineWidth;
  static double dyneFullScore;

  static double comboTextSize;
  static double comboTextHeight;
  static double comboTieBase;

  static double centerFirstPoint;
  static double centerSecondPoint;
  static double centerThirdPoint;
  static double centerForthPoint;
  static double centerFifthPoint;
  static double centerNoteWidth;

  static double outLineDistance;
  static double inLineDistance;
  static double noteMoveDistance;
  static double tieMoveDistance;

  static double lineWidth;
  static double halfLineWidth;
  static double bottomLine;
  static double firstLine;
  static double secondLine;
  static double thirdLine;
  static double topLine;

  static double leftTapPoint;
  static double rightTapPoint;

  static double noteWidth;
  static double noteHeight;
  static double halfNoteHeight;
  static double noteOutDistance;
  static double noteInDistance;

  static double leftLighterBottomPoint;
  static double rightLighterTopPoint;

  static double leftLighterPoint;
  static double rightLighterPoint;

  static double leftCenterPoint;
  static double leftNoteInPoint;
  static double leftNoteOutPoint;
  static double leftTieInPoint;
  static double leftTieOutPoint;

  static double rightCenterPoint;
  static double rightNoteInPoint;
  static double rightNoteOutPoint;
  static double rightTieInPoint;
  static double rightTieOutPoint;

  static double lighterFirstPoint;
  static double lighterSecondPoint;
  static double lighterThirdPoint;
  static double lighterForthPoint;

  static double tapStartRadius;
  static double tapEndRadius;
  static double tapDistanceRadius;
  static double holdStartRadius;
  static double holdEndRadius;
  static double holdDistanceRadius;

  static double playCount;
  static double startPlayTime;
  static double whiteRangeTime;
  static double orangeRangeTime;
  static double purpleRangeTime;
  static double dyneBaseTime;
  static double lighterTapTime;
  static double lighterHoldTime;

  static void initializeVariables(double width, double height) {
    windowWidth = width;
    windowHeight = height;
    gameWidth = height * 16 / 9 < width ? height * 16 / 9: width;
    gameHeight = height * 16 / 9 < width ? height: width * 9 / 16;
    
    ratioWidth = (windowWidth - gameWidth) * 0.5;
    ratioHeight = (windowHeight - gameHeight) * 0.5;

    sheetPadding = windowHeight * 0.02;
    sheetPaddingHalf = windowHeight * 0.01;

    introductionJacket = windowHeight * 0.5;
    introductionJacketPadding = windowHeight * 0.05;

    movementHeight = windowHeight * 0.192;
    movementPadding = windowHeight * 0.01;
    movementTitlePadding = windowWidth * 0.02;
    movementTitleSize = windowWidth * 0.03;

    centerWidth = windowWidth * 0.5;
    centerHeight = windowHeight * 0.5;

    dyneLinePoint = gameHeight * 0.08 + ratioHeight;
    dyneLineWidth = gameHeight * 0.04;
    dyneFullScore = gameWidth * 0.25;

    comboTextSize = gameHeight * 0.2;
    comboTextHeight = gameHeight * 0.74 + ratioHeight;
    comboTieBase = gameWidth * 0.2 * 0.002;

    centerFirstPoint = gameHeight * 0.625 + ratioHeight;
    centerSecondPoint = gameHeight * 0.5625 + ratioHeight;
    centerThirdPoint = gameHeight * 0.5 + ratioHeight;
    centerForthPoint = gameHeight * 0.4375 + ratioHeight;
    centerFifthPoint = gameHeight * 0.375 + ratioHeight;
    centerNoteWidth = gameHeight * 0.0625;

    outLineDistance = gameHeight * 0.375;
    inLineDistance = gameHeight * 0.1875;
    noteMoveDistance = gameWidth * 0.42;
    tieMoveDistance = gameWidth * 0.4;

    lineWidth = gameHeight * 0.005;
    halfLineWidth = gameHeight * 0.0025;
    bottomLine = gameHeight + ratioHeight;
    firstLine = gameHeight * 0.75 + ratioHeight;
    secondLine = gameHeight * 0.5 + ratioHeight;
    thirdLine = gameHeight * 0.25 + ratioHeight;
    topLine = ratioHeight;

    leftTapPoint = gameWidth * 0.2 + ratioWidth;
    rightTapPoint = gameWidth * 0.8 + ratioWidth;

    noteWidth = gameHeight * 0.25;
    noteHeight = gameWidth * 0.04;
    halfNoteHeight = gameWidth * 0.02;
    noteOutDistance = (noteHeight / tieMoveDistance) * outLineDistance;
    noteInDistance = (noteHeight / tieMoveDistance) * inLineDistance;

    leftLighterBottomPoint = gameWidth * 0.4975 + ratioWidth;
    rightLighterTopPoint = gameWidth * 0.5025 + ratioWidth;

    leftLighterPoint = gameWidth * 0.11 + ratioWidth;
    rightLighterPoint = gameWidth * 0.89 + ratioWidth;

    leftCenterPoint = gameWidth * 0.1 + ratioWidth;
    leftNoteInPoint = gameWidth * 0.16 + ratioWidth;
    leftNoteOutPoint = gameWidth * 0.04 + ratioWidth;
    leftTieInPoint = gameWidth * 0.14 + ratioWidth;
    leftTieOutPoint = gameWidth * 0.06 + ratioWidth;

    rightCenterPoint = gameWidth * 0.9 + ratioWidth;
    rightNoteInPoint = gameWidth * 0.84 + ratioWidth;
    rightNoteOutPoint = gameWidth * 0.96 + ratioWidth;
    rightTieInPoint = gameWidth * 0.86 + ratioWidth;
    rightTieOutPoint = gameWidth * 0.94 + ratioWidth;

    lighterFirstPoint = Constant.gameHeight * 0.875 + Constant.ratioHeight;
    lighterSecondPoint = Constant.gameHeight * 0.625 + Constant.ratioHeight;
    lighterThirdPoint = Constant.gameHeight * 0.375 + Constant.ratioHeight;
    lighterForthPoint = Constant.gameHeight * 0.125 + Constant.ratioHeight;

    tapStartRadius = gameHeight * 0.15;
    tapEndRadius = gameHeight * 0.21;
    tapDistanceRadius = gameHeight * 0.06;
    holdStartRadius = gameHeight * 0.17;
    holdEndRadius = gameHeight * 0.19;
    holdDistanceRadius = gameHeight * 0.02;

    playCount = 0;
    startPlayTime = 3;
    whiteRangeTime = 0.05;
    orangeRangeTime = 0.075;
    purpleRangeTime = 0.1;
    dyneBaseTime = 0.5;
    lighterTapTime = 0.3;
    lighterHoldTime = 0.1;
  }

  static Paint lighterPaint = Paint()
    ..color = Colors.white.withOpacity(0.2);
  static Paint linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.grey.withOpacity(0.75)
    ..strokeWidth = lineWidth;
  static Paint notePaint = Paint()
    ..color = Colors.lightBlueAccent;
  static Paint tiePaint = Paint()
    ..color = Colors.yellowAccent;
  static Paint greenPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.greenAccent
    ..strokeWidth = dyneLineWidth;
  static Paint redPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.pinkAccent
    ..strokeWidth = dyneLineWidth;
  static RadialGradient lighterRadialGradient = RadialGradient(colors: [
    Colors.white.withOpacity(1),
    Colors.white.withOpacity(0)
  ]);
}

enum Number {
  First,
  Second,
  Third,
  Forth
}

enum Direction {
  Left,
  Right
}

enum TapType {
  None,
  Left,
  Right
}
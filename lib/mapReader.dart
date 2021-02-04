import 'dart:async';
import 'dart:ui';
import 'dart:collection';

import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

import 'package:rhytube/model/Slur.dart';
import 'package:rhytube/recital/recitalCallback.dart';
import 'package:rhytube/recital/renderTrace.dart';
import 'package:rhytube/recital/renderNote.dart';
import 'package:rhytube/recital/renderTie.dart';
import 'package:rhytube/recital/renderSlur.dart';
import 'statics.dart';

class MapReader {

  RenderTraceCallback renderTraceCallback;

  String number = 'number';
  String bottomOffset = 'bottomOffset';
  String topOffset = 'topOffset';

  MapReader(this.renderTraceCallback);

  Future<List<List<RenderTrace>>> load(String map) async {
    List<RenderTrace> leftTraceList = List();
    List<RenderTrace> rightTraceList = List();

    String data = await rootBundle.loadString(map);
    List<List<dynamic>> mapTable = CsvToListConverter().convert(data);

    mapTable.forEach((map) {
      String objectType = map[0];
      String objectDirection = map[1];
      int objectNumber = map[2];
      double time = map[3];
      switch (objectType) {
        case 'N':
          switch (objectDirection) {
            case 'L':
              switch (objectNumber) {
                case 1:
                  leftTraceList.add(FirstLeftNote(renderTraceCallback, time, Number.First));
                  break;
                case 2:
                  leftTraceList.add(SecondLeftNote(renderTraceCallback, time, Number.Second));
                  break;
                case 3:
                  leftTraceList.add(ThirdLeftNote(renderTraceCallback, time, Number.Third));
                  break;
                case 4:
                  leftTraceList.add(ForthLeftNote(renderTraceCallback, time, Number.Forth));
                  break;
              }
              break;
            case 'R':
              switch (objectNumber) {
                case 1:
                  rightTraceList.add(FirstRightNote(renderTraceCallback, time, Number.First));
                  break;
                case 2:
                  rightTraceList.add(SecondRightNote(renderTraceCallback, time, Number.Second));
                  break;
                case 3:
                  rightTraceList.add(ThirdRightNote(renderTraceCallback, time, Number.Third));
                  break;
                case 4:
                  rightTraceList.add(ForthRightNote(renderTraceCallback, time, Number.Forth));
                  break;
              }
              break;
          }
          break;
        case 'T':
          double endTime = map[4];
          switch (objectDirection) {
            case 'L':
              switch (objectNumber) {
                case 1:
                  leftTraceList.add(FirstLeftTie(renderTraceCallback, time, endTime, Number.First));
                  break;
                case 2:
                  leftTraceList.add(SecondLeftTie(renderTraceCallback, time, endTime, Number.Second));
                  break;
                case 3:
                  leftTraceList.add(ThirdLeftTie(renderTraceCallback, time, endTime, Number.Third));
                  break;
                case 4:
                  leftTraceList.add(ForthLeftTie(renderTraceCallback, time, endTime, Number.Forth));
                  break;
              }
              break;
            case 'R':
              switch (objectNumber) {
                case 1:
                  rightTraceList.add(FirstRightTie(renderTraceCallback, time, endTime, Number.First));
                  break;
                case 2:
                  rightTraceList.add(SecondRightTie(renderTraceCallback, time, endTime, Number.Second));
                  break;
                case 3:
                  rightTraceList.add(ThirdRightTie(renderTraceCallback, time, endTime, Number.Third));
                  break;
                case 4:
                  rightTraceList.add(ForthRightTie(renderTraceCallback, time, endTime, Number.Forth));
                  break;
              }
              break;
          }
          break;
        case 'S':
          double endTime = map.last;
          List<Slur> modelList = List();
          HashMap offsetMap = getOffset(objectNumber);
          modelList.add(Slur(0, offsetMap[this.number], 0, offsetMap[bottomOffset], offsetMap[topOffset]));

          for (int i = 4; i < map.length; i += 2) {
            HashMap offsetMap = getOffset(map[i]);
            double time = map[i + 1];
            double length = (time - map[i - 1]) * renderTraceCallback.getSpeed();
            modelList.add(Slur(time + Constant.startPlayTime, offsetMap[this.number], length, offsetMap[bottomOffset], offsetMap[topOffset]));
          }
          switch (objectDirection) {
            case 'L':
              leftTraceList.add(LeftSlur(renderTraceCallback, time, endTime, modelList));
              break;
            case 'R':
              rightTraceList.add(RightSlur(renderTraceCallback, time, endTime, modelList));
              break;
          }
          break;
      }
    });

    return [leftTraceList, rightTraceList];
  }

  HashMap getOffset(int objectNumber) {
    Number number;
    double topDx;
    switch (objectNumber) {
      case 1:
        number = Number.First;
        topDx = Constant.centerFirstPoint;
        break;
      case 2:
        number = Number.Second;
        topDx = Constant.centerSecondPoint;
        break;
      case 3:
        number = Number.Third;
        topDx = Constant.centerThirdPoint;
        break;
      case 4:
        number = Number.Forth;
        topDx = Constant.centerForthPoint;
        break;
    }
    return HashMap()
      ..[this.number] = number
      ..[bottomOffset] = Offset(Constant.centerWidth, topDx - Constant.centerNoteWidth)
      ..[topOffset] = Offset(Constant.centerWidth, topDx);
  }
}
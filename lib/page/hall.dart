import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:rhytube/recital/recital.dart';
import 'package:rhytube/recital/widget.dart';
import 'package:rhytube/model/Movement.dart';

class HallWidget extends StatelessWidget {

  final Recital recital = Recital();

  HallWidget(Key key, Movement movement): super(key: key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      recital.load(movement);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
          children: [
            BoardWidget(),
            ScoreWidget(recital.scoreRenderBox),
            TapWidget(recital.tapRenderBox),
            TraceWidget(recital.traceRenderBox),
            PauseWidget(recital.recitalCallback)
          ]),
    );
  }
}

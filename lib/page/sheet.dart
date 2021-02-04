import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:rhytube/page/page.dart';
import 'package:rhytube/model/Movement.dart';
import 'package:rhytube/statics.dart';

class SheetWidget extends StatefulWidget {

  SheetWidget();

  @override
  State<StatefulWidget> createState() {
    return SheetState();
  }

  static SheetState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(SheetDataWidget) as SheetDataWidget).sheetState;
  }
}

class SheetState extends State<SheetWidget> {

  List<Movement> movementList;
  Movement movement;

  AudioPlayer audioPlayer;

  @override
  initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    audioPlayer.release();
    super.dispose();
  }

  initialize() async {
    movementList = List()
      ..add(Movement(
          0,
          'Test',
          'Test',
          'assets/particle.png',
          'test.mp3',
          '235',
          150,
          0,
          'assets/test.csv'
      ))
    ;
    movement = movementList.first;

    audioPlayer = AudioPlayer();
    await audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    playMusic();
  }

  selectMovement(Movement movement) {
    if (this.movement != movement) {
      setState(() {
        this.movement = movement;
      });
      playMusic();
    }
  }

  playMusic() async {
    AudioCache audioCache = AudioCache();
    String musicPath = (await audioCache.load(movement.music)).path;
    await audioPlayer.setUrl(musicPath);
    await audioPlayer.seek(Duration(milliseconds: (movement.previewTime * 1000).toInt()));
    audioPlayer.resume();
  }

  @override
  Widget build(BuildContext context) {
    return SheetDataWidget(
        sheetState: this,
        child: Container(
          color: Colors.black,
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: IntroductionWidget(movement)
              ),
              Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: CollectionWidget(movementList)
              )
            ],
          ),
        ),
    );
  }
}

class SheetDataWidget extends InheritedWidget {

  final SheetState sheetState;

  SheetDataWidget({key, this.sheetState, child}): super(key: key, child: child);

  @override
  bool updateShouldNotify(SheetDataWidget oldWidget) {
    return true;
  }
}

class IntroductionWidget extends StatelessWidget {

  final Movement movement;

  IntroductionWidget(this.movement);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            left: Constant.sheetPadding,
            top: Constant.sheetPadding,
            right: Constant.sheetPaddingHalf,
            bottom: Constant.sheetPadding
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  movement.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: Constant.movementTitleSize
                  )
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  movement.composer,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: Constant.movementTitleSize
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: Constant.introductionJacketPadding,
              ),
              child: GestureDetector(
                onTap: () {
                  PageWidget.of(context).startPlay(movement);
                },
                child: Image.asset(
                  movement.jacket,
                  width: Constant.introductionJacket,
                  height: Constant.introductionJacket,
                ),
              ),
            ),
          ],
        )
    );
  }
}

class CollectionWidget extends StatelessWidget {

  final List<Movement> movementList;

  CollectionWidget(this.movementList);

  List<MovementWidget> generateMovement() {
    List<MovementWidget> movementWidgetList = List();
    movementList.forEach((movement) {
      movementWidgetList.add(MovementWidget(movement));
    });
    return movementWidgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: Constant.sheetPaddingHalf,
          top: Constant.sheetPadding,
          right: Constant.sheetPadding,
          bottom: Constant.sheetPadding
      ),
      child: ListView(
          children: generateMovement()
      ),
    );
  }
}

class MovementWidget extends StatelessWidget {

  final Movement movement;

  MovementWidget(this.movement);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SheetWidget.of(context).selectMovement(movement);
      },
      child: Container(
          height: Constant.movementHeight,
          color: Colors.transparent,
          padding: EdgeInsets.only(
              top: Constant.movementPadding,
              bottom: Constant.movementPadding
          ),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Image.asset(
                  movement.jacket,
                  fit: BoxFit.fill
              ),
              Flexible(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(
                      left: Constant.movementTitlePadding
                  ),
                  child: Text(
                    movement.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: Constant.movementTitleSize
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}
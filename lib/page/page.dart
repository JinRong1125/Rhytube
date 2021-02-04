import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:rhytube/page/cover.dart';
import 'package:rhytube/page/hall.dart';
import 'package:rhytube/page/sheet.dart';
import 'package:rhytube/model/Movement.dart';
import 'package:rhytube/statics.dart';

class PageWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return PageState();
  }

  static PageState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(PageDataWidget) as PageDataWidget).pageState;
  }
}

class PageState extends State<PageWidget> {

  Widget mainWidget;

  @override
  initState() {
    super.initState();
    mainWidget = CoverWidget();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Material(
          child: PageDataWidget(
            pageState: this,
            child: mainWidget
          )
        )
    );
  }

  openSheet() {
    setState(() {
      mainWidget = SheetWidget();
    });
  }

  startPlay(Movement movement) {
    setState(() {
      mainWidget = HallWidget(Key((Constant.playCount++).toString()), movement);
    });
  }
}

class PageDataWidget extends InheritedWidget {

  final PageState pageState;

  PageDataWidget({key, this.pageState, child}): super(key: key, child: child);

  @override
  bool updateShouldNotify(PageDataWidget oldWidget) {
    return true;
  }
}
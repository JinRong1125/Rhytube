import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:rhytube/page/page.dart';
import 'package:rhytube/statics.dart';

class CoverWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        generateWindowSizes(context);
      },
      child: Container(
        color: Colors.green,
      ),
    );
  }

  generateWindowSizes(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets edgeInsets = MediaQuery.of(context).padding;
    double width = size.width;
    double height = size.height + (edgeInsets.top * 2);
    if (width > 0 && height > 0 && width > height) {
      Constant.initializeVariables(width, height);
      PageWidget.of(context).openSheet();
    }
  }
}
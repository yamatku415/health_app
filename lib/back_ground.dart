import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, contraint) {
      final height = contraint.maxHeight;
      final width = contraint.maxWidth;

      return Stack(
        children: <Widget>[
          Container(
            color: Color(0xFFDAE5D2),
          ),
          Positioned(
            top: height * 0.20,
            left: height * 0.35,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white.withOpacity(0.4)),
            ),
          ),
          Positioned(
            top: -height * 0.10,
            left: -height * 0.39,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white.withOpacity(0.2)),
            ),
          ),
        ],
      );
    });
  }
}

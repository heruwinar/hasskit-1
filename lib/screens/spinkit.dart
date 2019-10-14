import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SpinKit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SpinKitFadingGrid(
          size: 100.0,
          itemBuilder: (_, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(4),
                color: index.isEven ? Colors.black26 : Colors.grey,
//              color: Settings.randomColor,
              ),
            );
          },
        ),
//        Center(
//          child: Text(
//            'Loading data',
//            style: Styles.buttonText,
//          ),
//        ),
      ],
    );
  }
}

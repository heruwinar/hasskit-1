import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hasskit/utils/style.dart';

class SpinKit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SpinKitThreeBounce(
          color: Colors.amber,
          size: 50.0,
        ),
        Center(
          child: Text(
            'Please Check Your \nHome Assistant Connection',
            textAlign: TextAlign.center,
            style: Styles.textEntityNameInActive,
          ),
        ),
      ],
    );
  }
}

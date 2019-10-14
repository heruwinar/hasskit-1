import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hasskit/model/provider_data.dart';
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
            (providerData.hassUrl == null || providerData.hassUrl.length < 1)
                ? 'Please check your home assistant setting'
                : providerData.autoConnect
                    ? 'Connecting to ${providerData.hassUrl}'
                    : 'Please go to setting and \nSetup Home Assistant Connection',
            textAlign: TextAlign.center,
            style: Styles.textEntityNameInActive,
          ),
        ),
      ],
    );
  }
}

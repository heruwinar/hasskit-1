import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hasskit/model/ProviderData.dart';
import 'package:hasskit/utils/Style.dart';

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
                ? 'Please Check Your Home Assistant Setting'
                : providerData.autoConnect
                    ? 'Connecting To ${providerData.hassUrl}'
                    : 'Please Open Setting Tab and \nSetup Home Assistant Connection',
            textAlign: TextAlign.center,
            style: Styles.textEntityNameInActive,
          ),
        ),
//        Center(
//          child: Text(
//              'hassUrl == null ${providerData.hassUrl == null} length < 1 ${providerData.hassUrl.length < 1} autoConnect ${providerData.autoConnect}'),
//        ),
      ],
    );
  }
}

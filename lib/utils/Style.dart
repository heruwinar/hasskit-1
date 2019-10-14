// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

abstract class Styles {
  static const TextStyle textEntityGroupType = TextStyle(
    color: Color.fromRGBO(255, 255, 255, 0.8),
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle textEntityNameActive = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle textEntityNameInActive = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.5),
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle textEntityStatus = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.5),
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle textEntityStatusSensorActive = TextStyle(
    color: Color.fromRGBO(255, 0, 0, 0.8),
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle inputText = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 1),
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle textButton = TextStyle(
    color: Color.fromRGBO(0, 128, 255, 0.8),
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static const Color entityBackgroundActive =
      Color.fromRGBO(255, 255, 255, 0.8);
  static const Color entityBackgroundInActive =
      Color.fromRGBO(255, 255, 255, 0.25);
  static const Color entityIconActive = Color(0xFFFFC107);
  static const Color entityIconInActive = Color.fromRGBO(0, 0, 0, 0.25);

  static const Color amberA80 = Color.fromRGBO(255, 192, 0, 0.8);
  static const Color amberA50 = Color.fromRGBO(255, 192, 0, 0.5);
  static const Color amber50 = Color(0xFFFFF8E1);
  static const Color amber100 = Color(0xFFFFECB3);
  static const Color amber200 = Color(0xFFFFE082);
  static const Color amber300 = Color(0xFFFFD54F);
  static const Color amber400 = Color(0xFFFFCA28);
  static const Color amber500 = Color(0xFFFFC107);
  static const Color amber600 = Color(0xFFFFB300);
  static const Color amber700 = Color(0xFFFFA000);
  static const Color amber800 = Color(0xFFFF8F00);
  static const Color amber900 = Color(0xFFFF6F00);

  static const Color white20 = Color.fromRGBO(255, 255, 255, 0.2);
  static const Color white50 = Color.fromRGBO(255, 255, 255, 0.5);
  static const Color white80 = Color.fromRGBO(255, 255, 255, 0.8);
  static const Color black50 = Color.fromRGBO(0, 0, 0, 0.5);
}

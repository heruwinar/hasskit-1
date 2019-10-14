import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hasskit/model/Entity.dart';
import 'package:hasskit/utils/Settings.dart';
import 'package:hasskit/utils/Style.dart';

import 'EntityButtonRectangle.dart';
import 'EntityButtonSquare.dart';

class EntityButton extends StatelessWidget {
  final Function onTapCallback;
  final Function onLongPressCallback;
  final Entity entity;

  const EntityButton(
      {this.entity, this.onTapCallback, this.onLongPressCallback});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      color: entity.isBackgroundOn
          ? Styles.entityBackgroundActive
          : Styles.entityBackgroundInActive,
      child: InkResponse(
        onTap: onTapCallback,
        onLongPress: onLongPressCallback,
        child: entity.entityType == EntityType.cameras
            ? EntityButtonRectangle(entity: entity)
            : EntityButtonSquare(entity: entity),
      ),
    );
  }
}

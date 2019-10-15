import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hasskit/model/Entity.dart';
import 'package:hasskit/utils/Settings.dart';
import 'package:hasskit/utils/Style.dart';

class EntityButtonSquare extends StatelessWidget {
  final Entity entity;

  EntityButtonSquare({@required this.entity});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FittedBox(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: entity.entityType == EntityType.others &&
                                  entity.isIconOn
                              ? Border.all(
                                  width: 4,
                                  color: Styles.entityIconActive,
                                )
                              : null,
                          color: entity.iconBackgroundColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        width: 100,
                        height: 100,
                      ),
                      Icon(
                        entity.mdiIcon,
                        size: 100,
                        color: entity.iconColor,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: entity.topRightWidget,
                ),
              ],
            ),
          ),
          Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "${entity.friendlyName}",
                  style: entity.isBackgroundOn
                      ? Styles.textEntityNameActive
                      : Styles.textEntityNameInActive,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textScaleFactor: Settings.textScaleFactor,
                ),
              )),
          Expanded(
              flex: 1,
              child: Text(
                entity.stateCap,
                style: entity.entityType == EntityType.others && entity.isIconOn
                    ? Styles.textEntityStatusSensorActive
                    : Styles.textEntityStatus,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textScaleFactor: Settings.textScaleFactor,
              )),
        ],
      ),
    );
  }
}

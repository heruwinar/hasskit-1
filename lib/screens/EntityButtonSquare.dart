import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hasskit/model/Entity.dart';
import 'package:hasskit/model/ProviderData.dart';
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
                          color: entity.entityType == EntityType.others &&
                                  entity.isIconOn
                              ? Colors.green
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        width: 100,
                        height: 100,
                      ),
                      Icon(
                        entity.mdiIcon,
                        size: 100,
                        color: entity.isIconOn == true
                            ? Styles.entityIconActive
                            : Styles.entityIconInActive,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FittedBox(
                    alignment: Alignment.centerRight,
                    child: entity.state.contains('...')
                        ? SpinKitThreeBounce(
                            color: entity.isBackgroundOn == true
                                ? Styles.entityIconActive
                                : Styles.entityIconInActive,
                            size: 100,
                          )
                        : !providerData.serverConnected
                            ? SpinKitFadingCircle(
                                color: entity.isBackgroundOn == true
                                    ? Styles.entityIconActive
                                    : Styles.entityIconInActive,
                                size: 100,
                              )
                            : Container(),
                  ),
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

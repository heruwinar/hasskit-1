import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hasskit/model/entity.dart';
import 'package:hasskit/utils/style.dart';

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
                  child: Icon(
                    entity.mdiIcon,
                    size: 100,
                    color: entity.isIconOn == true
                        ? Styles.entityIconActive
                        : Styles.entityIconInActive,
                  ),
                ),
                Expanded(
                  child: FittedBox(
                    child: entity.state.contains('...')
                        ? SpinKitThreeBounce(
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
                  textScaleFactor: 1,
                ),
              )),
          Expanded(
              flex: 1,
              child: Text(
                entity.stateCap,
//                    entity.entityId,
                style: Styles.textEntityStatus,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textScaleFactor: 1,
              )),
        ],
      ),
    );
  }
}

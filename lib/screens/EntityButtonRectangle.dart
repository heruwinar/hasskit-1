import 'package:flutter/material.dart';
import 'package:hasskit/model/Entity.dart';
import 'package:hasskit/model/ProviderData.dart';
import 'package:hasskit/utils/Style.dart';

class EntityButtonRectangle extends StatefulWidget {
  final Entity entity;

  EntityButtonRectangle({@required this.entity});

  @override
  _EntityButtonRectangleState createState() => _EntityButtonRectangleState();
}

class _EntityButtonRectangleState extends State<EntityButtonRectangle> {
  void dispose() {
    if (widget.entity.entityId.contains('camera.') &&
        providerData.cameraActives.contains(widget.entity.entityId)) {
      print('cameraActives remove ${widget.entity.entityId}');
      providerData.cameraActives.remove(widget.entity.entityId);
    }
    super.dispose();
  }

  @override
  void initState() {
    if (widget.entity.entityId.contains('camera.') &&
        !providerData.cameraActives.contains(widget.entity.entityId)) {
      print('cameraActives add ${widget.entity.entityId}');
      providerData.cameraActives.add(widget.entity.entityId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: providerData.getCameraImage(widget.entity.entityId),
            ),
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                color: Styles.entityBackgroundActive,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, top: 4, bottom: 4),
                      child: Text(
                        '${widget.entity.friendlyName}',
                        style: Styles.textEntityNameActive,
                        textScaleFactor: 1,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 8.0, top: 4, bottom: 4),
                      child: Text(
                        '${widget.entity.state}',
                        style: Styles.textEntityNameActive,
                        textScaleFactor: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

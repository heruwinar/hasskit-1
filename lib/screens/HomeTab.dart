import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hasskit/model/ProviderData.dart';
import 'package:hasskit/model/Entity.dart';
import 'package:hasskit/screens/SliverGridEntity.dart';
import 'package:hasskit/utils/Settings.dart';
import 'SliverListGroupTitle.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String title = '';
    List<Entity> entities = [];
    if (providerData.cards.length > 0) {
      String cardsKey = providerData.cards.keys.toList()[0] ?? '';
//      print('cardsKey $cardsKey');
      title = cardsKey.split('.').last;
//      print('title $title');
      for (int i = 0; i < providerData.cards[cardsKey].length; i++) {
        var entity = providerData.cards[cardsKey][i];
//      print('entityId $entityId');
//      print('entity.entityId ${entity.entityId}');
        entities.add(entity);
      }
    }

    var lightSwitches =
        Settings.entityTypeFilter(entities, EntityType.lightSwitches);
    var cameras = Settings.entityTypeFilter(entities, EntityType.cameras);
    var climateFans =
        Settings.entityTypeFilter(entities, EntityType.climateFans);
    var mediaPlayers =
        Settings.entityTypeFilter(entities, EntityType.mediaPlayers);
    var others = Settings.entityTypeFilter(entities, EntityType.others);

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(Settings.getRoomImage(2)), fit: BoxFit.cover),
      ),
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text(title),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  width: 50,
                  child: FlatButton(
                    onPressed: () {
//                      var entity = Entity(
//                          icon: 'mdi:power',
//                          entityId: 'switch.home',
//                          friendlyName: 'switch home',
//                          state: 'on');
//                      providerData.addEntity(entity);
                    },
                    child: Icon(
                      Icons.menu,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverListGroupTitle(
              entities: lightSwitches, title: 'Lights and Switches'),
          SliverGridEntity(
              entities: lightSwitches, crossAxisCount: 3, childAspectRatio: 1),
          SliverListGroupTitle(
              entities: climateFans, title: 'Air Conditioners and Fans'),
          SliverGridEntity(
              entities: climateFans,
              crossAxisCount: 3,
              childAspectRatio: 8 / 8),
          SliverListGroupTitle(entities: cameras, title: 'Cameras'),
          SliverGridEntity(
              entities: cameras, crossAxisCount: 1, childAspectRatio: 8 / 5),
          SliverListGroupTitle(entities: mediaPlayers, title: 'Media Players'),
          SliverGridEntity(
              entities: mediaPlayers,
              crossAxisCount: 3,
              childAspectRatio: 8 / 8),
          SliverListGroupTitle(entities: others, title: 'Sensors'),
          SliverSafeArea(
            bottom: true,
            minimum: EdgeInsets.only(bottom: 100),
            sliver: SliverGridEntity(
              entities: others,
              crossAxisCount: 3,
              childAspectRatio: 8 / 8,
            ),
          ),
        ],
      ),
    );
  }
}

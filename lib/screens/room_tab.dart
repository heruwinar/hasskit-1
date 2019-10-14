import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hasskit/model/entity.dart';
import 'package:hasskit/screens/room_page.dart';
import 'package:hasskit/model/provider_data.dart';
import 'package:hasskit/utils/settings.dart';

class RoomTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: PageView.builder(
        itemBuilder: (context, position) {
          String cardsKey = providerData.cards.keys.toList()[position + 1];
          String title = cardsKey.split('.').last;
          List<Entity> entityList = [];
          for (int i = 0; i < providerData.cards[cardsKey].length; i++) {
            Entity entity = providerData.cards[cardsKey][i];
            if (entity == null) {
              print('Warning can not find ${entity.entityId}');
            }
            entityList.add(entity);
          }
          return RoomPage(
              title: title,
              entities: entityList,
              assetImage: Settings.getRoomImage(position));
        },
        itemCount: providerData.getCardsMapLength() - 1 > 0
            ? providerData.getCardsMapLength() - 1
            : 0,
      ),
    );
  }
}

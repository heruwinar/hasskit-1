//class GetEntities {
//
//  final entityContext = Provider.of<Entities>(context);
//
//  void getEntities() async {
//    print('getImages');
//
//    final response = await http.get(
//      kUrl,
//      headers: kHeaders,
//    );
//
//    if (response.statusCode == 200) {
//      List listDecodedData = jsonDecode(response.body) as List;
//      List<Entity> entities =
//      listDecodedData.map((i) => Entity.fromJson(i)).toList();
//      for (var entity in entities) {
////        print(
////            'friendly_name ${entity.friendlyName} icon ${entity.icon} entity_id ${entity.entityId} state ${entity.state}');
//
//        Entities.addEntity(entity);
//      }
//    } else {
//      print('response.statusCode ${response.statusCode}');
//    }
//  }
//}

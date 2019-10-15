import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hasskit/model/CameraThumbnail.dart';
import 'package:hasskit/model/Climate.dart';
import 'dart:collection';
import 'package:hasskit/model/Entity.dart';
import 'package:hasskit/utils/Settings.dart';
import 'package:hasskit/utils/WebSocketConnection.dart';

Map<String, List<Entity>> roomMap = {};
ProviderData providerData;

class ProviderData with ChangeNotifier {
  List<Entity> _entities = [];
  List<Climate> _climates = [];

  int socketIdGetStates;

  int socketIdLovelaceConfig;

  int socketIdSubscribeEvents;

  UnmodifiableListView<Entity> get entities {
    return UnmodifiableListView(_entities);
  }

  UnmodifiableListView<Climate> get climates {
    return UnmodifiableListView(_climates);
  }

  int get entityCount {
    return entities.length ?? 0;
  }

  void toggleStatus(Entity entity) {
//    print(
//        'entityId ${entity.entityId} friendlyName ${entity.friendlyName} icon ${entity.icon} getDefaultIcon ${entity.getDefaultIcon}');
    if (entity.entityType != EntityType.lightSwitches &&
        entity.entityType != EntityType.climateFans &&
        entity.entityType != EntityType.mediaPlayers) {
      return;
    }

    entity.toggleState();
    notifyListeners();
  }

  void addEntity(Entity entity) {
    if (["", null].contains(entity.friendlyName)) {
      return;
    }

    for (var rec in Settings.notSupportedDeviceType) {
      if (entity.entityId.contains(rec)) {
        return;
      }
    }
    entities.add(entity);
//    print('addEntity ${entity.entityId} ($entityCount)');
    notifyListeners();
  }

  String _connectionError = '';
  String get connectionError => _connectionError;
  set connectionError(String val) {
    _connectionError = val;
    if (val != '') {
      print('set connectionError to $val');
    }
    notifyListeners();
  }

  String _connectionStatus = '';
  String get connectionStatus => _connectionStatus;
  set connectionStatus(String val) {
    _connectionStatus = val;
//    if (val != '') {
//      print('set connectionStatus to $val');
//    }
    notifyListeners();
  }

  String _authenticationStatus = '';
  String get authenticationStatus => _authenticationStatus;
  set authenticationStatus(String val) {
    _authenticationStatus = val;
    if (val != '') {
      print('set authenticationStatus to $val');
    }
    notifyListeners();
  }

  bool _serverConnected = false;
  bool get serverConnected => _serverConnected;
  set serverConnected(bool val) {
    _serverConnected = val;
    notifyListeners();
  }

  bool _useSsl = false;
  bool get useSsl => _useSsl;
  set useSsl(bool val) {
    _useSsl = val;
    notifyListeners();
  }

  bool _autoConnect = false;
  bool get autoConnect => _autoConnect;
  set autoConnect(bool val) {
    _autoConnect = val;
    notifyListeners();
  }

  String _hassUrl = 'abc';
  String get hassUrl => _hassUrl;
  set hassUrl(String val) {
    _hassUrl = val;
    val != '' ?? print('set hassUrl to $val');
    notifyListeners();
  }

  String _hassToken = '';
  String get hassToken => _hassToken;
  set hassToken(String val) {
    _hassToken = val;
    val != '' ?? print('set hassToken to $val');
    notifyListeners();
  }

  String get socketUrl {
    return useSsl
        ? 'wss://$hassUrl/api/websocket'
        : 'ws://$hassUrl/api/websocket';
  }

  int _socketId = 1;
  int get socketId => _socketId;
  set socketId(int val) {
    _socketId = val;
    notifyListeners();
  }

  void socketIdIncrement() {
    socketId = socketId + 1;
  }

  List<Entity> badges = [];
  Map<String, List<Entity>> cards = {};

  int getCardsMapLength() {
    var listKey = cards.keys.toList();
    return listKey.length;
  }

  void socketGetStates(List<dynamic> message) {
    _entities.clear();
    _climates.clear();

    for (dynamic mess in message) {
      Entity entity = Entity.fromJson(mess);
      _entities.add(entity);
//      print('entity ${entity.entityId} ${entity.friendlyName}');
      if (entity.entityId.contains('climate.')) {
        Climate climate = Climate.fromJson(mess);
        _climates.add(climate);
      }
    }

    print('_entities.length ${entities.length}');
    print('_climates.length ${_climates.length}');

    int i = 1;
    for (Climate climate in climates) {
      print('$i. GetStates climate ${climate.entityId}');
      i++;
    }
    notifyListeners();
  }

  void socketLovelaceConfig(dynamic message) {
    badges.clear();
    cards.clear();

    var title = message['result']['title'];
    print('title $title');
    var viewNumber = 0;
    var cardNumber = 0;

    List<dynamic> viewsParse = message['result']['views'];
    print('viewsParse.length ${viewsParse.length}');

    for (var viewParse in viewsParse) {
      //iterate over the list
      var titleView = viewParse['title'];
//      if (titleView == null) {
//        titleView = 'Unnamed $cardNumber';
//      }
      List<dynamic> badgesParse = viewParse['badges'];
      List<Entity> tempListView = [];
//      print(
//          '\nviewNumber $viewNumber badgesParse.length ${badgesParse.length}');

      List<Entity> tempListEntities = [];
      for (var badgeParse in badgesParse) {
//        print('badgeParse $badgeParse');
        entityValidationAdd(badgeParse.toString(), tempListEntities);
      }

      for (var entity in tempListEntities) {
        if (!badges.contains(entity)) {
          badges.add(entity);
        }
      }
//      print('badges.length ${badges.length}');

      List<dynamic> cardsParse = viewParse['cards'];
      print('viewNumber $viewNumber cardsParse.length ${cardsParse.length}');

      for (var cardParse in cardsParse) {
        var titleCard = cardParse['title'];
//        if (titleCard == null) {
//          titleCard = 'Unnamed $cardNumber';
//        }
        var type = cardParse['type'];
        print('cardParse title $title type $type');

        //entities type = 1 page view
        if (type == 'entities' || type == 'glance') {
          List<dynamic> entitiesParse = cardParse['entities'];
          List<Entity> tempListEntities = [];

          for (var entityParse in entitiesParse) {
            entityValidationAdd(entityParse.toString(), tempListEntities);
          }
          if (tempListEntities.length > 0) {
            cards['[$viewNumber-$cardNumber].$titleView.$titleCard'] =
                tempListEntities;
          }
          //all none entities in 1 pageview
        } else {
          var entityParse = cardParse['entity'];
          entityValidationAdd(entityParse.toString(), tempListView);
        }

        //Don't add empty card

        cardNumber++;
      }
      if (tempListView.length > 0) {
        cards['[$viewNumber-$cardNumber].$titleView'] = tempListView;
      }
      viewNumber++;
      cardNumber = 0;
    }

    print('\nbadges.length ${badges.length}');
//    for (int i = 0; i < badges.length; i++) {
//      print('  - ${i + 1}. ${badges[i].entityId}');
//    }

    print('\ncards.length ${cards.length}');
//    var cardsKeys = cards.keys.toList();
//    for (var cardsKey in cardsKeys) {
////      print('\ncardskey $cardsKey length ${cards[cardsKey].length}');
//      int i = 0;
//      for (var entity in cards[cardsKey]) {
////        print('  - ${i + 1}. ${entity.entityId}');
//        i++;
//      }
//    }

    notifyListeners();
  }

  void entityValidationAdd(String entityId, List<Entity> list) {
    if (entityId == null) {
      print('entityValidationAdd $entityId null');
      return;
    }
    String entityIdOriginal = entityId;
    entityId = entityId.split(',').first;

    if (!entityId.contains('.')) {
      print('entityValidationAdd $entityIdOriginal not valid');
      return;
    }

    entityId = entityId.replaceAll('{entity: ', '');
    entityId = entityId.replaceAll('}', '');

    Entity entity;

    try {
      entity = entities.firstWhere((e) => e.entityId == entityId,
          orElse: () => null);
      if (entity != null) {
        list.add(entity);
      }
    } catch (e) {
      print('entityValidationAdd Error finding $entityId - $e');
    }
  }

  void socketSubscribeEvents(dynamic message) {
    Entity newEntity = Entity.fromJson(message['event']['data']['new_state']);
    Entity oldEntity = entities.firstWhere(
        (e) => e != null && e.entityId == newEntity.entityId,
        orElse: () => null);

    if (oldEntity != null) {
      oldEntity.state = newEntity.state;
      oldEntity.icon = newEntity.icon;
      oldEntity.friendlyName = newEntity.friendlyName;
//      print('Replace old oldEntity ${oldEntity.entityId}');
    } else {
      _entities.add(newEntity);
      print('WTF newEntity ${newEntity.entityId}');
    }

    if (newEntity != null && newEntity.entityId.contains('climate.')) {
      Climate newClimate =
          Climate.fromJson(message['event']['data']['new_state']);

      var oldClimate = climates.firstWhere(
          (e) => e != null && e.entityId == newClimate.entityId,
          orElse: () => null);

      if (oldClimate != null) {
        oldClimate.state = newClimate.state;
        oldClimate.hvacModes = newClimate.hvacModes;
        oldClimate.minTemp = newClimate.minTemp;
        oldClimate.maxTemp = newClimate.maxTemp;
        oldClimate.targetTempStep = newClimate.targetTempStep;
        oldClimate.temperature = newClimate.temperature;
        oldClimate.fanMode = newClimate.fanMode;
        oldClimate.fanModes = newClimate.fanModes;
        oldClimate.deviceCode = newClimate.deviceCode;
        oldClimate.manufacturer = newClimate.manufacturer;
//        print('Replace old oldClimate ${oldClimate.entityId}');
      } else {
        _climates.add(newClimate);
        print('WTF newClimate ${newClimate.entityId}');
      }
    }
    notifyListeners();
  }

  bool _loadingData = false;
  bool get loadingData => _loadingData;
  set loadingData(bool val) {
    _loadingData = val;
    notifyListeners();
  }

  Map<int, String> cameraThumbnailsId = {};
  Map<String, DateTime> cameraRequestTime = {};
  Map<String, CameraThumbnail> cameraThumbnails = {};
  List<String> cameraActives = [];

  requestCameraImage(String entityId) {
    var outMsg = {
      "id": providerData.socketId,
      "type": "camera_thumbnail",
      "entity_id": entityId,
    };

    var rand = Random().nextInt(4) - 2;
    cameraRequestTime[entityId] = DateTime.now().add(Duration(seconds: rand));
//    print('requestCameraImage $entityId $rand');
    sockets.send(json.encode(outMsg));
  }

  DecorationImage getCameraImage(String entityId) {
    var cameraThumbnail = cameraThumbnails[entityId];
    if (cameraThumbnail == null || cameraThumbnail.content.length < 1) {
      return DecorationImage(
        image: AssetImage('assets/images/loader.gif'),
        fit: BoxFit.cover,
      );
    }
    return DecorationImage(
      image: MemoryImage(cameraThumbnail.content),
      fit: BoxFit.cover,
    );
  }

  void camerasThumbnailUpdate(String entityId, String content) {
    CameraThumbnail cameraThumbnail = CameraThumbnail(
      entityId: entityId,
      receivedDateTime: DateTime.now(),
      content: base64Decode(content),
    );

    cameraThumbnails[entityId] = cameraThumbnail;
    notifyListeners();
  }

//  void updateTask(Task task) {
//    task.toggleDone();
//    notifyListeners();
//  }
//
//  void deleteTask(Task task) {
//    _tasks.remove(task);
//    notifyListeners();
//  }

}

//class EntityJsonList {
//  final List<EntityJson> entityJsonList;
//
//  EntityJsonList({
//    this.entityJsonList,
//  });
//
//  factory EntityJsonList.fromJson(List<dynamic> parsedJson) {
//    List<EntityJson> entityJsons = new List<EntityJson>();
//    entityJsons = parsedJson.map((i) => EntityJson.fromJson(i)).toList();
//
//    return new EntityJsonList(entityJsonList: entityJsons);
//  }
//}

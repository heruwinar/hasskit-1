import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hasskit/model/Climate.dart';
import 'package:hasskit/model/ProviderData.dart';
import 'package:hasskit/utils/mdi.class.dart';
import 'package:hasskit/utils/Settings.dart';
import 'package:hasskit/utils/WebSocketConnection.dart';

import '../utils/Style.dart';

class Entity {
  String friendlyName;
  String icon;
  final String entityId;
  String state;

  Entity({
    this.friendlyName,
    this.icon,
    this.entityId,
    this.state,
  });

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      icon: json['attributes']['icon'],
      friendlyName: json['attributes']['friendly_name'],
      entityId: json['entity_id'],
      state: json['state'],
    );
  }

  bool get isBackgroundOn {
    if (entityType != EntityType.lightSwitches &&
        entityType != EntityType.climateFans &&
        entityType != EntityType.mediaPlayers) {
      return false;
    }

    var stateLower = state.toLowerCase();
    if ([
      'on',
      'turning on...',
      'open',
      'opening...',
      'unlocked',
      'unlocking...'
    ].contains(stateLower)) {
      return true;
    }

    if (entityId.split('.')[0] == 'climate' && state.toLowerCase() != 'off') {
      return true;
    }
    return false;
  }

  bool get isIconOn {
    var stateLower = state.toLowerCase();
    if (['on', 'open', 'unlocked'].contains(stateLower)) {
      return true;
    }

    if (entityId.split('.')[0] == 'climate' && state.toLowerCase() != 'off') {
      return true;
    }
    return false;
  }

  String get getDefaultIcon {
    if (entityId.contains('lock.') && isIconOn) {
      return 'mdi:lock-open';
    }

    if (!["", null].contains(icon)) {
      return icon;
    }

    var deviceClass = entityId.split('.')[0];
    var deviceName = entityId.split('.')[1];

    if ([null, ''].contains(deviceClass) || [null, ''].contains(deviceName)) {
      return 'mdi:help-circle';
    }

    if (iconOverrider.containsKey(deviceClass)) {
      return '${iconOverrider[deviceClass]}';
    }

    if (deviceName.contains('automation')) {
      return 'mdi:home-automation';
    }
    if (deviceName.contains('cover')) {
      return isIconOn ? 'mdi:garage-open' : 'mdi:garage';
    }
    if (deviceName.contains('door_window')) {
      return isIconOn ? 'mdi:window-open' : 'mdi:window-closed';
    }
    if (deviceName.contains('illumination')) {
      return 'mdi:brightness-4';
    }
    if (deviceName.contains('humidity')) {
      return 'mdi:water-percent';
    }
    if (deviceName.contains('light')) {
      return 'mdi:brightness-4';
    }
    if (deviceName.contains('motion')) {
      return isIconOn ? 'mdi:run' : 'mdi:walk';
    }
    if (deviceName.contains('pressure')) {
      return 'mdi:gauge';
    }
    if (deviceName.contains('smoke')) {
      return 'mdi:fire';
    }
    if (deviceName.contains('temperature')) {
      return 'mdi:thermometer';
    }
    if (deviceName.contains('time')) {
      return 'mdi:clock';
    }
    if (deviceName.contains('switch')) {
      return 'mdi:toggle-switch';
    }
    if (deviceName.contains('water_leak')) {
      return 'mdi:water-off';
    }
    if (deviceName.contains('water')) {
      return 'mdi:water';
    }
    if (deviceName.contains('yr_symbol')) {
      return 'mdi:weather-partlycloudy';
    }

    return 'mdi:help-circle';
  }

  Map<String, String> iconOverrider = {
    'automation': 'mdi:home-automation',
    'camera': 'mdi:camera',
    'climate': 'mdi:thermostat',
    'cover': 'mdi:garage',
    'fan': 'mdi:fan',
    'group': 'mdi:group',
    'light': 'mdi:lightbulb',
    'lock': 'mdi:lock',
    'media_player': 'mdi:cast',
    'person': 'mdi:account',
    'sun': 'mdi:white-balance-sunny',
    'script': 'mdi:script-text',
    'switch': 'mdi:power',
    'timer': 'mdi:timer',
    'vacuum': 'mdi:robot-vacuum',
    'weather': 'mdi:weather-partlycloudy',
  };

  IconData get mdiIcon {
//    print('mdiIcon $getDefaultIcon');
    return IconData(MaterialDesignIcons.getIconCodeByIconName(getDefaultIcon),
        fontFamily: 'Material Design Icons');
  }

  String get stateCap {
    if (state.length > 1) {
      return state[0].toUpperCase() + state.substring(1);
    } else if (state.length > 0) {
      return state[0].toUpperCase();
    } else {
      return '???';
    }
  }

  toggleState() {
    var domain = entityId.split('.').first;
    var service = '';
    if (state == 'on' ||
        state == 'turning on...' ||
        domain == 'climate' && state != 'off') {
      state = 'turning off...';
      service = 'turn_off';
    } else if (state == 'off' || state == 'turning off...') {
      state = 'turning on...';
      service = 'turn_on';
    }
    if (state == 'open' || state == 'opening...') {
      state = 'closing...';
      service = 'close_cover';
    } else if (state == 'closed' || state == 'closing...') {
      state = 'opening...';
      service = 'open_cover';
    }
    if (state == 'locked' || state == 'locking...') {
      state = 'unlocking...';
      service = 'unlock';
    } else if (state == 'unlocked' || state == 'unlocking...') {
      state = 'locking...';
      service = 'lock';
    }
    var outMsg = {
      "id": providerData.socketId,
      "type": "call_service",
      "domain": domain,
      "service": service,
      "service_data": {"entity_id": entityId}
    };

    var outMsgEncoded = json.encode(outMsg);
    print('outMsgEncoded $outMsgEncoded');
    sockets.send(outMsgEncoded);
//    print('Toggle: $outMsgEncoded  ${Settings.dTHhMmSS}');
//    await Future.delayed(const Duration(seconds: 10), () {});
//
//    outMsg = {"id": providerData.socketId, "type": "get_states"};
//
//    outMsgEncoded = json.encode(outMsg);
////    print('outMsgEncoded $outMsgEncoded');
//    sockets.send(outMsgEncoded);
//    print('delayed: $outMsgEncoded ${Settings.dTHhMmSS})');
  }

  EntityType get entityType {
    if (entityId.contains('fan.') || entityId.contains('climate.')) {
      return EntityType.climateFans;
    } else if (entityId.contains('camera.')) {
      return EntityType.cameras;
    } else if (entityId.contains('media_player.')) {
      return EntityType.mediaPlayers;
    } else if (entityId.contains('light.') ||
        entityId.contains('switch.') ||
        entityId.contains('cover.') ||
        entityId.contains('input_boolean.') ||
        entityId.contains('lock.') ||
        entityId.contains('vacuum.')) {
      return EntityType.lightSwitches;
    } else {
      return EntityType.others;
    }
  }

  Color get iconColor {
    if (isIconOn) {
      if (entityId.contains('climate.')) {
        if (state.contains('heat')) {
          return Styles.red500;
        } else if (state.contains('cool')) {
          return Styles.greed500;
        }
      }
      return Styles.entityIconActive;
    }

    return Styles.entityIconInActive;
  }

  Color get iconBackgroundColor {
    if (isIconOn && entityType == EntityType.others) {
      return Styles.greed500;
    }

    return Colors.transparent;
  }

  Widget get topRightWidget {
    if (!providerData.serverConnected) {
      return FittedBox(
        alignment: Alignment.centerRight,
        child: SpinKitFadingCircle(
          color: Styles.white50,
          size: 100,
        ),
      );
    }
    if (state.contains('...')) {
      return FittedBox(
        alignment: Alignment.centerRight,
        child: SpinKitThreeBounce(
          color: iconColor,
          size: 100,
        ),
      );
    }
    if (entityId.contains('climate')) {
      Climate climate = providerData.climates.firstWhere(
          (e) => e != null && e.entityId == entityId,
          orElse: () => null);

      if (climate != null) {
        return Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${climate.temperature}°',
            style: isIconOn
                ? Styles.textEntityDegreeInActive
                : Styles.textEntityDegreeInActive,
            overflow: TextOverflow.ellipsis,
            textScaleFactor: Settings.textScaleFactor,
          ),
        );
      }
    }
    return Container();
  }
}

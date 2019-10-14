import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hasskit/model/ProviderData.dart';
import 'package:web_socket_channel/io.dart';

///
/// Application-level global variable to access the WebSockets
///
WebSocketConnection sockets = new WebSocketConnection();

///
/// Put your WebSockets server IP address and port number
///
//const String _SERVER_ADDRESS = "ws://192.168.1.45:34263";
///
///https://www.didierboelens.com/2018/06/web-sockets---build-a-real-time-game/
///

class WebSocketConnection with ChangeNotifier {
  static final WebSocketConnection _sockets =
      new WebSocketConnection._internal();

  factory WebSocketConnection() {
    return _sockets;
  }

  WebSocketConnection._internal();

  ///
  /// The WebSocket "open" channel
  ///
  IOWebSocketChannel _channel;

  ///
  /// Is the connection established?
  ///
  bool isOn = false;

  ///
  /// Listeners
  /// List of methods to be called when a new message
  /// comes in.
  ///
  ObserverList<Function> _listeners = new ObserverList<Function>();

  /// ----------------------------------------------------------
  /// Initialization the WebSockets connection with the server
  /// ----------------------------------------------------------
  initCommunication() async {
    print(
        'initCommunication socketUrl ${providerData.socketUrl} autoConnect ${providerData.autoConnect} serverConnected ${providerData.serverConnected}');

    ///
    /// Just in case, close any previous communication
    ///
    reset();

    ///
    /// Open a new WebSocket communication
    ///
    try {
      _channel = new IOWebSocketChannel.connect(providerData.socketUrl,
          pingInterval: Duration(seconds: 15));

//      providerData.connectionError = '';
//      providerData.connectionStatus = 'Connecting...';
//      providerData.serverConnected = false;

      ///
      /// Start listening to new notifications / messages
      ///
      _channel.stream.listen(_onData,
          onDone: _onDone, onError: _onError, cancelOnError: false);
    } catch (e) {
      ///
      /// General error handling
      print('initCommunication catch $e');
      providerData.serverConnected = false;
      providerData.connectionError = 'Error:\n' + e.toString();
      providerData.connectionStatus = 'Error: $e';

      ///
    }
  }

  /// ----------------------------------------------------------
  /// Closes the WebSocket communication
  /// ----------------------------------------------------------
  reset() {
    if (_channel != null) {
      if (_channel.sink != null) {
        _channel.sink.close();
        isOn = false;
//        providerData.isConnectedSet(false, 'reset');
        providerData.serverConnected = false;
        providerData.connectionError = '';
        providerData.connectionStatus = 'Disconnected';
        providerData.authenticationStatus = '';
        providerData.socketIdGetStates = null;
        providerData.socketIdLovelaceConfig = null;
        providerData.socketIdSubscribeEvents = null;
        providerData.socketId = 1;
        providerData.cameraThumbnailsId.clear();
        providerData.cameraRequestTime.clear();
        providerData.cameraActives.clear();
      }
    }
  }

  /// ---------------------------------------------------------
  /// Sends a message to the server
  /// ---------------------------------------------------------
  send(String message) {
    if (_channel != null) {
      if (_channel.sink != null && isOn) {
        var decode = json.decode(message);
        int id = decode['id'];
        String type = decode['type'];

        if (type == 'subscribe_events') {
          if (providerData.socketIdSubscribeEvents != null) {
            print('??? subscribe_events We do not sub twice');
            return;
          }
          providerData.socketIdSubscribeEvents = id;
        }

        if (type == 'get_states') {
          providerData.socketIdGetStates = id;
        }
        if (type == 'lovelace/config') {
          providerData.socketIdLovelaceConfig = id;
        }
        if (type == 'camera_thumbnail' && decode['entity_id'] != null) {
          providerData.cameraThumbnailsId[id] = decode['entity_id'];
//          print(
//              'camera_thumbnail $id = ${providerData.cameraThumbnailsId[id]}');
        }

        _channel.sink.add(message);
        print('SOCKET SEND: id $id type $type $message');
        providerData.socketIdIncrement();
      }
    }
  }

  /// ---------------------------------------------------------
  /// Adds a callback to be invoked in case of incoming
  /// notification
  /// ---------------------------------------------------------
  addListener(Function callback) {
    _listeners.add(callback);
  }

  removeListener(Function callback) {
    _listeners.remove(callback);
  }

  /// ----------------------------------------------------------
  /// Callback which is invoked each time that we are receiving
  /// a message from the server
  /// ----------------------------------------------------------
  _onData(message) {
    isOn = true;
    providerData.serverConnected = true;

    var decode = json.decode(message);
    var type = decode['type'];
    var outMsg;
//    print('_onData decode $decode');
    switch (type) {
      case 'auth_required':
        {
          outMsg = {
            "type": "auth",
            "access_token": "${providerData.hassToken}"
          };
          send(json.encode(outMsg));
          providerData.authenticationStatus = '';
          providerData.authenticationStatus = 'Authentication required';
        }
        break;
      case 'auth_ok':
        {
          outMsg = {"id": providerData.socketId, "type": "get_states"};
          send(json.encode(outMsg));
          providerData.connectionStatus = 'Connected';
          providerData.authenticationStatus = '';
          providerData.authenticationStatus = 'Authentication OK';
        }
        break;
      case 'result':
        {
          var success = decode['success'];
          if (!success) {
            print('result not success');
            break;
          }
          var id = decode['id'];

          if (id == providerData.socketIdGetStates) {
            print('Processing Get States');
            providerData.socketGetStates(decode['result']);
            outMsg = {"id": providerData.socketId, "type": "lovelace/config"};
            send(json.encode(outMsg));
          } else if (id == providerData.socketIdLovelaceConfig) {
            print('Processing Lovelace Config');
            providerData.socketLovelaceConfig(message);
            outMsg = {
              "id": providerData.socketId,
              "type": "subscribe_events",
              "event_type": "state_changed"
            };
            send(json.encode(outMsg));
          } else if (providerData.cameraThumbnailsId.containsKey(id)) {
            var content = decode['result']['content'];
//            print(
//                'cameraThumbnailsId $id ${providerData.cameraThumbnailsId[id]} content $content');
            providerData.camerasThumbnailUpdate(
                providerData.cameraThumbnailsId[id], content);
          } else {
//            print('providerData.socketIdServices $id == null $decode');
          }
        }
        break;
      case 'auth_invalid':
        {
          providerData.authenticationStatus = '';
          providerData.authenticationStatus = 'Invalid password';
          providerData.connectionStatus = 'Invalid Token';
        }
        break;
      case 'event':
        {
          providerData.connectionStatus = 'Connected';
          providerData.serverConnected = true;
//          print('case event');
          providerData.socketSubscribeEvents(message);
        }
        break;
      default:
        {
          print('type default $decode');
        }
    }

//    _listeners.forEach((Function callback) {
//      callback(message);
//    });
  }

  void _onDone() {
//    providerData.connectionStatus = 'Disconnected';
    providerData.serverConnected = false;
    print('_onDone');
  }

  _onError(error, StackTrace stackTrace) {
    providerData.connectionError = 'Error:\n' + error.toString();
    providerData.connectionStatus = 'Error: $error';
    providerData.authenticationStatus = '';
    providerData.serverConnected = false;
    isOn = false;
    print('_onError error: $error stackTrace: $stackTrace');
  }
}

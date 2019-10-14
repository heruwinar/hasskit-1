import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hasskit/model/ProviderData.dart';
import 'package:hasskit/screens/HomePage.dart';
import 'package:hasskit/screens/RoomTab.dart';
import 'package:hasskit/screens/SettingPage.dart';
import 'package:hasskit/screens/SpinKit.dart';
import 'package:hasskit/utils/WebSocketConnection.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/Settings.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:flutter_cupertino_localizations/flutter_cupertino_localizations.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  return runApp(
    ChangeNotifierProvider<ProviderData>(
      builder: (context) => ProviderData(),
      child: MyMaterialApp(),
    ),
  );
}

class MyMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    providerData = Provider.of<ProviderData>(context);
    return MaterialApp(
//      localizationsDelegates: [
//        // ... app-specific localization delegate[s] here
//        GlobalMaterialLocalizations.delegate,
//        GlobalWidgetsLocalizations.delegate,
//        GlobalCupertinoLocalizations.delegate,
//      ],
//      supportedLocales: [
//        const Locale('en'), // English
//        const Locale('vn'), // Vietnam
//        // ... other locales the app supports
//      ],
      title: 'HassKit',
      home: HassKitHome(),
    );
  }
}

class HassKitHome extends StatefulWidget {
  @override
  _HassKitHomeState createState() => _HassKitHomeState();
}

class _HassKitHomeState extends State<HassKitHome> with WidgetsBindingObserver {
  Timer timer1;
  Timer timer5;
  Timer timer10;
  Timer timer30;

  AppLifecycleState _notification;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
      print('didChangeAppLifecycleState ${_notification.index}');
    });
  }

  @override
  void initState() {
//    getEntities(entityContext);
    loadDataFromDisk();
    timer1 =
        Timer.periodic(Duration(seconds: 1), (Timer t) => timer1Callback());
    timer5 =
        Timer.periodic(Duration(seconds: 5), (Timer t) => timer5Callback());
    timer10 =
        Timer.periodic(Duration(seconds: 10), (Timer t) => timer10Callback());
    timer30 =
        Timer.periodic(Duration(seconds: 30), (Timer t) => timer30Callback());
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    sockets.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_carousel),
              title: Text('Room'),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
              title: Text('Setting'),
            ),
          ],
        ),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return CupertinoTabView(
                builder: (context) {
                  return CupertinoPageScaffold(
                    child:
                        providerData.serverConnected ? HomePage() : SpinKit(),
//                  child: HomeTab(),
                  );
                },
              );
            case 1:
              return CupertinoTabView(
                builder: (context) {
                  return CupertinoPageScaffold(
                    child: providerData.serverConnected ? RoomTab() : SpinKit(),
                  );
                },
              );
            case 2:
              return CupertinoTabView(
                builder: (context) {
                  return CupertinoPageScaffold(
                    child: SettingPage(),
                  );
                },
              );
            default:
              return CupertinoTabView(
                builder: (context) {
                  return CupertinoPageScaffold(
                    child: HomePage(),
                  );
                },
              );
          }
        },
      ),
    );
  }

  loadDataFromDisk() async {
    print('START loadingData');

    print('START loadDataFromDisk');
    var _preferences = await SharedPreferences.getInstance();

    providerData.useSsl = _preferences.getBool('useSsl');
    if (providerData.useSsl == null) {
      providerData.useSsl = Settings.ssls[Settings.connectionIndex];
      providerData.useSsl = false;
    }
    print('loadDataFromDisk: useSsl set to ${providerData.useSsl}');
    // call setState here to set the actual list of items and rebuild the widget.

    providerData.hassUrl = _preferences.getString('hassUrl');
    if (providerData.hassUrl == null || providerData.hassUrl.length < 1) {
      providerData.hassUrl = Settings.urls[Settings.connectionIndex];
      providerData.hassUrl = '';
    }
    print('loadDataFromDisk: hassUrl set to ${providerData.hassUrl}');

    providerData.hassToken = _preferences.getString('hassToken');
    if (providerData.hassToken == null || providerData.hassToken.length < 1) {
      providerData.hassToken = Settings.tokens[Settings.connectionIndex];
      providerData.hassToken = '';
    }
    print('loadDataFromDisk: hassToken set to ${providerData.hassToken}');

    print('START initCommunication');

    providerData.autoConnect = true;
    await initCommunication();

    print('START Future.delayed');
    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {});
    print('END loadDataFromDisk');
  }

  updateCameraThumbnails() {
    for (var i = 0; i < providerData.cameraActives.length; i++) {
      var cameraEntityId = providerData.cameraActives[i];
      var cameraRequestTime = providerData.cameraRequestTime[cameraEntityId];

      if (cameraRequestTime == null ||
          DateTime.now().difference(cameraRequestTime).inSeconds > 10) {
//        print('updateCameraThumbnails $cameraEntityId');
        providerData.requestCameraImage(cameraEntityId);
      }
    }
  }

  initCommunication() {
    if (providerData.autoConnect && !providerData.serverConnected) {
      sockets.initCommunication();
    }
  }

  timer1Callback() {
    updateCameraThumbnails();
  }

  timer5Callback() {}

  timer10Callback() {
    initCommunication();
  }

  timer30Callback() {
    if (providerData.serverConnected) {
      var outMsg = {"id": providerData.socketId, "type": "get_states"};
      var outMsgEncoded = json.encode(outMsg);
      sockets.send(outMsgEncoded);
    }
  }
}

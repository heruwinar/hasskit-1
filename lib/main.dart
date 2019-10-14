import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hasskit/Screens/home_tab.dart';
import 'package:hasskit/Screens/room_tab.dart';
import 'package:hasskit/Screens/setting_tab.dart';
import 'package:hasskit/model/provider_data.dart';
import 'package:hasskit/screens/spinkit.dart';
import 'package:hasskit/utils/web_sockets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/settings.dart';

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
      debugShowCheckedModeBanner: false,
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
  bool loadingData = false;
  Timer timer1;
  Timer timer5;
  Timer timer10;

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
                    child: loadingData ? SpinKit() : HomeTab(),
//                  child: HomeTab(),
                  );
                },
              );
            case 1:
              return CupertinoTabView(
                builder: (context) {
                  return CupertinoPageScaffold(
                    child: RoomTab(),
                  );
                },
              );
            case 2:
              return CupertinoTabView(
                builder: (context) {
                  return CupertinoPageScaffold(
                    child: SettingTab(),
                  );
                },
              );
            default:
              return CupertinoTabView(
                builder: (context) {
                  return CupertinoPageScaffold(
                    child: HomeTab(),
                  );
                },
              );
          }
        },
      ),
    );
  }

  loadDataFromDisk() async {
    loadingData = true;
    print('START loadingData $loadingData');

    print('START loadDataFromDisk');
    var _preferences = await SharedPreferences.getInstance();

    providerData.useSsl = _preferences.getBool('useSsl');
    if (providerData.useSsl == null) {
      providerData.useSsl = Settings.ssls[Settings.connectionIndex];
    }
    print('loadDataFromDisk: useSsl set to ${providerData.useSsl}');
    // call setState here to set the actual list of items and rebuild the widget.

    providerData.hassUrl = _preferences.getString('hassUrl');
    if (providerData.hassUrl == null || providerData.hassUrl.length < 1) {
      providerData.hassUrl = Settings.urls[Settings.connectionIndex];
    }
    print('loadDataFromDisk: hassUrl set to ${providerData.hassUrl}');

    providerData.hassToken = _preferences.getString('hassToken');
    if (providerData.hassToken == null || providerData.hassToken.length < 1) {
      providerData.hassToken = Settings.tokens[Settings.connectionIndex];
    }
    print('loadDataFromDisk: hassToken set to ${providerData.hassToken}');

    print('START initCommunication');
    await initCommunication();

    print('START Future.delayed');
    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      loadingData = false;
    });
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

  timer5Callback() {
    initCommunication();
  }

  timer10Callback() {
//    updateCameraThumbnails();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hasskit/model/provider_data.dart';
import 'package:hasskit/utils/web_sockets.dart';
import 'package:hasskit/utils/mdi.class.dart';
import 'package:hasskit/utils/settings.dart';
import '../utils/style.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(Settings.getRoomImage(4)), fit: BoxFit.cover),
      ),
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text('Setting'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  width: 50,
                  child: FlatButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.menu,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverSafeArea(
            top: false,
            minimum: EdgeInsets.fromLTRB(6, 6, 6, 54),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
                  HassConnect(),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HassConnect extends StatefulWidget {
  @override
  _HassConnectState createState() => _HassConnectState();
}

class _HassConnectState extends State<HassConnect> {
  final addressController = TextEditingController();
  final tokenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addressController.text = providerData.hassUrl;
    tokenController.text = providerData.hassToken;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Styles.white80,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    autofocus: false,
                    style: Styles.inputText,
                    controller: addressController,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      contentPadding: EdgeInsets.all(0),
                      prefixIcon: SizedBox(
                        width: 0,
                        height: 0,
                        child: Card(
                          elevation: 1,
                          color: Styles.white80,
                          child: providerData.useSsl
                              ? IconButton(
                                  onPressed: () {
                                    providerData.useSsl = false;
                                    print(
                                        'providerData.useSsl $providerData.useSsl');
                                    sockets.reset();
                                    providerData.autoConnect = false;
                                    providerData.connectionStatus =
                                        'Disconnected';
                                  },
                                  icon: Icon(
                                    Icons.lock,
                                    color: Colors.blue,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    providerData.useSsl = true;
                                    print(
                                        'providerData.useSsl $providerData.useSsl');
                                    sockets.reset();
                                    providerData.autoConnect = false;
                                    providerData.connectionStatus =
                                        'Disconnected';
                                  },
                                  icon: Icon(
                                    Icons.lock_open,
                                    color: Colors.blue,
                                  ),
                                ),
                        ),
                      ),
                      prefix: Text(
                        providerData.useSsl ? 'https://' : 'http://',
                      ),
                      suffixIcon: SizedBox(
                        height: 0,
                        child: Card(
                            elevation: 1,
                            color: Styles.white80,
                            child: FlatButton(
                              onPressed: () {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                providerData.hassUrl =
                                    addressController.text.trim();
                                providerData.hassToken =
                                    tokenController.text.trim();
                                Settings.saveString(
                                    'hassUrl', providerData.hassUrl);
                                Settings.saveString(
                                    'hassToken', providerData.hassToken);
                                Settings.saveBool(
                                    'useSsl', providerData.useSsl);
                                if (providerData.serverConnected) {
                                  sockets.reset();
                                  providerData.autoConnect = false;
                                  providerData.connectionStatus =
                                      'Disconnected';
                                } else {
                                  providerData.connectionStatus =
                                      'Connecting...';
                                  sockets.initCommunication();
                                  providerData.autoConnect = true;
                                }
                              },
                              child: providerData.serverConnected
                                  ? Text(
                                      'Disconnect',
                                      style: Styles.textButton,
                                    )
                                  : Text(
                                      'Connect',
                                      style: Styles.textButton,
                                    ),
                            )),
                      ),
                      hintText: 'sample.duckdns.org:8123',
                      labelText: 'Address : Port',
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(4),
                        borderSide: BorderSide(),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    onChanged: (val) {
                      print('addressController onChanged $val');
                      sockets.reset();
                      providerData.autoConnect = false;
                      providerData.hassUrl = val.trim();
                    },
                    onEditingComplete: () {
                      providerData.hassUrl = addressController.text.trim();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              style: Styles.inputText,
              controller: tokenController,
              minLines: 2,
              maxLines: 3,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: 'Token',
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(4),
                  borderSide: BorderSide(),
                ),
              ),
              onChanged: (val) {
                print('tokenController onChanged $val');
                sockets.reset();
                providerData.autoConnect = false;
                providerData.hassToken = val.trim();
              },
              onEditingComplete: () {
                providerData.hassToken = tokenController.text.trim();
              },
              autofocus: false,
            ),
            SizedBox(height: 8),
            Row(
              children: <Widget>[
                providerData.connectionStatus == 'Connecting...'
                    ? SpinKitThreeBounce(
                        color: Colors.yellow,
                        size: 24.0,
                      )
                    : providerData.connectionStatus == 'Connected'
                        ? SpinKitRipple(
                            color: Colors.green,
                            size: 24.0,
                          )
                        : SpinKitRipple(
                            color: Colors.red.withAlpha(0),
                            size: 24.0,
                          ),
                Icon(
                  MaterialDesignIcons.getIconDataFromIconName(
                      'mdi:server-network'),
                  color: providerData.connectionStatus == 'Connecting...'
                      ? Colors.yellow
                      : providerData.connectionStatus == 'Connected'
                          ? Colors.green
                          : Colors.red,
                ),
                Expanded(
                  child: Text('${providerData.connectionStatus}'),
                ),
              ],
            ),
            SizedBox(height: 8),
            providerData.serverConnected
                ? MaterialButton(
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      'Refresh Data',
                      style: Styles.textButton,
                    ),
                    elevation: 1,
                    color: Styles.white80,
                    onPressed: () {
                      var outMsg =
                          '{\"id\": ${providerData.socketId}, \"type\": \"get_states\"}';
                      sockets.send(outMsg);
                    },
                  )
                : Container(),
            (!providerData.serverConnected && Settings.urls[0].length > 0)
                ? MaterialButton(
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      Settings.urls[0],
                      style: Styles.textButton,
                    ),
                    elevation: 1,
                    color: Styles.white80,
                    onPressed: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      providerData.useSsl = Settings.ssls[0];
                      providerData.hassUrl = Settings.urls[0];
                      addressController.text = Settings.urls[0];
                      providerData.hassToken = Settings.tokens[0];
                      tokenController.text = Settings.tokens[0];
                      Settings.saveString('hassUrl', providerData.hassUrl);
                      Settings.saveString('hassToken', providerData.hassToken);
                      Settings.saveBool('useSsl', providerData.useSsl);
                      sockets.initCommunication();
                      providerData.autoConnect = true;
                      print(
                          '0. hassUrl ${providerData.hassUrl} useSsl ${providerData.useSsl} hassToken ${providerData.hassToken}');
                    },
                  )
                : Container(),
            (!providerData.serverConnected && Settings.urls[1].length > 0)
                ? MaterialButton(
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      Settings.urls[1],
                      style: Styles.textButton,
                    ),
                    elevation: 1,
                    color: Styles.white80,
                    onPressed: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      providerData.useSsl = Settings.ssls[1];
                      providerData.hassUrl = Settings.urls[1];
                      addressController.text = Settings.urls[1];
                      providerData.hassToken = Settings.tokens[1];
                      tokenController.text = Settings.tokens[1];
                      Settings.saveString('hassUrl', providerData.hassUrl);
                      Settings.saveString('hassToken', providerData.hassToken);
                      Settings.saveBool('useSsl', providerData.useSsl);
                      sockets.initCommunication();
                      providerData.autoConnect = true;
                      print(
                          '1. hassUrl ${providerData.hassUrl} useSsl ${providerData.useSsl} hassToken ${providerData.hassToken}');
                    },
                  )
                : Container(),
            (!providerData.serverConnected && Settings.urls[2].length > 0)
                ? MaterialButton(
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      Settings.urls[2],
                      style: Styles.textButton,
                    ),
                    elevation: 1,
                    color: Styles.white80,
                    onPressed: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      providerData.useSsl = Settings.ssls[2];
                      providerData.hassUrl = Settings.urls[2];
                      addressController.text = Settings.urls[2];
                      providerData.hassToken = Settings.tokens[2];
                      tokenController.text = Settings.tokens[2];
                      Settings.saveString('hassUrl', providerData.hassUrl);
                      Settings.saveString('hassToken', providerData.hassToken);
                      Settings.saveBool('useSsl', providerData.useSsl);
                      sockets.initCommunication();
                      providerData.autoConnect = true;
                      print(
                          '2. hassUrl ${providerData.hassUrl} useSsl ${providerData.useSsl} hassToken ${providerData.hassToken}');
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

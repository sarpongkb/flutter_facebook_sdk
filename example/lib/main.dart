import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_facebook_sdk/flutter_facebook_sdk.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  bool _loggedIn;
  dynamic _loginResult;


  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    bool loggedIn;
    dynamic loginResult;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterFacebookSdk.platformVersion;
      loginResult = await FlutterFacebookSdk.logInWithReadPermissions(["public_profile"]);
      loggedIn = await FlutterFacebookSdk.isLoggedIn();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _loggedIn = loggedIn;
      _loginResult = loginResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
             Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
             Center(
               child: Text('Is Logged In: $_loggedIn\n'),
             ),
             Center(
               child: Text('Login results: $_loginResult\n'),
             ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_facebook_sdk/fb_login.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _loggedIn;
  dynamic _loginResult;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    bool loggedIn;
    dynamic loginResult;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      loginResult =
          await FbLogin.logInWithReadPermissions(["public_profile"]);
      loggedIn = await FbLogin.isLoggedIn();
    } on PlatformException {
      print('Failed to get platform version.');
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _loggedIn = loggedIn;
      _loginResult = loginResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
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

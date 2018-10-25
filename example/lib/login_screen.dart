import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:flutter_facebook_sdk/fb_sdk.dart";
//import 'dart:async';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoggedIn;
  FbLoginStatus _loginStatus;
  FbAccessToken _accessToken;
  String _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Screen"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {},
            child: Text("Log In"),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                color: Colors.amberAccent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text("errorMessage: $_errorMessage"),
                    Text("isLoggedIn: $_isLoggedIn"),
                    Text("Login status: $_loginStatus"),
                    Text("appId: ${_accessToken?.appId}"),
                    Text("declinedPermissions: ${_accessToken?.declinedPermissions}"),
                    Text("expirationTime: ${_accessToken?.expirationTime}"),
                    Text("isExpired: ${_accessToken?.isExpired}"),
                    Text("permissions: ${_accessToken?.permissions}"),
                    Text("refreshTime: ${_accessToken?.refreshTime}"),
                    Text("tokenString: ${_accessToken?.tokenString}"),
                    Text("userId: ${_accessToken?.userId}"),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () => _logInWithReadPermissions(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Log in with read permissions",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.green,
                  ),
                  RaisedButton(
                    onPressed: () => _logOut(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Log Out",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logOut() async {
    FbLoginStatus loginStatus;
    FbAccessToken accessToken;
    bool isLoggedIn;
    String errorMessage;

    try {
      await FbLogin.logOut();
      accessToken = await FbAccessToken.currentAccessToken;
      isLoggedIn = await FbLogin.isLoggedIn();
    } on PlatformException catch (e) {
      errorMessage = e.message;
    }

    if (!mounted) return;

    setState(() {
      _isLoggedIn = isLoggedIn;
      _loginStatus = loginStatus;
      _accessToken = accessToken;
      _errorMessage = errorMessage;
    });
  }

  void _logInWithReadPermissions() async {
    FbLoginStatus loginStatus;
    FbAccessToken accessToken;
    bool isLoggedIn;
    String errorMessage;

    try {
      FbLoginResult loginResult =
          await FbLogin.logInWithReadPermissions(["public_profile"]);
      isLoggedIn = await FbLogin.isLoggedIn();

      loginStatus = loginResult.status;
      if (loginStatus == FbLoginStatus.ERROR ||
          loginStatus == FbLoginStatus.CANCELED) {
        errorMessage = loginResult.errorMessage;
      } else {
        accessToken = loginResult.accessToken;
      }
    } on PlatformException catch (e) {
      errorMessage = e.message;
    }

    if (!mounted) return;

    setState(() {
      _isLoggedIn = isLoggedIn;
      _loginStatus = loginStatus;
      _accessToken = accessToken;
      _errorMessage = errorMessage;
    });
  }
}

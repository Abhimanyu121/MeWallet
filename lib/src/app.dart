import 'package:flutter/material.dart';
import 'package:flutter_wallet_ui_challenge/src/pages/home_page.dart';
import 'package:flutter_wallet_ui_challenge/src/pages/send.dart';
import 'package:flutter_wallet_ui_challenge/src/pages/register.dart';
import 'package:flutter_wallet_ui_challenge/src/pages/login.dart';

import'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  @override
 AppUi createState() => new AppUi();
}
class AppUi extends State<App>{
  Widget currentWidget = Register();
  Future<dynamic> getStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('status');
  }
  final routes = <String, WidgetBuilder>{
    "/login":(context) =>Login(),
    "/home":(context) =>HomePage(),
    "/register":(context) => Register(),
  };
  @override
  void initState() {
    getStatus().then((value){
      if (value == null|| value ==false) {
        print(value.toString());
        setState(() {
          currentWidget = Register();
        });
      } else {
        print(value.toString());
        setState(() {
          currentWidget = HomePage();
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
       fontFamily: "Varela",
      ),
      home: Send(),
    );
  }

}

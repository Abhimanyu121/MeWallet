import 'package:flutter/material.dart';
import 'package:flutter_wallet_ui_challenge/src/pages/home_page.dart';
import 'package:flutter_wallet_ui_challenge/src/pages/register.dart';
import 'package:flutter_wallet_ui_challenge/src/pages/login.dart';

import'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  @override
 AppUi createState() => new AppUi();
}
class AppUi extends State<App>{
  Widget currentWidget = Register();
  _getStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("status");
  }
  final routes = <String, WidgetBuilder>{
    "/login":(context) =>Login(),
    "/home":(context) =>HomePage(),
    "/register":(context) => Register(),
  };
  @override
  void initState() {
    _getStatus().then((value){
      print("value is ");
      if (value==true ) {
        print(value.toString());
        setState(() {
          currentWidget = HomePage();
        });
      } else {
        print(value.toString());
        setState(() {
          currentWidget = Register();
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
      home: currentWidget,
      routes: routes,
    );
  }

}

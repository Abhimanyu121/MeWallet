import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Receive extends StatefulWidget{
  @override
  ReceiveUi createState()=> new ReceiveUi();
}
class ReceiveUi extends State<Receive>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: _receive_ui(),
    );
  }
  _receive_ui(){
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        left: 20,
        top: 70,
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Receive Either",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          "QR",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            inherit: true,
            letterSpacing: 0.4,
          ),
        ),
        SizedBox(
          height: 150,
        ),
        Center(
          child: new QrImage(
            data: "1234567890",
            size: 400.0,
          ),
        ),
      ],
    );
  }

}
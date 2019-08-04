import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'home_page.dart';
class QR extends StatefulWidget{
  @override
  qr createState()=> new qr();
}
class qr extends State<QR>{
  bool qrcode =false;
  String key;
  static _loader(){
    return new SpinKitCircle(color: Colors.black, size:100);
  }
  Widget code = _loader();
  _data()async{
    var prefs= await SharedPreferences.getInstance();
    var key = prefs.getString("privKey");
    return key;
  }

  @override
  void initState() {
     _data().then((val){
       setState(() {
         key = val;
         print(val);
         qrcode =true;
         code = new QrImage(
           data: val.toString(),
           size: 400.0,
         );
       });
     });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ListView(
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
                "Secret Code",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
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
              child: code
          ),
          Text("Please take a Screenshot and store it safely or else you wont be able to acces your account",maxLines: 5 ,style: TextStyle(color:Colors.red,fontWeight: FontWeight.bold),),
          Padding(
            padding: EdgeInsets.all(16),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>HomePage()));
              },
              padding: EdgeInsets.all(12),
              color: Colors.blueAccent,
              child: Text('Continue', style: TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
    );

  }

  _qrCode(){
    return new QrImage(
      data: key.toString(),
      size: 400.0,
    );
  }
}
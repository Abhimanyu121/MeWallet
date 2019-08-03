import 'package:flutter/material.dart';
import 'package:flutter_wallet_ui_challenge/src/pages/eth.dart';
import 'package:convert/convert.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;

class Register extends StatefulWidget{
  RegisterUi createState() => new RegisterUi();
}
class RegisterUi extends State<Register>{
  bool newWallet= false;
  bool existingWallet = false;
  //bool otpExisting = false;
  //bool otpNew = false;
  var passNew = new TextEditingController();
  var phNew = new TextEditingController();
  var exPass = new TextEditingController();
  var exPh = new TextEditingController();
  var exMn = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: newWallet? _new():(existingWallet?_existing():_button()),
    );
  }
  _new(){
    return Center(
      child: ListView(
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
                "Register",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Phone Number',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
              controller: phNew,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              obscureText: true,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Password',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
              controller:passNew,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: (){
                _newWallet();
              },
              padding: EdgeInsets.all(12),
              color: Colors.blueAccent,
              child: Text('Register Now', style: TextStyle(color: Colors.white)),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: (){
                setState(() {
                  newWallet =false;
                  existingWallet = false;
                });
              },
              padding: EdgeInsets.all(12),
              color: Colors.blueAccent,
              child: Text('Go Back', style: TextStyle(color: Colors.white)),
            ),
          ),

        ],
      ),
    );
  }
  _existing(){
    return Center(
      child: ListView(
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
                "Register",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Phone Number',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
              controller: exPh,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              obscureText: true,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Mnemonic',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
              controller: exMn,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              obscureText: true,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Password',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
              controller: exPh,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: (){
                _exisitingWallet();
              },
              padding: EdgeInsets.all(12),
              color: Colors.blueAccent,
              child: Text('Register Now', style: TextStyle(color: Colors.white)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: (){
                setState(() {
                  newWallet =false;
                  existingWallet = false;
                });
              },
              padding: EdgeInsets.all(12),
              color: Colors.blueAccent,
              child: Text('Go Back', style: TextStyle(color: Colors.white)),
            ),
          ),

        ],
      ),
    );
  }
  _newWallet()async {
    var content = new Utf8Encoder().convert(phNew.text);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    var hash =  hex.encode(digest.bytes);
    print(hash);
    ethereumWrapper wrapper = new ethereumWrapper();
    bool status = await wrapper.wallet();
    if(status){
      Navigator.of(context).pushNamedAndRemoveUntil('/home', ModalRoute.withName('/register'));
    }
  }
  _exisitingWallet(){
    var content = new Utf8Encoder().convert(exPh.text);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    var hash =  hex.encode(digest.bytes);
    print(hash);
    ethereumWrapper wrapper = new ethereumWrapper();
    bool status = wrapper.existing(exMn.text,exPh.text);
    if(status){
      Navigator.of(context).pushNamedAndRemoveUntil('/home', ModalRoute.withName('/register'));
    }
  }

  _button(){
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
                "Register",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ],
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: (){
                setState(() {
                  newWallet = true;
                });
              },
              padding: EdgeInsets.all(12),
              color: Colors.blueAccent,
              child: Text('New Wallet', style: TextStyle(color: Colors.white)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: (){
                setState(() {
                  existingWallet = true;
                });
              },
              padding: EdgeInsets.all(12),
              color: Colors.blueAccent,
              child: Text('Existing Wallet', style: TextStyle(color: Colors.white)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Register()),
                );
              },
              padding: EdgeInsets.all(12),
              color: Colors.white,
              child: Text('Login', style: TextStyle(color: Colors.black)),
            ),
          ),
        ],

    );
  }

}
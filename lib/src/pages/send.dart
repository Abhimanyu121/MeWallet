import 'package:flutter/material.dart';
import 'package:flutter_wallet_ui_challenge/src/utils/screen_size.dart';
import 'package:flutter_wallet_ui_challenge/src/pages/eth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';
import 'eth.dart';
import 'ApiWrapper.dart';
class Send extends StatefulWidget{
  @override
  SendUi createState() => new SendUi();
}

class SendUi extends State<Send>{
  bool fetch= true;
  String balance ;
  int transacts;
  _fetchbal()async{
    ethereumWrapper eth= new ethereumWrapper();
    return eth.fetchBalance();
  }
  _fetchTransactions(){
    ethereumWrapper eth= new ethereumWrapper();
    return  eth.fetchTransactionNumbers();
  }
  _loader(){
    return SpinKitCircle(color: Colors.black, size: 20);
  }
  var phone = new TextEditingController();
  var value = new TextEditingController();

  @override
  void initState() {
    _fetchbal().then((bal){
      _fetchTransactions().then((trans){
        setState(() {

          balance= bal;
          transacts = trans;
          fetch =false;
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _send_ui();
  }
  _send_ui(){
    final _media = MediaQuery.of(context).size;
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
                    "Send Ether",
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
                "Accounts",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  inherit: true,
                  letterSpacing: 0.4,
                ),
              ),
              Row(
                children: <Widget>[
                  fetch?_loader():colorCard("Ether in Wallet",int.parse(balance), 1, context, Color(0xFF1b5bff)),
                  fetch?_loader():colorCard("Transactions", transacts, 1, context, Color(0xFFff3f5e)),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Contact",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Varela",
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
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
                  controller: phone,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Amount",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Varela",
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                keyboardType: TextInputType.number,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Amount in Ether',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
                controller: value,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                onPressed: ()async{
                  ethereumWrapper wrapper = new ethereumWrapper();
                  await wrapper.send(phone.text, int.parse(value.text)).then((val){
                    _grant(phone.text);
                    if(val){
                      Toast.show("Sent", context,duration :Toast.LENGTH_LONG);
                    }else {
                      Toast.show("Sent", context,duration :Toast.LENGTH_LONG);
                    }
                  });

                },
                padding: EdgeInsets.all(12),
                color: Colors.blueAccent,
                child: Text('Send', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
      ),
    );
  }
  Widget colorCard(
      String text, int amount, int type, BuildContext context, Color color) {
    final _media = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 15, right: 15),
      padding: EdgeInsets.all(15),
      height: screenAwareSize(90, context),
      width: _media.width / 2 - 25,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 16,
                spreadRadius: 0.2,
                offset: Offset(0, 8)),
          ]),
      child: FlatButton(
        onPressed: (){},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "${amount.toString()}",
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
  _grant(String phone ){
    ApiWrapper wrapper = new ApiWrapper();
    wrapper.grant();

  }
}
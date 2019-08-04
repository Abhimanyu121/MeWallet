import 'package:flutter/material.dart';
import 'ApiWrapper.dart';
class Decryyption extends StatefulWidget{
  @override
  decryptUi createState()=> new decryptUi();

}
class decryptUi extends State<Decryyption>{
  var enc = TextEditingController();
  var policy = TextEditingController();
  var alice = TextEditingController();
  var label = TextEditingController();

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
                "Decryption",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            "Encrypted Message",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              inherit: true,
              letterSpacing: 0.4,
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'Encrypted Message',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
            controller: enc,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'Policy',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
            controller: policy,
          ),
        ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Alice Key',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
              controller: alice,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'label',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
              controller: label,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: (){
                ApiWrapper wrapper =new ApiWrapper();
                var resp = wrapper.retrieve(enc.text, policy.text, label.text, alice.text);
              },
              padding: EdgeInsets.all(12),
              color: Colors.blueAccent,
              child: Text("Decrypt", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );;
  }

}
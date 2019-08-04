import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class ApiWrapper{
  Future<dynamic> history()async{
    SharedPreferences prefs= await SharedPreferences.getInstance();
    var address = prefs.getString("address");
    var url = "https://api.etherscan.io/api?module=account&action=txlist&address="+address+"&startblock=0&endblock=99999999&page=1&offset=10&sort=asc&apikey=WWPW91GBNXA2UVAXDG1HH5787KIKIJ4XKU";
    var resp = await http.get(url);
    print(resp.statusCode);
    print(resp.body);
    return ;
  }
  Future <void> keyGen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = "http://35.225.73.177:8151/derive_policy_encrypting_key/mobeth";
    var  resp = await http.post(url);
    print(resp.statusCode);
    print(resp.body);
    var pjson=jsonDecode(resp.body);
    prefs.setString("encryptingKey", pjson['result']['policy_encrypting_key']);
    prefs.setString("label", pjson['result']['label']);
    print(prefs.getString('label'));
  }
  Future<void > grant() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url=  "http://35.225.73.177:8151/derive_policy_encrypting_key/mobeth";
    var map  = new Map<String, dynamic>();
    map["bob_encrypting_key"] = "0xe3cc9e7f5f68af57b6bb327d6cad9f383d43bd79";
    map['label'] = 'mobeth';
    map['m'] =1;
    map["n"] = 1;
    map['expiration']= "2019-09-15T15:53:00";
    map["bob_verifying_key"] = "0205ee059d4198c30c3960b2f0db27c92478e5eb92698f5473695baee521938a95";
    var response = await http.post(url,body: map);
    print(response.body.toString());
    var json = jsonDecode(response.body);
    prefs.setString("policy_encrypting_key", json['result']['policy_encrypting_key']);
    prefs.setString("alice_verifying_key", json['result']['alice_verifying_key']);

  }
  Future<void> encrypt(String phone)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url=  "http://35.225.73.177:8151/encrypt_message";
    var map  = new Map<String, dynamic>();
    map['message'] = phone;
    var response = await http.post(url,body: map);
    print(response.body);

  }
  Future<String> retrieve (String mText, String policy, String label, String alice, )async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = "http://35.225.73.177:8151/retrieve";
    var map  = new Map<String, dynamic>();
    map['policy_encrypting_key'] = policy;
    map['label'] = label;
    map['alice_verifying_key'] = alice;
    map['message_kit'] = mText;
    var response = await http.post(url,body: map);
    var pjson=jsonDecode(response.body);
    return pjson['result']['cleartexts'][0];

  }
}

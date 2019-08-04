import 'package:flutter/material.dart';
import 'package:flutter_wallet_ui_challenge/src/data/data.dart';
import 'package:flutter_wallet_ui_challenge/src/pages/overview_page.dart';
import 'package:flutter_wallet_ui_challenge/src/utils/screen_size.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/add_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'receive.dart';
import 'decryption.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/credit_card.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/payment_card.dart';
import 'package:flutter_wallet_ui_challenge/src/widgets/user_card.dart';
import 'eth.dart';
import 'send.dart';
import 'ApiWrapper.dart';
class HomePage extends StatefulWidget{
  @override
  HomePageUi createState() => new HomePageUi();
}
class HomePageUi extends State<HomePage> {
  var _media;
  String number;
  String balance;
  bool bal= false;

  @override
  void initState()  {
    _getprefs()async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      number = prefs.getString("number");
    }
    ApiWrapper apiwrapper = new ApiWrapper();
    apiwrapper.history();
    ethereumWrapper wrapper = new ethereumWrapper();
    wrapper.fetchBalance().then((val)async  {
      var add=await wrapper.fetchAddress("6FB42DA0E32E07B61C9F0251FE627A9C");
      print("address");
      print(add);
      setState(() {
        _getprefs();
        balance = val;
        bal = true;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    _media = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            color: Colors.grey.shade50,
            height: _media.height / 2,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Stack(
                        children: <Widget>[
                          Material(
                            elevation: 4,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/bg1.jpg"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: 0.3,
                            child: Container(
                              color: Colors.black87,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    )
                  ],
                ),
                FlatButton(
                  onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>Send()));
                  }
                ,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 20,
                        right: 20
                      ),
                      height: _media.longestSide <= 775
                          ? _media.height / 4
                          : _media.height / 4.3,
                      width: _media.width,
                      child:
                          NotificationListener<OverscrollIndicatorNotification>(
                        onNotification: (overscroll) {
                          overscroll.disallowGlow();
                        },
                        child:bal ?_card():_cardLoader(),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: _media.longestSide <= 775
                      ? screenAwareSize(20, context)
                      : screenAwareSize(35, context),
                  left: 10,
                  right: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () => print("Menu"),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.power_settings_new,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: ()async{
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setBool("status", false);
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Wallet",
                              style: TextStyle(
                                  fontSize: _media.longestSide <= 775 ? 35 : 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Varela"),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 36,
                            ),
                            onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Decryyption())
                              );},
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 36,
                            ),
                            onPressed: (){
                              Navigator.push(
                                context,
                                  MaterialPageRoute(
                                      builder: (context) => Receive())
                              );},
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey.shade50,
            width: _media.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25.0, right: 10, bottom: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Send Money",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 25),
                  height: screenAwareSize(
                      _media.longestSide <= 775 ? 110 : 80, context),
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overscroll) {
                      overscroll.disallowGlow();
                    },
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: getUsersCard().length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: AddButton());
                        }

                        return Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: UserCardWidget(
                            user: getUsersCard()[index - 1],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25.0, bottom: 15, right: 10, top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "All",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Received",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Sent",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25.0,
                    bottom: 15,
                    top: 15,
                  ),
                  child: Text(
                    "23 july 2019",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (overscroll) {
                        overscroll.disallowGlow();
                      },
                      child: ListView.separated(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 85.0),
                            child: Divider(),
                          );
                        },
                        padding: EdgeInsets.zero,
                        itemCount: getPaymentsCard().length,
                        itemBuilder: (BuildContext context, int index) {
                          return PaymentCardWidget(
                            payment: getPaymentsCard()[index],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  _cardLoader(){
    return new Material(
      elevation: 1,
      shadowColor: Colors.grey.shade300,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Padding(
            padding: EdgeInsets.all(20),
          child: SpinKitCircle(color: Colors.blueGrey, size: 50),
        ),
      )
    );

  }
  _card(){

    return new Material(
      elevation: 1,
      shadowColor: Colors.grey.shade300,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            width: _media.width - 40,
            padding: EdgeInsets.only(left: 30, right: 30, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Mobile No.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  number,
                  style: Theme.of(context).textTheme.headline.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Balance",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(balance,
                    style: Theme.of(context).textTheme.headline.copyWith(
                      color: Colors.black.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    ))
              ],
            ),
          ),
          Positioned(
            top: 15,
            right: 15,
            child: Container(
              height: 25,
              width: 50,
              color: Colors.pink,
              padding: EdgeInsets.all(7),
              child: Image.asset(
                "assets/images/bg1.jpg",
                width: 50,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// ListView.builder(
//                        physics: BouncingScrollPhysics(),
//                        padding: EdgeInsets.only(bottom: 10),
//                        shrinkWrap: true,
//                        scrollDirection: Axis.horizontal,
//                        itemCount: getCreditCards().length,
//                        itemBuilder: (context, index) {
//                          return Padding(
//                            padding: EdgeInsets.only(right: 10),
//                            child: GestureDetector(
//                              onTap: () => Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (context) => OverviewPage())),
//                              child: CreditCard(
//                                card: getCreditCards()[index],
//                              ),
//                            ),
//                          );
//                        },
//                      ),
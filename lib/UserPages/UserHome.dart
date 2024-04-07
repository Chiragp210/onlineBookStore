import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Login.dart';
import 'OrderHistory.dart';
import 'Profile.dart';
import 'ShopBook.dart';

class UserHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  signout() async{
    await auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
  }
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
          extendBody: true,
          body: Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/Images/img.png"),
                        fit: BoxFit.cover)),
                child: getSelectedWidget(index: _page),
              )
          ),
          bottomNavigationBar: CurvedNavigationBar(
            key: _bottomNavigationKey,
            items: <Widget>[
              Icon(Icons.shop, size: 30,color: Colors.white,),
              Icon(Icons.person, size: 30,color: Colors.white,),
              Icon(Icons.track_changes_outlined, size: 30,color: Colors.white,),
            ],
            index: _page,
            onTap: (selectedIndex) {
              setState(() {
                _page = selectedIndex;
              });
            },
            color: Colors.deepOrange,
            height: 65,
            backgroundColor: Colors.transparent,
            animationDuration: Duration(milliseconds: 100),
            animationCurve: Curves.linear,

          ),
        )
    );
  }
  Widget getSelectedWidget({required int index}){
    Widget widget;
    switch(index){
      case 0:
        widget = ShopPage();
        break;
      case 1:
        widget = ProfilePage();
        break;
      case 2:
        widget = OrderHistoryPage();
        break;
      default:
        widget = ShopPage();
        break;
    }
    return widget;

  }
}

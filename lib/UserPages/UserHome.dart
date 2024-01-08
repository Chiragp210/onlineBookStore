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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("User Home",
                style: TextStyle(color: Colors.white, fontSize: 20)),
            backgroundColor: Colors.deepOrange),
        body: Center(
            child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/Images/img.png"),
                        fit: BoxFit.cover)),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10),
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShopPage()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.red,
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shop,
                                  size: 50,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Shop Books",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )
                              ],
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderHistoryPage()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blue,
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 50,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Order History",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.green,
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Profile",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )
                              ],
                            ),
                          ),
                        ),
                      ]),
                )
            )
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: signout,
        backgroundColor: Colors.red, // Function to handle FAB tap
        child: const Icon(Icons.logout),
      ),
    );
  }
}

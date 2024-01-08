import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'BookAdd.dart';
import 'CustomerLIst.dart';
import 'BookList.dart';
import 'CustomerOrder.dart';
import '../Login.dart';

import 'BookAdd.dart';

class AdminHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  signout() async{
    await auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Admin Home",style: TextStyle(color: Colors.white,fontSize: 20)),backgroundColor: Colors.deepOrange),
        body: Center(child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Images/img.png"),
                    fit: BoxFit.cover)),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: GridView(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 10,crossAxisSpacing: 10),
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> AddPage()));
                      },
                      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.red,),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_circle_outline,size: 50,color: Colors.white,),
                            Text("Add Books",style: TextStyle(color: Colors.white,fontSize: 20),)
                          ],),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> BookListPage()));
                      },
                      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.deepPurple,),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.my_library_books,size: 50,color: Colors.white,),
                            Text("Book List",style: TextStyle(color: Colors.white,fontSize: 20),)
                          ],),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomerListPage()));
                      },
                      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.blue,),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person,size: 50,color: Colors.white,),
                            Text("Customer List",style: TextStyle(color: Colors.white,fontSize: 20),)
                          ],),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomerOrderPage()));
                      },
                      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.green,),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.list,size: 50,color: Colors.white,),
                            Text("Order List",style: TextStyle(color: Colors.white,fontSize: 20),)
                          ],),
                      ),
                    ),
              ]),
            )
        ),

        ),
        floatingActionButton: FloatingActionButton(
          onPressed: signout,
          backgroundColor: Colors.red, // Function to handle FAB tap
          child: const Icon(Icons.logout),
        ),
    );
  }
}

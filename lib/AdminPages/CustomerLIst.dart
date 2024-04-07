import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onlinebookstore/AdminPages/AdminHome.dart';

import '../Login.dart';

class CustomerListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  void _deletebook(String cId) async {
    try {
      // Delete the service document from Firestore
      await FirebaseFirestore.instance.collection('Customer').doc(cId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Customer Details deleted successfully.'),
        ),
      );
    } catch (error) {
      print('Error deleting Customer Details: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error deleting Customer.'),
        ),
      );
    }
  }
  final FirebaseAuth auth = FirebaseAuth.instance;
  signout() async{
    await auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AdminHomePage()));
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: const Text("Customer List",
                style: TextStyle(color: Colors.white, fontSize: 20)),
            backgroundColor: Colors.deepOrange,
            actions: [IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
                        (route) => false,
                  );
                },
                icon: const Icon(
                  Icons.logout,
                  size: 30,
                )),],
          ),
          body: Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/Images/img2.png"),
                        fit: BoxFit.cover)),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('Customer').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var userData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                            var userid = snapshot.data!.docs[index].id;
                            var name = userData['Name'] ?? '';
                            var email = userData['Email'] ?? '';
                            var mobileNo = userData['MobileNo'] ?? '';
                            var address = userData['Address'] ?? '';

                            return Card(
                              margin: const EdgeInsets.all(8),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Text(
                                        'Name: $name',
                                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Email: $email',
                                            style: const TextStyle(fontSize: 16, color: Colors.black),
                                          ),
                                          Text(
                                            'Phone No: $mobileNo',
                                            style: const TextStyle(fontSize: 16, color: Colors.black),
                                          ),
                                          Text(
                                            'Address: $address',
                                            style: const TextStyle(fontSize: 16, color: Colors.black),
                                          ),

                                        ],
                                      ),
                                      trailing: const Icon(Icons.person, color: Colors.indigo, size: 30),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [

                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => _deletebook(userid),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                      );
                    }
                ),
              )
          ),

        ));
  }
}

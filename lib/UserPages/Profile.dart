import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onlinebookstore/UserPages/ProfileUpdate.dart';
import 'package:onlinebookstore/UserPages/UserHome.dart';


class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = true;
  Future<Customer> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('Customer')
          .where('Email', isEqualTo: user.email)
          .get();

      if (userDoc.docs.isNotEmpty) {
        final userDocs = userDoc.docs.first;
        isLoading = false;
        return Customer.fromMap(userDocs.data()!);
      } else {
        // Handle the case where user data is not found
        throw Exception("User data not found");
      }
    } else {
      // Handle the case where the current user is null
      throw Exception("No authenticated user");
    }
  }


  @override
  Widget build(BuildContext context) => FutureBuilder<Customer?>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                  title: const Text("User Profile",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  backgroundColor: Colors.deepOrange),
              body: Center(
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/Images/img2.png"),
                            fit: BoxFit.cover)),
                    child: isLoading
                        ? const Center(
                      child: CircularProgressIndicator(), // Show a loading indicator
                    )
                        :Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(top: 60, bottom: 25),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                shape: BoxShape.circle),
                            child: const Icon(Icons.person,
                                color: Colors.white, size: 120),
                          ),
                          const SizedBox(height: 25.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Name: ',
                                style: TextStyle(
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                user.Name!,
                                style: const TextStyle(
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25.0),
                          // Display user email
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Email: ',
                                style: TextStyle(
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                user!.Email,
                                style: const TextStyle(
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25.0),
                          // Display additional user details
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Phone Number: ',
                                style: TextStyle(
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                user!.MobileNo,
                                style: const TextStyle(
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Address: ',
                                style: TextStyle(
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                user!.Address,
                                style: const TextStyle(
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25.0),
                          Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(top: 25, bottom: 25),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileUpdatePage()));
                                },

                                icon: const Icon(Icons.edit,color: Colors.deepOrange,size: 25),


                                ),
                          )
                        ],
                      ),
                    )),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> UserHomePage()));
                },
                backgroundColor: Colors.red, // Function to handle FAB tap
                child: const Icon(Icons.home),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      );
}

class Customer {
  final String Name;
  final String Email;
  final String MobileNo;
  final String Address;

  // Add other relevant fields

  Customer({
    required this.Name,
    required this.Email,
    required this.MobileNo,
    required this.Address,
  });

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      Name: map['Name'] ?? " ",
      Email: map['Email'] ?? " ",
      MobileNo: map['MobileNo'] ?? " ",
      Address: map['Address'] ?? " ",
    );
  }
}

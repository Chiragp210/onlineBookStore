import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onlinebookstore/UserPages/Profile.dart';
import 'package:onlinebookstore/UserPages/ProfileUpdate.dart';
import 'package:onlinebookstore/UserPages/UserHome.dart';


class ProfileUpdatePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  User? loggedInUser;
  TextEditingController nameController = TextEditingController();
  TextEditingController mobilenoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool isLoading = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    loadUserProfileData();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void loadUserProfileData() async {
    if (loggedInUser != null) {
      final userData = await _firestore.collection('Customer').where('Email',
          isEqualTo: loggedInUser!.email).get();
      if (userData.docs.isNotEmpty) {
        final userDoc = userData.docs.first;
        setState(() {
          nameController.text = userDoc['Name'] ?? "";
          mobilenoController.text = userDoc['MobileNo'] ?? "";
          emailController.text = userDoc['Email'] ?? "";
          addressController.text = userDoc['Address'] ?? "";
          isLoading = false; // Set isLoading to false when data is loaded
        });
      }
    }
  }
  void updateUserProfile() async {
    if (loggedInUser != null) {
      final userDocRef = _firestore.collection('Customer').where('Email', isEqualTo: loggedInUser!.email);

      // Fetch the document with the specified email
      final querySnapshot = await userDocRef.get();

      // Check if the document exists
      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;

        // Update the document
        await userDoc.reference.update({
          'Name': nameController.text,
          'MobileNo': mobilenoController.text,
          'Email': emailController.text,
          'Address': addressController.text,
        }).then((value) {
          Fluttertoast.showToast(
            msg: "Update User",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }).catchError((error) {
          Fluttertoast.showToast(
            msg: "Failed to Update User: $error",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        });

        nameController.clear();
        mobilenoController.clear();
        emailController.clear();
        addressController.clear();
      } else {
        // Handle the case where the document doesn't exist
        Fluttertoast.showToast(
          msg: "User document not found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
            extendBody: true,
            appBar: AppBar(
                title: const Text("User Profile Update",
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
                  child: Form(key: _formKey,
                    child: isLoading
                        ? const Center(
                      child: CircularProgressIndicator(), // Show a loading indicator
                    )
                        :Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 30.0),
                        child: ListView(
                            children: [
                              Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: TextFormField(
                                    autofocus: false,
                                    controller: nameController,
                                    cursorColor: Colors.white,
                                    style: const TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                    onChanged: (value) => nameController.text = value,
                                    decoration: const InputDecoration(
                                      labelText: "Name",
                                      labelStyle: TextStyle(
                                          fontSize: 20.0, color: Colors.white),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white)),
                                      errorStyle:
                                      TextStyle(color: Colors.redAccent,
                                          fontSize: 15.0),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please Enter Name";
                                      }
                                      return null;
                                    },
                                  )
                              ),
                              Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: TextFormField(
                                    autofocus: false,
                                    controller: mobilenoController,
                                    keyboardType: TextInputType.number,
                                    cursorColor: Colors.white,
                                    style: const TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                    onChanged: (value) => mobilenoController.text = value,
                                    decoration: const InputDecoration(
                                      labelText: "Mobile No.",
                                      labelStyle: TextStyle(
                                          fontSize: 20.0, color: Colors.white),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,)),
                                      errorStyle:
                                      TextStyle(color: Colors.redAccent,
                                          fontSize: 15.0),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please Enter Number";
                                      }
                                      else
                                      if (!RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$')
                                          .hasMatch(value)) {
                                        return "Please Enter Valid Number";
                                      }
                                      return null;
                                    },
                                  )
                              ),
                              Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: TextFormField(
                                    autofocus: false,
                                    controller: emailController,
                                    cursorColor: Colors.white,
                                    style: const TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                    onChanged: (value) => emailController.text = value,
                                    decoration: const InputDecoration(
                                      labelText: "Email",
                                      labelStyle: TextStyle(
                                          fontSize: 20.0, color: Colors.white),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white)),
                                      errorStyle:
                                      TextStyle(color: Colors.redAccent,
                                          fontSize: 15.0),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please Enter Email";
                                      }
                                      else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                        return

                                          'Please enter a valid email address';
                                      }
                                      return null;
                                    },
                                  )
                              ),

                              Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: TextFormField(
                                    autofocus: false,
                                    controller: addressController,
                                    cursorColor: Colors.white,
                                    style: const TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                    onChanged: (value) => addressController.text = value,
                                    decoration: const InputDecoration(
                                      labelText: "Address",
                                      labelStyle: TextStyle(
                                          fontSize: 20.0, color: Colors.white),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white)),
                                      errorStyle:
                                      TextStyle(color: Colors.redAccent,
                                          fontSize: 15.0),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please Enter Address";
                                      }
                                      return null;
                                    },
                                  )
                              ),


                              SizedBox(
                                  width: 300,
                                  height:50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      updateUserProfile();
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) => ProfilePage()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.deepOrange,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100),

                                        )),
                                    child: const Text('Update Profile',style: TextStyle(fontSize: 20,color: Colors.white),
                                    ),
                                  ))
                            ]
                        )


                    ),
                  ),
                )
            )
        ));
  }
}

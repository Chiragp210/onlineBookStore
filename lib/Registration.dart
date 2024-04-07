import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegitrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegitrationPageState();
}

class _RegitrationPageState extends State<RegitrationPage> {
  final _formKey = GlobalKey<FormState>();
  var name = "";
  var mobile = "";
  var email = "";
  var address = "";
  var password = "";

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    addressController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  clearText() {
    nameController.clear();
    mobileController.clear();
    addressController.clear();
    emailController.clear();
    passwordController.clear();
  }

  CollectionReference customers =
  FirebaseFirestore.instance.collection('Customer');
  Future<void> addUser() {
    return customers
        .add({
      'Name': name,
      'MobileNo': mobile,
      'Email': email,
      'Address': address,
      'Password': password
    })
        .then((value) => Fluttertoast.showToast(
        msg: "Add User",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0))
        .catchError((error) => Fluttertoast.showToast(
        msg: "Faild to Add User:$error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Images/img2.png"),
                    fit: BoxFit.cover)),
            child: Form(
                key: _formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 30.0),
                    child: ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          child: const Center(
                            child: Text("Sign Up",style: TextStyle(color: Colors.white,fontSize: 40),),
                          ),
                        ),

                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            child: TextFormField(
                              autofocus: false,
                              cursorColor: Colors.white,
                              style: const TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: "Name",
                                labelStyle: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.white)),
                                errorStyle: TextStyle(
                                    color: Colors.redAccent, fontSize: 15.0),
                              ),
                              controller: nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter Name";
                                }
                                return null;
                              },
                            )
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            child: TextFormField(
                              autofocus: false,
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.white,
                              style: const TextStyle(fontSize: 20.0,color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: "Mobile No.",
                                labelStyle: TextStyle(fontSize: 20.0,color: Colors.white),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,)),
                                errorStyle:
                                TextStyle(color: Colors.redAccent, fontSize: 15.0),
                              ),
                              controller: mobileController,
                              validator: (value){
                                if (value == null || value.isEmpty)
                                {
                                  return "Please Enter Number";
                                }
                                else if(!RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$').hasMatch(value)){
                                  return "Please Enter Valid Number";
                                }
                                return null;
                              },
                            )
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            child: TextFormField(
                              autofocus: false,
                              cursorColor: Colors.white,
                              style: const TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: "Email",
                                labelStyle: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.white)),
                                errorStyle: TextStyle(
                                    color: Colors.redAccent, fontSize: 15.0),
                              ),
                              controller: emailController,
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
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            child: TextFormField(
                              autofocus: false,
                              cursorColor: Colors.white,
                              style: const TextStyle(fontSize: 20.0,color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: "Address",
                                labelStyle: TextStyle(fontSize: 20.0,color: Colors.white),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                errorStyle:
                                TextStyle(color: Colors.redAccent, fontSize: 15.0),
                              ),
                              controller: addressController,
                              validator: (value){
                                if (value == null || value.isEmpty)
                                {
                                  return "Please Enter Address";
                                }
                                return null;
                              },
                            )
                        ),


                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            child: TextFormField(
                              autofocus: false,
                              cursorColor: Colors.white,
                              style: const TextStyle(fontSize: 20.0,color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: "Password",
                                labelStyle: TextStyle(fontSize: 20.0,color: Colors.white),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                errorStyle:
                                TextStyle(color: Colors.redAccent, fontSize: 15.0),
                              ),
                              controller: passwordController,
                              validator: (value){
                                if (value == null || value.isEmpty)
                                {
                                  return "Please Enter Password";
                                }
                                else if(value.length < 6){
                                  return "Password must be at least 6 characters long";
                                }
                                return null;
                              },
                            )
                        ),
                        Container(
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {

                                if(_formKey.currentState!.validate()){
                                  setState(() async {
                                    name = nameController.text;
                                    mobile = mobileController.text;
                                    address = addressController.text;
                                    email = emailController.text;
                                    password = passwordController.text;
                                    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text , password: passwordController.text );
                                    var user = FirebaseAuth.instance.currentUser;
                                    if(user!=null)
                                    {
                                      await user.sendEmailVerification();

                                    }
                                    else
                                    {
                                      Fluttertoast.showToast(
                                          msg: "Couldn't verify the email!",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );
                                    }

                                    addUser();
                                    clearText();

                                  }
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.deepOrange,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100),

                                  )),
                              child:  const Center(child: Text('Sign Up',style: TextStyle(fontSize: 20,color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                )
            )
        )
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ForgotPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Forgot Password",
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        autofocus: false,
                        cursorColor: Colors.white,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 20.0,color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(fontSize: 20.0,color: Colors.white),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 15.0),
                        ),
                        controller: emailController,
                        validator: (value){
                          if (value == null || value.isEmpty)
                          {
                            return "Please Enter ";
                          }
                          else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return

                              'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40,),
                      ElevatedButton(onPressed: () async{
                        try {
                          await auth.sendPasswordResetEmail(email: emailController.text).then((value)=>
                              Fluttertoast.showToast(
                                  msg: "Email Sent",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              )
                          );
                        } on FirebaseAuthException catch (error) {
                          Fluttertoast.showToast(
                              msg: error.code,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                      },

                          style: ElevatedButton.styleFrom(
                              primary: Colors.deepOrange,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100),

                              )),
                          child: const Center(child: Text('Reset Password',style: TextStyle(fontSize: 25,color: Colors.white)),)),
                    ]
                )
            )
        ),


    );
  }
}

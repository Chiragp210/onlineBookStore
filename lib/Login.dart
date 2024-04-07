import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onlinebookstore/AdminPages/AdminHome.dart';
import 'package:onlinebookstore/ForgotPassword.dart';
import 'package:onlinebookstore/Registration.dart';
import 'package:onlinebookstore/UserPages/UserHome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  String _password = '';
  final _formKey = GlobalKey<FormState>();
  TextEditingController tec1 = TextEditingController();
  TextEditingController tec2 = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData && snapshot.data != null) {
              // User or admin is already logged in
              User? user = snapshot.data;
              // Check if admin is logged in
              bool isAdmin = user?.email == "admin123@gmail.com";
              // Navigate to respective home page
              return isAdmin ? AdminHomePage() : UserHomePage();
            } else {
              // User or admin is not logged in, show login page
              return _buildLoginPage();
            }
          }
        },
      ),
    );
  }

  Widget _buildLoginPage() {
    TextFormField tf1 = TextFormField(
      controller: tec1,
      autofocus: false,
      cursorColor: Colors.white,
      style: const TextStyle(fontSize: 20.0, color: Colors.white),
      decoration: const InputDecoration(
        suffixIcon: Icon(Icons.person, color: Colors.white),
        labelText: "Email",
        labelStyle: TextStyle(fontSize: 20.0, color: Colors.white),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      ),
    );
    TextFormField tf2 = TextFormField(
      controller: tec2,
      autofocus: false,
      onChanged: (value) {
        _password = value;
      },
      obscureText: _isObscure,
      cursorColor: Colors.white,
      style: const TextStyle(fontSize: 20.0, color: Colors.white),
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            _isObscure ? Icons.visibility : Icons.visibility_off,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
              if (!_isObscure) {
                tec2.text = _password;
              }
            });
          },
        ),
        labelText: "Password",
        labelStyle: TextStyle(fontSize: 20.0, color: Colors.white),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      ),
    );
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/Images/img2.png"), fit: BoxFit.cover),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 95),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 7.0),
                padding: const EdgeInsets.all(5),
                child: tf1,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 7.0),
                padding: const EdgeInsets.all(5),
                child: tf2,
              ),

              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(5),
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });

                    if (tec1.text == "admin123@gmail.com" && tec2.text == "Admin@123") {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomePage()));
                    } else {
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(email: tec1.text, password: tec2.text);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserHomePage()));
                        tec1.clear();
                        tec2.clear();
                      } on FirebaseAuthException catch (error) {
                        Fluttertoast.showToast(
                          msg: error.code,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    }

                    setState(() {
                      _isLoading = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepOrange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  ),
                  child: const Center(child: Text('Log-In', style: TextStyle(fontSize: 20, color: Colors.white))),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                  },
                  child: const Text('Forgot Password', style: TextStyle(color: Colors.red, fontSize: 15)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegitrationPage()));
                },
                child: const Text('Sign Up', style: TextStyle(color: Colors.blue, fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

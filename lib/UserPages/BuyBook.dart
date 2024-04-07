import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onlinebookstore/UserPages/UserHome.dart';
import 'package:onlinebookstore/UserPages/upi_payment_screen.dart';


class BuyBookPage extends StatefulWidget {

  @override
  final double price;
  final String title;
  final String id;
  const BuyBookPage(this.id,this.price,this.title, {super.key});
  State<StatefulWidget> createState() => _BuyBookPageState();
}

class _BuyBookPageState extends State<BuyBookPage> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final pincodeController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final houseController = TextEditingController();
  final quantityController = TextEditingController();
  String phoneNumberError = '';
  String pincodeError = '';
  String nameError = '';
  String stateError = '';
  String cityError = '';
  String houseError = '';
  String quatityError = '';
  String paymentMethod = '';

  late double totalprice = double.parse(quantityController.text)*widget.price;

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Book Order Confirmed'),
          content: const Text('Your book order is confirmed.'),
          actions: [
            TextButton(
              onPressed: () {
                if (paymentMethod=="Online") {
                  final double price = totalprice;
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => UpiPaymentScreen(price: price,)));
                }
                else{
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => UserHomePage()));
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
          extendBody: true,
          appBar: AppBar(
              title: const Text("Add Address",
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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.name,
                            controller: fullNameController,
                            decoration: const InputDecoration(labelText: 'Full Name',labelStyle: TextStyle(
                              color: Colors.white,)),
                            cursorColor: Colors.white,
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: phoneNumberController,
                            decoration: const InputDecoration(labelText: 'Phone Number',labelStyle: TextStyle(
                              color: Colors.white,)),
                            cursorColor: Colors.white,
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              if (value.length != 10) {
                                return 'Phone number should be 10 digits';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                phoneNumberError = '';
                              }
                            },
                          ),
                          Text(
                            phoneNumberError,
                            style: const TextStyle(color: Colors.red),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: pincodeController,
                            decoration: const InputDecoration(labelText: 'Pincode',labelStyle: TextStyle(
                              color: Colors.white,)),
                            cursorColor: Colors.white,
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the pincode';
                              }
                              if (value.length != 6) {
                                return 'Pincode should be of 6 digits';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                pincodeError = '';
                              }
                            },
                          ),
                          Text(
                            pincodeError,
                            style: const TextStyle(color: Colors.red),
                          ),
                          TextFormField(
                            controller: stateController,
                            decoration: const InputDecoration(labelText: 'State',labelStyle: TextStyle(
                              color: Colors.white,)),
                            cursorColor: Colors.white,
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your state';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                stateError = '';
                              }
                            },
                          ),
                          Text(
                            stateError,
                            style: const TextStyle(color: Colors.red),
                          ),
                          TextFormField(
                            controller: cityController,
                            decoration: const InputDecoration(labelText: 'City',labelStyle: TextStyle(
                              color: Colors.white,)),
                            cursorColor: Colors.white,
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your city';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                cityError = '';
                              }
                            },
                          ),
                          Text(
                            cityError,
                            style: const TextStyle(color: Colors.red),
                          ),
                          TextFormField(
                            controller: houseController,
                            decoration: const InputDecoration(labelText: 'House',labelStyle: TextStyle(
                              color: Colors.white,)),
                            cursorColor: Colors.white,
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your house';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                houseError = '';
                              }
                            },
                          ),
                          Text(
                            houseError,
                            style: const TextStyle(color: Colors.red),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: quantityController,
                            decoration: const InputDecoration(labelText: 'Quantity',labelStyle: TextStyle(
                              color: Colors.white,)),
                            cursorColor: Colors.white,
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter quantity';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Quantity must be a number';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  totalprice = double.parse(value) * widget.price;
                                });
                              }
                            },
                          ),
                          quantityController.text.isNotEmpty && double.tryParse(quantityController.text) != null
                              ? Text(
                            'Total Price: ₹${totalprice.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                          )
                              : const SizedBox.shrink(),
                          Row(
                            children: [
                              const Text('Payment: ',style: TextStyle(
                                color: Colors.white,fontSize: 20.0,)),
                              Radio(
                                value: 'COD',
                                activeColor: Colors.white,
                                groupValue: paymentMethod,
                                onChanged: (value) {
                                  setState(() {
                                    paymentMethod = value!;
                                  });
                                },
                              ),
                              const Text("COD",style: TextStyle(
                                color: Colors.white,fontSize: 20.0,)),
                              Radio(
                                value: 'Online',
                                activeColor: Colors.white,
                                groupValue: paymentMethod,
                                onChanged: (value) {
                                  setState(() {
                                    paymentMethod = value!;
                                  });
                                },
                              ),
                              const Text("Online",style: TextStyle(
                                color: Colors.white,fontSize: 20.0,)),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Center(
                            child: SizedBox(
                              height: 50,
                              width: 280,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrange,
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                child: const Text('Confirm Book Order',style: TextStyle(
                                  color: Colors.white,)),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    final orderData = {
                                      'userUid': FirebaseAuth.instance.currentUser?.uid,
                                      'fullName': fullNameController.text,
                                      'phoneNumber': phoneNumberController.text,
                                      'pincode': pincodeController.text,
                                      'state': stateController.text,
                                      'city': cityController.text,
                                      'house': houseController.text,
                                      'quantity': double.parse(quantityController.text),
                                      'title': widget.title,
                                      'totalprice': totalprice,
                                      'paymentMethod': paymentMethod,
                                    };
                                    FirebaseFirestore.instance.collection('oderDetails').add(orderData);
                                    _showConfirmationDialog();
                                    fullNameController.clear();
                                    phoneNumberController.clear();
                                    pincodeController.clear();
                                    stateController.clear();
                                    cityController.clear();
                                    houseController.clear();
                                    quantityController.clear();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
          ),

        ));
  }
}

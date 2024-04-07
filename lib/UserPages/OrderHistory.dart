import 'package:casa_vertical_stepper/casa_vertical_stepper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onlinebookstore/Login.dart';
import 'package:vertical_page_stepper/vertical_page_stepper.dart';
import 'package:onlinebookstore/UserPages/UserHome.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  void _deleteOrder(String oId) async {
    try {
      // Delete the service document from Firestore
      await FirebaseFirestore.instance.collection('oderDetails').doc(oId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order deleted successfully.'),
        ),
      );
    } catch (error) {
      print('Error deleting order: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error deleting order.'),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
        top: false,
        child: Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: const Text("User Order History",
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
                        image: AssetImage("assets/Images/img.png"),
                        fit: BoxFit.cover)),

                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('oderDetails')
                        .where('userUid',
                        isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      List<QueryDocumentSnapshot> customerorder = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: customerorder.length,
                        itemBuilder: (context, index) {
                          var orderData =
                          customerorder[index]!.data() as Map<String, dynamic>;
                          String orderid = customerorder[index].id;
                          String name = orderData['fullName'] ?? '';
                          String title = orderData['title'] ?? '';
                          String house = orderData['house'] ?? '';
                          String city = orderData['city'] ?? '';
                          String state = orderData['state'] ?? '';
                          double quatity = orderData['quantity'] ?? '';
                          String paymentmethod = orderData['paymentMethod'] ?? '';
                          String pincode = orderData['pincode'] ?? '';
                          double price = orderData['totalprice'] ?? '';
                          String phone = orderData['phoneNumber'] ?? '';

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      'Order ID: ${customerorder[index].id}',
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Full Name: $name',
                                          style: TextStyle(fontSize: 14,),
                                        ),
                                        Text(
                                          'Book Title: $title',
                                          style: TextStyle(fontSize: 14,),
                                        ),
                                        Text(
                                          'House: $house',
                                          style: TextStyle(fontSize: 14,),
                                        ),
                                        Text(
                                          'City: $city',
                                          style: TextStyle(fontSize: 14,),
                                        ),
                                        Text(
                                          'State: $state',
                                          style: TextStyle(fontSize: 14,),
                                        ),
                                        Text(
                                          'Pincode: $pincode',
                                          style: TextStyle(fontSize: 14,),
                                        ),
                                        Text(
                                          'Payment: $paymentmethod',
                                          style: TextStyle(fontSize: 14,),
                                        ),
                                        Text(
                                          'Quntity: ${quatity.toStringAsFixed(2)}',
                                          style: TextStyle(fontSize: 14,),
                                        ),
                                        Text(
                                          'Price: ₹${price.toStringAsFixed(2)}',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          'Phone number: $phone',
                                          style: TextStyle(fontSize: 14,),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [

                                            IconButton(
                                              icon: const Icon(Icons.delete, color: Colors.red),
                                              onPressed: () => _deleteOrder(orderid),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.track_changes, color: Colors.red),
                                              onPressed: () {
                                                final String id = orderid;
                                                Navigator.pushReplacement(context,
                                                    MaterialPageRoute(builder: (context) => OrderTrackPage(id)));},
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
              )
          ),

        ));
  }
}





class OrderTrackPage extends StatefulWidget {
  final String id;
  const OrderTrackPage(this.id, {super.key});
  @override
  State<StatefulWidget> createState() => _OrderTrackPageState();
}

class _OrderTrackPageState extends State<OrderTrackPage> {

  var Mystep=0;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: const Text("Order Track Page",
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
              child: Stepper(
                currentStep: Mystep,
                steps: [
                  Step(title: Text("Order Dispatch",style: TextStyle(color: Colors.greenAccent),),
                    content: Text("2023/12/13 11:35 AM Order Dispatch from storage",style: TextStyle(color: Colors.white),),
                    isActive: Mystep>=0,
                  ),
                  Step(title: Text("Order out for delivery",style: TextStyle(color: Colors.greenAccent),),
                    content: Text("2023/12/18 08:35 AM Order out for delivery",style: TextStyle(color: Colors.white),),
                    isActive: Mystep>=1,
                  ),
                  Step(title: Text("Order Placed",style: TextStyle(color: Colors.greenAccent),),
                    content: Text("2023/12/18 11:35 AM Order Placed",style: TextStyle(color: Colors.white),),
                    isActive: Mystep>=2,
                  ),

                ],
                onStepContinue: (){Mystep==2?null:setState(() {Mystep+=1;});},
                onStepCancel: (){Mystep==0?null:setState(() {Mystep-=1;});},
                onStepTapped: (a){setState(() {Mystep=a;print(a);});},

                controlsBuilder: (context, details) => Row(
                  children: [
                    ElevatedButton(onPressed: details.onStepContinue, child: Text('Next')),
                    ElevatedButton(onPressed: details.onStepCancel, child: Text('Back')),
                  ],
                ),
              )
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> UserHomePage()));
        },
        backgroundColor: Colors.red, // Function to handle FAB tap
        child: const Icon(Icons.home),
      ),
    );
  }
}

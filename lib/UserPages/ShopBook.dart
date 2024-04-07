import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_filters/data_filters.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:onlinebookstore/Login.dart';
import 'package:onlinebookstore/UserPages/BookDetails.dart';
import 'package:onlinebookstore/UserPages/BuyBook.dart';
import 'package:onlinebookstore/UserPages/UserHome.dart';

class ShopPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, dynamic>> _bookData = [];



  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('bookInfo')
        .get()
        .then((querySnapshot) {
      setState(() {
        _bookData = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    });
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }



  // Future<void> _confirmSignOut(BuildContext context) async {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Confirm Sign Out'),
  //         content: const Text('Are you sure you want to sign out?'),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               await FirebaseAuth.instance.signOut();
  //
  //               Navigator.pushReplacement(context,
  //                   MaterialPageRoute(builder: (context) => LoginPage()));
  //             },
  //             child: const Text('Sign Out'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  List<int>? filterIndex ;

  @override
  Widget build(BuildContext context) {
    List<String> filterTitles = [
      'Title',
      'Author',
      'Genre', // Add more filters as needed
    ];
    List<List<dynamic>> _bookDataList = _bookData.map((book) => filterTitles.map((title) => book[title]).toList()).toList();


    List<Map<String, dynamic>> filteredBooks = _bookData.where((book) {
      String bookName = book['Title'] ?? "";
      String authorName = book['AuthName'] ?? "";
      String genre = book['Genre'] ?? "";

      return bookName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          authorName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          genre.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (_searchQuery.isNotEmpty) {
      filteredBooks.sort((a, b) {
        if (a['Title'].toLowerCase().contains(_searchQuery.toLowerCase()) &&
            !b['Title'].toLowerCase().contains(_searchQuery.toLowerCase())) {
          return -1;
        } else if (b['Title']
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()) &&
            !a['Title'].toLowerCase().contains(_searchQuery.toLowerCase())) {
          return 1;
        }

        if (a['AuthName'].toLowerCase().contains(_searchQuery.toLowerCase()) &&
            !b['AuthName'].toLowerCase().contains(_searchQuery.toLowerCase())) {
          return -2;
        } else if (b['AuthName']
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()) &&
            !a['AuthName'].toLowerCase().contains(_searchQuery.toLowerCase())) {
          return 2;
        }
        if (a['Genre'].toLowerCase().contains(_searchQuery.toLowerCase()) &&
            !b['Genre'].toLowerCase().contains(_searchQuery.toLowerCase())) {
          return -3;
        } else if (b['Genre']
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()) &&
            !a['Genre'].toLowerCase().contains(_searchQuery.toLowerCase())) {
          return 3;
        }
        String aCombined = '${a['Title']} ${a['AuthName']} ${a['Genre']}';
        String bCombined = '${b['Title']} ${b['AuthName']} ${b['Genre']}';
        return aCombined.toLowerCase().compareTo(bCombined.toLowerCase());
      });
    }
    return SafeArea(
        top: false,
        child: Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: const Text("Book Shop",
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
          // drawer: Drawer(
          //   child: ListView(
          //     padding: EdgeInsets.zero,
          //     children: <Widget>[
          //       DrawerHeader(
          //         // Your drawer header content...
          //         decoration: BoxDecoration(
          //           color: Colors.deepOrange,
          //         ),
          //         child: Text(
          //           'Drawer Header',
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 24,
          //           ),
          //         ),
          //       ),
          //       ListTile(
          //         title: Text('Logout'),
          //         onTap: () {
          //           showDialog(
          //             context: context,
          //             builder: (BuildContext context) {
          //               return AlertDialog(
          //                 title: Text('Confirm Logout'),
          //                 content: Text('Are you sure you want to log out?'),
          //                 actions: <Widget>[
          //                   TextButton(
          //                     onPressed: () {
          //                       Navigator.of(context)
          //                           .pop(); // Close the alert dialog
          //                     },
          //                     child: Text('Cancel'),
          //                   ),
          //                   TextButton(
          //                     onPressed: () {
          //                       _confirmSignOut(
          //                           context); // Call the sign out method
          //                       Navigator.of(context)
          //                           .pop(); // Close the alert dialog
          //                     },
          //                     child: Text('Logout'),
          //                   ),
          //                 ],
          //               );
          //             },
          //           );
          //         },
          //       ),
          //     ],
          //   ),
          // ),
          body: Center(
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/Images/img.png"),
                          fit: BoxFit.cover)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(Icons.search, color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(),
                            ),
                          ),
                          onChanged: (query) {
                            setState(() {
                              _searchQuery = query;
                            });
                          },
                        ),
                      ),

                      // DataFilters( // Replace FilterListWidget with DataFilters
                      //   data: _bookDataList,
                      //   filterTitle: filterTitles,
                      //   showAnimation: true,
                      //   recent_selected_data_index: (List<int>? index) {
                      //     setState(() {
                      //       filterIndex = index ?? [];
                      //     });
                      //   },
                      //   style: FilterStyle(
                      //     buttonColor: Colors.green,
                      //     buttonColorText: Colors.white,
                      //     filterBorderColor: Colors.grey,
                      //   ),
                      // ),
                      // const SizedBox(height: 20),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('bookInfo')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }

                            return ListView.builder(
                              itemCount: filteredBooks.length,
                              itemBuilder: (context, index) {
                                if (filterIndex == null || filterIndex!.contains(index)) {
                                  var bookData = filteredBooks[index]
                                  as Map<String, dynamic>;
                                  var bookId = snapshot.data!.docs[index].id;
                                  var bookImage = bookData['imageLink'] ?? '';
                                  var bookTitle = bookData['Title'] ?? '';
                                  var bookAuth = bookData['AuthName'] ?? '';
                                  var bookIsbn = bookData['ISBN'] ?? '';
                                  var bookGenre = bookData['Genre'] ?? '';
                                  var bookPrice = bookData['Price'] ?? '';
                                  var bookDesc = bookData['Desc'] ?? '';

                                  return Card(
                                    margin: const EdgeInsets.all(8),

                                    elevation: 2,
                                    child: ListTile(

                                      contentPadding:
                                      const EdgeInsets.all(16),
                                      leading: Image.network(
                                        bookImage,
                                        width: 100,
                                        height: 100,
                                      ),

                                      title: Text(
                                        'Title: $bookTitle',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Author: $bookAuth',
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              'Generation: $bookGenre',
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              'ISBN: $bookIsbn',
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              'Price: \₹$bookPrice',
                                              style: const TextStyle(
                                                  fontSize: 16),
                                            ),
                                            Align(
                                                alignment:
                                                Alignment.centerRight,
                                                child: Container(
                                                    height: 35,
                                                    width: 130,
                                                    child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                            primary: Colors
                                                                .green,
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  100),
                                                            )),
                                                        onPressed: () {
                                                          final double price =
                                                              bookPrice;
                                                          final String title =
                                                              bookTitle;
                                                          final String id =
                                                              bookId;
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      BuyBookPage(
                                                                          id,
                                                                          price,
                                                                          title)));
                                                        },
                                                        child: const Center(
                                                          child: Text(
                                                            'Buy Book',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )))),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Align(
                                                alignment:
                                                Alignment.centerRight,
                                                child: Container(
                                                    height: 35,
                                                    width: 130,
                                                    child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                            primary: Colors
                                                                .green,
                                                            shape:
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  100),
                                                            )),
                                                        onPressed: () {
                                                          final double price =
                                                              bookPrice;
                                                          final String title =
                                                              bookTitle;
                                                          final String id =
                                                              bookId;
                                                          // Pass item details to the addToCart function in ShoppingCartPage
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      ShoppingCartPage(
                                                                          title,
                                                                          price,
                                                                          id)));
                                                        },
                                                        child: const Center(
                                                          child: Text(
                                                            'Add To Cart',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                    )
                                                )
                                            )
                                          ]),
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BookDetailPage(bookData, documentId: bookId),
                                          ),
                                        );

                                      },
                                    ),
                                  );
                                }},
                            );
                          },
                        ),
                      ),
                    ],
                  ))),
        ));
  }
}

class ShoppingCartPage extends StatefulWidget {
  @override
  final double price;
  final String title;
  final String id;
  const ShoppingCartPage(this.title, this.price, this.id, {super.key});
  State<StatefulWidget> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  List<Map<String, dynamic>> _cartItems = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void addToCart(Map<String, dynamic> item) {
    _firestore
        .collection('Customer')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('bookInfo')
        .add(item);
    setState(() {
      _cartItems.add(item);
    });
  }

  void removeFromCart(int index) {
    final itemToRemove = _cartItems[index];
    _firestore
        .collection('Customer')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('bookInfo')
        .where('Title', isEqualTo: itemToRemove['Title'])
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  double calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var item in _cartItems) {
      totalPrice += item['Price'];
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
            extendBody: true,
            appBar: AppBar(
              title: const Text(
                "Shopping Cart",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.deepOrange,
            ),
            body: Center(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/Images/img.png"),
                          fit: BoxFit.cover)),
                  child: Column(
                    children: [
                      // Display the cart items
                      Expanded(
                        child: _cartItems.isEmpty
                            ? Center(
                            child: Text(
                              "Your cart is empty",
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ))
                            : ListView.builder(
                          itemCount: _cartItems.length,
                          itemBuilder: (context, index) {
                            var cartItem = _cartItems[index];
                            return ListTile(
                              title: Text(cartItem['Title']),
                              subtitle: Text('Price: \₹${cartItem['Price']}'),
                              trailing: IconButton(
                                icon: Icon(Icons.remove_shopping_cart),
                                onPressed: () {
                                  removeFromCart(index);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      // Display the total price
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Total Price: \₹${calculateTotalPrice()}',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      // Display passed data
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'ID: ${widget.id}, Price: \₹${widget.price}, Title: ${widget.title}',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      Container(
                          height: 35,
                          width: 130,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  )),
                              onPressed: () {
                                final double price = widget.price;
                                final String title = widget.title;
                                final String id = widget.id;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BuyBookPage(id, price, title)));
                              },
                              child: const Center(
                                child: Text(
                                  'Buy Book',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ))),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ))));
  }
}

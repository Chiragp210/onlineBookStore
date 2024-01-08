import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
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

  signout() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => UserHomePage()));
  }

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Shop",
            style: TextStyle(color: Colors.white, fontSize: 20)),
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
                  const SizedBox(
                    height: 20,
                  ),
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
                            var bookData =
                                filteredBooks[index] as Map<String, dynamic>;
                            var bookId = snapshot.data!.docs[index].id;
                            var bookImage = bookData['imageLink'] ?? '';
                            var bookTitle = bookData['Title'] ?? '';
                            var bookAuth = bookData['AuthName'] ?? '';
                            var bookIsbn = bookData['ISBN'] ?? '';
                            var bookGenre = bookData['Genre'] ?? '';
                            var bookPrice = bookData['Price'] ?? '';

                            return Card(
                              margin: const EdgeInsets.all(8),
                              elevation: 2,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
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
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                              height: 35,
                                              width: 130,
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: Colors.green,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                          )),
                                                  onPressed: () {
                                                    final double price =
                                                        bookPrice;
                                                    final String title =
                                                        bookTitle;
                                                    final String id = bookId;
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
                                                          color: Colors.white),
                                                    ),
                                                  )))),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                              height: 35,
                                              width: 130,
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: Colors.green,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                          )),
                                                  onPressed: () {
                                                    final double price =
                                                        bookPrice;
                                                    final String title =
                                                        bookTitle;
                                                    final String id = bookId;
                                                    // Pass item details to the addToCart function in ShoppingCartPage
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ShoppingCartPage(title, price, id)));
                                                    },
                                                  child: const Center(
                                                    child: Text(
                                                      'Add To Cart',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ))))
                                    ]),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: signout,
        backgroundColor: Colors.red, // Function to handle FAB tap
        child: const Icon(Icons.home),
      ),
    );
  }
}

class ShoppingCartPage extends StatefulWidget {
  @override
  final double price;
  final String title;
  final String id;
  const ShoppingCartPage(this.title,this.price,this.id, {super.key});
  State<StatefulWidget> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {

  List<Map<String, dynamic>> _cartItems = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  void addToCart(Map<String, dynamic> item) {
    _firestore.collection('Customer').doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('bookInfo').add(item);
    setState(() {
      _cartItems.add(item);
    });
  }

  void removeFromCart(int index) {
    final itemToRemove = _cartItems[index];
    _firestore.collection('Customer').doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('bookInfo').where('Title', isEqualTo: itemToRemove['Title']).get()
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Cart",style: TextStyle(color: Colors.white),),
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
                ? Center(child: Text("Your cart is empty", style: TextStyle(fontSize: 18 , color: Colors.white),))
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
            ),
          ),
          // Display passed data
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'ID: ${widget.id}, Price: \₹${widget.price}, Title: ${widget.title}',
              style: TextStyle(fontSize: 18 , color: Colors.white),
            ),
          ),
        Container(
                  height: 35,
                  width: 130,
                  child: ElevatedButton(
                      style:
                      ElevatedButton.styleFrom(
                          primary: Colors.green,
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                                100),
                          )),
                      onPressed: () {
                        final double price =
                            widget.price;
                        final String title =
                            widget.title;
                        final String id = widget.id;
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
                              color: Colors.white),
                        ),
                      ))),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    )));
  }
}

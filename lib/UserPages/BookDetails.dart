import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onlinebookstore/Login.dart';
import 'package:onlinebookstore/UserPages/BuyBook.dart';
import 'package:onlinebookstore/UserPages/ShopBook.dart';

class BookDetailPage extends StatelessWidget {
  final Map<String, dynamic> bookData;
  final String documentId;
  const BookDetailPage(this.bookData, {required this.documentId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bookId = documentId; // Retrieve the document ID
    var bookImage = bookData['imageLink'] ?? '';
    var bookTitle = bookData['Title'] ?? '';
    var bookAuth = bookData['AuthName'] ?? '';
    var bookIsbn = bookData['ISBN'] ?? '';
    var bookGenre = bookData['Genre'] ?? '';
    var bookPrice = bookData['Price'] ?? '';
    var bookDesc = bookData['Desc'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("BookDetails",
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
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Images/img.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 4/3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.network(
                          bookImage,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Title: $bookTitle',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text('Author: $bookAuth',style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 8.0),
                    Text('Genre: $bookGenre',style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 8.0),
                    Text('ISBN: $bookIsbn',style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 8.0),
                    Text('Price: ₹${bookPrice.toStringAsFixed(2)}',style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Description:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                    Text(bookDesc,style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
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
                        ),
                        ElevatedButton(
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
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



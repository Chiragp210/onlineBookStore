import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onlinebookstore/AdminPages/AdminHome.dart';
import 'package:onlinebookstore/Login.dart';

class BookListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, dynamic>> _bookData = [];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('bookInfo').get().then((querySnapshot) {
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

  void _editbook(String bId) {
    // Navigate to the edit service screen and pass the serviceId
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBookScreen(bId: bId),
      ),
    );
  }

  void _deletebook(String bId) async {
    try {
      // Delete the service document from Firestore
      await FirebaseFirestore.instance.collection('bookInfo').doc(bId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Book deleted successfully.'),
        ),
      );
    } catch (error) {
      print('Error deleting Book: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error deleting Book.'),
        ),
      );
    }
  }
  signout() async{
    await auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AdminHomePage()));
  }
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredBooks = _bookData.where((book) {
      String bookName = book['Title'] ?? "";
      String authorName = book['AuthName'] ?? "";
      String genre = book['Genre'] ?? "";

      return bookName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          authorName.toLowerCase().contains(_searchQuery.toLowerCase())||
          genre.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (_searchQuery.isNotEmpty) {
      filteredBooks.sort((a, b) {
        if (a['Title'].toLowerCase().contains(_searchQuery.toLowerCase()) &&
            !b['Title'].toLowerCase().contains(_searchQuery.toLowerCase())) {
          return -1;
        } else if (b['Title'].toLowerCase().contains(_searchQuery.toLowerCase()) &&
            !a['Title'].toLowerCase().contains(_searchQuery.toLowerCase())) {
          return 1;
        }
        if (a['AuthName'].toLowerCase().contains(_searchQuery.toLowerCase()) &&
            !b['AuthName'].toLowerCase().contains(_searchQuery.toLowerCase())) {
          return -2;
        } else if (b['AuthName'].toLowerCase().contains(_searchQuery.toLowerCase()) &&
            !a['AuthName'].toLowerCase().contains(_searchQuery.toLowerCase())) {
          return 2;
        }
        if (a['Genre'].toLowerCase().contains(_searchQuery.toLowerCase()) &&
            !b['Genre'].toLowerCase().contains(_searchQuery.toLowerCase())) {
          return -3;
        } else if (b['Genre'].toLowerCase().contains(_searchQuery.toLowerCase()) &&
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
        child:Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: const Text("Book List",
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
                      const SizedBox(height: 20,),
                      Expanded(
                        child:StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('bookInfo').snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            }

                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var bookData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
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
                                    contentPadding: const EdgeInsets.all(16),
                                    leading: Image.network(
                                      bookImage,
                                      width: 100,
                                      height: 100,
                                    ),
                                    title: Text(
                                      'Title: $bookTitle',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    subtitle:  Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Author: $bookAuth',
                                            style: const TextStyle(fontSize: 16,),
                                          ),
                                          Text(
                                            'Generation: $bookGenre',
                                            style: const TextStyle(fontSize: 16,),
                                          ),
                                          Text(
                                            'ISBN: $bookIsbn',
                                            style: const TextStyle(fontSize: 16,),
                                          ),
                                          Text(
                                            'Price: \₹$bookPrice',
                                            style: const TextStyle(fontSize: 16),
                                          ),

                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit, color: Colors.blue),
                                                onPressed: () => _editbook(bookId),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete, color: Colors.red),
                                                onPressed: () => _deletebook(bookId),
                                              ),
                                            ],
                                          ),
                                        ]
                                    ),

                                  ),
                                );
                              },
                            );
                          },
                        ),)
                    ],
                  )
              )
          ),
        )
    );
  }
}

class EditBookScreen extends StatefulWidget {
  final String bId;

  const EditBookScreen({Key? key, required this.bId}) : super(key: key);

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  TextEditingController _bookNameController = TextEditingController();
  TextEditingController _bookAuthNameController = TextEditingController();
  TextEditingController _bookPriceController = TextEditingController();
  TextEditingController _bookIsbnController = TextEditingController();
  TextEditingController _bookGenreController = TextEditingController();
  TextEditingController _bookDescController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch service details and populate the fields
    fetchBookDetails();
  }

  void fetchBookDetails() async {
    try {
      DocumentSnapshot serviceSnapshot =
      await FirebaseFirestore.instance.collection('bookInfo').doc(widget.bId).get();

      var bookData = serviceSnapshot.data() as Map<String, dynamic>;

      setState(() {
        _bookNameController.text = bookData['Title'] ?? '';
        _bookAuthNameController.text = bookData['AuthName'] ?? '';
        _bookPriceController.text = bookData['Price'].toString() ?? '';
        _bookIsbnController.text = bookData['ISBN'] ?? '';
        _bookGenreController.text = bookData['Gerne'] ?? '';
        _bookDescController.text = bookData['Desc'] ?? '';
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching service details: $error');
    }
  }

  void _updateBook() async {
    try {
      await FirebaseFirestore.instance.collection('bookInfo').doc(widget.bId).update({
        'Title': _bookNameController.text,
        'AuthName': _bookAuthNameController.text,
        'Price': double.parse(_bookPriceController.text),
        'ISBN': _bookIsbnController.text,
        'Gerne': _bookGenreController.text,
        'Desc': _bookDescController.text
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Book updated successfully.'),
        ),
      );

      // Navigate back to the service list screen
      Navigator.pop(context);
    } catch (error) {
      print('Error updating book: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error updating book.'),
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
              title: const Text("Update Book", style: TextStyle(color: Colors.white, fontSize: 20)),
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
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0),
                          child:TextField(
                            controller: _bookNameController,
                            style: const TextStyle(fontSize: 16,color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: "Book Title",
                              labelStyle: TextStyle(
                                  fontSize: 15.0, color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white)),
                              errorStyle:
                              TextStyle(color: Colors.redAccent,
                                  fontSize: 15.0),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0),
                          child: TextField(
                            controller: _bookAuthNameController,
                            style: const TextStyle(fontSize: 16,color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: "Book Auth Name",
                              labelStyle: TextStyle(
                                  fontSize: 15.0, color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white)),
                              errorStyle:
                              TextStyle(color: Colors.redAccent,
                                  fontSize: 15.0),

                            ),

                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0),
                          child:TextField(
                            controller: _bookIsbnController,
                            style: const TextStyle(fontSize: 16,color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: "Book ISBN",
                              labelStyle: TextStyle(
                                  fontSize: 15.0, color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white)),
                              errorStyle:
                              TextStyle(color: Colors.redAccent,
                                  fontSize: 15.0),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0),
                          child:TextField(
                            controller: _bookGenreController,
                            style: const TextStyle(fontSize: 16,color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: "Book Generation",
                              labelStyle: TextStyle(
                                  fontSize: 15.0, color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white)),
                              errorStyle:
                              TextStyle(color: Colors.redAccent,
                                  fontSize: 15.0),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0),
                          child:
                          TextField(
                            controller: _bookPriceController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: const TextStyle(fontSize: 16,color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: "Price",
                              labelStyle: TextStyle(
                                  fontSize: 15.0, color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white)),
                              errorStyle:
                              TextStyle(color: Colors.redAccent,
                                  fontSize: 15.0),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0),
                          child:TextField(
                            controller: _bookDescController,
                            style: const TextStyle(fontSize: 16,color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: "Book Description",
                              labelStyle: TextStyle(
                                  fontSize: 15.0, color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white)),
                              errorStyle:
                              TextStyle(color: Colors.redAccent,
                                  fontSize: 15.0),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0),
                          child: ElevatedButton(
                              onPressed: _updateBook,
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.deepOrange,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100),

                                  )),
                              child:  const Center(child: Text('Update Book',style: TextStyle(fontSize: 20,color: Colors.white)),


                              )),
                        ),
                      ],
                    ),
                  ),
                )
            )
        ));
  }
}

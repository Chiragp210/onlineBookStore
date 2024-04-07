
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../Login.dart';
import 'AddGenrePage.dart';


class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<StatefulWidget> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final Uuid uuid = Uuid();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final authnameController = TextEditingController();
  final isbnController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  String? selectedGenre;
  int? selectedGenreId;
  List<String> genreName = [];

  String? selectedImageURL;

  Future<void> loadGenres() async{
    final QuerySnapshot genreSnapshot = await _firestore.collection('genres').get();
    genreName = genreSnapshot.docs.map((doc) => doc['genreName'] as String).toList() ;
  }

  @override
  void dispose() {
    titleController.dispose();
    authnameController.dispose();
    isbnController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void clearText() {
    titleController.clear();
    authnameController.clear();
    isbnController.clear();

    priceController.clear();
    descriptionController.clear();
    selectedImageURL = null;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final serviceId = uuid.v4();
      final imageFile = File(pickedFile.path!);
      final imageFormat = imageFile.path.split('.').last;
      final reference = FirebaseStorage.instance.ref().child('bookImage/$serviceId.$imageFormat');

      final UploadTask uploadTask = reference.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() => null);

      if (snapshot.state == TaskState.success) {
        final downloadURL = await reference.getDownloadURL();

        setState(() {
          selectedImageURL = downloadURL;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image uploaded and selected successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload the image')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected')),
      );
    }
  }

  Future<void> addBook() async {
    String title = titleController.text;
    String authname = authnameController.text;
    String isbn = isbnController.text;
    String price = priceController.text;
    String desc = descriptionController.text;
    String? selectedImg = selectedImageURL;
    if (_formKey.currentState!.validate()) {
      try {
        final String serviceId = DateTime.now().millisecondsSinceEpoch.toString();
        await _firestore.collection('bookInfo').doc(serviceId).set({
          'Title': title,
          'AuthName': authname,
          'Genre': selectedGenre,
          'ISBN': isbn,
          'Price': double.parse(price),
          'Desc':desc,
          'imageLink': selectedImg, // Use the selected image URL
        });

        Fluttertoast.showToast(
          msg: "Book Added Successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        clearText();
      } catch (error) {
        Fluttertoast.showToast(
          msg: "Failed to add book: ${error.toString()}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }
  @override
  void initState() {
    super.initState();
    loadGenres();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: const Text("Book Inventory", style: TextStyle(color: Colors.white, fontSize: 20)),
            backgroundColor: Colors.deepOrange,
            actions: [

              IconButton(
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
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 36,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Admin',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'admin123@gmail.com',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: const Text('Add Genre',style: TextStyle(fontSize: 20)),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddGenrePage()));
                  },
                ),
                // Add more list tiles for other options if needed
              ],
            ),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Images/img2.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: const Center(
                        child: Text("Book ADD",style: TextStyle(color: Colors.white,fontSize: 40),),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 280,
                      child: ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            )
                        ),
                        child: const Text('Select Image',style: TextStyle(color: Colors.white),),
                      ),
                    ),
                    if (selectedImageURL != null)
                      Image.network(selectedImageURL!),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          autofocus: false,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                              fontSize: 20.0, color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: "Title",
                            labelStyle: TextStyle(
                                fontSize: 20.0, color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.white)),
                            errorStyle: TextStyle(
                                color: Colors.redAccent, fontSize: 15.0),
                          ),
                          controller: titleController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Title";
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
                            labelText: "Author Name",
                            labelStyle: TextStyle(
                                fontSize: 20.0, color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.white)),
                            errorStyle: TextStyle(
                                color: Colors.redAccent, fontSize: 15.0),
                          ),
                          controller: authnameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Author Name";
                            }
                            return null;
                          },
                        )
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: DropdownButtonFormField<String>(
                          dropdownColor: Colors.deepOrange,
                          items: genreName.isEmpty
                              ? [DropdownMenuItem(value: null, child: Text('Select Genre'))]
                              : genreName.map((genreName) {
                            return DropdownMenuItem<String>(
                              value: genreName,
                              child: Text(genreName),
                            );
                          }).toList(),
                          value: selectedGenre,
                          onChanged: (String? value) {
                            setState(() {
                              selectedGenre = value; // Assign the selected genre directly
                            });
                          },
                          decoration: InputDecoration(
                            labelText: "Genre",
                            labelStyle: TextStyle(fontSize: 20.0, color: Colors.white),
                            enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15.0),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Select genre";
                            }
                            return null;
                          },
                          isExpanded: true,
                          iconSize: 30.0,
                          style: const TextStyle(color: Colors.white, fontSize: 20),
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
                            labelText: "ISBN",
                            labelStyle: TextStyle(
                                fontSize: 20.0, color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.white)),
                            errorStyle: TextStyle(
                                color: Colors.redAccent, fontSize: 15.0),
                          ),
                          controller: isbnController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter ISBN";
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
                        style: const TextStyle(fontSize: 20.0, color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: "Price",
                          labelStyle: TextStyle(fontSize: 20.0, color: Colors.white),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15.0),
                        ),
                        controller: priceController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Price";
                          }
                          return null;
                        },
                      ),
                    ),

                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          autofocus: false,
                          cursorColor: Colors.white,
                          style: const TextStyle(fontSize: 20.0,color: Colors.white),
                          maxLines: 15,
                          decoration: const InputDecoration(
                            labelText: "Description",
                            labelStyle: TextStyle(fontSize: 20.0,color: Colors.white),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 15.0),

                          ),
                          controller: descriptionController,
                          validator: (value){
                            if (value == null || value.isEmpty)
                            {
                              return "Please Enter description";
                            }
                            return null;
                          },
                        )
                    ),

                    ElevatedButton(
                        onPressed: addBook,
                        style: ElevatedButton.styleFrom(
                            primary: Colors.deepOrange,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100),

                            )),
                        child:  const Center(child: Text('Add Book',style: TextStyle(fontSize: 20,color: Colors.white)),


                        ))
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}


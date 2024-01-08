
import 'dart:io';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';


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
  final genreController = TextEditingController();
  final isbnController = TextEditingController();
  final priceController = TextEditingController();

  String? selectedImageURL;

  @override
  void dispose() {
    titleController.dispose();
    authnameController.dispose();
    genreController.dispose();
    isbnController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void clearText() {
    titleController.clear();
    authnameController.clear();
    isbnController.clear();
    genreController.clear();
    priceController.clear();
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
    String genre = genreController.text;
    String isbn = isbnController.text;
    String price = priceController.text;
    String? selectedImg = selectedImageURL;
    if (_formKey.currentState!.validate()) {
      try {
        final String serviceId = DateTime.now().millisecondsSinceEpoch.toString();
        await _firestore.collection('bookInfo').doc(serviceId).set({
          'Title': title,
          'AuthName': authname,
          'Genre': genre,
          'ISBN': isbn,
          'Price': double.parse(price),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Inventory", style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Images/img.png"),
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
                    child: TextFormField(
                      autofocus: false,
                      cursorColor: Colors.white,
                      style: const TextStyle(fontSize: 20.0,color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Generation",
                        labelStyle: TextStyle(fontSize: 20.0,color: Colors.white),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15.0),
                      ),
                      controller: genreController,
                      validator: (value){
                        if (value == null || value.isEmpty)
                        {
                          return "Please Enter genre";
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
    );
  }
}


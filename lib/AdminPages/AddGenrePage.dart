import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddGenrePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddGenrePageState();
}

class _AddGenrePageState extends State<AddGenrePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _genreIdController = TextEditingController();
  final TextEditingController _genreNameController = TextEditingController();

  @override
  void dispose() {
    _genreIdController.dispose();
    _genreNameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed to save data
      String genreId = _genreIdController.text.trim();
      String genreName = _genreNameController.text.trim();

      // Store data in Firestore
      FirebaseFirestore.instance.collection('genres').add({
        'genreId': genreId,
        'genreName': genreName,
      }).then((_) {
        // Data added successfully, navigate back or show success message
        Navigator.pop(context);
      }).catchError((error) {
        // Error occurred while adding data
        // Handle error or show error message
        print("Failed to add genre: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Genre', style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.deepOrange,
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
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
              Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextFormField(
                    cursorColor: Colors.white,
                    style: const TextStyle(
                        fontSize: 20.0, color: Colors.white),
                    controller: _genreIdController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Genre ID",
                      labelStyle: TextStyle(
                          fontSize: 20.0, color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.white)),
                      errorStyle: TextStyle(
                          color: Colors.redAccent, fontSize: 15.0),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Genre ID';
                      }
                      return null;
                    },
                  )
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                    cursorColor: Colors.white,
                    style: const TextStyle(
                        fontSize: 20.0, color: Colors.white),
                    controller: _genreNameController,
                    decoration: const InputDecoration(
                      labelText: "Genre Name",
                      labelStyle: TextStyle(
                          fontSize: 20.0, color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.white)),
                      errorStyle: TextStyle(
                          color: Colors.redAccent, fontSize: 15.0),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Genre Name';
                      }
                      return null;
                    },
                  ),
              ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepOrange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100),

                        )),
                    child: const Center(child: Text('Add Genre',style: TextStyle(fontSize: 20,color: Colors.white)),
                  ),)
                ],
              ),
            ),
          )),
    );
  }
}

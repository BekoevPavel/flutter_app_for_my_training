import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class CreatePostScreen extends StatefulWidget {
  static const String id = 'create_post_screen';
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  String _description = '';

  Future<void> _submit({
    required File image,
  }) async {
    Navigator.pop(context);
    FocusScope.of(context).unfocus();
    if (_description.trim().isNotEmpty) {
      String imageUrl = '';
      firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;

      try {
        await storage
            .ref('images/${UniqueKey().toString()}.png')
            .putFile(image)
            .then((taskSnapshot) async {
          imageUrl = await taskSnapshot.ref.getDownloadURL();
        });
      } on firebase_core.FirebaseException catch (e, o) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 10),
            content: Text(e.message ?? 'error')));

        print('ERROROROR: ${e.message}');

        // ...
      }

      FirebaseFirestore.instance.collection('posts').add({
        'timeStamp': Timestamp.now(),
        'userID': FirebaseAuth.instance.currentUser!.uid,
        'description': _description,
        'userName': FirebaseAuth.instance.currentUser!.displayName,
        'imageUrl': imageUrl
      }).then((docRef) {
        docRef.update({'postID': docRef.id});
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> map =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final File imageFile = map['imageFile'] as File;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: (() => FocusScope.of(context).unfocus()),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 1.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: FileImage(imageFile), fit: BoxFit.cover),
                  ),
                ),
                TextField(
                  decoration:
                      const InputDecoration(hintText: 'Enter a description'),
                  textInputAction: TextInputAction.done,
                  onChanged: (value) => _description = value,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                        180), // Max lenght 180 symbols
                  ],
                  // Done on keyboard
                  onEditingComplete: () {
                    _submit(image: imageFile);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

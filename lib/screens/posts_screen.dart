import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_for_my_training/bloc/auth_cubit.dart';
import 'package:flutter_app_for_my_training/models/post_model.dart';
import 'package:flutter_app_for_my_training/screens/chat_screen.dart';
import 'package:flutter_app_for_my_training/screens/create_post_screen.dart';
import 'package:flutter_app_for_my_training/screens/sign_in_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class PostsScreen extends StatefulWidget {
  static const String id = 'posts_screen';
  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () {
              final picker = ImagePicker();
              picker
                  .pickImage(source: ImageSource.gallery, imageQuality: 40)
                  .then((xFile) {
                if (xFile != null) {
                  final file = File(xFile.path);
                  Navigator.of(context).pushNamed(CreatePostScreen.id,
                      arguments: {'imageFile': file});
                }
              });
            },
            icon: const Icon(Icons.add)),
        IconButton(
            onPressed: () {
              context.read<AuthCubit>().signOut().then((value) =>
                  Navigator.of(context).pushReplacementNamed(SignInScreen.id));
            },
            icon: const Icon(Icons.logout))
      ]),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                duration: Duration(seconds: 10),
                content: Text('Something went wrong')));
            return Container();
          }
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return const CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) {
              final QueryDocumentSnapshot doc = snapshot.data!.docs[index];
              print('doc id :${doc['postID']}');
              final PostModel postModel = PostModel(
                  id: doc['postID'],
                  userName: doc['userName'],
                  userId: doc['userID'],
                  imageUrl: doc['imageUrl'],
                  description: doc['description'],
                  timestamp: doc['timeStamp']);
              return GestureDetector(
                onTap: (() {
                  Navigator.of(context)
                      .pushNamed(ChatScreen.id, arguments: postModel);
                }),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(doc['imageUrl']),
                              fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        doc['userName'],
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        doc['description'],
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}

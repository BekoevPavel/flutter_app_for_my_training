import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_for_my_training/bloc/auth_cubit.dart';
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
      body: ListView.builder(
          itemCount: 0,
          itemBuilder: ((context, index) {
            return Container();
          })),
    );
  }
}

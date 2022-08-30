import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_for_my_training/bloc/auth_cubit.dart';
import 'package:flutter_app_for_my_training/screens/chat_screen.dart';

import 'package:flutter_app_for_my_training/screens/create_post_screen.dart';
import 'package:flutter_app_for_my_training/screens/posts_screen.dart';
import 'package:flutter_app_for_my_training/screens/sign_up_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/sign_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PaintingBinding.instance.imageCache.maximumSizeBytes = 1024 * 1024 * 300;
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        // ThemeData(
        //   primarySwatch: Colors.blue,
        // ),

        home: const SignUpScreen(),
        routes: {
          SignInScreen.id: ((context) => const SignInScreen()),
          SignUpScreen.id: ((context) => const SignUpScreen()),
          PostsScreen.id: ((context) => const PostsScreen()),
          CreatePostScreen.id: ((context) => const CreatePostScreen()),
          ChatScreen.id: (context) => const ChatScreen(),
        },
      ),
    );
  }
}

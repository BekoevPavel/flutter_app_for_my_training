import 'package:flutter/material.dart';
import 'package:flutter_app_for_my_training/screens/posts_screen.dart';
import 'package:flutter_app_for_my_training/screens/sign_in_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_cubit.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = 'sign_up_screen';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String userName = '';
  String password = '';

  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _userNameFocusNode = FocusNode();

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      //invalid
      return;
    }
    _formKey.currentState!.save();
    context
        .read<AuthCubit>()
        .signUp(email: email, username: userName, password: password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (prevState, currentState) {
          if (currentState is AuthSignUp) {
            Navigator.of(context).pushReplacementNamed(PostsScreen.id);
          }
          if (currentState is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 2),
                content: Text(currentState.message)));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SafeArea(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Text('Social Media App',
                            style: Theme.of(context).textTheme.headline3),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      //email
                      TextFormField(
                        onSaved: (value) {
                          email = value!.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter your email';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_userNameFocusNode);
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Enter your email',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      //username
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        focusNode: _userNameFocusNode,
                        onSaved: (value) {
                          userName = value!.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter your username';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Enter your username',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      //password
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        focusNode: _passwordFocusNode,
                        onSaved: (value) {
                          password = value!.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter your password';
                          }
                          if (value.length < 5) {
                            return 'Please Enter longer password';
                          }
                          return null;
                        },
                        obscureText: true, // only for password
                        onFieldSubmitted: (_) {
                          _submit(context);
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Enter your password',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _submit(context);
                        },
                        child: const Text('Sign Up'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(SignInScreen.id);
                        },
                        child: const Text('Sign In instead'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

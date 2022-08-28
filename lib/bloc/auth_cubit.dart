import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial()); // First State

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print('saccess');

      emit(AuthSignIn());
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(message: 'An Error has occurred'));
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        emit(AuthFailure(message: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(AuthFailure(message: 'Wrong password provided for that user.'));

        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signUp(
      {required String email,
      required String username,
      required String password}) async {
    emit(AuthLoading());
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'userID': credential.user!.uid,
        'email': credential.user!.email,
        'username': username,
      });
      credential.user!.updateDisplayName(username);
      emit(AuthSignUp());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(AuthFailure(message: 'The password provided is too weak.'));
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        emit(
            AuthFailure(message: 'The account already exists for that email.'));
        print('The account already exists for that email.');
      }
    } catch (e) {
      print('reeriir $e');
    }
  }
}

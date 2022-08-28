part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthLoading extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthSignUp extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthSignIn extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

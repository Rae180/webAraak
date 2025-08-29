part of 'auth_bloc.dart';

class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class LoginSucess extends AuthState {}

final class LogoutSuccess extends AuthState {}

final class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}

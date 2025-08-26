part of 'users_bloc.dart';

class UsersState {}

final class UsersInitial extends UsersState {}

final class UsersLoading extends UsersState {}

final class GetAllUsersSuccess extends UsersState {
  final UserModel user;

  GetAllUsersSuccess({required this.user});
}

final class GetOrdersUsersSuccess extends UsersState {
  final UserOrders orders;

  GetOrdersUsersSuccess({required this.orders});
}

final class UsersError extends UsersState {
  final String message;

  UsersError({required this.message});
}

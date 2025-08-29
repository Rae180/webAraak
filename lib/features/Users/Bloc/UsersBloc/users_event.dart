part of 'users_bloc.dart';

class UsersEvent {}

final class GetAllUsersEvent extends UsersEvent {}

final class GetOrdersUsersEvent extends UsersEvent {
  final int id;

  GetOrdersUsersEvent({required this.id});
}

final class AddAmountEvent extends UsersEvent {
  final int id;
  final String amount;

  AddAmountEvent({required this.id, required this.amount});
}

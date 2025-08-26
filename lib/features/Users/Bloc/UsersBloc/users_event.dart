part of 'users_bloc.dart';

class UsersEvent {}

final class GetAllUsersEvent extends UsersEvent {}

final class GetOrdersUsersEvent extends UsersEvent {
  final int id;

  GetOrdersUsersEvent({required this.id});
}

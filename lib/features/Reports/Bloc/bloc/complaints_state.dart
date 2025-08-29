part of 'complaints_bloc.dart';

class ComplaintsState {}

final class ComplaintsInitial extends ComplaintsState {}

final class ComplaintsLoading extends ComplaintsState {}

final class ComplaaintsSuccess extends ComplaintsState {
  final ComplaintsModel complaints;

  ComplaaintsSuccess({required this.complaints});
}

final class ComplaintsError extends ComplaintsState {
  final String message;

  ComplaintsError({required this.message});
}

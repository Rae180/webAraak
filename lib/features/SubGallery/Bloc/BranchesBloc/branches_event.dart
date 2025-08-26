part of 'branches_bloc.dart';

class BranchesEvent {}

final class GetAllBranchesEvent extends BranchesEvent {}

final class GetBranchDetailesEvent extends BranchesEvent {
  final int? id;

  GetBranchDetailesEvent({required this.id});
}

final class GetSubManagersEvent extends BranchesEvent {}

final class GetSubManagerDetailesEvent extends BranchesEvent {
  final int? id;

  GetSubManagerDetailesEvent({required this.id});
}

final class AddNewBranchEvent extends BranchesEvent {
  final num latitude;
  final num longitude;
  final String adress;
  final int subId;

  AddNewBranchEvent(
      {required this.latitude,
      required this.longitude,
      required this.adress,
      required this.subId});
}

final class DeleteBranchEvent extends BranchesEvent {
  final int branchId;

  DeleteBranchEvent({required this.branchId});
}

final class AddNewSubManagerEvent extends BranchesEvent {
  final String name;
  final String email;
  final String password;
  final String? phone;
  final Uint8List? imageBytes;

  AddNewSubManagerEvent(
      {required this.name,
      required this.phone,
      required this.email,
      required this.password,
      required this.imageBytes});
}

final class DeleteSubManagerEvent extends BranchesEvent {
  final int subid;

  DeleteSubManagerEvent({required this.subid});
}

final class EditSubManagerEvent extends BranchesEvent {
  final int id;
  final String name;
  final String email;
  final String phone;

  EditSubManagerEvent(
      {required this.name,
      required this.email,
      required this.phone,
      required this.id});
}

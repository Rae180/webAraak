part of 'branches_bloc.dart';

class BranchesState {}

final class BranchesInitial extends BranchesState {}

final class BranchesLoading extends BranchesState {}

final class GetBranchesSucess extends BranchesState {
  final BranchesModel branches;

  GetBranchesSucess({required this.branches});
}

final class BranchDetailesSuccess extends BranchesState {
  final BrancheDetiles detailes;

  BranchDetailesSuccess({required this.detailes});
}

final class GetSubManagersSuccess extends BranchesState {
  final SubManagersModel managers;

  GetSubManagersSuccess({required this.managers});
}

final class GetSubManagerDetailesSuccess extends BranchesState {
  final SubManagerDetailes detailes;

  GetSubManagerDetailesSuccess({required this.detailes});
}

final class AddNewBranchSuccess extends BranchesState {}

final class DeleteBranchSuccess extends BranchesState {}

final class AddNewSubManagerSuccess extends BranchesState {}

final class DeleteSubManagerSuccess extends BranchesState {}

final class EditSubManagerSuccess extends BranchesState {}

final class BranchesError extends BranchesState {
  final String message;

  BranchesError({required this.message});
}

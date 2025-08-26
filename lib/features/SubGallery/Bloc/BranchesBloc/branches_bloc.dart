import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:start/core/api_service/base_Api_service.dart';
import 'package:start/core/api_service/base_repo.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/errors/failures.dart';
import 'package:start/features/SubGallery/Models/BranchDetailes.dart';
import 'package:start/features/SubGallery/Models/Branches.dart';
import 'package:start/features/SubGallery/Models/SubManaagerDetailes.dart';
import 'package:start/features/SubGallery/Models/SubManagersModel.dart';

part 'branches_event.dart';
part 'branches_state.dart';

class BranchesBloc extends Bloc<BranchesEvent, BranchesState> {
  final BaseApiService client;

  BranchesBloc({required this.client}) : super(BranchesInitial()) {
    on<EditSubManagerEvent>(((event, emit) async {
      emit(BranchesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.postRequestAuth(
            url: ApiConstants.editsub + event.id.toString(),
            jsonBody: {
              "name": event.name,
              "email": event.email,
              "phone": event.phone
            });
        return jsonDecode(response.body);
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(EditSubManagerSuccess());
      });
    }));
    on<DeleteSubManagerEvent>(((event, emit) async {
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.delete(
            url: ApiConstants.deletesub + event.subid.toString());
        return jsonDecode(response.body);
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(DeleteSubManagerSuccess());
        add(GetSubManagersEvent());
      });
    }));
    on<AddNewSubManagerEvent>(((event, emit) async {
      emit(BranchesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        // Create a multipart request with bytes instead of File
        final response = await client.multipartWithBytes(
          url: ApiConstants.addsubmanager,
          jsonBody: {
            "name": event.name,
            "email": event.email,
            "phone": event.phone,
            "password": event.password,
          },
          fileBytes: event.imageBytes, // Pass bytes instead of File
          filename: 'profile.jpg', // Provide a filename for the web
        );
        return jsonDecode(response.body);
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(AddNewSubManagerSuccess());
      });
    }));
    on<DeleteBranchEvent>(((event, emit) async {
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.delete(
            url: ApiConstants.deletebranch + event.branchId.toString());
        return jsonDecode(response.body);
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(DeleteBranchSuccess());
        add(GetAllBranchesEvent());
      });
    }));
    on<AddNewBranchEvent>(((event, emit) async {
      emit(BranchesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client
            .postRequestAuth(url: ApiConstants.addnewbranch, jsonBody: {
          "latitude": event.latitude,
          "longitude": event.longitude,
          "address": event.adress,
          "sub_manager_id": event.subId
        });
        return jsonDecode(response.body);
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(AddNewBranchSuccess());
      });
    }));
    on<GetSubManagerDetailesEvent>(((event, emit) async {
      emit(BranchesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.getRequestAuth(
            url: ApiConstants.submangerDet + event.id.toString());
        final data = jsonDecode(response.body);
        final detailes = SubManagerDetailes.fromJson(data);
        return detailes;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(GetSubManagerDetailesSuccess(detailes: responseData));
      });
    }));
    on<GetSubManagersEvent>((event, emit) async {
      emit(BranchesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response =
            await client.getRequestAuth(url: ApiConstants.submangers);
        final data = jsonDecode(response.body);
        final managers = SubManagersModel.fromJson(data);
        return managers;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(GetSubManagersSuccess(managers: responseData));
      });
    });
    on<GetAllBranchesEvent>((event, emit) async {
      emit(BranchesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response =
            await client.getRequestAuth(url: ApiConstants.branches);
        final data = jsonDecode(response.body);
        final branches = BranchesModel.fromJson(data);
        return branches;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(GetBranchesSucess(branches: responseData));
      });
    });
    on<GetBranchDetailesEvent>(((event, emit) async {
      emit(BranchesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.getRequestAuth(
            url: ApiConstants.branchDet + event.id.toString());
        final data = jsonDecode(response.body);
        final detailes = BrancheDetiles.fromJson(data);
        return detailes;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(BranchDetailesSuccess(detailes: responseData));
      });
    }));
  }
  _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return BranchesError(message: 'No internet');

      case NetworkErrorFailure:
        return BranchesError(
          message: (f as NetworkErrorFailure).message,
        );

      default:
        return BranchesError(
          message: 'Error',
        );
    }
  }
}

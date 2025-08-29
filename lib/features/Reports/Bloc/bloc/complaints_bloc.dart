import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:start/core/api_service/base_Api_service.dart';
import 'package:start/core/api_service/base_repo.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/errors/failures.dart';
import 'package:start/features/Reports/Models/ComplaintsModel.dart';

part 'complaints_event.dart';
part 'complaints_state.dart';

class ComplaintsBloc extends Bloc<ComplaintsEvent, ComplaintsState> {
  final BaseApiService client;
  ComplaintsBloc({required this.client}) : super(ComplaintsInitial()) {
    on<GetComplaintsEvent>((event, emit) async {
      emit(ComplaintsLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response =
            await client.getRequestAuth(url: ApiConstants.getComplaints);
        final data = jsonDecode(response.body);
        final coms = ComplaintsModel.fromJson(data);
        return coms;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(ComplaaintsSuccess(complaints: responseData));
      });
    });
  }
  _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return ComplaintsError(message: 'No internet');

      case NetworkErrorFailure:
        return ComplaintsError(
          message: (f as NetworkErrorFailure).message,
        );

      default:
        return ComplaintsError(
          message: 'Error',
        );
    }
  }
}

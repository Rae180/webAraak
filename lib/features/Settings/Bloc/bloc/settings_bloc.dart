import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:start/core/api_service/base_Api_service.dart';
import 'package:start/core/api_service/base_repo.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/errors/failures.dart';
import 'package:start/features/Settings/Models/AllOrdersModel.dart';
import 'package:start/features/Settings/Models/ManagerInfo.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final BaseApiService client;
  SettingsBloc({required this.client}) : super(SettingsInitial()) {
    on<GetManagerInfoEvent>(((event, emit) async {
      emit(SettingsLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.getRequestAuth(url: ApiConstants.getInfo);
        final data = jsonDecode(response.body);
        final info = ManagerInfo.fromJson(data);
        return info;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(GetManagerInfoSuccess(info: responseData));
      });
    }));
    on<GetAllOrdersEvent>((event, emit) async {
      final result = await BaseRepo.repoRequest(request: () async {
        final response =
            await client.getRequestAuth(url: ApiConstants.getOrders);
        final data = jsonDecode(response.body);
        final orders = AllOrdersModel.fromJson(data);
        return orders;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(GetAllOrdersSuccess(orders: responseData));
      });
    });
  }
  _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return SettingsError(message: 'No internet');

      case NetworkErrorFailure:
        return SettingsError(
          message: (f as NetworkErrorFailure).message,
        );

      default:
        return SettingsError(
          message: 'Error',
        );
    }
  }
}

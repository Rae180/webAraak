import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:start/core/api_service/base_Api_service.dart';
import 'package:start/core/api_service/base_repo.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/errors/failures.dart';
import 'package:start/features/Users/Models/UserModel.dart';
import 'package:start/features/Users/Models/UsersOrdersModel.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final BaseApiService client;
  UsersBloc({required this.client}) : super(UsersInitial()) {
    on<GetAllUsersEvent>((event, emit) async {
      emit(UsersLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response =
            await client.getRequestAuth(url: ApiConstants.getusers);
        final data = jsonDecode(response.body);
        final users = UserModel.fromJson(data);
        return users;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(GetAllUsersSuccess(user: responseData));
      });
    });
    on<GetOrdersUsersEvent>(((event, emit) async {
      emit(UsersLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.getRequestAuth(
            url: ApiConstants.ordersuser + event.id.toString());
        final data = jsonDecode(response.body);
        final orders = UserOrders.fromJson(data);
        return orders;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(GetOrdersUsersSuccess(orders: responseData));
      });
    }));
  }
  _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return UsersError(message: 'No internet');

      case NetworkErrorFailure:
        return UsersError(
          message: (f as NetworkErrorFailure).message,
        );

      default:
        return UsersError(
          message: 'Error',
        );
    }
  }
}

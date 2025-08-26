import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:start/core/api_service/base_Api_service.dart';
import 'package:start/core/api_service/base_repo.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/errors/failures.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final NetworkApiServiceHttp client;
  AuthBloc({required this.client}) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading()); // Add a loading state

      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.postRequest(
            url: ApiConstants.login,
            jsonBody: {'email': event.email, 'password': event.password});

        return response;
      });

      await result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) async {
        // Extract token from response and save it
        final token = responseData['token'] as String;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        print("Login token saved: $token");
        emit(LoginSucess());
      });
    });
  }

  _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return AuthError(message: 'No internet');

      case NetworkErrorFailure:
        return AuthError(
          message: (f as NetworkErrorFailure).message,
        );

      default:
        return AuthError(
          message: 'Error',
        );
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:start/core/errors/exceptions.dart';
import 'package:start/core/locator/service_locator.dart';
import 'package:start/core/network/check_internet.dart';

import '../errors/failures.dart';

class BaseRepo {
  static Future<Either<Failure, dynamic>> repoRequest({required Function request}) async {
    if (kIsWeb) {
      // Skip network check for web
      try {
        final info = await request();
        return Right(info);
      } catch (e) {
        return Left(NetworkErrorFailure(message: e.toString()));
      }
    }
    
    NetworkInfo networkInfo = sl.get<NetworkInfo>();
    if (await networkInfo.isConnected) {
      try {
        final info = await request();
        return Right(info);
      } on ExceptionTimeout {
        return Left(NetworkErrorFailure(message: 'Time out'));
      } on ExceptionSocket {
        return Left(NetworkErrorFailure(message: 'Socket Error'));
      } on ExceptionFormat {
        return Left(NetworkErrorFailure(message: 'Bad Response Format'));
      } on ExceptionHandshake {
        return Left(NetworkErrorFailure(message: 'Handshake Error'));
      } on ExceptionOther {
        return Left(NetworkErrorFailure(message: 'Error'));
      } on CustomException catch (e) {
        return Left(NetworkErrorFailure(message: e.message));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
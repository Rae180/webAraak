import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:start/core/api_service/base_Api_service.dart';
import 'package:start/core/api_service/base_repo.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/errors/failures.dart';

part 'resources_event.dart';
part 'resources_state.dart';

class ResourcesBloc extends Bloc<ResourcesEvent, ResourcesState> {
  final BaseApiService client;
  ResourcesBloc({required this.client}) : super(ResourcesInitial()) {
    on<UploadGLBEvent>((event, emit) async {
      emit(ResourcesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final fileMap = <String, dynamic>{};

        // Always handle model file using bytes
        fileMap['glb_file'] = {
          'bytes': event.modelBytes,
          'filename': event.modelName,
        };

        // Handle thumbnail file if available
        if (event.thumbnailBytes != null) {
          fileMap['thumbnail'] = {
            'bytes': event.thumbnailBytes!,
            'filename': event.thumbnailName ?? 'thumbnail.jpg',
          };
        }

        final response = await client.multipart2(
          url: '${ApiConstants.uploadGlb}${event.itemId}',
          jsonBody: {},
          files: fileMap,
        );

        return response;
      });

      result.fold(
        (f) => emit(_mapFailureToState(f)),
        (responseData) => emit(UploadedGLBSuccess(
          glbUrl: responseData['glb_url'],
          thumbnailUrl: responseData['thumbnail_url'],
        )),
      );
    });
  }
}

_mapFailureToState(Failure f) {
  switch (f.runtimeType) {
    case OfflineFailure:
      return ResourcesError(message: 'No internet');

    case NetworkErrorFailure:
      return ResourcesError(
        message: (f as NetworkErrorFailure).message,
      );

    default:
      return ResourcesError(
        message: 'Error',
      );
  }
}

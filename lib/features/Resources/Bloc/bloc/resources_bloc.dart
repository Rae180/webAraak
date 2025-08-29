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
import 'package:start/features/Resources/Models/AllFabricModel.dart';
import 'package:start/features/Resources/Models/AllItemsModel.dart';
import 'package:start/features/Resources/Models/AllRoomsModel.dart';
import 'package:start/features/Resources/Models/AllWoodModel.dart';
import 'package:start/features/Resources/Models/CategoryModel.dart';
import 'package:start/features/Resources/Models/ItemTypesModel.dart';
import 'package:start/features/Resources/Models/OptionsModel.dart';

part 'resources_event.dart';
part 'resources_state.dart';

class ResourcesBloc extends Bloc<ResourcesEvent, ResourcesState> {
  final BaseApiService client;
  ResourcesBloc({required this.client}) : super(ResourcesInitial()) {
    on<DeleteFabricEvent>(((event, emit) async {
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.delete(
            url: ApiConstants.deletefabric + event.id.toString());
        return response;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(DeleteFabricSuccess());
      });
    }));
    on<DeleteWoodEvent>(((event, emit) async {
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.delete(
            url: ApiConstants.deletewood + event.id.toString());
        return response;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(DeleteWoodSuccess());
      });
    }));
    on<GetAllFabricEvent>(((event, emit) async {
      emit(ResourcesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response =
            await client.getRequestAuth(url: ApiConstants.getfabric);
        final data = jsonDecode(response.body);
        final fabrics = AllFabricModel.fromJson(data);
        return fabrics;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(GetAllFabricSuccess(fabric: responseData));
      });
    }));
    on<GetAllWoodEvent>(((event, emit) async {
      emit(ResourcesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.getRequestAuth(url: ApiConstants.getwood);
        final data = jsonDecode(response.body);
        final woods = AllWoodModel.fromJson(data);
        return woods;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(GetAllWoodSuccess(woods: responseData));
      });
    }));
    on<AddNewOtionsEvent>(((event, emit) async {
      emit(ResourcesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.postRequestAuth(
            url: ApiConstants.addoptions + event.roomId.toString(),
            jsonBody: event.options.toJson());
        return response;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(AddNewOptionsSuccess());
      });
    }));
    on<EditFabricEvent>(((event, emit) async {
      emit(ResourcesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.postRequestAuth(
            url: ApiConstants.editfabric + event.id.toString(),
            jsonBody: {"price_per_meter": event.price});
        return response;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(EditFabricSuccess());
      });
    }));
    on<EditWoodEvent>(((event, emit) async {
      emit(ResourcesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.postRequestAuth(
            url: ApiConstants.editwood + event.id.toString(),
            jsonBody: {"price_per_meter": event.price});
        return response;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(EditWoodSuccess());
      });
    }));
    on<AddNewFabricEvent>(((event, emit) async {
      emit(ResourcesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client
            .postRequestAuth(url: ApiConstants.addfabric, jsonBody: {
          "fabric_type_name": event.fabricName,
          "price_per_meter": event.price,
          "fabric_color_name": event.fabricColor
        });
        return response;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(AddNewFabricSuccess());
      });
    }));
    on<AddNewWoodEvent>(((event, emit) async {
      emit(ResourcesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response =
            await client.postRequestAuth(url: ApiConstants.addwood, jsonBody: {
          "wood_type_name": event.woodName,
          "price_per_meter": event.price,
          "wood_color_name": event.woodColor
        });
        return response;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(AddNewWoodSuccess());
      });
    }));
    on<AddNewRoomEvent>(((event, emit) async {
      emit(ResourcesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.multipartWithBytes(
          url: ApiConstants.addRoom,
          jsonBody: {
            "name": event.name,
            "description": event.description,
            "category_id": event.Catid,
            "wood_type_id": event.woodId,
            "wood_color_id": event.woodColorId,
            "fabric_type_id": event.fabricId,
            "fabric_color_id": event.faabricColorId
          },
          fileBytes: event.imageUrl,
          filename: "image_url",
        );
        return response;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(AddNewRoomSuccess());
      });
    }));
    on<DeleteCategoryEvent>(((event, emit) async {
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.delete(
            url: ApiConstants.deletecat + event.id.toString());
        return response;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(DeleteCategorySucess());
      });
    }));
    on<DeleteItemTypeEvent>(((event, emit) async {
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.delete(
            url: ApiConstants.deleteitemtype + event.id.toString());
        return response;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(DeleteItemTypeSuccess());
      });
    }));
    on<GetCaategoriesEvent>(((event, emit) async {
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.getRequestAuth(url: ApiConstants.getcaat);
        final data = jsonDecode(response.body);
        final cats = CategoryModel.fromJson(data);
        return cats;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(GetCategoriesSuccess(model: responseData));
      });
    }));
    on<GetItemTypesEvent>(((event, emit) async {
      emit(ResourcesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response =
            await client.getRequestAuth(url: ApiConstants.gettypes);
        final data = jsonDecode(response.body);
        final types = ItemTypesModel.fromJson(data);
        return types;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(GetItemTypesSuccess(items: responseData));
      });
    }));
    on<AddNewItemEvent>(((event, emit) async {
      emit(ResourcesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response =
            await client.postRequestAuth(url: ApiConstants.newItem, jsonBody: {
          "name": event.name,
          "description": event.description,
          "room_id": event.roomId,
          "item_type_id": event.itemTypeId,
          "wood_length": event.woodLength,
          "wood_width": event.woodWidth,
          "wood_height": event.woodHeight,
          "fabric_length": event.fabricLength,
          "fabric_width": event.fabricWidth
        });
        return response;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(AddNewItemSuccess());
      });
    }));
    on<AddNewCategoryEvent>(((event, emit) async {
      emit(ResourcesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.postRequestAuth(
            url: ApiConstants.newctegory, jsonBody: {"name": event.name});
        return response;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(AddNewCategorySuccess());
      });
    }));
    on<AddItemTypeEvent>(((event, emit) async {
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.postRequestAuth(
            url: ApiConstants.newItemtpe,
            jsonBody: {"name": event.name, "description": event.description});
        return response;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(AddItemTypeSuccess());
      });
    }));
    on<DeleteRoomEvent>(((event, emit) async {
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.delete(
            url: ApiConstants.deleteRoom + event.id.toString());
        return response;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(DeleteItemSuccess());
      });
    }));
    on<UpdateRoomEvent>(((event, emit) async {
      emit(ResourcesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.multipartWithBytes(
            url: ApiConstants.updateRoom + event.id.toString(),
            jsonBody: {
              "name": event.name,
              "description": event.descreption,
              "price": event.price,
            },
            fileBytes: event.imageUrl,
            filename: 'image_url');
        return response;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(UpdateRoomSuccess());
      });
    }));
    on<DeleteItemEvent>(((event, emit) async {
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.delete(
            url: ApiConstants.deleteitem + event.id.toString());
        return response;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(DeleteItemSuccess());
      });
    }));
    on<EditItemEvent>(((event, emit) async {
      emit(ResourcesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.multipartWithBytes(
            fileBytes: event.image,
            filename: 'image',
            url: ApiConstants.edititem + event.id.toString(),
            jsonBody: {
              "name": event.name,
              "description": event.description,
              "price": event.price,
            });
        return jsonDecode(response.body);
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(EditItemSuccess());
      });
    }));
    on<GetAllItemsEvent>(((event, emit) async {
      emit(ResourcesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response =
            await client.getRequestAuth(url: ApiConstants.allitems);
        final data = jsonDecode(response.body);
        final items = AllItemsModel.fromJson(data);
        return items;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(GetAllItemsSuccess(allItemsModel: responseData));
      });
    }));
    on<GetAllRoomsEvent>(((event, emit) async {
      emit(ResourcesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response =
            await client.getRequestAuth(url: ApiConstants.allrooms);
        final data = jsonDecode(response.body);
        final rooms = AllRoomsModel.fromJson(data);
        return rooms;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(GetAllRoomsSuccess(allRoomsModel: responseData));
      });
    }));
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

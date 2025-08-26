part of 'resources_bloc.dart';

class ResourcesState {}

final class ResourcesInitial extends ResourcesState {}

final class ResourcesLoading extends ResourcesState {}

final class GetAllRoomsSuccess extends ResourcesState {
  final AllRoomsModel allRoomsModel;

  GetAllRoomsSuccess({required this.allRoomsModel});
}

final class GetAllItemsSuccess extends ResourcesState {
  final AllItemsModel allItemsModel;

  GetAllItemsSuccess({required this.allItemsModel});
}

final class EditItemSuccess extends ResourcesState {}

final class UploadedGLBSuccess extends ResourcesState {
  final String glbUrl;
  final String? thumbnailUrl;

  UploadedGLBSuccess({required this.glbUrl, required this.thumbnailUrl});
}

final class ResourcesError extends ResourcesState {
  final String message;

  ResourcesError({required this.message});
}

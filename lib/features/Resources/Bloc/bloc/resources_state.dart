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

final class DeleteItemSuccess extends ResourcesState {}

final class UpdateRoomSuccess extends ResourcesState {}

final class DeleteRoomSuccess extends ResourcesState {}

final class AddItemTypeSuccess extends ResourcesState {}

final class AddNewCategorySuccess extends ResourcesState {}

final class AddNewItemSuccess extends ResourcesState {}

final class GetItemTypesSuccess extends ResourcesState {
  final ItemTypesModel items;

  GetItemTypesSuccess({required this.items});
}

final class UploadedGLBSuccess extends ResourcesState {
  final String glbUrl;
  final String? thumbnailUrl;

  UploadedGLBSuccess({required this.glbUrl, required this.thumbnailUrl});
}

final class GetCategoriesSuccess extends ResourcesState {
  final CategoryModel model;

  GetCategoriesSuccess({required this.model});
}

final class DeleteItemTypeSuccess extends ResourcesState {}

final class DeleteCategorySucess extends ResourcesState {}

final class AddNewRoomSuccess extends ResourcesState {}

final class AddNewWoodSuccess extends ResourcesState {}

final class AddNewFabricSuccess extends ResourcesState {}

final class EditWoodSuccess extends ResourcesState {}

final class EditFabricSuccess extends ResourcesState {}

final class AddNewOptionsSuccess extends ResourcesState {}

final class GetAllWoodSuccess extends ResourcesState {
  final AllWoodModel woods;

  GetAllWoodSuccess({required this.woods});
}

final class GetAllFabricSuccess extends ResourcesState {
  final AllFabricModel fabric;

  GetAllFabricSuccess({required this.fabric});
}

final class DeleteWoodSuccess extends ResourcesState {}

final class DeleteFabricSuccess extends ResourcesState {}

final class ResourcesError extends ResourcesState {
  final String message;

  ResourcesError({required this.message});
}

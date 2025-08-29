part of 'resources_bloc.dart';

class ResourcesEvent {}

final class UploadGLBEvent extends ResourcesEvent {
  final String itemId;

  final Uint8List modelBytes;
  final String modelName;
  final Uint8List? thumbnailBytes;
  final String? thumbnailName;

  UploadGLBEvent(
      {required this.itemId,
      required this.modelBytes,
      required this.modelName,
      this.thumbnailBytes,
      this.thumbnailName});
}

final class GetAllRoomsEvent extends ResourcesEvent {}

final class GetAllItemsEvent extends ResourcesEvent {}

final class EditItemEvent extends ResourcesEvent {
  final int id;
  final String name;
  final String description;
  final String price;
  final Uint8List image;

  EditItemEvent(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.image});
}

final class DeleteItemEvent extends ResourcesEvent {
  final int id;

  DeleteItemEvent({required this.id});
}

final class UpdateRoomEvent extends ResourcesEvent {
  final int id;
  final String name;
  final String descreption;
  final String price;
  final Uint8List? imageUrl;

  UpdateRoomEvent(
      {required this.name,
      required this.id,
      required this.descreption,
      required this.price,
      required this.imageUrl});
}

final class DeleteRoomEvent extends ResourcesEvent {
  final int id;

  DeleteRoomEvent({required this.id});
}

final class AddItemTypeEvent extends ResourcesEvent {
  final String name;
  final String description;

  AddItemTypeEvent({required this.name, required this.description});
}

final class AddNewCategoryEvent extends ResourcesEvent {
  final String name;

  AddNewCategoryEvent({required this.name});
}

final class AddNewItemEvent extends ResourcesEvent {
  final String name;
  final String description;
  final String roomId;
  final String itemTypeId;
  final String woodLength;
  final String woodWidth;
  final String woodHeight;
  final String fabricLength;
  final String fabricWidth;

  AddNewItemEvent(
      {required this.name,
      required this.description,
      required this.roomId,
      required this.itemTypeId,
      required this.woodLength,
      required this.woodWidth,
      required this.woodHeight,
      required this.fabricLength,
      required this.fabricWidth});
}

final class GetItemTypesEvent extends ResourcesEvent {}

final class GetCaategoriesEvent extends ResourcesEvent {}

final class DeleteItemTypeEvent extends ResourcesEvent {
  final int id;

  DeleteItemTypeEvent({required this.id});
}

final class DeleteCategoryEvent extends ResourcesEvent {
  final int id;

  DeleteCategoryEvent({required this.id});
}

final class AddNewRoomEvent extends ResourcesEvent {
  final String name;
  final String description;
  final int? Catid;
  final Uint8List imageUrl;
  final int? woodId;
  final int? woodColorId;
  final int? fabricId;
  final int? faabricColorId;

  AddNewRoomEvent(
      {required this.name,
      required this.description,
      required this.Catid,
      required this.imageUrl,
      required this.woodId,
      required this.woodColorId,
      required this.fabricId,
      required this.faabricColorId});
}

final class AddNewWoodEvent extends ResourcesEvent {
  final String woodName;
  final String price;
  final String woodColor;

  AddNewWoodEvent(
      {required this.woodName, required this.price, required this.woodColor});
}

final class AddNewFabricEvent extends ResourcesEvent {
  final String fabricName;
  final String price;
  final String fabricColor;

  AddNewFabricEvent(
      {required this.fabricName,
      required this.price,
      required this.fabricColor});
}

final class EditWoodEvent extends ResourcesEvent {
  final int id;
  final String price;

  EditWoodEvent({required this.price, required this.id});
}

final class EditFabricEvent extends ResourcesEvent {
  final int id;
  final String price;

  EditFabricEvent({required this.id, required this.price});
}

final class AddNewOtionsEvent extends ResourcesEvent {
  final int roomId;
  final OptionsModel options;

  AddNewOtionsEvent({required this.options, required this.roomId});
}

final class GetAllWoodEvent extends ResourcesEvent {}

final class GetAllFabricEvent extends ResourcesEvent {}

final class DeleteWoodEvent extends ResourcesEvent {
  final int id;

  DeleteWoodEvent({required this.id});
}

final class DeleteFabricEvent extends ResourcesEvent {
  final int id;

  DeleteFabricEvent({required this.id});
}

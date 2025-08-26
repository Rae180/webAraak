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

  EditItemEvent({required this.id,required this.name, required this.description, required this.price, required this.image});
}

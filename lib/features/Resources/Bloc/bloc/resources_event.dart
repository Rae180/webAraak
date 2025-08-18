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

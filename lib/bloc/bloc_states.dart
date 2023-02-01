import 'package:wallpaper_app/models/photo_list_response.dart';

abstract class PhotosState {}

class InitialPhotoState extends PhotosState {}

class LoadingMorePhotosState extends PhotosState {
  final List<PhotoListItem> oldPhotos;

  LoadingMorePhotosState({required this.oldPhotos});
}

class LoadedPhotosState extends PhotosState {
  List<PhotoListItem> list;

  LoadedPhotosState({required this.list});
}

class FailedToLoadPhotosState extends PhotosState {
  Error error;

  FailedToLoadPhotosState({required this.error});
}
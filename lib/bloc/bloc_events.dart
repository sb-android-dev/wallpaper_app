import '../models/photo_type.dart';

abstract class PhotosEvent {}

class LoadPhotosEvent extends PhotosEvent {
  PhotoSort sortType;

  LoadPhotosEvent({this.sortType = PhotoSort.POPULAR});
}

class RefreshListEvent extends PhotosEvent {
  PhotoSort sortType;

  RefreshListEvent({this.sortType = PhotoSort.POPULAR});
}
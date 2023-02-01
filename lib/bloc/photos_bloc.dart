import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/bloc/bloc_events.dart';
import 'package:wallpaper_app/bloc/bloc_states.dart';
import 'package:wallpaper_app/models/photo_list_response.dart';
import 'package:wallpaper_app/service/data_service.dart';

class WallpaperBloc extends Bloc<PhotosEvent, PhotosState> {
  final _dataService = DataService();

  int page = 1;
  List<PhotoListItem> list = [];
  bool isLoading = false;

  WallpaperBloc() : super(InitialPhotoState()) {
    on<LoadPhotosEvent>((event, emit) async {
      if (isLoading) return;

      isLoading = true;
      if (list.isNotEmpty) {
        emit(LoadingMorePhotosState(oldPhotos: list));
      } else {
        emit(InitialPhotoState());
      }

      try {
        await _dataService
            .getTopicWisePhotos(page, 'wallpapers', event.sortType)
            .then((newList) {
          page++;
          list.addAll(newList);
          isLoading = false;
        });
        emit(LoadedPhotosState(list: list));
      } catch (e) {
        emit(FailedToLoadPhotosState(error: e as Error));
        isLoading = false;
      }
    });
    on<RefreshListEvent>((event, emit) async {
      isLoading = false;
      page = 1;
      list.clear();
      add(LoadPhotosEvent(sortType: event.sortType));
    });
  }
}

class TravelBloc extends Bloc<PhotosEvent, PhotosState> {
  final _dataService = DataService();

  int page = 1;
  List<PhotoListItem> list = [];
  bool isLoading = false;

  TravelBloc() : super(InitialPhotoState()) {
    on<LoadPhotosEvent>((event, emit) async {
      if (isLoading) return;

      isLoading = true;
      if (list.isNotEmpty) {
        emit(LoadingMorePhotosState(oldPhotos: list));
      } else {
        emit(InitialPhotoState());
      }

      try {
        await _dataService
            .getTopicWisePhotos(page, 'travel', event.sortType)
            .then((newList) {
          page++;
          list.addAll(newList);
          isLoading = false;
        });
        emit(LoadedPhotosState(list: list));
      } catch (e) {
        emit(FailedToLoadPhotosState(error: e as Error));
        isLoading = false;
      }
    });
    on<RefreshListEvent>((event, emit) async {
      isLoading = false;
      page = 1;
      list.clear();
      add(LoadPhotosEvent(sortType: event.sortType));
    });
  }
}

class NatureBloc extends Bloc<PhotosEvent, PhotosState> {
  final _dataService = DataService();

  int page = 1;
  List<PhotoListItem> list = [];
  bool isLoading = false;

  NatureBloc() : super(InitialPhotoState()) {
    on<LoadPhotosEvent>((event, emit) async {
      if (isLoading) return;

      isLoading = true;
      if (list.isNotEmpty) {
        emit(LoadingMorePhotosState(oldPhotos: list));
      } else {
        emit(InitialPhotoState());
      }

      try {
        await _dataService
            .getTopicWisePhotos(page, 'nature', event.sortType)
            .then((newList) {
          page++;
          list.addAll(newList);
          isLoading = false;
        });
        emit(LoadedPhotosState(list: list));
      } catch (e) {
        emit(FailedToLoadPhotosState(error: e as Error));
        isLoading = false;
      }
    });
    on<RefreshListEvent>((event, emit) async {
      isLoading = false;
      page = 1;
      list.clear();
      add(LoadPhotosEvent(sortType: event.sortType));
    });
  }
}

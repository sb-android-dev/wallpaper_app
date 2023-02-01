import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/models/photo_list_response.dart';
import 'package:wallpaper_app/models/photo_type.dart';
import 'package:wallpaper_app/service/data_service.dart';

class PhotosCubit extends Cubit<List<PhotoListItem>> {
  final _dataService = DataService();

  PhotosCubit(): super([]);

  int page = 1;
  List<PhotoListItem> list = [];
  bool isLoading = false;

  void getPhotosByTopic(String topicName) async {
    if(isLoading) return;

    isLoading = true;

    await _dataService.getTopicWisePhotos(page, topicName, PhotoSort.LATEST).then((newList) {
      page++;
      list.addAll(newList);
      isLoading = false;
    });
    return emit(list);
  }

  void refreshList(String topicName) {
    isLoading = false;
    page = 1;
    list.clear();
    return getPhotosByTopic(topicName);
  }
}
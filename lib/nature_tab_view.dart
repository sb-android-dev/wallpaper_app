import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/bloc/bloc_states.dart';
import 'package:wallpaper_app/bloc/photos_bloc.dart';
import 'package:wallpaper_app/models/photo_list_response.dart';
import 'package:wallpaper_app/wallpaper_view.dart';

class NatureTabView extends StatelessWidget {
  NatureTabView(
      {Key? key, required this.loadMoreCallback, required this.refreshCallback})
      : super(key: key);

  final scrollController = ScrollController();
  final VoidCallback loadMoreCallback;
  final VoidCallback refreshCallback;

  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          loadMoreCallback();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setupScrollController(context);
    return BlocBuilder<NatureBloc, PhotosState>(builder: (context, state) {
      if (state is InitialPhotoState) {
        return Center(
          child: _loadingIndicator(),
        );
      }

      List<PhotoListItem> list = [];
      bool isLoading = false;

      if (state is LoadingMorePhotosState) {
        list = state.oldPhotos;
        isLoading = true;
      } else if (state is LoadedPhotosState) {
        list = state.list;
      }

      return RefreshIndicator(
          child: GridView.builder(
            controller: scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemCount: list.length + (isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < list.length) {
                return _photo(context, list[index]);
              } else {
                return _loadingIndicator();
              }
            },
          ),
          onRefresh: () async {
            refreshCallback();
          });
    });
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _photo(BuildContext context, PhotoListItem photo) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WallpaperView(imageUrl: photo.photoItemUrls.full))),
      child: GridTile(
        child: SizedBox(
          height: 50,
          child: Image.network(
            photo.photoItemUrls.thumb,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return const FlutterLogo();
            },
          ),
        ),
      ),
    );
  }
}

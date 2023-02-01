import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/bloc/bloc_events.dart';
import 'package:wallpaper_app/bloc/photos_bloc.dart';
import 'package:wallpaper_app/bloc/photos_cubit.dart';
import 'package:wallpaper_app/models/photo_list_response.dart';
import 'package:wallpaper_app/models/photo_type.dart';
import 'package:wallpaper_app/nature_tab_view.dart';
import 'package:wallpaper_app/service/data_service.dart';
import 'package:wallpaper_app/travel_tab_view.dart';
import 'package:wallpaper_app/wallpapers_tab_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallpaper App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<WallpaperBloc>(create: (context) => WallpaperBloc()),
          BlocProvider<TravelBloc>(create: (context) => TravelBloc()),
          BlocProvider<NatureBloc>(create: (context) => NatureBloc()),
          BlocProvider<PhotosCubit>(create: (context) => PhotosCubit())
        ],
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dataService = DataService();

  final categories = <String, String>{
    'wallpapers': 'Wallpapers',
    'travel': 'Travel',
    'nature': 'Nature',
  };

  final _wallpapersPopular = <PhotoListItem>[];
  final _wallpapersLatest = <PhotoListItem>[];
  final _wallpapersOldest = <PhotoListItem>[];
  var pageNumberPopular = 1;
  var pageNumberLatest = 1;
  var pageNumberOldest = 1;

  PhotoSort selectedSort = PhotoSort.POPULAR;

  @override
  void initState() {
    super.initState();
    context.read<WallpaperBloc>().add(LoadPhotosEvent(sortType: selectedSort));
    context.read<TravelBloc>().add(LoadPhotosEvent(sortType: selectedSort));
    context.read<NatureBloc>().add(LoadPhotosEvent(sortType: selectedSort));
    context.read<PhotosCubit>().getPhotosByTopic('travel');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wallpapers'),
          centerTitle: true,
          bottom: TabBar(tabs: getTabs()),
          actions: [
            PopupMenuButton(
                icon: const Icon(Icons.filter_list),
                initialValue: selectedSort,
                onSelected: (PhotoSort sortType) {
                  setState(() {
                    selectedSort = sortType;
                    BlocProvider.of<WallpaperBloc>(context).add(RefreshListEvent(sortType: selectedSort));
                    BlocProvider.of<TravelBloc>(context).add(RefreshListEvent(sortType: selectedSort));
                    BlocProvider.of<NatureBloc>(context).add(RefreshListEvent(sortType: selectedSort));
                  });
                },
                itemBuilder: (context) => <PopupMenuEntry<PhotoSort>>[
                      const PopupMenuItem(
                          value: PhotoSort.POPULAR, child: Text('Popular')),
                      const PopupMenuItem(
                          value: PhotoSort.LATEST, child: Text('Latest')),
                      const PopupMenuItem(
                          value: PhotoSort.OLDEST, child: Text('Oldest')),
                    ])
          ],
        ),
        body: TabBarView(children: [
          WallpaperTabView(
            loadMoreCallback: () => BlocProvider.of<WallpaperBloc>(context).add(LoadPhotosEvent(sortType: selectedSort)),
            refreshCallback: () => BlocProvider.of<WallpaperBloc>(context).add(RefreshListEvent(sortType: selectedSort)),
          ),
          TravelTabView(
            loadMoreCallback: () => BlocProvider.of<TravelBloc>(context).add(LoadPhotosEvent(sortType: selectedSort)),
            refreshCallback: () => BlocProvider.of<TravelBloc>(context).add(RefreshListEvent(sortType: selectedSort)),
          ),
          NatureTabView(
            loadMoreCallback: () => BlocProvider.of<NatureBloc>(context).add(LoadPhotosEvent(sortType: selectedSort)),
            refreshCallback: () => BlocProvider.of<NatureBloc>(context).add(RefreshListEvent(sortType: selectedSort)),
          ),
          // BlocBuilder<PhotosCubit, List<PhotoListItem>>(
          //     builder: (context, photos) {
          //   if (kDebugMode) {
          //     for (var element in photos) {
          //       print(element.photoItemUrls.full);
          //     }
          //   }
          //   return Column(children: [
          //     if (photos.isNotEmpty)
          //       Flexible(
          //           flex: 1,
          //           child: GridView.builder(
          //             gridDelegate:
          //                 const SliverGridDelegateWithFixedCrossAxisCount(
          //                     crossAxisCount: 3),
          //             itemCount: photos.length,
          //             itemBuilder: (context, index) => GridTile(
          //               child: SizedBox(
          //                 height: 50,
          //                 child: Image.network(
          //                   photos[index].photoItemUrls.thumb,
          //                   fit: BoxFit.cover,
          //                   errorBuilder: (BuildContext context,
          //                       Object exception, StackTrace? stackTrace) {
          //                     return const FlutterLogo();
          //                   },
          //                 ),
          //               ),
          //             ),
          //           )),
          //     Flexible(
          //         flex: 0,
          //         child: ElevatedButton(
          //             onPressed: () {
          //               context.read<PhotosCubit>().getPhotosByTopic(
          //                   pageNumberPopular, categories.keys.elementAt(1));
          //             },
          //             child: photos.isEmpty
          //                 ? const Text('Get Wallpapers')
          //                 : const Text('More Wallpapers')))
          //   ]);
          // }),
        ]),
      ),
    );
  }

  // old way to get list & show in tab views
  Widget _tabView(PhotoSort sortBy) {
    switch (sortBy) {
      case PhotoSort.POPULAR:
        {
          return Column(children: [
            if (_wallpapersPopular.isNotEmpty)
              Flexible(flex: 1, child: _wallpaperGridView(sortBy)),
            Flexible(
                flex: 0,
                child: ElevatedButton(
                    onPressed: () {
                      getWallpapers(sortBy);
                    },
                    child: _wallpapersPopular.isEmpty
                        ? const Text('Get Wallpapers')
                        : const Text('More Wallpapers')))
          ]);
        }

      case PhotoSort.LATEST:
        {
          return Column(children: [
            if (_wallpapersLatest.isNotEmpty)
              Flexible(flex: 1, child: _wallpaperGridView(sortBy)),
            Flexible(
                flex: 0,
                child: ElevatedButton(
                    onPressed: () {
                      getWallpapers(sortBy);
                    },
                    child: _wallpapersLatest.isEmpty
                        ? const Text('Get Wallpapers')
                        : const Text('More Wallpapers')))
          ]);
        }

      case PhotoSort.OLDEST:
        {
          return Column(children: [
            if (_wallpapersOldest.isNotEmpty)
              Flexible(flex: 1, child: _wallpaperGridView(sortBy)),
            Flexible(
                flex: 0,
                child: ElevatedButton(
                    onPressed: () {
                      getWallpapers(sortBy);
                    },
                    child: _wallpapersOldest.isEmpty
                        ? const Text('Get Wallpapers')
                        : const Text('More Wallpapers')))
          ]);
        }
    }
  }

  Widget _wallpaperGridView(PhotoSort sortBy) {
    switch (sortBy) {
      case PhotoSort.POPULAR:
        {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemCount: _wallpapersPopular.length,
            itemBuilder: (context, index) => GridTile(
              child: SizedBox(
                height: 48,
                child: Image.network(
                  _wallpapersPopular[index].photoItemUrls.thumb,
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

      case PhotoSort.LATEST:
        {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemCount: _wallpapersLatest.length,
            itemBuilder: (context, index) => GridTile(
              child: SizedBox(
                height: 50,
                child: Image.network(
                    _wallpapersLatest[index].photoItemUrls.thumb,
                    fit: BoxFit.cover),
              ),
            ),
          );
        }

      case PhotoSort.OLDEST:
        {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemCount: _wallpapersOldest.length,
            itemBuilder: (context, index) => GridTile(
              child: SizedBox(
                height: 50,
                child: Image.network(
                    _wallpapersOldest[index].photoItemUrls.thumb,
                    fit: BoxFit.cover),
              ),
            ),
          );
        }
    }
  }

  void getWallpapers(PhotoSort sortBy) async {
    switch (sortBy) {
      case PhotoSort.POPULAR:
        {
          pageNumberPopular =
              _wallpapersPopular.isEmpty ? 1 : ++pageNumberPopular;
          final list =
              await dataService.getPhotos(pageNumberPopular, sortType: sortBy);

          if (kDebugMode) {
            for (var element in list) {
              print(element.photoItemUrls.thumb);
            }
          }

          setState(() {
            _wallpapersPopular.addAll(list);
          });
        }
        break;

      case PhotoSort.LATEST:
        {
          pageNumberLatest = _wallpapersLatest.isEmpty ? 1 : ++pageNumberLatest;
          final list =
              await dataService.getPhotos(pageNumberLatest, sortType: sortBy);

          if (kDebugMode) {
            for (var element in list) {
              print(element.photoItemUrls.thumb);
            }
          }

          setState(() {
            _wallpapersLatest.addAll(list);
          });
        }
        break;

      case PhotoSort.OLDEST:
        {
          pageNumberOldest = _wallpapersOldest.isEmpty ? 1 : ++pageNumberOldest;
          final list =
              await dataService.getPhotos(pageNumberOldest, sortType: sortBy);
          if (kDebugMode) {
            for (var element in list) {
              print(element.photoItemUrls.thumb);
            }
          }

          setState(() {
            _wallpapersOldest.addAll(list);
          });
        }
        break;
    }
  }

  // show tabs dynamically using categories map
  List<Widget> getTabs() {
    final list = <Widget>[];

    for (int i = 0; i < categories.length; i++) {
      var tab = Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Text(categories.values.elementAt(i)),
      );
      list.add(tab);
    }

    return list;
  }
}

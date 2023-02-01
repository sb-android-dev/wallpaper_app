import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class WallpaperView extends StatelessWidget {
  const WallpaperView({Key? key, required this.imageUrl}) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        basePosition: Alignment.center,
        initialScale: PhotoViewComputedScale.covered,
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 1.8,
      ),
    );
  }
}

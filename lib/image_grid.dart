import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixabay_gallery/model/image_model.dart';

class ImageGrid extends StatelessWidget {
  final List<ImageModel> images;

  const ImageGrid({super.key, required this.images});

  /// This Dart function calculates the number of items to display in a row based on the screen width in
  /// a responsive manner.
  int _calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 1200) return 6;
    if (screenWidth >= 992) return 5;
    if (screenWidth >= 768) return 4;
    if (screenWidth >= 576) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = _calculateCrossAxisCount(context);

    /// `MasonryGridView` is a widget provided by the `flutter_staggered_grid_view` package in
    /// Flutter. It is used to create a staggered grid view where the items can have different
    /// heights, allowing for a more dynamic and visually appealing layout compared to a
    /// traditional grid view. The `count` constructor of `MasonryGridView` allows you to specify
    /// the number of columns in the grid, and the items in the grid will be laid out in a
    /// staggered manner based on their heights.
    MasonryGridView.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images[index];
        return Card(
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// `CachedNetworkImage` is a widget provided by the `cached_network_image` package in
              /// Flutter. It is used to load and cache images from a network URL efficiently. When you
              /// provide the `imageUrl` parameter with the URL of the image you want to display,
              /// `CachedNetworkImage` will handle fetching the image, caching it locally for future
              /// use, and displaying it in your Flutter application.
              CachedNetworkImage(
                imageUrl: image.previewURL,
                
                placeholder: (context, url) => const SizedBox(
                  height: 150,
                  child: Center(
                    child: SpinKitPulse(
                      color: Colors.blue,
                      size: 50.0,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.contain,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  children: [
                    const Icon(Icons.favorite, size: 16, color: Colors.red),
                    const SizedBox(width: 4),
                    Text('${image.likes}'),
                    const SizedBox(width: 16),
                    const Icon(Icons.remove_red_eye, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${image.views}'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
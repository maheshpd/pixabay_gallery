import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pixabay_gallery/image_grid.dart';
import 'package:pixabay_gallery/model/image_model.dart';
import 'package:pixabay_gallery/services/api_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixabay Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GalleryPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final ApiService apiService = ApiService();
  final ScrollController scrollController = ScrollController();

 final List<ImageModel> images = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;

  final int _perPage = 20;

  @override
  void initState() {
    super.initState();
    fetchImages();

    /// The `_scrollController.addListener()` method is adding a listener to the scroll controller in
    /// the `_GalleryPageState` class. This listener is triggered whenever the user scrolls the content
    /// of the page.
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 300 &&
          !isLoading &&
          hasMore) {
        fetchImages();
      }
    });
  }

  /// The `_fetchImages` function fetches images from an API, updates the state accordingly, and handles
  /// errors gracefully.
  Future<void> fetchImages() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<ImageModel> fetchedImages =
          await apiService.fetchImages(page: page, perPage: _perPage);

      setState(() {
        page++;
        if (fetchedImages.length < _perPage) {
          hasMore = false;
        }
        images.addAll(fetchedImages);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching images: $e')),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// The `_refreshImages` function clears the existing images, resets the page number, and fetches new
  /// images asynchronously.
  Future<void> _refreshImages() async {
    setState(() {
      images.clear();
      page = 1;
      hasMore = true;
    });
    await fetchImages();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  /// The _buildProgressIndicator function returns a centered circular progress indicator with a blue
  /// color and size of 50.0.
  Widget _buildProgressIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: SpinKitCircle(
          color: Colors.blue,
          size: 50.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pixabay Gallery'),
      ),
      body: /// The `RefreshIndicator` widget is used to implement the "pull-to-refresh" functionality
      /// in a Flutter app. In this specific code snippet:
      RefreshIndicator(
        onRefresh: _refreshImages,
        child: Column(
          children: [
            Expanded(
              child: images.isEmpty && isLoading
                  ? _buildProgressIndicator()
                  : ImageGrid(images: images),
            ),
            if (isLoading) _buildProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

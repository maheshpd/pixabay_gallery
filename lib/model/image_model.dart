class ImageModel {
  final String previewURL;
  final int likes;
  final int views;

  ImageModel({
    required this.previewURL,
    required this.likes,
    required this.views,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      previewURL: json['previewURL'],
      likes: json['likes'],
      views: json['views'],
    );
  }
}
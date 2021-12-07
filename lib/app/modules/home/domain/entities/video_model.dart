class VideoModel {
  String id = '';
  String title = '';
  String url = '';

  VideoModel({
    required this.id,
    required this.title,
    required this.url,
  });

  VideoModel.fromJson(Map<String, dynamic> json) {
    id = json['id']['videoId'];
    title = json['snippet']['title'];
    url = json['snippet']['thumbnails']['high']['url'];
  }
}

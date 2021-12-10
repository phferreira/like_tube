import 'i_video.dart';

class Video extends IVideo {
  Video({
    required id,
    required title,
    required url,
    favorite,
  });

  Video.noProperties() {
    id = '';
    title = '';
    url = '';
    favorite = false;
  }

  Video.fromJson(Map<String, dynamic> json) {
    id = json['id']['videoId'];
    title = json['snippet']['title'];
    url = json['snippet']['thumbnails']['high']['url'];
  }
}

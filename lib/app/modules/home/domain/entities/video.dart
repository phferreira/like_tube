import 'dart:convert';
import 'i_video.dart';

class Video implements IVideo {
  @override
  bool favorite = false;

  @override
  String id = '';

  @override
  String title = '';

  @override
  String url = '';

  Video({
    required this.id,
    required this.title,
    required this.url,
    this.favorite = false,
  });

  Video.noProperties() {
    id = '';
    title = '';
    url = '';
    favorite = false;
  }

  Map<String, dynamic> toMap() {
    return {
      'favorite': '$favorite',
      'id': id,
      'title': title,
      'url': url,
    };
  }

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      favorite: map['favorite'].toString() == 'true' ? true : false,
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      url: map['url'] ?? '',
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Video.fromJson(String source) => Video.fromMap(jsonDecode(source));
}

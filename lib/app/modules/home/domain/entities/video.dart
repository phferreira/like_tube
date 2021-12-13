import 'dart:convert';
import 'package:like_tube/app/modules/home/domain/entities/i_video.dart';

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
      'bl_favorite': '$favorite',
      'cd_id': id,
      'tx_title': title,
      'tx_url': url,
    };
  }

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      favorite: map['bl_favorite'].toString() == 'true',
      id: map['cd_id'] ?? '',
      title: map['tx_title'] ?? '',
      url: map['tx_url'] ?? '',
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Video.fromJson(String source) => Video.fromMap(jsonDecode(source));

  factory Video.fromJsonHttp(Map<String, dynamic> json) {
    return Video(
      id: json['id']['videoId'] ?? '',
      title: json['snippet']['title'] ?? '',
      url: json['snippet']['thumbnails']['high']['url'] ?? '',
    );
  }
}

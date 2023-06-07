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
      'cd_id': id,
      'tx_title': title,
      'tx_url': url,
      'bl_favorite': '$favorite',
    };
  }

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      favorite: map['bl_favorite'].toString() == 'true',
      id: map['cd_id'] as String,
      title: map['tx_title'] as String,
      url: map['tx_url'] as String,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Video.fromJson(String source) => Video.fromMap(jsonDecode(source) as Map<String, dynamic>);

  factory Video.fromJsonHttp(Map<String, dynamic> json) {
    return Video(
      id: json['id']['videoId'] as String,
      title: json['snippet']['title'] as String,
      url: json['snippet']['thumbnails']['high']['url'] as String,
    );
  }
}

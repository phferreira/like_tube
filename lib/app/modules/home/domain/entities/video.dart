import 'dart:convert';

import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/modules/home/domain/entities/i_video.dart';

class Video implements IVideo {
  @override
  bool historic = false;

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
    this.historic = false,
  });

  Video.noProperties() {
    id = '';
    title = '';
    url = '';
    favorite = false;
    historic = false;
  }

  JsonType toMap() {
    return {
      'cd_id': id,
      'tx_title': title,
      'tx_url': url,
      'bl_favorite': '$favorite',
      'bl_historic': '$historic',
    };
  }

  factory Video.fromMap(JsonType map) {
    return Video(
      favorite: map['bl_favorite'].toString() == 'true',
      historic: map['bl_historic'].toString() == 'true',
      id: map['cd_id'] as String,
      title: map['tx_title'] as String,
      url: map['tx_url'] as String,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Video.fromJson(String source) => Video.fromMap(jsonDecode(source) as JsonType);

  factory Video.fromJsonHttp(JsonType json) {
    return Video(
      id: json['id']['videoId'].toString(),
      title: json['snippet']['title'].toString(),
      url: json['snippet']['thumbnails']['high']['url'].toString(),
    );
  }
}

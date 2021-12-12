import 'package:flutter/material.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';

class VideoPage extends StatelessWidget {
  final Video video;

  const VideoPage({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualização'),
      ),
      body: Hero(
        tag: video.id,
        child: buildImage(),
      ),
    );
  }

  Widget buildImage() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(video.url),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

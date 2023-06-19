import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/presenter/stores/video_item_store.dart';
import 'package:like_tube/app/modules/video/video_page.dart';

class VideoItemWidget extends StatelessWidget {
  final Video video;

  const VideoItemWidget({
    super.key,
    required this.video,
  });

  VideoItemStore get store => Modular.get<VideoItemStore>();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: GridTile(
        header: GridTileBar(
          backgroundColor: Colors.black45,
          leading: const Icon(Icons.videocam),
          title: Text(video.title),
          trailing: const Icon(Icons.share_outlined),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black45,
          trailing: ScopedBuilder<VideoItemStore, IFailure, Video>(
            store: store,
            onLoading: (_) {
              return const SizedBox();
            },
            onState: (_, video1) {
              return IconButton(
                color: video.favorite ? Colors.yellow : Colors.yellow.withAlpha(99),
                icon: const Icon(Icons.star),
                splashRadius: 16,
                onPressed: () {
                  store.saveFavorite(video);
                },
              );
            },
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Modular.to.push(
              MaterialPageRoute<void>(
                builder: (context) => VideoPage(video: video),
              ),
            );
          },
          child: Container(
            width: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(video.url),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

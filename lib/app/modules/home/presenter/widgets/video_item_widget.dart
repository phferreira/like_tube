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
    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                onTap: () {
                  Modular.to.push(
                    MaterialPageRoute(
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
              Positioned(
                top: 10,
                child: ScopedBuilder<VideoItemStore, IFailure, Video>(
                  store: store,
                  onLoading: (_) {
                    return const SizedBox();
                  },
                  onState: (_, video1) {
                    return IconButton(
                      iconSize: 40,
                      color: video.favorite ? Colors.yellow : Colors.yellow.withAlpha(99),
                      icon: const Icon(Icons.star),
                      onPressed: () {
                        store.saveFavorite(video);
                      },
                    );
                  },
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  iconSize: 40,
                  color: Colors.black,
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
        ListTile(
          title: Text(
            video.title,
            maxLines: 2,
          ),
          leading: FutureBuilder<String>(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const CircleAvatar(
                  backgroundColor: Colors.black,
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/presenter/stores/favorite_video_store.dart';
import 'package:like_tube/app/modules/home/presenter/stores/history_video_store.dart';
import 'package:like_tube/app/modules/home/presenter/widgets/video_item_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPage extends StatefulWidget {
  final Video video;

  const VideoPage({super.key, required this.video});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late YoutubePlayerController _controller;
  final HistoryVideoStore _historyVideoStore = Modular.get<HistoryVideoStore>();
  final FavoriteVideoStore _favoriteVideoStore = Modular.get<FavoriteVideoStore>();

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.id,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    );
    _historyVideoStore.setHistoryVideo(widget.video);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(controller: _controller),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.video.title),
          ),
          body: Column(
            children: [
              player,
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 20,
                        child: Row(
                          children: [
                            const Text('Favoritos'),
                            const Expanded(child: SizedBox()),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Ver todos'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _favoriteVideoStore.state.length,
                        padding: const EdgeInsets.all(8),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 20,
                        ),
                        itemBuilder: (context, index) => VideoItemWidget(
                          video: _favoriteVideoStore.state[index],
                          headerVisible: false,
                          footerVisible: false,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 20,
                        child: Row(
                          children: [
                            const Text('Historico'),
                            const Expanded(child: SizedBox()),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Ver todos'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _historyVideoStore.state.length,
                        padding: const EdgeInsets.all(8),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 20,
                        ),
                        itemBuilder: (context, index) => VideoItemWidget(
                          video: _historyVideoStore.state[index],
                          headerVisible: false,
                          footerVisible: false,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

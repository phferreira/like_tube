import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/presenter/stores/history_video_store.dart';
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

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.id,
      flags: const YoutubePlayerFlags(
        controlsVisibleAtStart: true,
      ),
    );
    _historyVideoStore.setHistoryVideo(widget.video);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('teste'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: (MediaQuery.of(context).orientation == Orientation.portrait) ? MediaQuery.of(context).size.height / 1.5 : MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: YoutubePlayer(
              onEnded: (_) => Modular.to.pop(),
              controller: _controller,
              liveUIColor: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }
}

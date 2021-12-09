import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:like_tube/app/modules/home/domain/entities/video_model.dart';
import 'package:like_tube/app/modules/home/home_store.dart';

class VideoItem extends StatelessWidget {
  final VideoModel videoModel;

  const VideoItem({
    Key? key,
    required this.videoModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            width: 200,
            decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(videoModel.url), fit: BoxFit.cover)),
          ),
        ),
        ListTile(
          // isThreeLine: true,
          title: Text(
            videoModel.title,
            maxLines: 2,
          ),
          leading: FutureBuilder<String>(
            // future: HomeRepository(CustomDio()).getImage(idChannel: snapshot.idChannel),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(videoModel.url),
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

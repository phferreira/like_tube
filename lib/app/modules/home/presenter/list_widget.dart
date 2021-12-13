import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/bottom_navigation_store.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/favorite_video_store.dart';
import 'package:like_tube/app/modules/home/history_video_store.dart';
import 'package:like_tube/app/modules/home/home_store.dart';
import 'package:like_tube/app/modules/home/presenter/video_item_widget.dart';

BottomNavigationStore get bottomNavigationStore => Modular.get<BottomNavigationStore>();
HomeStore get homeStore => Modular.get<HomeStore>();
FavoriteVideoStore get videoItemStore => Modular.get<FavoriteVideoStore>();
HistoryVideoStore get historyVideoStore => Modular.get<HistoryVideoStore>();

List<Widget> listWidgetMenu = <Widget>[
  TextField(
    controller: homeStore.pesquisarController,
    decoration: InputDecoration(
      labelText: 'Pesquisar',
      labelStyle: const TextStyle(
        color: Colors.white,
      ),
      suffixIcon: IconButton(
        color: Colors.white,
        onPressed: () => homeStore.getVideoByDescription(''),
        icon: const Icon(Icons.search),
      ),
    ),
  ),
  const Text(
    'Favoritos',
  ),
  Row(
    children: [
      Expanded(
        flex: 5,
        // crossAxisAlignment: CrossAxisAlignment.start,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Histórico'),
          ],
        ),
      ),
      Expanded(
        flex: 5,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            PopupMenuButton(
              icon: const Icon(Icons.list),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  child: const ListTile(
                    title: Text('Remover todos'),
                    leading: Icon(Icons.delete),
                  ),
                  onTap: () => historyVideoStore.removeAll,
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  ),
];

List<Widget> listWidgetBody = <Widget>[
  ScopedBuilder<HomeStore, IFailure, List<Video>>(
    store: homeStore,
    onState: (_, list) {
      return Scrollbar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: GridView.builder(
            itemCount: list.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 20,
            ),
            itemBuilder: (context, index) => VideoItemWidget(
              video: list[index],
            ),
          ),
        ),
      );
    },
    onError: (context, error) {
      return Container();
    },
  ),
  ScopedBuilder<FavoriteVideoStore, IFailure, List<Video>>(
    store: videoItemStore,
    onState: (_, list) {
      return Scrollbar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: GridView.builder(
            itemCount: list.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 20,
            ),
            itemBuilder: (context, index) => VideoItemWidget(
              video: list[index],
            ),
          ),
        ),
      );
    },
  ),
  ScopedBuilder<HistoryVideoStore, IFailure, List<Video>>(
    store: historyVideoStore,
    onState: (_, list) {
      return Scrollbar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: GridView.builder(
            itemCount: list.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 20,
            ),
            itemBuilder: (context, index) => VideoItemWidget(
              video: list[index],
            ),
          ),
        ),
      );
    },
  ),
];

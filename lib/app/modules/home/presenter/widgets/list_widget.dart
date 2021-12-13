import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/presenter/stores/bottom_navigation_store.dart';
import 'package:like_tube/app/modules/home/presenter/stores/favorite_video_store.dart';
import 'package:like_tube/app/modules/home/presenter/stores/history_video_store.dart';
import 'package:like_tube/app/modules/home/presenter/stores/home_store.dart';
import 'package:like_tube/app/modules/home/presenter/widgets/grid_list_widget.dart';

BottomNavigationStore get bottomNavigationStore => Modular.get<BottomNavigationStore>();
HomeStore get homeStore => Modular.get<HomeStore>();
FavoriteVideoStore get videoItemStore => Modular.get<FavoriteVideoStore>();
HistoryVideoStore get historyVideoStore => Modular.get<HistoryVideoStore>();

List<AppBar> listWidgetMenu = <AppBar>[
  AppBar(
    title: TextField(
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
  ),
  AppBar(
    title: const Text(
      'Favoritos',
    ),
  ),
  AppBar(
    title: const Text('Histórico'),
    actions: <Widget>[
      PopupMenuButton(
        icon: const Icon(Icons.list),
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
          PopupMenuItem(
            child: const ListTile(
              title: Text('Remover todos'),
              leading: Icon(Icons.delete),
            ),
            onTap: () => historyVideoStore.removeAll(),
          ),
        ],
      ),
    ],
  ),
];

List<Widget> listWidgetBody = <Widget>[
  ScopedBuilder<HomeStore, IFailure, List<Video>>(
    store: homeStore,
    onState: (_, list) {
    },
    onError: (context, error) {
      return Container();
    },
  ),
  ScopedBuilder<FavoriteVideoStore, IFailure, List<Video>>(
    store: videoItemStore,
    onState: (_, list) {
    },
  ),
  ScopedBuilder<HistoryVideoStore, IFailure, List<Video>>(
    store: historyVideoStore,
    onState: (_, list) {
    },
  ),
];

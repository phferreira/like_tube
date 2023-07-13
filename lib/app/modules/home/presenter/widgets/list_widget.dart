import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:like_tube/app/core/constants/key.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/core/types/query_type.dart';
import 'package:like_tube/app/core/utils/debounce.dart';
import 'package:like_tube/app/modules/home/presenter/stores/favorite_video_store.dart';
import 'package:like_tube/app/modules/home/presenter/stores/history_video_store.dart';
import 'package:like_tube/app/modules/home/presenter/stores/home_store.dart';
import 'package:like_tube/app/modules/home/presenter/widgets/grid_list_widget.dart';

HomeStore get homeStore => Modular.get<HomeStore>();
FavoriteVideoStore get videoItemStore => Modular.get<FavoriteVideoStore>();
HistoryVideoStore get historyVideoStore => Modular.get<HistoryVideoStore>();
final pesquisarController = TextEditingController();
Debounce debounce = Debounce();

List<AppBar> listWidgetMenu = <AppBar>[
  AppBar(
    title: TextField(
      controller: pesquisarController,
      decoration: InputDecoration(
        labelText: 'Pesquisar',
        labelStyle: const TextStyle(
          color: Colors.white,
        ),
        suffixIcon: IconButton(
          color: Colors.white,
          onPressed: () => debounce(() => homeStore.getVideoByDescription(pesquisarController.text)),
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
    actions: [
      PopupMenuButton(
        icon: const Icon(Icons.list),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<void>>[
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
  ScopedBuilder<HomeStore, IFailure, ListVideo>(
    store: homeStore,
    onState: (_, list) {
      return GridListsWidget(gridList: list);
    },
    onError: (context, error) {
      return Container();
    },
  ),
  ScopedBuilder<FavoriteVideoStore, IFailure, ListVideo>(
    store: videoItemStore,
    onState: (_, list) {
      return GridListsWidget(gridList: list);
    },
  ),
  ScopedBuilder<HistoryVideoStore, IFailure, ListVideo>(
    store: historyVideoStore,
    onState: (_, list) {
      return GridListsWidget(gridList: list);
    },
  ),
];

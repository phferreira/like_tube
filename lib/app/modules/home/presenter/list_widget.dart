import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/domain/entities/video.dart';
import 'package:like_tube/app/modules/home/presenter/video_item_widget.dart';

import '../bottom_navigation_store.dart';
import '../home_store.dart';

BottomNavigationStore get bottomNavigationStore => Modular.get<BottomNavigationStore>();
HomeStore get homeStore => Modular.get<HomeStore>();

class ListWidget {
  static List<Widget> listWidgetMenu = <Widget>[
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
    const Text(
      'Historico',
    ),
  ];

  static List<Widget> listWidgetBody = <Widget>[
    ScopedBuilder<HomeStore, IFailure, List<Video>>(
      store: homeStore,
      onState: (_, list) {
        return Scrollbar(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: GridView.builder(
              scrollDirection: Axis.vertical,
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
    const Text('Favoritos'),
    const Text('Historico'),
  ];
}
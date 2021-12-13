import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/presenter/stores/bottom_navigation_store.dart';
import 'package:like_tube/app/modules/home/presenter/stores/home_store.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({
    Key? key,
  }) : super(key: key);

  HomeStore get homeStore => Modular.get<HomeStore>();
  BottomNavigationStore get bottomNavigationStore => Modular.get<BottomNavigationStore>();

  @override
  Widget build(BuildContext context) {
    return ScopedBuilder<BottomNavigationStore, IFailure, int>(
      onLoading: (_) => const SizedBox(),
      onState: (_, selectItem) {
        return BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Pesquisar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Favoritos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Histórico',
            ),
          ],
          currentIndex: selectItem,
          selectedItemColor: Colors.amber[800],
          onTap: (index) {
            bottomNavigationStore.selectedIndex(index);
            homeStore.changePage(index);
          },
        );
      },
    );
  }
}

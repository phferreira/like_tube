import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/presenter/stores/bottom_navigation_store.dart';
import 'package:like_tube/app/modules/home/presenter/stores/home_store.dart';
import 'package:like_tube/app/modules/home/presenter/widgets/botton_navigation_bar_widget.dart';
import 'package:like_tube/app/modules/home/presenter/widgets/list_widget.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({super.key, this.title = 'Like Tube'});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeStore homeStore = Modular.get<HomeStore>();
  BottomNavigationStore get bottomNavigationStore => Modular.get<BottomNavigationStore>();

  @override
  void initState() {
    homeStore.observer(
      onState: (state) => debugPrint('state change '),
      onLoading: (loading) => debugPrint('is loading'),
      onError: (error) => debugPrint('error true'),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedBuilder<BottomNavigationStore, IFailure, int>(
      store: bottomNavigationStore,
      onLoading: (_) => const SizedBox(),
      onState: (context, index) {
        return Scaffold(
          appBar: listWidgetMenu.elementAt(bottomNavigationStore.getSelectedIndex()),
          body: listWidgetBody.elementAt(index),
          bottomNavigationBar: const BottomNavigationBarWidget(),
        );
      },
    );
  }
}

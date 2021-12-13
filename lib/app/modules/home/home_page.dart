import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:like_tube/app/core/errors/i_failure.dart';
import 'package:like_tube/app/modules/home/bottom_navigation_store.dart';
import 'package:like_tube/app/modules/home/home_store.dart';
import 'package:like_tube/app/modules/home/presenter/botton_navigation_bar_widget.dart';
import 'package:like_tube/app/modules/home/presenter/list_widget.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = 'Like Tube'}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeStore> {
  @override
  void initState() {
    store.observer(
      onState: (state) => debugPrint('state change '),
      onLoading: (loading) => debugPrint('is loading'),
      onError: (error) => debugPrint('error true'),
    );
    super.initState();
  }

  BottomNavigationStore get bottomNavigationStore => Modular.get<BottomNavigationStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ScopedBuilder<BottomNavigationStore, IFailure, int>(
          onLoading: (_) => const SizedBox(),
          onState: (_, index) {
            return listWidgetMenu.elementAt(index);
          },
        ),
      ),
      body: ScopedBuilder<BottomNavigationStore, IFailure, int>(
        onLoading: (_) => const SizedBox(),
        onState: (_, index) {
          return listWidgetBody.elementAt(index);
        },
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }
}

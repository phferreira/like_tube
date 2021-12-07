import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'home_store.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = "Like Tube"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeStore> {
  @override
  void initState() {
    store.observer(
      onState: (state) => debugPrint('state:' + state.toString()),
      onLoading: (loading) => debugPrint('loading:' + loading.toString()),
      onError: (error) => debugPrint('error:' + error.toString()),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ScopedBuilder<HomeStore, Exception, int>(
        store: store,
        onState: (_, counter) {
          return ElevatedButton(
            child: const Text('Buscar'),
            onPressed: () {
              store.getVideoByDescription('');
            },
          );
        },
        onError: (context, error) {
          return Container();
        },
      ),
    );
  }
}

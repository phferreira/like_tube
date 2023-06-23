import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:like_tube/app/app_module.dart';
import 'package:like_tube/app/app_widget.dart';

void main() {
  // FIX CI/CD:  <22-06-23, yourname> //
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    ),
  );
}

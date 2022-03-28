import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_challenge_menu/features/app/view/app_view.dart';

import 'features/app/viewmodel/app_viewmodel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final model = AppViewModel();
            model.init();
            return model;
          },
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'UI Challenge 2 - MENU',
        theme: ThemeData(
          fontFamily: "Lato",
          primarySwatch: Colors.blue,
        ),
        home: AppView(),
      ),
    );
  }
}

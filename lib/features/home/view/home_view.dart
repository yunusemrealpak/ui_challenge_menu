import 'package:flutter/material.dart';

import 'package:ui_challenge_menu/core/base/base_view.dart';
import 'package:ui_challenge_menu/core/extensions/context_extensions.dart';

import '../viewmodel/home_viewmodel.dart';

class HomeView extends StatelessWidget {
  final bool isCompressed;
  const HomeView({
    Key? key,
    this.isCompressed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModel: HomeViewModel(),
      builder: (context, model, _) => Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
          width: context.customWidthValue(isCompressed ? 0.7 : 1),
          height: context.height,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    height: 300,
                    child: Image.asset(
                      "assets/images/shoes.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  "FLIP THE SWITCH PACK",
                  style: TextStyle(
                    fontFamily: "Lato",
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    "Enrace the intensity of the playoffs as you transform \nyour game into an art form",
                    style: TextStyle(
                      fontFamily: "Lato",
                      fontSize: 17,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

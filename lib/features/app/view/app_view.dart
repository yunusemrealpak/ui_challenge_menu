import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ui_challenge_menu/core/extensions/context_extensions.dart';
import 'package:ui_challenge_menu/features/app/_widgets/drawer_widget.dart';
import 'package:ui_challenge_menu/features/home/view/home_view.dart';

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late PageController _controller;
  int _pageCount = 1;

  bool _drawerOpen = false;

  changeDrawerState() {
    if (_animationController.status == AnimationStatus.dismissed ||
        _animationController.status == AnimationStatus.reverse) {
      setState(() {
        _drawerOpen = !_drawerOpen;
      });
      _animationController.forward();
    } else if (_animationController.status == AnimationStatus.completed ||
        _animationController.status == AnimationStatus.forward) {
      setState(() {
        _drawerOpen = !_drawerOpen;
      });
      _animationController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    _controller = PageController();
  }

  addPage() {
    setState(() {
      _pageCount++;
    });
    //_controller.nextPage(duration: Duration(seconds: 1), curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Stack(
        children: [
          AnimatedPadding(
            duration: Duration(milliseconds: 450),
            curve: Curves.ease,
            padding: EdgeInsets.all(_drawerOpen ? 35.0 : 0),
            child: _buildContent(),
          ),
          AnimatedPositioned(
            right: _drawerOpen ? 0 : -context.width,
            curve: Curves.ease,
            duration: Duration(milliseconds: 450),
            child: _buildDrawerContent(),
          ),
          _buildAppBar(),
          _buildShare(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return HomeView(isCompressed: _drawerOpen);
  }

  Widget _buildDrawerContent() {
    return DrawerWidget(
      isCompressed: _drawerOpen,
      closeDrawer: () {
        changeDrawerState();
      },
    );
  }

  Widget _buildAppBar() {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100,
                height: 50,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  opacity: _drawerOpen ? 0 : 1,
                  child: Image.asset("assets/images/im_nike.png"),
                ),
              ),
              GestureDetector(
                onTap: changeDrawerState,
                child: Lottie.asset(
                  'assets/lottie/hamburgermenu.json',
                  controller: _animationController,
                  repeat: false,
                  width: 100,
                  height: 100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShare() {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomRight,
        child: SizedBox(
          width: 100,
          height: 100,
          child: Icon(Icons.share),
        ),
      ),
    );
  }
}

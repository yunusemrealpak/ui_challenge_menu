import 'package:animate_do/animate_do.dart';
import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ui_challenge_menu/core/extensions/context_extensions.dart';
import 'package:ui_challenge_menu/core/utils/my_scroll_behaviour.dart';
import 'package:ui_challenge_menu/features/app/viewmodel/app_viewmodel.dart';
import 'package:ui_challenge_menu/features/widgets/frosted_glass_box.dart';

import '../../../models/category.dart';

class DrawerWidget extends StatefulWidget {
  final bool isCompressed;
  final VoidCallback? closeDrawer;
  const DrawerWidget({
    Key? key,
    this.isCompressed = false,
    this.closeDrawer,
  }) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late PageController _pageController;
  late PageController _titleController;

  int _currentPage = 0;
  int _currentTitle = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _titleController = PageController(viewportFraction: 0.35);
  }

  Future nextPage() async {
    var _titleNext = _titleController.nextPage(
        duration: context.lowDuration, curve: Curves.ease);
    var _pageNext = _pageController.nextPage(
        duration: context.lowDuration, curve: Curves.ease);

    await Future.wait([_titleNext, _pageNext]);
  }

  Future prevPage() async {
    var _titleNext = _titleController.previousPage(
        duration: context.lowDuration, curve: Curves.ease);
    var _pageNext = _pageController.previousPage(
        duration: context.lowDuration, curve: Curves.ease);

    await Future.wait([_titleNext, _pageNext]);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(
      builder: (context, model, _) => ClipRRect(
        child: FrostedGlassBox(
          child: SafeArea(
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 450),
              curve: Curves.easeIn,
              opacity: widget.isCompressed ? 1 : 0,
              child: Stack(
                children: [
                  _buildContent(model),
                  _buildAppBar(),
                  _buildTitles(context, model),
                  _buildBottomArea(context, model),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildTitles(BuildContext context, AppViewModel model) {
    return Padding(
      padding: EdgeInsets.only(top: context.height / 5),
      child: Container(
        height: context.height / 8,
        child: PageView.builder(
          controller: _titleController,
          itemCount: model.selectedCategories.length,
            physics: NeverScrollableScrollPhysics(),
          onPageChanged: (_) {
            setState(() {
              _currentTitle = _;
            });
          },
          itemBuilder: (context, index) {
            late String label;
            final Category category = model.selectedCategories.elementAt(index);
            label = category.name.toUpperCase();
            if (!category.lastParent) label += "   /";

            final bool isLastItem =
                model.selectedCategories.length == (index + 1);

            final bool hasPrevItem = (index - 1) >= 0;

            final bool _selected = _currentTitle == index;

            return Center(
              child: FadeIn(
                duration: context.lowDuration,
                delay: context.muchLowerDuration,
                child: GestureDetector(
                  onTap: () {
                    if (!isLastItem) {
                      prevPage().then((value) {
                        model.selectCategory(category);
                      });
                    }
                  },
                  child: AnimatedOpacity(
                    duration: context.lowDuration,
                    curve: Curves.ease,
                    opacity: index > _currentPage ? 0 : 1,
                    child: Blur(
                      blur: _selected ? 0 : 1,
                      blurColor: Colors.grey.shade100,
                      child: Text(
                        label,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: _selected ? 22 : 20,
                          color:
                              _selected ? Colors.black : Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Align _buildAppBar() {
    return Align(
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            color: Colors.transparent,
            width: 100,
            height: 100,
            child: Icon(
              CupertinoIcons.search,
              color: Colors.black,
            ),
          ),
          Container(
              color: Colors.transparent,
              width: 100,
              height: 100,
              margin: EdgeInsets.only(right: 70),
              child: Center(
                child: Text(
                  "Cart",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Column _buildContent(AppViewModel model) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: model.selectedCategories.length,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              final Category category =
                  model.selectedCategories.elementAt(index);
              return FadeIn(
                duration: context.lowDuration,
                delay: context.muchLowerDuration,
                child: ScrollConfiguration(
                  behavior: MyScrollBehavior(),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: context.height / 3),
                        ...category.subCategories.map(
                          (e) => GestureDetector(
                            onTap: () {
                              model.selectCategory(e).then((value) {
                                if (value)
                                  nextPage();
                                else if (!value && widget.closeDrawer != null)
                                  widget.closeDrawer!();
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Text(
                                e.name.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600.withOpacity(0.55),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: context.height / 5),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomArea(BuildContext context, AppViewModel model) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "HELP",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: 25,
                  child: Text(
                    "NIKE +",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                )
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "EN",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(height: 75),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

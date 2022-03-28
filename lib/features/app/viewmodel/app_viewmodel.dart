import 'package:flutter/widgets.dart';
import 'package:ui_challenge_menu/core/base/base_viewmodel.dart';
import 'package:ui_challenge_menu/core/enum/view_state.dart';
import 'package:ui_challenge_menu/features/home/view/home_view.dart';
import 'package:ui_challenge_menu/models/category.dart';

class AppViewModel extends BaseViewModel {
  List<Widget> views = [];

  List<Category> categories = [];

  List<Category> selectedCategories = []; // Üstte horizontal olarak listelenen categoriler


  init() async {
    setState(ViewState.Busy);
    _configureViews();
    categories = await Category.mockListCategory;
    selectedCategories.add(Category(id: 0, name: "Menu", subCategories: categories, lastParent: false));
    setState(ViewState.Idle);
  }

  _configureViews() {
    views.add(HomeView());
  }

  Future<bool> selectCategory(Category category) async {
    late bool res;
    if(selectedCategories.contains(category)) {
      final index = selectedCategories.indexWhere((element) => element.id == category.id);
      if(selectedCategories.length>(index+1)) selectedCategories.removeAt(index+1);
      res = true;
    } 
    else {
      if(category.subCategories.isNotEmpty){
        selectedCategories.add(category);
        res = true;
      } else res = false;
    }
    await Future.delayed(Duration(milliseconds: 5));
    saveChanges();
    return res;
  }
}
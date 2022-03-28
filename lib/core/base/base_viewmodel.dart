
import 'package:flutter/material.dart';

import '../enum/view_state.dart';

enum NotificationType {
  ERROR,
  SUCCESS,
}

abstract class BaseViewModel with ChangeNotifier {
  BuildContext? context;

  ViewState _state = ViewState.Idle;
  ViewState get state => _state;

  bool disposed = false;

  setContext(BuildContext context) => this.context = context;

  setState(ViewState state) {
    _state = state;
    saveChanges();
  }
  
  saveChanges(){
    if (!disposed) notifyListeners();
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}

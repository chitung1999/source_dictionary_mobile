import 'package:english_app/presentation/state/app_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppViewModel extends Notifier<AppState> {
  @override
  AppState build() {
    return const AppState();
  }

  Future<bool> initialize() async {
    state = state.copyWith(
        indexTab: 0
    );

    return true;
  }

  void setIndexTab(int indexTab) => state = state.copyWith(indexTab: indexTab);
}

final appViewModel = NotifierProvider<AppViewModel, AppState>(AppViewModel.new);
class AppState {
  final int indexTab;

  const AppState({
    this.indexTab = 0,
  });

  AppState copyWith({
    int? indexTab,
  }) {
    return AppState(
      indexTab: indexTab ?? this.indexTab,
    );
  }
}
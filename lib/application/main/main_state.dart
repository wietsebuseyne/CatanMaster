part of 'main_bloc.dart';

@immutable
class MainState {

  final HomePageTab page;

  MainState(this.page);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MainState && runtimeType == other.runtimeType && page == other.page;

  @override
  int get hashCode => page.hashCode;
}

enum HomePageTab {
  games, players
}
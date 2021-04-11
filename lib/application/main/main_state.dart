part of 'main_bloc.dart';

@immutable
class MainState extends Equatable {

  final HomePageTab page;

  MainState({
    required this.page,
  });

  MainState copyWith({HomePageTab? page}) {
    return MainState(
        page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [page];
}

enum HomePageTab {
  games, players
}
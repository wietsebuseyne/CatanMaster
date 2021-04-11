import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:catan_master/domain/games/game_repository.dart';
import 'package:catan_master/domain/players/player_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {

  MainBloc() : super(MainState(page: HomePageTab.games));

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is SwitchTabEvent) {
      yield state.copyWith(page: event.tab);
    }
  }
}

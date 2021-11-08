import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(const MainState(page: HomePageTab.games));

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is SwitchTabEvent) {
      yield state.copyWith(page: event.tab);
    }
  }
}

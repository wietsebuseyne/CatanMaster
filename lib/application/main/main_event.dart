part of 'main_bloc.dart';

@immutable
abstract class MainEvent {}

class SwitchPageEvent extends MainEvent {

  final HomePageTab page;

  SwitchPageEvent(this.page);

}
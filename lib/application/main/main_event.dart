part of 'main_bloc.dart';

@immutable
abstract class MainEvent {}

class SwitchTabEvent extends MainEvent {

  final HomePageTab tab;

  SwitchTabEvent(this.tab);

}
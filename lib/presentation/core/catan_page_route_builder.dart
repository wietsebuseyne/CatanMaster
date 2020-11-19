import 'package:catan_master/presentation/core/catan_master_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//TODO Fix without Hero animation
//Try to get the FAB by a global key and rotate in transitionsBuilder
class CatanPageRouteBuilder extends PageRouteBuilder {

  CatanPageRouteBuilder({Widget page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return Stack(children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 28.0),
                    child: CatanFloatingActionButton(onPressed: () {},)
                ),
              ),
              page,
            ],);
          },
          transitionDuration: Duration(milliseconds: 500),
          reverseTransitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return SlideTransition(
              position: new Tween<Offset>(
                begin: const Offset(0.0, -1.0),
                end: Offset.zero,
              ).animate(animation),
              child: Container(
                child: child,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ]),
              ),
            );
              /*
            return Stack(
                children: <Widget>[
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 28.0),
                      child: RotationTransition(
                          turns: Tween<double>(begin: 0.0, end: 2.0)
                              .animate(CurvedAnimation(parent: animation, curve: Curves.easeInOutSine)),
                          child: CatanFloatingActionButton(onPressed: () {},)),
                    ),
                    alignment: Alignment.bottomCenter,
                  ),
                  SlideTransition(
                    position: new Tween<Offset>(
                      begin: const Offset(0.0, -1.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: Container(
                      child: AddEditGameScreen.add(),
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                    ),
                  ),
                ],
              );*/
          }
        );
}


/*
Version 1 (double FAB)
import 'package:catan_master/presentation/core/catan_master_app.dart';
import 'package:catan_master/presentation/games/screens/add_edit_game_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CatanPageRouteBuilder extends PageRouteBuilder {

  CatanPageRouteBuilder()
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return AddEditGameScreen.add();
          },
          transitionDuration: Duration(milliseconds: 1500),
          reverseTransitionDuration: Duration(milliseconds: 1500),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              Stack(
                children: <Widget>[
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 28.0),
                      child: RotationTransition(
                          turns: Tween<double>(begin: 0.0, end: 2.0)
                              .animate(CurvedAnimation(parent: animation, curve: Curves.easeInOutSine)),
                          child: CatanFloatingActionButton(onPressed: () {},)),
                    ),
                    alignment: Alignment.bottomCenter,
                  ),
                  SlideTransition(
                    position: new Tween<Offset>(
                      begin: const Offset(0.0, -1.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: Container(
                      child: child,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                    ),
                  ),
                ],
              )
        );
}

 */
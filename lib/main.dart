import 'package:catan_master/data/games/game_dtos.dart';
import 'package:catan_master/data/players/player_dtos.dart';
import 'package:catan_master/presentation/core/catan_master_app.dart';
import 'package:catan_master/presentation/core/catan_master_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PlayerDtoAdapter());
  Hive.registerAdapter(GameDtoAdapter());
  runApp(CatanMasterRepositoryProvider(child: CatanMasterApp()));
}

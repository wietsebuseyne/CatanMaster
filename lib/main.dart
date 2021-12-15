import 'package:catan_master/feature/game/data/dto/game_dtos.dart';
import 'package:catan_master/feature/home/presentation/catan_master_app.dart';
import 'package:catan_master/feature/home/presentation/provider/catan_master_providers.dart';
import 'package:catan_master/feature/player/data/dto/player_dtos.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(PlayerDtoAdapter());
  Hive.registerAdapter(GameDtoAdapter());
  runApp(CatanMasterProviders(child: CatanMasterApp()));
}

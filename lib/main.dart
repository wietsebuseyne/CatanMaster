import 'package:catan_master/catan_master_mappers.dart';
import 'package:catan_master/core/mapping.dart';
import 'package:catan_master/feature/game/data/dto/game_dtos.dart';
import 'package:catan_master/feature/home/presentation/catan_master_app.dart';
import 'package:catan_master/feature/home/presentation/provider/catan_master_providers.dart';
import 'package:catan_master/feature/player/data/dto/player_dtos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(PlayerDtoAdapter());
  Hive.registerAdapter(GameDtoAdapter());
  MapperRegistry.instance.setOnMapFailure((mapFailure) {
    //TODO log and keeps the logs
    if (kDebugMode) {
      print(mapFailure);
    }
  });

  runApp(const CatanMasterProviders(child: CatanMasterMapperRegistrar(child: CatanMasterApp())));
}

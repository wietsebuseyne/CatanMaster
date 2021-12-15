import 'package:catan_master/feature/game/data/dto/game_dtos.dart';
import 'package:catan_master/feature/player/data/dto/player_dtos.dart';
import 'package:catan_master/feature/home/presentation/catan_master_app.dart';
import 'package:catan_master/feature/home/presentation/provider/catan_master_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(PlayerDtoAdapter());
  Hive.registerAdapter(GameDtoAdapter());
  runApp(CatanMasterLocalRepositoryProvider(child: CatanMasterApp()));
}

/*_initFirebase() {
  FirebaseDatabase database;
  try {
    final newApp = await Firebase.initializeApp(
      name: 'fdb',
      options:
      FirebaseOptions(
        appId: '1:445084760019:android:bca210c7021debecd8a126',
        apiKey: 'AIzaSyD378PdTM4Kxtyy7i-2fuuRIeHH_2dgw6Y',
        messagingSenderId: '445084760019',
        projectId: 'catan-master',
        databaseURL: 'https://catan-master.firebaseio.com',
      ),
    );
    database = FirebaseDatabase(app: newApp);
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
  } on Exception {
    database = FirebaseDatabase.instance;
  }
}*/

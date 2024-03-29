import 'package:catan_master/core/color.dart';
import 'package:catan_master/feature/game/presentation/pages/games_page.dart';
import 'package:catan_master/feature/home/presentation/route/catan_route_generator.dart';
import 'package:catan_master/feature/home/presentation/screen/catan_master_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CatanMasterApp extends StatelessWidget {
  const CatanMasterApp();

  @override
  Widget build(BuildContext context) {
    return GamesPage(
      childBuilder: (context, gamesState) {
        //TODO keep list of possible colors and which are too light for primaryswatch
        Color c = gamesState.games.getCatanMaster()?.color ?? Colors.blue;
        MaterialColor? mc = colorToMaterialColor(c);
        var light = isLight(c);
        var overlayStyle = light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light;
        return MaterialApp(
          title: 'Catan Master',
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: c,
            primarySwatch: mc,
            appBarTheme: AppBarTheme(
              color: c,
              systemOverlayStyle: overlayStyle,
              foregroundColor: light ? Colors.black : Colors.white,
            ),
            dividerTheme: const DividerThemeData(indent: 32.0, endIndent: 32.0, thickness: 1.0),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: light ? mc?.shade900 ?? Colors.black : c,
              type: BottomNavigationBarType.fixed,
            ),
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: mc ?? Colors.blue,
              accentColor: c,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: c,
            primarySwatch: mc,
            appBarTheme: AppBarTheme(
              color: c,
              systemOverlayStyle: overlayStyle,
              foregroundColor: light ? Colors.black : Colors.white,
            ),
            dividerTheme: const DividerThemeData(indent: 32.0, endIndent: 32.0, thickness: 1.0),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: light ? c : mc?.shade200 ?? Colors.white,
              type: BottomNavigationBarType.fixed,
            ),
            colorScheme: ColorScheme.fromSwatch(
              brightness: Brightness.dark,
              primarySwatch: mc ?? Colors.blue,
              accentColor: c,
            ),
          ),
          home: const CatanMasterHomeScreen(),
          initialRoute: '/',
          onGenerateRoute: CatanRouteGenerator.generateRoute,
        );
      },
    );
  }
}

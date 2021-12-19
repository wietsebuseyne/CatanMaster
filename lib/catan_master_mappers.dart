import 'package:catan_master/core/mapping.dart';
import 'package:catan_master/feature/game/data/dto/game_mapper.dart';
import 'package:catan_master/feature/player/data/dto/player_mappers.dart';
import 'package:catan_master/feature/player/domain/player_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CatanMasterMapperRegistryEntry with MapperRegistryEntry {
  final PlayerRepository playerRepository;

  CatanMasterMapperRegistryEntry({required this.playerRepository});

  @override
  Iterable<MapperRegistryEntry> get entries => [];

  @override
  Iterable<Mapper<Object, Object>> get mappers => [
        GameMapper(playerRepository: playerRepository),
        const PlayerMapper(),
      ];
}

class CatanMasterMapperRegistrar extends StatelessWidget {
  final Widget child;

  const CatanMasterMapperRegistrar({required this.child});

  @override
  Widget build(BuildContext context) {
    return MapperRegistrar(entry: CatanMasterMapperRegistryEntry(playerRepository: context.read()), child: child);
  }
}

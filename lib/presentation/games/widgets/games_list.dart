import 'package:catan_master/application/games/games_bloc.dart';
import 'package:catan_master/domain/games/game.dart';
import 'package:catan_master/presentation/core/catan_expansion_ui.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
import 'package:catan_master/presentation/core/widgets/empty_list_message.dart';
import 'package:catan_master/presentation/games/widgets/game_actions.dart';
import 'package:catan_master/presentation/games/widgets/game_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//TODO save expansion filters in Bloc and keep them between both main pages
class GamesList extends StatefulWidget {

  final Games games;

  GamesList(this.games);

  @override
  _GamesListState createState() => _GamesListState();
}

class _GamesListState extends State<GamesList> {

  final Set<CatanExpansion?> selectedExpansions = {};

  @override
  Widget build(BuildContext context) {
    var filteredGames = widget.games.filterExpansion(selectedExpansions);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ExpansionFiltersHeader(
          onSelectionChanged: (expansion, selected) {
            setState(() {
              if (selected) selectedExpansions.add(expansion); else selectedExpansions.remove(expansion);
            });
          },
          selection: selectedExpansions,
        ),
        if (filteredGames.isEmpty)
          Expanded(
            child: EmptyListMessage(
              title: Text("No games"),
              subtitle: Text(
                  selectedExpansions.isEmpty
                      ? "Add your first game by pressing the \u2795 button below"
                      : "No games with current expansion filters."
              ),
              action: selectedExpansions.isEmpty
                  ? null
                  : OutlinedButton.icon(
                      icon: Icon(Icons.clear),
                      style: OutlinedButton.styleFrom(primary: Theme.of(context).colorScheme.onSurface),
                      onPressed: () {
                        setState(() {
                          selectedExpansions.clear();
                        });
                      },
                      label: Text("Clear expansion filters"),
                    ),
            ),
          )
        else
          Expanded(
            child:
            ListView.builder(
              itemBuilder: (BuildContext context, int index) => GameListTile(
                filteredGames[index],
                onTap: () => Navigator.of(context).pushNamed("/games/detail", arguments: {"game": filteredGames[index]}),
              ),
              itemCount: filteredGames.length,
              padding: const EdgeInsets.only(bottom: 48.0),
            ),
          )
      ],
    );
  }
}

class ExpansionFiltersHeader extends StatelessWidget {

  final Function(CatanExpansion?, bool) onSelectionChanged;
  final Set<CatanExpansion?> selection;

  ExpansionFiltersHeader({
    required this.onSelectionChanged,
    required Iterable<CatanExpansion?> selection,
  }) : this.selection = selection.toSet();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 8.0,),
        _filter(null),
        SizedBox(width: 8.0,),
        _filter(CatanExpansion.cities_and_knights),
        SizedBox(width: 8.0,),
        _filter(CatanExpansion.seafarers),
        SizedBox(width: 8.0,),
        _filter(CatanExpansion.traders_and_barbarians),
        SizedBox(width: 8.0,),
        _filter(CatanExpansion.explorers_and_pirates),
        SizedBox(width: 8.0,),
        _filter(CatanExpansion.legend_of_the_conquerers),
        SizedBox(width: 8.0,),
      ],
    );
  }

  Widget _filter(CatanExpansion? e) {
    return ExpansionFilter(
      expansion: e,
      selected: selection.contains(e),
      onSelected: (selected) {
        onSelectionChanged.call(e, selected);
      },
    );
  }

}

class ExpansionFilter extends StatelessWidget {

  final CatanExpansion? expansion;
  final bool selected;
  final ValueChanged<bool> onSelected;

  ExpansionFilter({required this.expansion, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(expansion.icon, size: 12, color: selected ? Colors.white : Colors.black ,),
      labelPadding: const EdgeInsets.only(),
      label: SizedBox(),
      shape: PolygonBorder(
        sides: 6,
        rotate: 30,
      ),
      visualDensity: VisualDensity.compact,
      onPressed: () => onSelected.call(!selected),
      backgroundColor: selected ? Colors.black : null,
      tooltip: expansion.name,
      padding: const EdgeInsets.all(8.0),
      elevation: selected ? 8.0 : 0.0,
    );
  }

}

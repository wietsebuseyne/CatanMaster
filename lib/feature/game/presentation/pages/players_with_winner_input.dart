import 'package:catan_master/core/catan_icons.dart';
import 'package:catan_master/feature/player/domain/player.dart';
import 'package:catan_master/feature/player/presentation/player_presentation.dart';
import 'package:flutter/material.dart';

class PlayersWithWinnerInput extends StatelessWidget {
  final List<Player> players;
  final Player? winner;
  final Set<Player> selected;
  final ValueChanged<Set<Player>> onSelectionChanged;
  final ValueChanged<Player?> onWinnerChanged;

  const PlayersWithWinnerInput({
    required this.players,
    required this.selected,
    required this.winner,
    required this.onSelectionChanged,
    required this.onWinnerChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: players
          .map((p) => InkWell(
                onTap: () => _onPlayerSelected(p, !selected.contains(p)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: selected.contains(p),
                          onChanged: (s) => _onPlayerSelected(p, s!),
                          activeColor: p.color,
                          checkColor: p.onColor,
                        ),
                        Text(p.name),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(CatanIcons.trophy),
                      color: winner == p ? const Color.fromARGB(255, 218, 165, 32) : Theme.of(context).disabledColor,
                      onPressed: () {
                        if (!selected.contains(p)) {
                          _onPlayerSelected(p, true);
                        }
                        onWinnerChanged(p);
                      },
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  void _onPlayerSelected(Player p, bool s) {
    var newSelected = Set.of(selected);
    if (s) {
      newSelected.add(p);
    } else {
      newSelected.remove(p);
      if (winner == p) {
        onWinnerChanged(null);
      }
    }
    onSelectionChanged(newSelected);
  }
}

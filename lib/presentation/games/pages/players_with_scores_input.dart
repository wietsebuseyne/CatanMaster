import 'package:catan_master/domain/players/player.dart';
import 'package:flutter/material.dart';

class PlayersWithScoresInput extends StatelessWidget {

  final Map<Player, int> scores;
  final List<Player> players;
  final ValueChanged<Map<Player, int>> onChanged;

  PlayersWithScoresInput({
    required this.scores,
    required this.players,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: players.map((p) => CheckboxListTile(
          activeColor: p.color,
          value: scores[p] != null,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: const EdgeInsets.only(),
          dense: true,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(p.name)),
                Row(
                  children: [
                    if (scores[p] != null) SizedBox(width: 16.0,),
                    if (scores[p] != null) Chip(label: Text(scores[p].toString()),),
                    Slider(
                        label: scores[p]?.toString(),
                        activeColor: p.color,
                        min: 0,
                        max: 20,
                        divisions: 20,
                        value: (scores[p] ?? 0).toDouble(),
                        onChanged: (v) {
                          Map<Player, int> newScores = Map.from(scores);
                          int score = v.toInt();
                          if (score == 0) {
                            newScores.remove(p);
                          } else {
                            newScores[p] = score;
                          }
                          onChanged(newScores);
                        }),
                  ],
                ),
              ]
          ),
          onChanged: (selected) {
            Map<Player, int> newScores = Map.from(scores);
            if (selected!) {
              newScores[p] = 5;
            } else {
              newScores.remove(p);
            }
            onChanged(newScores);
          }
      )).toList(),
    );
  }
}

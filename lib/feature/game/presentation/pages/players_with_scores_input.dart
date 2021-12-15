import 'package:catan_master/core/color.dart';
import 'package:catan_master/feature/player/domain/player.dart';
import 'package:flutter/material.dart';

class PlayersWithScoresInput extends StatelessWidget {
  final Map<Player, int> scores;
  final List<Player> players;
  final ValueChanged<Map<Player, int>> onChanged;

  const PlayersWithScoresInput({
    required this.scores,
    required this.players,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: players.map((p) {
        var color = p.color;
        var light = isLight(color);
        return CheckboxListTile(
            activeColor: color,
            checkColor: light ? Colors.black : Colors.white,
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
                    if (scores[p] != null)
                      const SizedBox(
                        width: 16.0,
                      ),
                    if (scores[p] != null)
                      Chip(
                        label: Text(scores[p].toString()),
                      ),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: color,
                        inactiveTickMarkColor: color == Colors.white ? Colors.grey : color,
                        activeTickMarkColor: color.withOpacity(0.1),
                        inactiveTrackColor: color.withOpacity(0.1),
                        thumbColor: color,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: Slider(
                          label: scores[p]?.toString(),
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
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            onChanged: (selected) {
              Map<Player, int> newScores = Map.from(scores);
              if (selected!) {
                newScores[p] = 5;
              } else {
                newScores.remove(p);
              }
              onChanged(newScores);
            });
      }).toList(),
    );
  }
}

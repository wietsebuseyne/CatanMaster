import 'package:catan_master/feature/game/domain/game.dart';
import 'package:catan_master/feature/game/presentation/catan_expansion_ui.dart';
import 'package:flutter/material.dart';

class ExpansionPicker extends StatelessWidget {
  final ValueChanged<ExpansionSelection> onChanged;
  final ExpansionSelection selection;

  const ExpansionPicker({Key? key, required this.selection, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: CatanExpansion.values.expand((expansion) {
        final selected = selection.expansions.contains(expansion);
        return [
          _Selector.expansion(
            expansion: expansion,
            selected: selected,
            onChanged: (selected) => _expansionChanged(expansion),
          ),
          if (selected)
            ...expansion.scenarios.map((s) {
              return _Selector.scenario(
                expansion: expansion,
                scenario: s,
                selected: selection.scenarios.contains(s),
                onChanged: (selected) => _scenarioChanged(s),
              );
            }),
        ];
      }).toList(),
    );
  }

  void _expansionChanged(CatanExpansion expansion) {
    if (!selection.expansions.contains(expansion)) {
      onChanged.call(selection.copyWith(expansion: expansion));
    } else {
      onChanged.call(selection.copyWithout(expansion: expansion));
    }
  }

  void _scenarioChanged(CatanScenario scenario) {
    if (!selection.scenarios.contains(scenario)) {
      onChanged.call(selection.copyWith(scenario: scenario));
    } else {
      onChanged.call(selection.copyWithout(scenario: scenario));
    }
  }
}

class ExpansionSelection {
  final Set<CatanExpansion> expansions;
  final Set<CatanScenario> scenarios;

  ExpansionSelection({
    Iterable<CatanExpansion> expansions = const [],
    Iterable<CatanScenario> scenarios = const [],
  })  : this.expansions = Set.unmodifiable(expansions),
        this.scenarios = Set.unmodifiable(scenarios);

  ExpansionSelection copyWith({CatanExpansion? expansion, CatanScenario? scenario}) {
    final newExpansions = expansion == null ? List.of(expansions) : (List.of(expansions)..add(expansion));
    if (scenario != null) {
      newExpansions.addAll(scenario.expansions);
    }
    return ExpansionSelection(
      expansions: newExpansions,
      scenarios: scenario == null ? List.of(scenarios) : (List.of(scenarios)..add(scenario)),
    );
  }

  ExpansionSelection copyWithout({CatanExpansion? expansion, CatanScenario? scenario}) {
    final newScenarios = scenario == null ? List.of(scenarios) : (List.of(scenarios)..remove(scenario));
    if (expansion != null) {
      newScenarios.removeWhere((scenario) => expansion.scenarios.contains(scenario));
    }
    return ExpansionSelection(
      expansions: expansion == null ? List.of(expansions) : (List.of(expansions)..remove(expansion)),
      scenarios: newScenarios,
    );
  }
}

class _Selector extends StatelessWidget {
  final ValueChanged<bool> onChanged;
  final bool selected;
  final Color color;
  final IconData? icon;
  final String label;
  final double leadingInset;

  const _Selector({
    Key? key,
    required this.selected,
    required this.onChanged,
    required this.color,
    required this.icon,
    required this.label,
    this.leadingInset = 0.0,
  }) : super(key: key);

  factory _Selector.expansion({
    required bool selected,
    required ValueChanged<bool> onChanged,
    required CatanExpansion expansion,
  }) {
    return _Selector(
      key: ValueKey(expansion.toString()),
      onChanged: onChanged,
      selected: selected,
      color: expansion.color,
      label: expansion.name!,
      icon: expansion.icon,
    );
  }

  factory _Selector.scenario({
    required bool selected,
    required ValueChanged<bool> onChanged,
    required CatanExpansion expansion,
    required CatanScenario scenario,
  }) {
    return _Selector(
      key: ValueKey('$expansion.$scenario'),
      onChanged: onChanged,
      selected: selected,
      color: expansion.color,
      label: scenario.name,
      icon: null,
      leadingInset: 12.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!selected),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (leadingInset != 0) SizedBox(width: leadingInset),
          Checkbox(
            value: selected,
            activeColor: color,
            onChanged: (selected) => onChanged(selected!),
          ),
          if (icon != null) Icon(icon),
          const SizedBox(width: 8.0),
          Text(label),
        ],
      ),
    );
  }
}

import 'package:catan_master/feature/stats/presentation/widgets/stats_body.dart';
import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: const StatsBody(),
    );
  }
}

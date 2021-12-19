import 'package:catan_master/core/mapping.dart';
import 'package:flutter/cupertino.dart';

class MapperRegistrar extends StatefulWidget {
  final Widget child;
  final MapperRegistryEntry entry;

  const MapperRegistrar({required this.entry, required this.child});

  @override
  State<MapperRegistrar> createState() => _MapperRegistrarState();
}

class _MapperRegistrarState extends State<MapperRegistrar> {
  @override
  void initState() {
    MapperRegistry.instance.register(widget.entry);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

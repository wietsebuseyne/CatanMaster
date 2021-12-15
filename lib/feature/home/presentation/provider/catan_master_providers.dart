import 'package:catan_master/feature/home/presentation/provider/catan_master_bloc_provider.dart';
import 'package:catan_master/feature/home/presentation/provider/catan_master_repository_provider.dart';
import 'package:flutter/widgets.dart';

class CatanMasterProviders extends StatelessWidget {
  final Widget child;

  const CatanMasterProviders({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CatanMasterLocalRepositoryProvider(
      child: CatanMasterBlocProvider(child: child),
    );
  }
}

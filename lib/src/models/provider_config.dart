import 'package:better_bus_core/core.dart';
import 'package:better_bus_core/src/models/data_paths.dart';

abstract class ProviderConfig {
  BusNetwork getProvider();
}

abstract class GTFSProviderConfig extends ProviderConfig {
  GTFSProviderConfig({required this.paths});
  DataPaths paths;
}

import 'package:better_bus_core/core.dart';

class BrokenApi extends ApiProvider {
  BrokenApi() : super(apiUrl: Uri.base, tokenUrl: Uri.base);

  @override
  bool isAvailable() {
    return false;
  }

}
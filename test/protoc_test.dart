import 'package:better_bus_core/src/gtfsrt_provider.dart';
import 'package:test/test.dart';
const url = "https://proxy.transport.data.gouv.fr/resource/mobius-angouleme";

void main() async {
    final provider = GTFSRTProvider(Uri.parse(url));

    await provider.test();

}

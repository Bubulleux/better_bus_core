import 'package:better_bus_core/src/gtfsrt_provider.dart';
import 'package:better_bus_core/src/models/gtfs/gtfs_path.dart';
import 'package:better_bus_core/src/networks/mobius_downloader.dart';
import 'package:test/test.dart';
const url = "https://proxy.transport.data.gouv.fr/resource/mobius-angouleme";

void main() async {
    final path = GTFSPaths("/tmp/gtfs.zip", "/tmp/gtfs/");
    final provider = GTFSRTProvider(downloader: MobiusDownloader(paths: path));

    await provider.test();

}

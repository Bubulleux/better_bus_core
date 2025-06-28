import './protoc/gtfs-realtime.pb.dart';
import './protoc/gtfs-realtime.pbenum.dart';

class GTFSRTProvider {
    final Uri endPoint;

    GTFSRTProvider(this.endPoint) {
        FeedMessages.fromBuffer();
    }
    
    
}

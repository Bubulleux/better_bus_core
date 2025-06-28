import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:intl/message_format.dart';

import './protoc/gtfs-realtime.pb.dart';
import './protoc/gtfs-realtime.pbenum.dart';

class GTFSRTProvider {
    final Uri endPoint;

    GTFSRTProvider(this.endPoint) {
        _fetchData();
    }

    Future test() async {
        await _fetchData();
        await _loadFile();
    }

    Future _fetchData() async {
        final  client = http.Client();
        final request = http.Request("GET" ,endPoint);
        final response = await client.send(request);

        final List<int> data = [];

        await for (var buf in response.stream) {
            data.addAll(buf);
        }

        print(data.length);
    }

    Future _loadFile() async {
        final file = File("/home/ulysse/Projects/better_bus_workspace/core/lib/src/protoc/mobius-angouleme");

        final data = await file.readAsBytes();
        print(data.length);

        final message = FeedMessage.fromBuffer(data);
        print(message.entity.first);

    }
}

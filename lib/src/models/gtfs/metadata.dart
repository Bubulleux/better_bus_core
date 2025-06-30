class DatasetMetadata {
    Uri downloadUri;
    DateTime updateTime;
    Uri? gtfsrtEndpoint;

    DatasetMetadata(this.downloadUri, this.updateTime, [this.gtfsrtEndpoint]);
}

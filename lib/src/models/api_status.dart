class ApiStatus {
  final bool available;
  final String? message;
  final String? version;

  ApiStatus(this.available, {this.message, this.version});

  ApiStatus.fromJson(Map<String, dynamic> json) : this(
    json["available"]!,
    message: json["message"],
    version: json["version"],
  );

  Map<String, dynamic> toJson() {
    return  {
      "available": available,
      "message": message,
      "version": version,
    };
  }
}
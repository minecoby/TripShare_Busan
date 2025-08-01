class RouteModel {
  final int id;
  final int postId;
  final List<Location> locations;

  RouteModel({required this.id, required this.postId, required this.locations});

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'],
      postId: json['postId'],
      locations:
          (json['locations'] as List)
              .map((loc) => Location.fromJson(loc))
              .toList(),
    );
  }
}

class Location {
  final int id;
  final String locationName;
  final String address;
  final String? imageUrl;
  final int orderIndex;

  Location({
    required this.id,
    required this.locationName,
    required this.address,
    this.imageUrl,
    required this.orderIndex,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      locationName: json['locationName'],
      address: json['address'],
      imageUrl: json['imageUrl'] as String?,
      orderIndex: json['orderIndex'],
    );
  }
}

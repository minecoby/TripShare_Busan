class LocationDto {
  final String locationName;
  final String address;
  final String imageUrl;
  final int orderIndex;

  LocationDto({
    required this.locationName,
    required this.address,
    required this.imageUrl,
    required this.orderIndex,
  });

  Map<String, dynamic> toJson() => {
    'locationName': locationName,
    'address': address,
    'imageUrl': imageUrl,
    'orderIndex': orderIndex,
  };
}

class PostCreateRequest {
  final String title;
  final String content;
  final int userId;
  final String regionName;
  final List<LocationDto> locations;

  PostCreateRequest({
    required this.title,
    required this.content,
    required this.userId,
    required this.regionName,
    required this.locations,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'userId': userId,
    'regionName': regionName,
    'locations': locations.map((e) => e.toJson()).toList(),
  };
}

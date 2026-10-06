class CoordinatesModel {
  final double lat;
  final double lng;

  const CoordinatesModel({required this.lat, required this.lng});

  factory CoordinatesModel.fromJson(Map<String, dynamic> json) {
    return CoordinatesModel(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};
}

class DestinationModel {
  final String id;
  final String name;
  final String location;
  final String category;
  final double price;
  final String currency;
  final String priceUnit;
  final int durationDays;
  final int maxGuests;
  final double rating;
  final int reviewCount;
  final List<String> images;
  final List<String> included;
  final String about;
  final bool isPopular;
  final CoordinatesModel? coordinates;
  final String? mapImage;
  final bool isActive;

  const DestinationModel({
    required this.id,
    required this.name,
    required this.location,
    required this.category,
    required this.price,
    required this.currency,
    required this.priceUnit,
    required this.durationDays,
    required this.maxGuests,
    required this.rating,
    required this.reviewCount,
    required this.images,
    required this.included,
    required this.about,
    required this.isPopular,
    this.coordinates,
    this.mapImage,
    required this.isActive,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      priceUnit: json['priceUnit'] as String? ?? 'per_person',
      durationDays: (json['durationDays'] as num?)?.toInt() ?? 1,
      maxGuests: (json['maxGuests'] as num?)?.toInt() ?? 1,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      included: (json['included'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      about: json['about'] as String? ?? '',
      isPopular: json['isPopular'] as bool? ?? false,
      coordinates: json['coordinates'] != null
          ? CoordinatesModel.fromJson(json['coordinates'] as Map<String, dynamic>)
          : null,
      mapImage: json['mapImage'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'location': location,
        'category': category,
        'price': price,
        'currency': currency,
        'priceUnit': priceUnit,
        'durationDays': durationDays,
        'maxGuests': maxGuests,
        'rating': rating,
        'reviewCount': reviewCount,
        'images': images,
        'included': included,
        'about': about,
        'isPopular': isPopular,
        'coordinates': coordinates?.toJson(),
        'mapImage': mapImage,
        'isActive': isActive,
      };
}

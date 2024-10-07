class Pokemon {
  final int id;
  final String name;
  final List<String> types;
  final String image;
  final bool captured;
  final DateTime? captureDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Pokemon({
    required this.id,
    required this.name,
    required this.types,
    required this.image,
    required this.captured,
    this.captureDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      types: List<String>.from(json['types']),
      image: json['image'],
      captured: json['captured'],
      captureDate: json['captureDate'] != null
          ? DateTime.parse(json['captureDate'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'types': types,
      'image': image,
      'captured': captured,
      'captureDate': captureDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

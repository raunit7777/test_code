class CreatePartnerModel {
  final String name;
  final String relationship;
  final int age;
  final String gender;
  final String? imagePath; // Cloudinary or local image URL/path
  final double shyNaughty;
  final double caringPlayful;
  final double matureChildish;
  final List<String> traits;
  final List<String> interests;
  final String speakingStyle;

  CreatePartnerModel({
    this.name = '',
    this.relationship = 'girlfriend',
    this.age = 22,
    this.gender = 'female',
    this.imagePath,
    this.shyNaughty = 0.5,
    this.caringPlayful = 0.5,
    this.matureChildish = 0.5,
    this.traits = const [],
    this.interests = const ['Music', 'Romance', 'Travel'],
    this.speakingStyle = 'Flirty & Sweet',
  });

  CreatePartnerModel copyWith({
    String? name,
    String? relationship,
    int? age,
    String? gender,
    String? imagePath,
    double? shyNaughty,
    double? caringPlayful,
    double? matureChildish,
    List<String>? traits,
    List<String>? interests,
    String? speakingStyle,
  }) {
    return CreatePartnerModel(
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      imagePath: imagePath ?? this.imagePath,
      shyNaughty: shyNaughty ?? this.shyNaughty,
      caringPlayful: caringPlayful ?? this.caringPlayful,
      matureChildish: matureChildish ?? this.matureChildish,
      traits: traits ?? this.traits,
      interests: interests ?? this.interests,
      speakingStyle: speakingStyle ?? this.speakingStyle,
    );
  }

  // 🟢 Convert Map from JSON/Backend response
  factory CreatePartnerModel.fromJson(Map<String, dynamic> json) {
    final personality = json['personality'] as Map<String, dynamic>? ?? {};

    return CreatePartnerModel(
      name: json['name'] ?? '',
      gender: json['gender'] ?? 'female',
      age: json['age'] ?? 22,
      relationship: json['relationshipType'] ?? json['relationship'] ?? 'girlfriend',
      imagePath: json['image'] ?? json['imagePath'],
      shyNaughty: ((personality['shyNaughty'] ?? 50) as num) / 100.0,
      caringPlayful: ((personality['caringPlayful'] ?? 50) as num) / 100.0,
      matureChildish: ((personality['matureChildish'] ?? 50) as num) / 100.0,
      traits: List<String>.from(personality['traits'] ?? []),
      interests: List<String>.from(personality['interests'] ?? ['Music', 'Romance', 'Travel']),
      speakingStyle: personality['speakingStyle'] ?? 'Flirty & Sweet',
    );
  }

  // 🟢 Convert Model to JSON for API Request Payload
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender,
      'age': age,
      'relationshipType': relationship.toLowerCase(),
      if (imagePath != null && imagePath!.isNotEmpty) 'image': imagePath,
      'personality': {
        'shyNaughty': (shyNaughty * 100).round(),
        'caringPlayful': (caringPlayful * 100).round(),
        'matureChildish': (matureChildish * 100).round(),
        'traits': traits,
        'interests': interests,
        'speakingStyle': speakingStyle,
      },
    };
  }
}
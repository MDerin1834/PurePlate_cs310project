class User {
  final String name;
  final String email;
  final int age;
  final String dietType;
  final int calorieTarget;
  final int proteinTarget;
  final String? profileImageUrl;
  final bool isGlutenFree;
  final bool isVegetarian;
  final bool isLactoseFree;
  final bool isLowCarb;

  const User({
    required this.name,
    required this.email,
    required this.age,
    required this.dietType,
    required this.calorieTarget,
    required this.proteinTarget,
    this.profileImageUrl,
    this.isGlutenFree = false,
    this.isVegetarian = false,
    this.isLactoseFree = false,
    this.isLowCarb = false,
  });

  User copyWith({
    String? name,
    String? email,
    int? age,
    String? dietType,
    int? calorieTarget,
    int? proteinTarget,
    String? profileImageUrl,
    bool? isGlutenFree,
    bool? isVegetarian,
    bool? isLactoseFree,
    bool? isLowCarb,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      dietType: dietType ?? this.dietType,
      calorieTarget: calorieTarget ?? this.calorieTarget,
      proteinTarget: proteinTarget ?? this.proteinTarget,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isLactoseFree: isLactoseFree ?? this.isLactoseFree,
      isLowCarb: isLowCarb ?? this.isLowCarb,
    );
  }
}
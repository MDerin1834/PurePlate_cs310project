class ScheduledRecipe {
  final String id;
  final String recipeId;
  final String isoTime;

  const ScheduledRecipe({required this.id, required this.recipeId, required this.isoTime});

  factory ScheduledRecipe.fromMap(Map<String, dynamic> data) {
    return ScheduledRecipe(
      id: data['id'] ?? "",
      recipeId: data['recipeId'] ?? "",
      isoTime: data['isoTime'] ?? ""
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recipeId': recipeId,
      'isoTime': isoTime
    };
  }
}
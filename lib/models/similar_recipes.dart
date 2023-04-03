class SimilarRecipe {
  final int id;
  final String imageType;
  final String title;
  final int readyInMinutes;
  final int servings;
  final String sourceUrl;

  SimilarRecipe({
    required this.id,
    required this.imageType,
    required this.title,
    required this.readyInMinutes,
    required this.servings,
    required this.sourceUrl,
  });

  factory SimilarRecipe.fromJson(Map<String, dynamic> json) {
    return SimilarRecipe(
      id: json['id'],
      imageType: json['imageType'],
      title: json['title'],
      readyInMinutes: json['readyInMinutes'],
      servings: json['servings'],
      sourceUrl: json['sourceUrl'],
    );
  }
}
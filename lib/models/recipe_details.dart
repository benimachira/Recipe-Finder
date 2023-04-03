class RecipeDetails {
  final int id;
  final String title;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> steps;

  RecipeDetails({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
  });

  factory RecipeDetails.fromJson(Map<String, dynamic> json) {
    final ingredients = (json['extendedIngredients'] as List)
        .map((ingredient) => ingredient['original'].toString())
        .toList();

    final steps = (json['analyzedInstructions'][0]['steps'] as List)
        .map((step) => step['step'].toString())
        .toList();

    return RecipeDetails(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image'],
      ingredients: ingredients,
      steps: steps,
    );
  }
}

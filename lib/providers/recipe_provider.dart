import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_finder/models/recipe.dart';

import '../models/recipe_details.dart';


//This file handles all api request to serve the app

class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];

  List<Recipe> get recipes => _recipes;

  //this is the api key for spoonacular
  final ApiKey ='4574b6dc101c45eeb5fb6aefdcebd5d9';

  RecipeProvider() {

  }

  Future<void> fetchRecipes(String query) async {
    final url = 'https://api.spoonacular.com/recipes/complexSearch?apiKey=$ApiKey&query=$query';

    print(url);
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body) as Map<String, dynamic>;

    if (data['results'] != null) {
      final List<Recipe> loadedRecipes = [];

      for (var recipeData in data['results']) {
        loadedRecipes.add(Recipe.fromJson(recipeData));
      }

      _recipes = loadedRecipes;

      print(_recipes);
      notifyListeners();
    }
  }

  Future<RecipeDetails> fetchRecipeDetails(int id) async {
    final url = 'https://api.spoonacular.com/recipes/$id/information?apiKey=$ApiKey';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body) as Map<String, dynamic>;

    print(data);

    return RecipeDetails.fromJson(data);
  }

  Future<void> fetchRandomRecipes() async {
    final response = await http.get(Uri.parse(
        'https://api.spoonacular.com/recipes/random?apiKey=$ApiKey&number=21'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body)['recipes'];
      _recipes = jsonResponse.map((recipe) => Recipe.fromJson(recipe)).toList();
      notifyListeners();
    } else {
      print(response.statusCode);
      throw Exception('Failed to load random recipes');
    }
  }

  Future<List<Recipe>> fetchRandomizedListRecipes() async {
    final response = await http.get(Uri.parse(
        'https://api.spoonacular.com/recipes/random?apiKey=$ApiKey&number=21'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body)['recipes'];
      return jsonResponse.map((recipe) => Recipe.fromJson(recipe)).toList();
      notifyListeners();
    } else {
      print(response.statusCode);
      throw Exception('Failed to load random recipes');
    }
  }

  Future<List<String>> getSuggestions(String query) async {
    final url = Uri.parse('https://api.spoonacular.com/food/ingredients/autocomplete?query=$query&number=10&apiKey=$ApiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final suggestions = List<String>.from(jsonDecode(response.body).map((suggestion) => suggestion['name']));
      return suggestions;
    } else {
      throw Exception('Failed to fetch suggestions');
    }
  }


}

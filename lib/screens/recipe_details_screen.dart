import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_finder/models/recipe.dart';
import 'package:recipe_finder/models/recipe_details.dart';
import 'package:recipe_finder/providers/recipe_provider.dart';
import 'package:recipe_finder/screens/recipe_list_holizontal.dart';
import 'package:recipe_finder/widgets/recipe_list.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final int recipeId;
  final int action_source;

  RecipeDetailsScreen({required this.recipeId, required this.action_source});

  @override
  _RecipeDetailsScreenState createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<RecipeDetails>(
        future: Provider.of<RecipeProvider>(context).fetchRecipeDetails(widget.recipeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred.'));
          } else {
            final recipeDetails = snapshot.data!;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 250,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      recipeDetails.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  pinned: true,
                  floating: true, // Added this line
                  title: Text(recipeDetails.title), // Added this line
                ),
                SliverPadding(
                  padding: EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      SizedBox(height: 16),
                      Text(
                        'Ingredients',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 8),
                      ..._buildListItems(recipeDetails.ingredients),
                      SizedBox(height: 16),
                      Text(
                        'Steps',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 8),
                      ..._buildListItems(recipeDetails.steps),
                      SizedBox(height: 64),
                      widget.action_source==1? Text(
                        'More Recipes Suggestions',
                        style: TextStyle(fontSize: 16, color: Colors.grey[800], fontWeight: FontWeight.w600),
                      ):Container(),
                     // SizedBox(height: 8),
                    ]),
                  ),
                ),
                widget.action_source==1? SliverToBoxAdapter(
                    child: FutureBuilder<List<Recipe>>(
                      future: RecipeProvider().fetchRandomizedListRecipes(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          print('HH SS${snapshot.error}');
                          return Center(child: Text('An error occurred.'));
                        } else if (snapshot.data!.isEmpty) {
                          return Center(
                              child: Text('No similar recipes found.'));
                        } else {
                          return Container(
                            height: 200,
                            child: HorizontalRecipeList(
                                recipes: snapshot.data!),
                          );
                        }
                      },
                    ),
                  ):SliverToBoxAdapter(child: Container())

              ],
            );
          }
        },
      ),
    );
  }

  List<Widget> _buildListItems(List<String> items) {
    return items.map((item) => Text(item)).toList();
  }
}

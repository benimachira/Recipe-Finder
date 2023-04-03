import 'package:flutter/material.dart';
import 'package:recipe_finder/models/recipe.dart';
import 'package:recipe_finder/screens/recipe_details_screen.dart';

class HorizontalRecipeList extends StatelessWidget {
final List<Recipe> recipes;

HorizontalRecipeList({required this.recipes});

@override
Widget build(BuildContext context) {
  return Container(
    height: 200.0,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return InkWell(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RecipeDetailsScreen(recipeId: recipe.id,action_source: 2,)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                width: 120.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      width: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: FadeInImage(
                          placeholder: AssetImage('assets/images/placeholder.jpg'),
                          image: NetworkImage('${recipe.imageUrl}'),
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/placeholder.jpg',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      recipe.title,

                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.0,color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
}

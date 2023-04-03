import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_finder/models/recipe.dart';

import '../screens/recipe_details_screen.dart';

class RecipeList extends StatelessWidget {
  final List<Recipe> recipes;

  RecipeList({required this.recipes});

  @override
  Widget build(BuildContext context) {
    if (recipes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 40,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No recipes found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return Padding(
          padding: index==0?EdgeInsets.only(top: 32.0,right: 2,left: 2,bottom: 2):EdgeInsets.all(2.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(

                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RecipeDetailsScreen(recipeId: recipe.id, action_source: 1),
                    ),
                  );
                },
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: FadeInImage(
                        placeholder:
                        AssetImage('assets/images/placeholder.jpg'),
                        image: NetworkImage('${recipe.imageUrl}'),
                        width: 120,
                        height: 70,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/placeholder.jpg',
                            width: 120,
                            height: 70,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          SizedBox(height: 16.0),
                          Text(
                            recipe.title,
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(height: 2.0),
                          Icon(Icons.checklist_rtl_outlined,color: Colors.grey[400],size: 18,),
                          SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                   // SizedBox(height: 16.0),
                  ],
                ),
              ),
               SizedBox(height: 2.0),
              Divider(),
            ],
          ),
        );
      },
    );
  }
}

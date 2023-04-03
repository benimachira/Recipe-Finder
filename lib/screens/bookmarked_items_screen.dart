import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_finder/models/recipe_details.dart';
import 'package:recipe_finder/screens/recipe_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/recipe.dart';
import '../providers/recipe_provider.dart';

class BookmarkedItemsScreen extends StatefulWidget {
  @override
  _BookmarkedItemsScreenState createState() => _BookmarkedItemsScreenState();
}

class _BookmarkedItemsScreenState extends State<BookmarkedItemsScreen> {
  List<int> _bookmarkedIds = [];

  @override
  void initState() {
    super.initState();
    _fetchBookmarkedIds();
  }

  Future<void> _fetchBookmarkedIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? recipeIds = prefs.getStringList('bookmarkedRecipes');
    if (recipeIds != null) {
      setState(() {
        _bookmarkedIds = recipeIds.map(int.parse).toList();
      });
    }
  }

  Future<void> _updateBookmarkedIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? recipeIds = prefs.getStringList('bookmarkedRecipes');
    if (recipeIds != null) {
      setState(() {
        _bookmarkedIds = recipeIds.map(int.parse).toList();
      });
    } else {
      setState(() {
        _bookmarkedIds = [];
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updateBookmarkedIds();
    }
   // super.did();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarked Recipes'),
      ),
      body: _bookmarkedIds.isEmpty
          ? Center(
              child: Text('No Bookmarked Recipes'),
            )
          : ListView.builder(
              itemCount: _bookmarkedIds.length,
              itemBuilder: (context, index) {
                final recipeId = _bookmarkedIds[index];
                return FutureBuilder<RecipeDetails>(
                  future: Provider.of<RecipeProvider>(context)
                      .fetchRecipeDetails(recipeId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircularProgressIndicator(),
                          title: Text('Loading...'),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Icon(Icons.error),
                          title: Text('An error occurred.'),
                        ),
                      );
                    } else {
                      final recipe = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(recipe.imageUrl),
                          ),
                          title: Text(recipe.title),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              List<String>? recipeIds =
                                  prefs.getStringList('bookmarkedRecipes');
                              if (recipeIds != null &&
                                  recipeIds.contains(recipeId.toString())) {
                                recipeIds.remove(recipeId.toString());
                                await prefs.setStringList(
                                    'bookmarkedRecipes', recipeIds);
                                setState(() {
                                  _bookmarkedIds.remove(recipeId);
                                });
                              }
                            },
                          ),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeDetailsScreen(
                                    recipeId: recipeId, action_source: 2),
                              ),
                            );
                            _updateBookmarkedIds();
                          },
                        ),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}

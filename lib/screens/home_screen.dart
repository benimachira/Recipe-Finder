import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:recipe_finder/providers/recipe_provider.dart';
import 'package:recipe_finder/screens/bookmarked_items_screen.dart';
import 'package:recipe_finder/widgets/recipe_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recipe Finder',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BookmarkedItemsScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Find the perfect recipe for any occasion!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 32),
            SizedBox(
              height: 52,
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    hintText: 'Enter ingredients or dish name',
                    contentPadding: EdgeInsets.only(left: 16.0, top: 16.0),
                  ),
                  style: TextStyle(fontSize: 16),
                ),
                suggestionsCallback: RecipeProvider().getSuggestions,
                itemBuilder: (context, suggestion) {
                  return ListTile(title: Text(suggestion));
                },
                onSuggestionSelected: (suggestion) {
                  _searchController.text = suggestion;
                  _searchRecipes();
                },
              ),
            ),

            Expanded(
              child: Consumer<RecipeProvider>(
                builder: (context, recipeProvider, _) {
                  if (_isLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return RefreshIndicator(
                      onRefresh: () async {
                        await Provider.of<RecipeProvider>(context, listen: false)
                            .fetchRandomRecipes();
                      },
                      child: RecipeList(recipes: recipeProvider.recipes),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _searchRecipes() async {
    if (_searchController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<RecipeProvider>(context, listen: false)
          .fetchRecipes(_searchController.text);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _initProvider() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<RecipeProvider>(context, listen: false)
        .fetchRandomRecipes();
    setState(() {
      _isLoading = false;
    });
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:recipes_app/components/search_bar.dart';
import 'package:recipes_app/screens/home/components/recipe_card.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static BuildContext? homeBuildContext;
  //final Function? onTap;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int page = 0;
  final controller = ScrollController();
  List<RecipeData> recipeCards = [];
  bool hasMoreItems = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetch();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future refresh() async {
    setState(() {
      isLoading = false;
      hasMoreItems = true;
      page = 0;
      recipeCards.clear();
    });
    fetch();
  }

  Future fetch() async {
    if (isLoading) return;
    isLoading = true;

    int limit = 25;
    final Uri url = Uri.parse(
        "https://jsonplaceholder.typicode.com/posts?_limit=$limit&_page=$page");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        final List newItems = jsonDecode(response.body);
        page++;
        isLoading = false;

        if (newItems.length < limit) {
          hasMoreItems = false;
        }

        recipeCards.addAll(newItems.map<RecipeData>((e) {
          String name = e["title"];
          int id = e["id"];
          return RecipeData(
              name,
              id.toString(),
              "resources/test_image.png",
              15,
              5,
              2,
              0,
              List.generate(
                  2,
                  (index) => Ingredient("Something", index.toString(), 0.125,
                      10 * index + 100, 10, 5, 85)));
        }).toList());
      });
    } else {
      log("Problem! Code: $response.statusCode");
    }
  }

  @override
  Widget build(BuildContext context) {
    HomeScreen.homeBuildContext = context;
    return Column(children: [
      Row(children: [
        const Align(),
        const Expanded(child: SearchBar()),
        Align(
            child:
                IconButton(onPressed: () {}, icon: const Icon(Icons.settings)))
      ]),
      Expanded(
          child: RefreshIndicator(
              onRefresh: refresh,
              child: ListView.builder(
                  controller: controller,
                  padding: const EdgeInsets.all(4),
                  itemCount: recipeCards.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index < recipeCards.length) {
                      return RecipeCard(
                        data: recipeCards[index],
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Container(
                          alignment: Alignment.center,
                          child: hasMoreItems
                              ? const CircularProgressIndicator(
                                  strokeWidth: 2,
                                )
                              : const Text("No more data",
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xFF666666))),
                        ),
                      );
                    }
                  })))
    ]);
  }
}

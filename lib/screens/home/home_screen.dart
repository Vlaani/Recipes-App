import 'dart:convert';
import 'dart:developer';
import 'package:recipes_app/screens/details/components/ingredient_search.dart';
import 'package:recipes_app/view_model/data.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:recipes_app/constants.dart';
import 'package:recipes_app/screens/home/components/search_bar.dart';
import 'package:recipes_app/screens/home/components/recipe_card.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static BuildContext? homeBuildContext;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  String lastId = "0";
  final controller = ScrollController();
  List<RecipeData> recipeCards = [];
  String? query;
  bool hasMoreItems = true;
  bool isLoading = false;
  List<Ingredient> includedIngredients = [];
  List<Ingredient> excludedIngredients = [];
  List<int> _includedIngredients = [];
  List<int> _excludedIngredients = [];
  RangeValues ccalsRangeValues = const RangeValues(10, 500);
  RangeValues cookTimeRangeValues = const RangeValues(0, 300);
  int ingredientInEditIndex = -1;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (recipeCards.isEmpty) {
      loadRecipes();
      controller.addListener(() {
        if (controller.position.maxScrollExtent == controller.offset) {
          loadRecipes();
        }
      });
    }
  }

  void handleSelection(Pair<String, String> selectedIngredient,
      {bool inExludeList = false}) {
    if (ingredientsMap.isEmpty) fillIngredientsMap();
    if (inExludeList) {
      _excludedIngredients[ingredientInEditIndex] =
          ingredientsMap.indexOf(selectedIngredient);
      excludedIngredients[ingredientInEditIndex] =
          convertToIngredient(ingredientsMap.indexOf(selectedIngredient));
    } else {
      _includedIngredients[ingredientInEditIndex] =
          ingredientsMap.indexOf(selectedIngredient);
      includedIngredients[ingredientInEditIndex] =
          convertToIngredient(ingredientsMap.indexOf(selectedIngredient));
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void deleteIngredient(int index, {bool inExludeList = false}) {
    if (inExludeList) {
      _excludedIngredients.removeAt(index);
      excludedIngredients.removeAt(index);
    } else {
      _includedIngredients.removeAt(index);
      includedIngredients.removeAt(index);
    }
  }

  void addIngredient({bool inExludeList = false}) {
    if (inExludeList) {
      _excludedIngredients.add(-1);
      excludedIngredients.add(Ingredient("", "", 0, 0, 0, 0, 0));
    } else {
      _includedIngredients.add(-1);
      includedIngredients.add(Ingredient("", "", 0, 0, 0, 0, 0));
    }
  }

  Future<void> openFilters() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context, setState) => SizedBox(
                  height: 150,
                  child: SimpleDialog(
                    clipBehavior: Clip.hardEdge,
                    title: const Text('Выберите фильтры поиска'),
                    children: <Widget>[
                      const SizedBox(height: 15),
                      const Align(
                          alignment: Alignment.center,
                          child: Text("Каллории на 100 гр.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 18,
                                  height: 1,
                                  color: Color(0xFF666666)))),
                      const SizedBox(height: 15),
                      RangeSlider(
                        activeColor: Colors.amberAccent,
                        values: ccalsRangeValues,
                        divisions: 49,
                        labels: RangeLabels(
                          ccalsRangeValues.start.round().toString(),
                          ccalsRangeValues.end.round().toString(),
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            ccalsRangeValues = values;
                          });
                        },
                        min: 10,
                        max: 500,
                      ),
                      const SizedBox(height: 15),
                      const Align(
                          alignment: Alignment.center,
                          child: Text("Время приготовления",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 18,
                                  height: 1,
                                  color: Color(0xFF666666)))),
                      const SizedBox(height: 15),
                      RangeSlider(
                        activeColor: Colors.amberAccent,
                        values: cookTimeRangeValues,
                        divisions: 60,
                        labels: RangeLabels(
                          cookTimeRangeValues.start.round().toString(),
                          cookTimeRangeValues.end.round().toString(),
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            cookTimeRangeValues = values;
                          });
                        },
                        min: 0,
                        max: 300,
                      ),
                      const SizedBox(height: 15),
                      const Align(
                          alignment: Alignment.center,
                          child: Text("Включить ингредиенты",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 18,
                                  height: 1,
                                  color: Color(0xFF666666)))),
                      const SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                            children: List<Widget>.generate(
                                includedIngredients.length + 1, (int index) {
                          return Container(
                            height: 50,
                            padding: EdgeInsets.only(left: 10, right: 10),
                            margin: EdgeInsets.only(top: 2, bottom: 2),
                            decoration: BoxDecoration(
                              color: Color(0xFFEDEDED),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            child: index ==
                                                    includedIngredients.length
                                                ? ElevatedButton(
                                                    onPressed: () {
                                                      addIngredient();
                                                      setState(() {});
                                                    },
                                                    child:
                                                        const Icon(Icons.add),
                                                    style: ButtonStyle(
                                                      padding:
                                                          WidgetStateProperty
                                                              .all(EdgeInsets
                                                                  .zero),
                                                      shape: WidgetStateProperty
                                                          .all<CircleBorder>(
                                                              const CircleBorder()),
                                                      backgroundColor:
                                                          WidgetStateProperty.all<
                                                                  Color>(
                                                              const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  206,
                                                                  206,
                                                                  206)), // <-- Button color
                                                      foregroundColor:
                                                          WidgetStateProperty.all<
                                                                  Color>(
                                                              const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  71,
                                                                  71,
                                                                  71)), // <-- Splash color
                                                    ),
                                                  )
                                                : includedIngredients[index]
                                                        .iconPath
                                                        .isNotEmpty
                                                    ? Image.network(
                                                        "http://" +
                                                            serverUrl +
                                                            "/images/" +
                                                            includedIngredients[
                                                                    index]
                                                                .iconPath,
                                                        fit: BoxFit.fill,
                                                      )
                                                    : Icon(
                                                        Icons
                                                            .question_mark_rounded,
                                                        color:
                                                            Color(0xFF666666),
                                                      ),
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      index == includedIngredients.length
                                          ? Text("Добавить ингредиент",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  height: 1,
                                                  color: Color(0xFF666666)))
                                          : IngredientSearch(
                                              includedIngredients[index]
                                                      .ingredientName
                                                      .isEmpty
                                                  ? "Поиск"
                                                  : includedIngredients[index]
                                                      .ingredientName, (obj) {
                                              handleSelection(obj);
                                              setState(() {});
                                            }, () {
                                              ingredientInEditIndex = index;
                                            })
                                    ],
                                  ),
                                  if (index != includedIngredients.length)
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      height: 36,
                                      width: 36,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          deleteIngredient(index);
                                          setState(() {});
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          size: 12,
                                          color: Color(0xFF666666),
                                        ),
                                        style: ButtonStyle(
                                          padding: WidgetStateProperty.all(
                                              EdgeInsets.zero),
                                          shape: WidgetStateProperty.all<
                                                  CircleBorder>(
                                              const CircleBorder()),
                                          backgroundColor: WidgetStateProperty
                                              .all<Color>(Colors
                                                  .amberAccent), // <-- Button color
                                          foregroundColor:
                                              WidgetStateProperty.all<Color>(
                                                  const Color.fromARGB(
                                                      255,
                                                      71,
                                                      71,
                                                      71)), // <-- Splash color
                                        ),
                                      ),
                                    )
                                ]),
                          );
                        })),
                      ),
                      const SizedBox(height: 15),
                      const Align(
                          alignment: Alignment.center,
                          child: Text("Исключить ингредиенты",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 18,
                                  height: 1,
                                  color: Color(0xFF666666)))),
                      const SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                            children: List<Widget>.generate(
                                excludedIngredients.length + 1, (int index) {
                          return Container(
                            height: 50,
                            padding: EdgeInsets.only(left: 10, right: 10),
                            margin: EdgeInsets.only(top: 2, bottom: 2),
                            decoration: BoxDecoration(
                              color: Color(0xFFEDEDED),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            child: index ==
                                                    excludedIngredients.length
                                                ? ElevatedButton(
                                                    onPressed: () {
                                                      addIngredient(
                                                          inExludeList: true);
                                                      setState(() {});
                                                    },
                                                    child:
                                                        const Icon(Icons.add),
                                                    style: ButtonStyle(
                                                      padding:
                                                          WidgetStateProperty
                                                              .all(EdgeInsets
                                                                  .zero),
                                                      shape: WidgetStateProperty
                                                          .all<CircleBorder>(
                                                              const CircleBorder()),
                                                      backgroundColor:
                                                          WidgetStateProperty.all<
                                                                  Color>(
                                                              const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  206,
                                                                  206,
                                                                  206)), // <-- Button color
                                                      foregroundColor:
                                                          WidgetStateProperty.all<
                                                                  Color>(
                                                              const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  71,
                                                                  71,
                                                                  71)), // <-- Splash color
                                                    ),
                                                  )
                                                : excludedIngredients[index]
                                                        .iconPath
                                                        .isNotEmpty
                                                    ? Image.network(
                                                        "http://" +
                                                            serverUrl +
                                                            "/images/" +
                                                            excludedIngredients[
                                                                    index]
                                                                .iconPath,
                                                        fit: BoxFit.fill,
                                                      )
                                                    : Icon(
                                                        Icons
                                                            .question_mark_rounded,
                                                        color:
                                                            Color(0xFF666666),
                                                      ),
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      index == excludedIngredients.length
                                          ? Text("Добавить ингредиент",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  height: 1,
                                                  color: Color(0xFF666666)))
                                          : IngredientSearch(
                                              excludedIngredients[index]
                                                      .ingredientName
                                                      .isEmpty
                                                  ? "Поиск"
                                                  : excludedIngredients[index]
                                                      .ingredientName, (obj) {
                                              handleSelection(obj,
                                                  inExludeList: true);
                                              setState(() {});
                                            }, () {
                                              ingredientInEditIndex = index;
                                            })
                                    ],
                                  ),
                                  if (index != excludedIngredients.length)
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      height: 36,
                                      width: 36,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          deleteIngredient(index,
                                              inExludeList: true);
                                          setState(() {});
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          size: 12,
                                          color: Color(0xFF666666),
                                        ),
                                        style: ButtonStyle(
                                          padding: WidgetStateProperty.all(
                                              EdgeInsets.zero),
                                          shape: WidgetStateProperty.all<
                                                  CircleBorder>(
                                              const CircleBorder()),
                                          backgroundColor: WidgetStateProperty
                                              .all<Color>(Colors
                                                  .amberAccent), // <-- Button color
                                          foregroundColor:
                                              WidgetStateProperty.all<Color>(
                                                  const Color.fromARGB(
                                                      255,
                                                      71,
                                                      71,
                                                      71)), // <-- Splash color
                                        ),
                                      ),
                                    )
                                ]),
                          );
                        })),
                      ),
                      const SizedBox(height: 15),
                      const Align(
                          alignment: Alignment.center,
                          child: Text("Тэги",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 18,
                                  height: 1,
                                  color: Color(0xFF666666)))),
                      const SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.only(right: 10, left: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.only(right: 10, left: 10),
                            side: BorderSide(
                              width: 1,
                              color: Color(0xFF666666),
                            ),
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.amber,
                          ),
                          child: Text("Применить",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                  height: 1,
                                  overflow: TextOverflow.ellipsis,
                                  color: Color(0xFF666666))),
                          onPressed: () async {
                            Navigator.pop(context);
                            refresh();
                          },
                        ),
                      ),
                    ],
                  )));
        });
  }

  Future refresh() async {
    setState(() {
      isLoading = false;
      hasMoreItems = true;
      lastId = "0";
      recipeCards.clear();
    });
    loadRecipes();
  }

  Future loadRecipes() async {
    if (allIngredients.isEmpty) await loadIngredients();
    if (isLoading) return;
    isLoading = true;

    int limit = 25;
    var url = Uri.http(serverUrl, "/getRecipes", {
      "limit": limit.toString(),
      "last_id": lastId,
      if (query != null) "query": query,
      if (ccalsRangeValues.start != 10)
        "ccalsMin": ccalsRangeValues.start.toString(),
      if (ccalsRangeValues.end != 500)
        "ccalsMax": ccalsRangeValues.end.toString(),
      if (cookTimeRangeValues.start != 0)
        "cookTimeMin": cookTimeRangeValues.start.toString(),
      if (cookTimeRangeValues.end != 300)
        "cookTimeMax": cookTimeRangeValues.end.toString(),
      if (_includedIngredients.isNotEmpty)
        "includedIngredients": jsonEncode(_includedIngredients),
      if (_excludedIngredients.isNotEmpty)
        "excludedIngredients": jsonEncode(_excludedIngredients)
    });
    print(jsonEncode(_includedIngredients));
    print(url);
    final response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        final List newRecipes = jsonDecode(response.body);
        if (newRecipes.isEmpty) {
          hasMoreItems = false;
          return;
        }
        lastId = (newRecipes.last)["_id"];
        isLoading = false;

        if (newRecipes.length < limit) {
          hasMoreItems = false;
        }

        recipeCards.addAll(newRecipes.map<RecipeData>((e) {
          List<String> photoPaths =
              e["photoPaths"].map<String>((e) => e as String).toList();
          return RecipeData(
              e["name"],
              photoPaths[0] == " " ? ["resources/test_image.png"] : photoPaths,
              e["description"],
              e["readinessTime"],
              e["timeInKitchen"],
              e["difficulty"],
              e["spiciness"],
              List.generate(e["ingredients"].length, (index) {
                Map<String, dynamic> ingredientInfo =
                    (e["ingredients"] as List<dynamic>)[index];
                int id = int.parse(
                        ingredientInfo["_id"].toString().substring(16),
                        radix: 16) -
                    start;
                //var ingredient = allIngredients[id];
                return Pair(
                    id,
                    double.parse((ingredientInfo["count"]["weight"].toDouble())
                        .toStringAsFixed(3)));
              }),
              e["steps"] == null
                  ? []
                  : List.generate(e["steps"].length, (index) {
                      return RecipeStep((e["steps"] as List)[index], "");
                    }));
        }).toList());
      });
    } else {
      log("Problem! Code: $response.statusCode");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    HomeScreen.homeBuildContext = context;
    return Column(children: [
      Container(
          height: 64,
          padding: EdgeInsets.all(10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(child: Search((text) {
              query = text;
              refresh();
            })),
            IconButton(
                iconSize: 32,
                onPressed: () {
                  openFilters();
                },
                icon: const Icon(Icons.filter_alt_outlined))
          ])),
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

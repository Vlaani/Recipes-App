import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipes_app/constants.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/create/components/recipe_tab.dart';
import 'package:recipes_app/screens/details/components/ingredient_search.dart';
import 'package:recipes_app/view_model/data.dart';

// ignore: must_be_immutable
class CreateScreen extends StatefulWidget {
  const CreateScreen(this.onNoUser, {Key? key}) : super(key: key);
  final Function onNoUser;
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen>
    with AutomaticKeepAliveClientMixin {
  int selectedTab = -1;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  int ingredientInEditIndex = -1;

  get http => null;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    print("set state create screen");
  }

  @override
  void initState() {
    super.initState();
    if (ingredientsMap.isEmpty) fillIngredientsMap();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void createNewRecipe() {
    setState(() {
      recipesInEdit.add(
          Pair(Pair(false, -1), RecipeData("", [], "", 0, 0, 0, 0, [], [])));
      onTabSelected(recipesInEdit.length - 1);
    });
  }

  void addIngredient() {
    setState(() {
      recipesInEdit[selectedTab].key.key = false;
      recipesInEdit[selectedTab].value.ingredients.add(Pair(-1, 0));
    });
  }

  void deleteIngredient(int index) {
    setState(() {
      recipesInEdit[selectedTab].key.key = false;
      recipesInEdit[selectedTab].value.ingredients.removeAt(index);
    });
  }

  void addStep() {
    setState(() {
      recipesInEdit[selectedTab].key.key = false;
      recipesInEdit[selectedTab].value.steps.add(RecipeStep("", ""));
    });
  }

  void onTabSelected(int tab) {
    setState(() {
      selectedTab = tab;
      nameController.text = recipesInEdit[selectedTab].value.recipeName;
      descriptionController.text = recipesInEdit[selectedTab].value.description;
    });
  }

  Iterable<Widget> getSuggestions(SearchController controller) {
    final String input = controller.value.text;
    return ingredientsMap
        .where((_ingredient) => _ingredient.value.contains(input))
        .map(
          (_filteredIngredient) => ListTile(
            leading: CircleAvatar(
              backgroundImage: Image.network("http://" +
                      serverUrl +
                      "/images/" +
                      _filteredIngredient.key)
                  .image,
            ),
            title: Text(_filteredIngredient.value),
            onTap: () {
              controller.closeView(_filteredIngredient.value);
              handleSelection(_filteredIngredient);
            },
          ),
        );
  }

  void handleSelection(Pair<String, String> selectedIngredient) {
    setState(() {
      recipesInEdit[selectedTab].value.ingredients[ingredientInEditIndex] =
          Pair(
              ingredientsMap.indexOf(selectedIngredient),
              recipesInEdit[selectedTab]
                  .value
                  .ingredients[ingredientInEditIndex]
                  .value);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (recipesInEdit.isNotEmpty && selectedTab == -1) onTabSelected(0);
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DefaultTabController(
                  length: recipesInEdit.length + 1,
                  child: TabBar(
                    indicatorWeight: 0.1,
                    labelPadding: EdgeInsets.all(0),
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    onTap: (value) {
                      onTabSelected(value);
                    },
                    overlayColor: WidgetStateProperty.resolveWith((states) {
                      return Color.fromARGB(0, 237, 237, 237);
                    }),
                    indicatorColor: Color.fromARGB(0, 255, 255, 255),
                    tabs: List<Widget>.generate(
                        (recipesInEdit.isNotEmpty ? recipesInEdit.length : 0) +
                            1, (index) {
                      if (index == recipesInEdit.length) {
                        return Container(
                          padding: EdgeInsets.all(5),
                          height: 36,
                          width: 36,
                          child: ElevatedButton(
                            onPressed: () {
                              user != null
                                  ? createNewRecipe()
                                  : widget.onNoUser();
                            },
                            child: const Icon(
                              Icons.add,
                              color: Color(0xFF666666),
                            ),
                            style: ButtonStyle(
                              padding: WidgetStateProperty.all(EdgeInsets.zero),
                              shape: WidgetStateProperty.all<CircleBorder>(
                                  const CircleBorder()),
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.amber), // <-- Button color
                              foregroundColor: WidgetStateProperty.all<Color>(
                                  const Color.fromARGB(
                                      255, 71, 71, 71)), // <-- Splash color
                            ),
                          ),
                        );
                      } else {
                        return RecipeTab(recipesInEdit[index].value.recipeName,
                            selectedTab == index);
                      }
                    }),
                  )),
              Expanded(
                child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: recipesInEdit.isEmpty
                        ? const Align(
                            alignment: Alignment.center,
                            child: Text("Нажми на плюс, чтобы создать рецепт",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 24,
                                    height: 1,
                                    color: Color(0xFF666666))),
                          )
                        : ListView(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            children: [
                              const SizedBox(height: 15),
                              const Align(
                                  alignment: Alignment.center,
                                  child: Text("Название рецепта",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 20,
                                          height: 1,
                                          color: Color(0xFF666666)))),
                              const SizedBox(height: 15),
                              Container(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: SizedBox(
                                      height: 48,
                                      child: TextField(
                                        controller: nameController,
                                        onTapOutside: (event) {
                                          setState(() {});
                                        },
                                        onChanged: (value) {
                                          recipesInEdit[selectedTab].key.key =
                                              false;
                                          recipesInEdit[selectedTab]
                                              .value
                                              .recipeName = value;
                                        },
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16,
                                            color: Color(0xFF666666)),
                                        decoration: InputDecoration(
                                          hintText: "Название",
                                          filled: true,
                                          fillColor: Color.fromARGB(
                                              255, 235, 235, 235),
                                          contentPadding:
                                              const EdgeInsets.only(left: 14),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    0, 255, 255, 255)),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    0, 255, 255, 255)),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ))),
                              const SizedBox(height: 15),
                              const Align(
                                  alignment: Alignment.center,
                                  child: Text("Фотографии",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 20,
                                          height: 1,
                                          color: Color(0xFF666666)))),
                              const SizedBox(height: 15),
                              GridView.count(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  crossAxisCount: 3,
                                  children: List<Widget>.of(recipesInEdit[
                                              selectedTab]
                                          .value
                                          .photoPaths
                                          .map((x) => ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Container(
                                                  foregroundDecoration:
                                                      BoxDecoration(
                                                    image: DecorationImage(
                                                        image:
                                                            Image.file(File(x))
                                                                .image,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                              ))) +
                                      [
                                        ElevatedButton(
                                          onPressed: () async {
                                            final ImagePicker picker =
                                                ImagePicker();
                                            final List<XFile> images =
                                                await picker.pickMultiImage();
                                            if (images.isEmpty) return;
                                            setState(() {
                                              recipesInEdit[selectedTab]
                                                  .key
                                                  .key = false;
                                              recipesInEdit[selectedTab]
                                                  .value
                                                  .photoPaths
                                                  .addAll(images
                                                      .map((x) => x.path));
                                            });
                                          },
                                          style: ButtonStyle(
                                            padding: WidgetStateProperty.all(
                                                EdgeInsets.zero),
                                            shape: WidgetStateProperty.all(
                                                const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)))),
                                            backgroundColor:
                                                WidgetStateProperty.all<Color>(
                                              Color.fromARGB(
                                                  255, 236, 236, 236),
                                            ),
                                            foregroundColor:
                                                WidgetStateProperty.all<Color>(
                                                    const Color.fromARGB(
                                                        255, 71, 71, 71)),
                                          ),
                                          child: Icon(
                                            Icons.add_photo_alternate_outlined,
                                            color: Color(0xFF666666),
                                          ),
                                        ),
                                      ]),
                              const SizedBox(height: 15),
                              const Align(
                                  alignment: Alignment.center,
                                  child: Text("Описание",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 20,
                                          height: 1,
                                          color: Color(0xFF666666)))),
                              const SizedBox(height: 15),
                              TextField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                controller: descriptionController,
                                onChanged: (value) {
                                  recipesInEdit[selectedTab].key.key = false;
                                  recipesInEdit[selectedTab].value.description =
                                      value;
                                },
                                onTapOutside: (event) {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  hintText: 'Описание',
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 235, 235, 235),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.amber, width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFF666666), width: 0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Align(
                                  alignment: Alignment.center,
                                  child: Text("Ингредиенты",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 20,
                                          height: 1,
                                          color: Color(0xFF666666)))),
                              const SizedBox(height: 15),
                              Column(
                                  children: List<Widget>.generate(
                                      recipesInEdit[selectedTab]
                                              .value
                                              .ingredients
                                              .length +
                                          1, (int index) {
                                return Container(
                                  margin: EdgeInsets.only(top: 2, bottom: 2),
                                  height: 50,
                                  padding: EdgeInsets.only(left: 8, right: 10),
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
                                                          recipesInEdit[
                                                                  selectedTab]
                                                              .value
                                                              .ingredients
                                                              .length
                                                      ? ElevatedButton(
                                                          onPressed: () {
                                                            addIngredient();
                                                          },
                                                          child: const Icon(
                                                              Icons.add),
                                                          style: ButtonStyle(
                                                            padding:
                                                                WidgetStateProperty
                                                                    .all(EdgeInsets
                                                                        .zero),
                                                            shape: WidgetStateProperty.all<
                                                                    CircleBorder>(
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
                                                      : recipesInEdit[selectedTab]
                                                                  .value
                                                                  .ingredients[
                                                                      index]
                                                                  .key !=
                                                              -1
                                                          ? Image.network(
                                                              "http://" +
                                                                  serverUrl +
                                                                  "/images/" +
                                                                  allIngredients[recipesInEdit[
                                                                              selectedTab]
                                                                          .value
                                                                          .ingredients[
                                                                              index]
                                                                          .key]
                                                                      .iconPath,
                                                              fit: BoxFit.fill,
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .question_mark_rounded,
                                                              color: Color(
                                                                  0xFF666666),
                                                            ),
                                                )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            index ==
                                                    recipesInEdit[selectedTab]
                                                        .value
                                                        .ingredients
                                                        .length
                                                ? Text("Добавить ингредиент",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16,
                                                        height: 1,
                                                        color:
                                                            Color(0xFF666666)))
                                                : IngredientSearch(
                                                    recipesInEdit[selectedTab]
                                                                .value
                                                                .ingredients[
                                                                    index]
                                                                .key ==
                                                            -1
                                                        ? "Поиск"
                                                        : allIngredients[
                                                                recipesInEdit[
                                                                        selectedTab]
                                                                    .value
                                                                    .ingredients[
                                                                        index]
                                                                    .key]
                                                            .ingredientName,
                                                    handleSelection, () {
                                                    ingredientInEditIndex =
                                                        index;
                                                  })
                                          ],
                                        ),
                                        if (index !=
                                            recipesInEdit[selectedTab]
                                                .value
                                                .ingredients
                                                .length)
                                          Flexible(
                                              child: Container(
                                                  width: 128,
                                                  height: 64,
                                                  padding: EdgeInsets.all(10),
                                                  child: TextFormField(
                                                      controller: TextEditingController(
                                                          text: recipesInEdit[selectedTab].value.ingredients[index].key == -1
                                                              ? "0"
                                                              : recipesInEdit[selectedTab]
                                                                  .value
                                                                  .ingredients[
                                                                      index]
                                                                  .value
                                                                  .ceil()
                                                                  .toString()),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          overflow:
                                                              TextOverflow.clip,
                                                          fontSize: 12,
                                                          color: Color(
                                                              0xFF666666)),
                                                      maxLines: 1,
                                                      onFieldSubmitted:
                                                          (value) {
                                                        setState(() {
                                                          recipesInEdit[
                                                                  selectedTab]
                                                              .key
                                                              .key = false;
                                                        });
                                                      },
                                                      onChanged: (value) {
                                                        recipesInEdit[
                                                                selectedTab]
                                                            .value
                                                            .ingredients[index]
                                                            .value = value
                                                                .isEmpty
                                                            ? 0
                                                            : double.parse(
                                                                value);
                                                        print(value);
                                                      },
                                                      keyboardType:
                                                          TextInputType.number,
                                                      textAlign:
                                                          TextAlign.center,
                                                      decoration:
                                                          InputDecoration(
                                                              hintText:
                                                                  'Кол-во',
                                                              filled: true,
                                                              fillColor: Color.fromARGB(
                                                                  255, 235, 235, 235),
                                                              contentPadding: EdgeInsets.only(
                                                                  left: 7.0,
                                                                  bottom: 0.0,
                                                                  top: 0.0),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: const BorderSide(
                                                                    color: Color(
                                                                        0xFF666666)),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(color: Colors.amber, width: 2),
                                                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                                              border: InputBorder.none)))),
                                        if (index !=
                                            recipesInEdit[selectedTab]
                                                .value
                                                .ingredients
                                                .length)
                                          Flexible(
                                              child: Text("г/мл",
                                                  softWrap: false,
                                                  overflow:
                                                      TextOverflow.visible,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          Color(0xFF666666)))),
                                        if (index !=
                                            recipesInEdit[selectedTab]
                                                .value
                                                .ingredients
                                                .length)
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            height: 36,
                                            width: 36,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                deleteIngredient(index);
                                              },
                                              child: const Icon(
                                                Icons.delete,
                                                size: 12,
                                                color: Color(0xFF666666),
                                              ),
                                              style: ButtonStyle(
                                                padding:
                                                    WidgetStateProperty.all(
                                                        EdgeInsets.zero),
                                                shape: WidgetStateProperty.all<
                                                        CircleBorder>(
                                                    const CircleBorder()),
                                                backgroundColor: WidgetStateProperty
                                                    .all<Color>(Colors
                                                        .amberAccent), // <-- Button color
                                                foregroundColor:
                                                    WidgetStateProperty.all<
                                                            Color>(
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
                              const SizedBox(height: 15),
                              const Align(
                                  alignment: Alignment.center,
                                  child: Text("Шаги приготовления",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 20,
                                          height: 1,
                                          color: Color(0xFF666666)))),
                              const SizedBox(height: 80),
                            ],
                          )),
              )
            ],
          ),
          if (recipesInEdit.isNotEmpty)
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  color: Color(0xFFFFFFFF),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
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
                            backgroundColor: recipesInEdit[selectedTab].key.key
                                ? Colors.transparent
                                : Colors.amber,
                          ),
                          child: Text("Сохранить",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                  height: 1,
                                  overflow: TextOverflow.ellipsis,
                                  color: Color(0xFF666666))),
                          onPressed: () {
                            setState(() {
                              if (recipesInEdit[selectedTab].key.key) return;
                              if (recipesInEdit[selectedTab]
                                  .value
                                  .photoPaths
                                  .isEmpty) {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible:
                                      false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Недостаточно данных'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            if (recipesInEdit[selectedTab]
                                                .value
                                                .photoPaths
                                                .isEmpty)
                                              Text('Не выбрано ни одного фото',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 18,
                                                      height: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color:
                                                          Color(0xFF666666))),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Ок',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  height: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Colors.amber)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                return;
                              }
                              if (user!.userRecipes == null) {
                                user!.userRecipes = [];
                              }
                              int recipeIndex = 0;
                              if (recipesInEdit[selectedTab].key.value == -1) {
                                user!.userRecipes!.add(RecipeData.clone(
                                    recipesInEdit[selectedTab].value));
                                recipeIndex = user!.userRecipes!.length - 1;
                              } else {
                                user!.userRecipes![
                                        recipesInEdit[selectedTab].key.value] =
                                    RecipeData.clone(
                                        recipesInEdit[selectedTab].value);
                                recipeIndex =
                                    recipesInEdit[selectedTab].key.value;
                              }
                              recipesInEdit[selectedTab].key =
                                  Pair(true, recipeIndex);
                              writeJsonFile("user", user);
                              //updateAccount();
                            });
                          },
                        ),
                        width: 180,
                      ),
                      SizedBox(
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
                            backgroundColor: Color(0xFF666666),
                          ),
                          child: Text("Закрыть",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                  height: 1,
                                  overflow: TextOverflow.ellipsis,
                                  color: Color.fromARGB(255, 255, 255, 255))),
                          onPressed: () {
                            setState(() {
                              recipesInEdit.removeAt(selectedTab);
                              selectedTab = recipesInEdit.length - 1;
                            });
                          },
                        ),
                        width: 180,
                      ),
                    ],
                  ),
                ))
        ]));
  }

  @override
  bool get wantKeepAlive => true;
}

/*
SearchAnchor(
                                                  builder:
                                                      (BuildContext context,
                                                          SearchController
                                                              controller) {
                                                    return Container(
                                                      padding: EdgeInsets.only(
                                                          top: 8, bottom: 8),
                                                      width: 160,
                                                      height: 64,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 10,
                                                                  left: 10),
                                                          side: BorderSide(
                                                            width: 1,
                                                            color: Color(
                                                                0xFF666666),
                                                          ),
                                                          shadowColor: Colors
                                                              .transparent,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                      0,
                                                                      170,
                                                                      73,
                                                                      73)
                                                                  .withOpacity(
                                                                      0),
                                                        ),
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Flexible(
                                                                  child: Text(
                                                                      recipesInEdit[selectedTab]
                                                                              .value
                                                                              .ingredients[
                                                                                  index]
                                                                              .ingredientName
                                                                              .isEmpty
                                                                          ? "Поиск"
                                                                          : recipesInEdit[selectedTab]
                                                                              .value
                                                                              .ingredients[
                                                                                  index]
                                                                              .ingredientName,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w300,
                                                                          fontSize:
                                                                              14,
                                                                          height:
                                                                              1,
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          color:
                                                                              Color(0xFF666666)))),
                                                              Icon(
                                                                Icons
                                                                    .keyboard_double_arrow_down_sharp,
                                                                color: Color(
                                                                    0xFF666666),
                                                              ),
                                                            ]),
                                                        onPressed: () {
                                                          ingredientInEditIndex =
                                                              index;
                                                          print(
                                                              ingredientInEditIndex);
                                                          controller.openView();
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  viewHintText: "Поиск",
                                                  suggestionsBuilder:
                                                      (BuildContext context,
                                                          SearchController
                                                              controller) {
                                                    if (controller
                                                            .text.length >=
                                                        3) {
                                                      return getSuggestions(
                                                          controller);
                                                    }
                                                    return <Widget>[
                                                      Center(
                                                          child: Text(
                                                              'Ингредиент не найден',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 12,
                                                                  height: 1,
                                                                  color: Color(
                                                                      0xFF666666))))
                                                    ];
                                                  },
                                                ),
                                        
 */
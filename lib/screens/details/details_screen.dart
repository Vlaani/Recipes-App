import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recipes_app/constants.dart';
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/details/components/ingredient_card.dart';
import 'package:recipes_app/screens/details/components/step_card.dart';
import 'package:recipes_app/view_model/data.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen(this.recipeData, {Key? key}) : super(key: key);
  final RecipeData recipeData;
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  double ingredientsMultiplier = 1;
  final TextEditingController multiplierController = TextEditingController();
  FocusNode _focus = FocusNode();

  void _updateMultiplierValue({double? addValue, bool isDoneEditting = false}) {
    final text = multiplierController.text;
    if (!_focus.hasFocus || isDoneEditting) {
      setState(() {
        if (text.isEmpty || double.parse(text) == 0) {
          multiplierController.text = "1.0";
        }
        ingredientsMultiplier = double.parse(multiplierController.text);
        if (addValue != null) {
          if (ingredientsMultiplier + addValue > 0) {
            ingredientsMultiplier += addValue;
          }
        }
        if (ingredientsMultiplier >= 100) {
          ingredientsMultiplier = 99;
        }
        multiplierController.text = ingredientsMultiplier.toStringAsFixed(1);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    multiplierController.addListener(_updateMultiplierValue);
  }

  @override
  void dispose() {
    multiplierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _updateMultiplierValue();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 28,
                ))),
        Expanded(
            child: ListView(
          shrinkWrap: true,
          children: [
            Container(
                margin: const EdgeInsets.only(right: 15, left: 15),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: const Color(0xFFEDEDED),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(25))),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Stack(
                      children: [
                        Container(
                          height: 200,
                          foregroundDecoration: BoxDecoration(
                            image: DecorationImage(
                                image: widget.recipeData.photoPaths[0]
                                        .startsWith("resources")
                                    ? AssetImage(
                                        widget.recipeData.photoPaths[0])
                                    : widget.recipeData.photoPaths[0]
                                            .startsWith("/")
                                        ? Image.file(File(widget
                                                .recipeData.photoPaths[0]))
                                            .image
                                        : NetworkImage("http://" +
                                                serverUrl +
                                                "/images/" +
                                                widget.recipeData.photoPaths[0])
                                            as ImageProvider,
                                fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ))),
            Container(
              padding: const EdgeInsets.only(
                  right: 15, left: 15, bottom: 10, top: 5),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Text(widget.recipeData.getName(),
                                softWrap: true,
                                style: const TextStyle(
                                    fontSize: 16, color: Color(0xFF666666)))),
                        const Icon(Icons.flag_circle)
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(widget.recipeData.description,
                        textAlign: TextAlign.left,
                        softWrap: true,
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF666666))),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                            child: Text("Ингридиенты: ",
                                softWrap: true,
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xFF666666)))),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Порции: ",
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xFF666666))),
                            Container(
                                height: 35,
                                width: 105,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 228, 228, 228),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 35,
                                        width: 35,
                                        child: TextButton(
                                            onPressed: () {
                                              _updateMultiplierValue(
                                                  addValue: -1);
                                            },
                                            child: Text("-",
                                                style: TextStyle(
                                                    height: 1,
                                                    fontSize: 20,
                                                    color:
                                                        Color(0xFF666666))))),
                                    Container(
                                        height: 35,
                                        width: 35,
                                        child: TextField(
                                            keyboardType: TextInputType.number,
                                            controller: multiplierController,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF666666)),
                                            focusNode: _focus,
                                            onSubmitted: (arg) =>
                                                _updateMultiplierValue(
                                                    isDoneEditting: true),
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                contentPadding: EdgeInsets.only(
                                                    left: 7.0,
                                                    bottom: 0.0,
                                                    top: 0.0),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color.fromARGB(
                                                          0, 255, 255, 255)),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color.fromARGB(
                                                          0, 255, 255, 255)),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                border: InputBorder.none))),
                                    SizedBox(
                                        height: 35,
                                        width: 35,
                                        child: TextButton(
                                            onPressed: () {
                                              _updateMultiplierValue(
                                                  addValue: 1);
                                            },
                                            child: Text("+",
                                                style: TextStyle(
                                                    height: 1,
                                                    fontSize: 20,
                                                    color:
                                                        Color(0xFF666666))))),
                                  ],
                                ))
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(4),
                        itemCount: widget.recipeData.ingredients.length,
                        itemBuilder: (BuildContext context, int index) {
                          Ingredient t = allIngredients[
                              widget.recipeData.ingredients[index].key];
                          t.weight = widget.recipeData.ingredients[index].value;
                          return IngredientCard(t, ingredientsMultiplier);
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Рецепт: ",
                          softWrap: true,
                          style: const TextStyle(
                              fontSize: 16, color: Color(0xFF666666))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(4),
                        itemCount: widget.recipeData.steps.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Шаг ${index + 1}: ",
                                      softWrap: true,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.amber)),
                                ),
                                StepCard(widget.recipeData.steps[index]),
                              ]);
                        }),
                  ]),
            ),
          ],
        ))
      ],
    );
  }
}

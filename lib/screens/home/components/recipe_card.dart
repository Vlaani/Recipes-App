import 'package:flutter/material.dart';
import 'package:recipes_app/constants.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/details/details_screen.dart';
import 'package:recipes_app/screens/home/components/info_shape.dart';
import 'package:recipes_app/view_model/data.dart';

class RecipeCard extends StatefulWidget {
  final RecipeData data;
  const RecipeCard({Key? key, required this.data}) : super(key: key);
  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  String query = '';

  void onQueryChanged(String newQuery) {
    setState(() {
      query = newQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          openDetails(context);
        },
        child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: const Color(0xFFEDEDED),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(25))),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 200,
                          foregroundDecoration: BoxDecoration(
                            image: DecorationImage(
                                image: widget.data.photoPaths[0]
                                        .startsWith("resources")
                                    ? AssetImage(widget.data.photoPaths[0])
                                    : NetworkImage("http://" +
                                            serverUrl +
                                            "/images/" +
                                            widget.data.photoPaths[0])
                                        as ImageProvider,
                                fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Container(
                            color: Color.fromARGB(255, 255, 255, 255),
                            height: 90,
                            padding: const EdgeInsets.only(
                                right: 10, left: 10, bottom: 10, top: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(widget.data.getName(maxChars: 30),
                                        style: const TextStyle(
                                            overflow: TextOverflow.visible,
                                            fontSize: 18,
                                            color: Color(0xFF666666))),
                                    const Icon(Icons.flag_circle)
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.star_half_outlined,
                                                color: Colors.amberAccent,
                                                size: 24,
                                              ),
                                              const SizedBox(width: 5),
                                              Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        "${widget.data.getRating()}",
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            height: 1,
                                                            color: Color(
                                                                0xFF666666))),
                                                    Text(
                                                        "  (" +
                                                            "${widget.data.reviews.length} оценок" +
                                                            ")",
                                                        style: const TextStyle(
                                                            fontSize: 10,
                                                            height: 1,
                                                            color: Color(
                                                                0xFF666666)))
                                                  ])
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.access_time_rounded,
                                                color: Color(0xFF666666),
                                                size: 20,
                                              ),
                                              Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Text(
                                                      "${widget.data.timeInKitchen} / ${widget.data.readyTime} мин.",
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Color(
                                                              0xFF666666))))
                                            ],
                                          ),
                                        ]),
                                  ],
                                )
                              ],
                            )),
                        Container(
                            height: 90,
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: ClipPath(
                                  clipper: InfoClipPath(40, 25),
                                  child: Container(
                                    height: 45,
                                    width: 270,
                                    color: Color.fromARGB(255, 128, 128, 128),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text("  Калории",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w300,
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255))),
                                            Text(
                                                (widget.data.ingredients
                                                                .map<double>((el) =>
                                                                    allIngredients[el
                                                                            .key]
                                                                        .calories *
                                                                    el.value)
                                                                .fold<double>(
                                                                    0,
                                                                    (a, b) =>
                                                                        a + b) /
                                                            widget.data
                                                                .getWeight())
                                                        .toInt()
                                                        .toString() +
                                                    " ккал",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    color: Colors.amber))
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Transform(
                                          //origin: Offset(0,0)
                                          transform: Matrix4.rotationZ(0.3),
                                          child: Container(
                                            color: Color(0xFFFFFFFF),
                                            width: 1,
                                            height: 55,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text("  Белки",
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w300,
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255))),
                                            Text(
                                                (widget.data.ingredients
                                                                .map((el) =>
                                                                    allIngredients[el
                                                                            .key]
                                                                        .proteins *
                                                                    el.value)
                                                                .fold<double>(
                                                                    0,
                                                                    (a, b) =>
                                                                        a + b) /
                                                            widget.data
                                                                .getWeight())
                                                        .toStringAsFixed(1) +
                                                    " г",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    color: Colors.amber))
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Transform(
                                          //origin: Offset(0,0)
                                          transform: Matrix4.rotationZ(0.3),
                                          child: Container(
                                            color: Color(0xFFFFFFFF),
                                            width: 1,
                                            height: 55,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text("  Жиры",
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w300,
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255))),
                                            Text(
                                                (widget.data.ingredients
                                                                .map((el) =>
                                                                    allIngredients[el
                                                                            .key]
                                                                        .fats *
                                                                    el.value)
                                                                .fold<double>(
                                                                    0,
                                                                    (a, b) =>
                                                                        a + b) /
                                                            widget.data
                                                                .getWeight())
                                                        .toStringAsFixed(1) +
                                                    " г",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    color: Colors.amber))
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Transform(
                                          //origin: Offset(0,0)
                                          transform: Matrix4.rotationZ(0.3),
                                          child: Container(
                                            color: Color(0xFFFFFFFF),
                                            width: 1,
                                            height: 55,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("  Углеводы",
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w300,
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255))),
                                            Text(
                                                (widget.data.ingredients
                                                                .map((el) =>
                                                                    allIngredients[el
                                                                            .key]
                                                                        .carbohydrates *
                                                                    el.value)
                                                                .fold<double>(
                                                                    0,
                                                                    (a, b) =>
                                                                        a + b) /
                                                            widget.data
                                                                .getWeight())
                                                        .toStringAsFixed(1) +
                                                    " г",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    color: Colors.amber))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )))
                      ],
                    )
                  ],
                ))));
  }

  void openDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(widget.data),
      ),
    );
  }
}

/*
Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(1),
                                        height: 70,
                                        width: 62,
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: const Color(0xFF666666),
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8))),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Text("Калории",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF666666))),
                                            Text(
                                                (widget.data.ingredients
                                                                .map((el) =>
                                                                    el.calories *
                                                                    el.weight)
                                                                .fold<double>(
                                                                    0,
                                                                    (a, b) =>
                                                                        a + b) /
                                                            widget.data
                                                                .getWeight())
                                                        .toString() +
                                                    " кКал",
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Color(0xFF666666)))
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(1),
                                        height: 70,
                                        width: 62,
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: const Color(0xFF666666),
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Text("Белки",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF666666))),
                                            Text(
                                                (widget.data.ingredients
                                                                .map((el) =>
                                                                    el.proteins *
                                                                    el.weight)
                                                                .fold<double>(
                                                                    0,
                                                                    (a, b) =>
                                                                        a + b) /
                                                            widget.data
                                                                .getWeight())
                                                        .toString() +
                                                    " г",
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Color(0xFF666666)))
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(1),
                                        height: 70,
                                        width: 62,
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: const Color(0xFF666666),
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Text("Жиры",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF666666))),
                                            Text(
                                                (widget.data.ingredients
                                                                .map((el) =>
                                                                    el.fats *
                                                                    el.weight)
                                                                .fold<double>(
                                                                    0,
                                                                    (a, b) =>
                                                                        a + b) /
                                                            widget.data
                                                                .getWeight())
                                                        .toString() +
                                                    " г",
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Color(0xFF666666)))
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(1),
                                        height: 70,
                                        width: 62,
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: const Color(0xFF666666),
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Text("Углеводы",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF666666))),
                                            Text(
                                                (widget.data.ingredients
                                                                .map((el) =>
                                                                    el.carbohydrates *
                                                                    el.weight)
                                                                .fold<double>(
                                                                    0,
                                                                    (a, b) =>
                                                                        a + b) /
                                                            widget.data
                                                                .getWeight())
                                                        .toString() +
                                                    " г",
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Color(0xFF666666)))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  flex: 66,
                                )
                              
 */
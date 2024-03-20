import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/details/details_screen.dart';

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
                        Image.asset(
                          widget.data.previewPath,
                          fit: BoxFit.fitHeight,
                          height: 200,
                        )
                      ],
                    ),
                    Container(
                        height: 120,
                        padding: const EdgeInsets.only(
                            right: 10, left: 10, bottom: 10, top: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.data.getName(maxChars: 40),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF666666))),
                                const Icon(Icons.flag_circle)
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                            height: 35,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.access_time_rounded,
                                                  color: Color(0xFF666666),
                                                  size: 22,
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
                                            )),
                                        SizedBox(
                                            height: 35,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.star_half_rounded,
                                                  color: Colors.amberAccent,
                                                  size: 24,
                                                ),
                                                Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              "${widget.data.getRating()}",
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Color(
                                                                      0xFF666666))),
                                                          Text(
                                                              "${widget.data.reviews.length} оценок",
                                                              style: const TextStyle(
                                                                  fontSize: 10,
                                                                  color: Color(
                                                                      0xFF666666)))
                                                        ]))
                                              ],
                                            )),
                                      ]),
                                  flex: 28,
                                ),
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
                                  flex: 72,
                                )
                              ],
                            )
                          ],
                        ))
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

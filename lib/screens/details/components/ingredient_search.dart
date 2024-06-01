import 'package:flutter/material.dart';
import 'package:recipes_app/constants.dart';
import 'package:recipes_app/view_model/data.dart';

class IngredientSearch extends StatefulWidget {
  const IngredientSearch(this.foregroundText, this.onSelected, this.onOpened,
      {Key? key})
      : super(key: key);
  final String foregroundText;
  final Function(Pair<String, String>) onSelected;
  final Function onOpened;
  @override
  IngredientSearchState createState() => IngredientSearchState();
}

class IngredientSearchState extends State<IngredientSearch> {
  List<Pair<String, String>> ingredientsMap = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ingredientsMap = allIngredients
        .map<Pair<String, String>>((e) => Pair(e.iconPath, e.ingredientName))
        .toList();
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
              widget.onSelected(_filteredIngredient);
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return Container(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          width: 160,
          height: 64,
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
              backgroundColor: Color.fromARGB(0, 170, 73, 73).withOpacity(0),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: Text(widget.foregroundText,
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              height: 1,
                              overflow: TextOverflow.ellipsis,
                              color: Color(0xFF666666)))),
                  Icon(
                    Icons.keyboard_double_arrow_down_sharp,
                    color: Color(0xFF666666),
                  ),
                ]),
            onPressed: () {
              widget.onOpened();
              controller.openView();
            },
          ),
        );
      },
      viewHintText: "Поиск",
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        if (controller.text.length >= 3) {
          return getSuggestions(controller);
        }
        return <Widget>[
          Center(
              child: Text('Ингредиент не найден',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      height: 1,
                      color: Color(0xFF666666))))
        ];
      },
    );
  }
}

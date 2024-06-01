import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Search extends StatefulWidget {
  Search(this.onSearch, {Key? key}) : super(key: key);
  Function onSearch;
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String query = '';

  void onQueryChanged(String newQuery) {
    setState(() {
      query = newQuery;
    });
  }

  Iterable<Widget> getSuggestions(SearchController controller) {
    final String input = controller.value.text;
    return [
      ListTile(
        title: Text("Coming soon"),
        trailing: IconButton(
          icon: const Icon(Icons.call_missed),
          onPressed: () {
            controller.text = "Not implemented yet";
            controller.selection =
                TextSelection.collapsed(offset: controller.text.length);
          },
        ),
        onTap: () {
          controller.closeView("Not implemented yet");
          //handleSelection(filteredColor);
        },
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    SearchController? _controller;
    final FocusNode _focusNode = FocusNode();
    return SearchAnchor(
        viewHintText: "Поиск",
        viewOnSubmitted: (value) {
          query = value;
          widget.onSearch(query);
          _controller?.closeView(query);
          _focusNode.unfocus();
        },
        builder: (BuildContext context, SearchController controller) {
          _controller = controller;
          return SearchBar(
            focusNode: _focusNode,
            hintText: "Поиск",
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              return const Color(0xFFEDEDED);
            }),
            controller: controller,
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)),
            onTap: () {
              controller.openView();
            },
            leading: const Icon(Icons.search),
          );
        },
        isFullScreen: false,
        suggestionsBuilder:
            (BuildContext context, SearchController controller) {
          return getSuggestions(controller);
        });
  }
}

/*
Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        onChanged: onQueryChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFEDEDED),
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
          enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(0, 255, 255, 255)),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(0, 255, 255, 255)),
            borderRadius: BorderRadius.circular(20),
          ),
          labelText: 'Поиск',
          border: InputBorder.none,
        ),
      ),
    );
 */
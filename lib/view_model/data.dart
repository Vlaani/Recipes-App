import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:recipes_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:recipes_app/models/ingredient.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/user.dart';

User? user;
List _ingredients = [];
List<Ingredient> allIngredients = [];
List<Pair<String, String>> ingredientsMap = [];
List<Pair<Pair<bool, int>, RecipeData>> recipesInEdit = [];
late int start;

Future<void> fillIngredientsMap() async {
  if (allIngredients.isNotEmpty) return;
  print("Started loading");
  await loadIngredients();
  int i = 0;
  allIngredients =
      _ingredients.map<Ingredient>((e) => convertToIngredient(i++)).toList();
  ingredientsMap = allIngredients
      .map<Pair<String, String>>((e) => Pair(e.iconPath, e.ingredientName))
      .toList();
}

Future<String> get directoryPath async {
  Directory directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> jsonFile(String fileName) async {
  final path = await directoryPath;
  return File('$path/$fileName.json');
}

Future<Map<String, dynamic>?> readJsonFile(String fileName) async {
  File file = await jsonFile(fileName);

  if (await file.exists()) {
    try {
      String fileContent = await file.readAsString();
      print(fileContent);
      return json.decode(fileContent);
    } catch (e) {
      print(e);
    }
  }

  return null;
}

void updateAccount() async {
  try {
    print("updateAccount");
    print(json.encode({
      "userName": user!.userName,
      "login": user!.login,
      "email": user!.email,
      "password": "0",
      "publishedRecipes": user!.publishedRecipes
    }));
    var url = Uri.http(serverUrl, "/profile");
    final response = await http.put(url,
        headers: {'cookie': "jwt=" + user!.cookie!},
        body: json.encode({
          "userName": user!.userName,
          "login": user!.login,
          "email": user!.email,
          "password": "0",
          "publishedRecipes": user!.publishedRecipes
        }));
    print(response.body);
  } catch (e) {
    print(e);
  }
}

Future<T> writeJsonFile<T>(String fileName, T object) async {
  File file = await jsonFile(fileName);
  //print(json.encode(object));
  print(json.encode(object));
  await file.writeAsString(json.encode(object));
  return object;
}

Future loadIngredients() async {
  var url = Uri.http(serverUrl, "/getIngredients");
  final response = await http.get(url);
  _ingredients = jsonDecode(response.body);
  start =
      int.parse(_ingredients.first["_id"].toString().substring(16), radix: 16);

  print("finished loading");
}

Ingredient convertToIngredient(int index) {
  var ingredient = _ingredients[index];
  return Ingredient(
      ingredient["name"],
      ingredient["iconPath"],
      0,
      ingredient["ccal"].toDouble(),
      ingredient["protein"].toDouble(),
      ingredient["fats"].toDouble(),
      ingredient["carbohydrates"].toDouble());
}

class Pair<T, D> {
  T key;
  D value;
  Pair(this.key, this.value);

  @override
  bool operator ==(covariant Pair<T, D> other) {
    return key == other.key && value == other.value;
  }

  Pair.fromJson(Map<String, dynamic> json)
      : key = json['key'] as T,
        value = json['value'] as D;
  Map<String, dynamic> toJson() {
    return {
      "key": key,
      "value": value,
    };
  }
}

/*
Future<Map<String, dynamic>?> _loadData(String localPath) async {
  try {
    final String response = await rootBundle.loadString('/sample.json');
    final data = await json.decode(response);
    final directory = await getApplicationSupportDirectory();
    print(directory.path + "/" + localPath);
    if (Directory(directory.path + "/" + localPath).existsSync()) {
      String json = File(directory.path + "/" + localPath).readAsStringSync();
      print(json);
      final data = jsonDecode(json);
      return data;
    }
  } catch (e) {
    return null;
  }
  return null;
}

Future<String> _saveData(String localPath, dynamic data) async {
  try {
    String json = jsonEncode(data);
    print(json);
    final directory = await getApplicationSupportDirectory();
    File(directory.path + "/" + localPath).writeAsString(json);
    print(directory.path + "/" + localPath);
    return "";
  } catch (exception) {
    print(exception.toString());
    return exception.toString();
  }
}

 */
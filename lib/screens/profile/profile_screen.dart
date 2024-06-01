import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:recipes_app/constants.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:http/http.dart' as http;
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/screens/details/details_screen.dart';
import 'package:recipes_app/view_model/data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(this.user, this.onExit, this.onRecipeEdit, {Key? key})
      : super(key: key);
  final User user;
  final Function onExit;
  final Function onRecipeEdit;
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void openDetails(BuildContext context, RecipeData x) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(x),
      ),
    );
  }

  Future<void> publishRecipe(RecipeData x) async {
    try {
      var url = Uri.http(serverUrl, "/uploadImage");
      http.MultipartRequest request = http.MultipartRequest('POST', url);
      int i = 0;
      for (final imagePath in x.photoPaths) {
        if (imagePath.startsWith("/")) {
          request.files
              .add(await http.MultipartFile.fromPath('file', imagePath));
          request.headers["cookie"] = "jwt=" + user!.cookie!;
          http.StreamedResponse response = await request.send();
          x.photoPaths[i] = utf8.decode(await response.stream.toBytes());
        } //print(utf8.decode(await response.stream.toBytes()));
        i++;
      }
      url = Uri.http(serverUrl, "/uploadRecipe");
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'cookie': "jwt=" + user!.cookie!
          },
          body: jsonEncode(x));
      user!.publishedRecipes = [];
      //print(response.body);

      print("published");
      if (!user!.publishedRecipes!.contains(response.body)) {
        user!.publishedRecipes!.add(response.body);
      }
      return;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: 203,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 45, left: 30, right: 30),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Color(0xFFD9D9D9),
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.user.userName,
                                        overflow: TextOverflow.visible,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            overflow: TextOverflow.visible,
                                            fontSize: 22,
                                            height: 1,
                                            color: Color(0xFF666666))),
                                    const SizedBox(height: 2),
                                    Text("@" + widget.user.login,
                                        overflow: TextOverflow.visible,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16,
                                            height: 1,
                                            color: Color(0xFF666666)))
                                  ],
                                ),
                                const SizedBox(height: 15),
                                SizedBox(
                                    width: 140,
                                    child: TextButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                            shape: WidgetStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                            ),
                                            backgroundColor:
                                                WidgetStateProperty.all(
                                                    Colors.amber)),
                                        child: const Text("Избранное",
                                            overflow: TextOverflow.visible,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                height: 1,
                                                color: Color(0xFF666666)))))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 15, right: 15),
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              user = null;
                            });
                          },
                          icon: const Icon(
                            Icons.exit_to_app,
                            size: 32,
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text("Мои рецепты",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color(0xFF666666))),
                const SizedBox(height: 5),
                Expanded(
                    child: Divider(
                  color: Color(0xFF666666),
                )),
              ],
            )),
        (widget.user.userRecipes != null && widget.user.userRecipes!.isNotEmpty)
            ? Container(
                padding: EdgeInsets.all(2),
                child: GridView.count(
                    shrinkWrap: true,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    crossAxisCount: 3,
                    children: List<Widget>.of(
                        widget.user.userRecipes!.map((x) => GestureDetector(
                            onTap: () {
                              openDetails(context, x);
                            },
                            child: Container(
                                foregroundDecoration: BoxDecoration(
                                  border: Border.all(
                                    width: 0.5,
                                    color: Color(0xFF666666),
                                  ),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: ClipRRect(
                                    child: Stack(
                                  children: [
                                    Container(
                                      foregroundDecoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(0),
                                        image: DecorationImage(
                                            image: x.photoPaths[0]
                                                    .startsWith("/")
                                                ? Image.file(
                                                        File(x.photoPaths[0]))
                                                    .image
                                                : Image.network("http://" +
                                                        serverUrl +
                                                        "/images/" +
                                                        x.photoPaths[0])
                                                    .image,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        height: 36,
                                        width: double.infinity,
                                        child: Text(
                                          x.recipeName,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              height: 1,
                                              overflow: TextOverflow.ellipsis,
                                              color: Color(0xFF666666)),
                                        ),
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: SizedBox(
                                          width: 36,
                                          height: 36,
                                          child: MenuAnchor(
                                              builder: (BuildContext context,
                                                  MenuController controller,
                                                  Widget? child) {
                                                return IconButton(
                                                  onPressed: () {
                                                    if (controller.isOpen) {
                                                      controller.close();
                                                    } else {
                                                      controller.open();
                                                    }
                                                  },
                                                  icon: const Icon(
                                                      Icons.more_vert_rounded),
                                                  tooltip: 'Show menu',
                                                );
                                              },
                                              menuChildren: <MenuItemButton>[
                                                MenuItemButton(
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.edit,
                                                      size: 20,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        int index = widget
                                                            .user.userRecipes!
                                                            .indexOf(x);
                                                        if (recipesInEdit
                                                                .firstWhere(
                                                                    (el) {
                                                                  return el.key
                                                                          .value ==
                                                                      index;
                                                                },
                                                                    orElse: () => Pair(
                                                                        Pair(
                                                                            false,
                                                                            -1),
                                                                        x))
                                                                .key
                                                                .value ==
                                                            -1) {
                                                          recipesInEdit.add(
                                                              Pair(
                                                                  Pair(true,
                                                                      index),
                                                                  RecipeData
                                                                      .clone(
                                                                          x)));
                                                          //widget.onRecipeEdit();
                                                        }
                                                        widget.onRecipeEdit();
                                                      });
                                                    },
                                                  ),
                                                ),
                                                MenuItemButton(
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.share,
                                                      size: 20,
                                                    ),
                                                    onPressed: () {
                                                      showDialog<void>(
                                                        context: context,
                                                        barrierDismissible:
                                                            false, // user must tap button!
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Публикация рецепта'),
                                                            content:
                                                                const SingleChildScrollView(
                                                              child: ListBody(
                                                                children: <Widget>[
                                                                  Text(
                                                                      'Вы действительно хотите опубликовать свой рецепт?'),
                                                                ],
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child: const Text(
                                                                    'Опубликовать',
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontSize:
                                                                            16,
                                                                        height:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        color: Colors
                                                                            .amber)),
                                                                onPressed:
                                                                    () async {
                                                                  publishRecipe(
                                                                          x)
                                                                      .then(
                                                                          (val) {
                                                                    updateAccount();
                                                                  });
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  writeJsonFile(
                                                                      "user",
                                                                      user);
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: const Text(
                                                                    'Отмена',
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontSize:
                                                                            16,
                                                                        height:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        color: Color(
                                                                            0xFF666666))),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                                MenuItemButton(
                                                    child: IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    size: 20,
                                                  ),
                                                  onPressed: () {
                                                    showDialog<void>(
                                                      context: context,
                                                      barrierDismissible:
                                                          false, // user must tap button!
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Удаление рецепта'),
                                                          content:
                                                              const SingleChildScrollView(
                                                            child: ListBody(
                                                              children: <Widget>[
                                                                Text(
                                                                    'Вы действительно хотите удалить свой рецепт?'),
                                                              ],
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: const Text(
                                                                  'Удалить',
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          16,
                                                                      height: 1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      color: Colors
                                                                          .amber)),
                                                              onPressed: () {
                                                                setState(() {
                                                                  user!
                                                                      .userRecipes!
                                                                      .remove(
                                                                          x);
                                                                });
                                                                writeJsonFile(
                                                                    "user",
                                                                    user);
                                                                updateAccount();
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: const Text(
                                                                  'Отмена',
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          16,
                                                                      height: 1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      color: Color(
                                                                          0xFF666666))),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                )),
                                              ]),
                                        )),
                                  ],
                                ))))))))
            : Expanded(
                child: Align(
                alignment: Alignment.center,
                child: Text("Здесь пока ничего нет",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Color(0xFF666666))),
              ))
      ],
    );
  }
}

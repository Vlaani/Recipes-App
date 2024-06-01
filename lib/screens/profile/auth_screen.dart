import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipes_app/constants.dart';
import 'package:recipes_app/models/user.dart';
//import 'package:recipes_app/view_model/data.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen(this.appLogoPath, this.onAuthenticated, {Key? key})
      : super(key: key);
  final String appLogoPath;
  final Function(User) onAuthenticated;
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool isLoginScreen = true;
  bool isRequestSent = false;

  String loginOrEmail = "";
  String userName = "";
  String login = "";
  String email = "";
  String password = "";
  bool loginProblem = false;
  bool signupProblem = false;

  Future submitLogin() async {
    if (isRequestSent) return;
    try {
      isRequestSent = true;
      var url = Uri.http(serverUrl, "/login");
      final body =
          jsonEncode({"login_or_email": loginOrEmail, "password": password});
      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: body);
      String? rawCookie = response.headers['set-cookie'];
      if (response.statusCode == 200) {
        if (loginProblem) {
          setState(() {
            loginProblem = false;
          });
        }
        Map<String, String> headers = {};
        if (rawCookie != null) {
          int index = rawCookie.indexOf(';');
          headers['cookie'] =
              (index == -1) ? rawCookie : rawCookie.substring(0, index);
        }
        print(response.body);
        url = Uri.http(serverUrl, "/profile");
        response = await http.get(url, headers: headers);
        print(response.body);
        final _user = User.fromJson(jsonDecode(response.body));
        print(_user);
        print("onAuth");
        widget.onAuthenticated(_user);
      } else if (response.statusCode != 500) {
        setState(() {
          loginProblem = true;
        });
      }
    } catch (e) {
      AlertDialog(
        title: Text(e.toString()),
      );
      isRequestSent = false;
    }
    isRequestSent = false;
  }

  Future submitSignup() async {
    if (isRequestSent) return;
    try {
      isRequestSent = true;
      var url = Uri.http(serverUrl, "/signup");
      final body = jsonEncode({
        "userName": userName,
        "login": login,
        "email": email,
        "password": password
      });
      print(body);
      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: body);
      print(response.body);
      if (response.statusCode == 201) {
        if (signupProblem) {
          setState(() {
            signupProblem = false;
          });
        }
        widget.onAuthenticated(User.fromJson({
          "profilePhotoPath": "",
          "userName": userName,
          "cookie": response.headers["cookie"],
          "login": login.toLowerCase(),
          "email": email.toLowerCase(),
          "publishedRecipes": [],
          "likedRecipes": [],
          "userRecipes": []
        }));
      } else if (response.statusCode != 500) {
        setState(() {
          signupProblem = true;
        });
      }
    } catch (e) {
      AlertDialog(
        title: Text(e.toString()),
      );
      isRequestSent = false;
    }
    isRequestSent = false;
  }

  void changeAuthType() {
    setState(() {
      isLoginScreen = !isLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Container(
          padding: const EdgeInsets.all(24),
        ),
        Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.settings,
                  size: 32,
                ))),
      ]),
      Expanded(
        child: Container(
          padding: const EdgeInsets.only(right: 30, left: 30, bottom: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: [
                  Image.asset(
                    widget.appLogoPath,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(height: (isLoginScreen ? 60 : 20)),
                  isLoginScreen
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Логин",
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFFB0B0B0))),
                                Container(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: SizedBox(
                                        height: 25,
                                        width: 125,
                                        child: TextButton(
                                            onPressed: () => {changeAuthType()},
                                            style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith<Color>(
                                                            (Set<MaterialState>
                                                                states) {
                                                  if (states.contains(
                                                          MaterialState
                                                              .pressed) ||
                                                      states.contains(
                                                          MaterialState
                                                              .hovered))
                                                    return Colors.amber;
                                                  return Colors.amber.withOpacity(
                                                      0.5); // null throus error in flutter 2.2+.
                                                })),
                                            child: Text("Создать аккаунт",
                                                overflow: TextOverflow.visible,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    height: 1,
                                                    color:
                                                        Color(0xFF666666))))))
                              ],
                            ),
                            Container(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: SizedBox(
                                    height: 45,
                                    child: TextField(
                                      onChanged: (value) =>
                                          loginOrEmail = value,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16,
                                          color: Color(0xFF666666)),
                                      decoration: InputDecoration(
                                        hintText: "Логин или email",
                                        filled: true,
                                        fillColor: const Color(0xFFF6F6F6),
                                        contentPadding:
                                            const EdgeInsets.only(left: 14),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: loginProblem
                                                  ? Color.fromARGB(
                                                      255, 255, 0, 0)
                                                  : Color.fromARGB(
                                                      0, 255, 255, 255)),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: loginProblem
                                                  ? Color.fromARGB(
                                                      255, 255, 0, 0)
                                                  : Color.fromARGB(
                                                      0, 255, 255, 255)),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ))),
                            Text("Пароль",
                                style: const TextStyle(
                                    fontSize: 10, color: Color(0xFFB0B0B0))),
                            Container(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: SizedBox(
                                    height: 45,
                                    child: TextField(
                                      obscureText: true,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      onChanged: (value) => password = value,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16,
                                          color: Color(0xFF666666)),
                                      decoration: InputDecoration(
                                        hintText: "Пароль",
                                        filled: true,
                                        fillColor: const Color(0xFFF6F6F6),
                                        contentPadding:
                                            const EdgeInsets.only(left: 14),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: loginProblem
                                                  ? Color.fromARGB(
                                                      255, 255, 0, 0)
                                                  : Color.fromARGB(
                                                      0, 255, 255, 255)),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: loginProblem
                                                  ? Color.fromARGB(
                                                      255, 255, 0, 0)
                                                  : Color.fromARGB(
                                                      0, 255, 255, 255)),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ))),
                            const SizedBox(height: 10),
                            SizedBox(
                                height: 45,
                                width: double.infinity,
                                child: TextButton(
                                    onPressed: () => submitLogin(),
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.amber)),
                                    child: Text("Войти",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: Color(0xFF666666))))),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Имя пользователя",
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFFB0B0B0))),
                                  Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: SizedBox(
                                          height: 25,
                                          width: 125,
                                          child: TextButton(
                                              onPressed: () => {
                                                    changeAuthType()
                                                  },
                                              style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                  ),
                                                  backgroundColor:
                                                      MaterialStateProperty
                                                          .resolveWith<
                                                              Color>((Set<
                                                                  MaterialState>
                                                              states) {
                                                    if (states.contains(
                                                            MaterialState
                                                                .pressed) ||
                                                        states.contains(
                                                            MaterialState
                                                                .hovered))
                                                      return Colors.amber;
                                                    return Colors.amber.withOpacity(
                                                        0.5); // null throus error in flutter 2.2+.
                                                  })),
                                              child: Text(
                                                  "Войти",
                                                  overflow:
                                                      TextOverflow.visible,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
                                                      height: 1,
                                                      color:
                                                          Color(0xFF666666))))))
                                ],
                              ),
                              Container(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 4),
                                  child: SizedBox(
                                      height: 45,
                                      child: TextField(
                                        onChanged: (value) => userName = value,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14,
                                            height: 1,
                                            color: Color(0xFF666666)),
                                        decoration: InputDecoration(
                                          hintText: "Имя пользователя",
                                          filled: true,
                                          fillColor: const Color(0xFFF6F6F6),
                                          contentPadding:
                                              const EdgeInsets.only(left: 14),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    0, 255, 255, 255)),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    0, 255, 255, 255)),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ))),
                              Text("Логин",
                                  style: const TextStyle(
                                      fontSize: 10, color: Color(0xFFB0B0B0))),
                              Container(
                                  padding:
                                      const EdgeInsets.only(top: 3, bottom: 4),
                                  child: SizedBox(
                                      height: 45,
                                      child: TextField(
                                        onChanged: (value) => login = value,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14,
                                            color: Color(0xFF666666)),
                                        decoration: InputDecoration(
                                          hintText: "Логин",
                                          filled: true,
                                          fillColor: const Color(0xFFF6F6F6),
                                          contentPadding:
                                              const EdgeInsets.only(left: 14),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    0, 255, 255, 255)),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    0, 255, 255, 255)),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ))),
                              Text("Почта",
                                  style: const TextStyle(
                                      fontSize: 10, color: Color(0xFFB0B0B0))),
                              Container(
                                  padding:
                                      const EdgeInsets.only(top: 3, bottom: 4),
                                  child: SizedBox(
                                      height: 45,
                                      child: TextField(
                                        onChanged: (value) => email = value,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14,
                                            color: Color(0xFF666666)),
                                        decoration: InputDecoration(
                                          hintText: "Email",
                                          filled: true,
                                          fillColor: const Color(0xFFF6F6F6),
                                          contentPadding:
                                              const EdgeInsets.only(left: 14),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    0, 255, 255, 255)),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    0, 255, 255, 255)),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ))),
                              Text("Пароль",
                                  style: const TextStyle(
                                      fontSize: 10, color: Color(0xFFB0B0B0))),
                              Container(
                                  padding:
                                      const EdgeInsets.only(top: 3, bottom: 4),
                                  child: SizedBox(
                                      height: 45,
                                      child: TextField(
                                        obscureText: true,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        onChanged: (value) => password = value,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14,
                                            color: Color(0xFF666666)),
                                        decoration: InputDecoration(
                                          hintText: "Пароль",
                                          filled: true,
                                          fillColor: const Color(0xFFF6F6F6),
                                          contentPadding:
                                              const EdgeInsets.only(left: 14),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    0, 255, 255, 255)),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    0, 255, 255, 255)),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ))),
                              const SizedBox(height: 10),
                              SizedBox(
                                  height: 45,
                                  width: double.infinity,
                                  child: TextButton(
                                      onPressed: () => submitSignup(),
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                          ),
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                  Colors.amber)),
                                      child: Text("Создать аккаунт",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                              color: Color(0xFF666666))))),
                            ]),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: Divider(color: Color(0xFF666666))),
                      Text("   войти с помощью   ",
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Color(0xFF666666))),
                      Expanded(
                          child: Divider(
                        color: Color(0xFF666666),
                      )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        height: 45,
                        width: 45,
                        child: Image.asset(
                          "resources/login_logo_1.png",
                          fit: BoxFit.fill,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border:
                                Border.all(width: 1, color: Color(0xFFEDEDED))),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        height: 45,
                        width: 45,
                        child: Image.asset(
                          "resources/login_logo_2.png",
                          fit: BoxFit.fill,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border:
                                Border.all(width: 1, color: Color(0xFFEDEDED))),
                      )
                    ],
                  )
                ]),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text("Recipes app 2024",
                      style: const TextStyle(
                          fontWeight: FontWeight.w200,
                          fontSize: 10,
                          color: Color(0xFF666666))),
                )
              ]),
        ),
      )
    ]);
  }
}

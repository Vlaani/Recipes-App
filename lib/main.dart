import 'package:flutter/material.dart';
import 'package:recipes_app/screens/home/home_screen.dart';
import 'package:recipes_app/screens/create/create_screen.dart';
import 'package:recipes_app/screens/profile/auth_screen.dart';
import 'package:recipes_app/screens/profile/profile_screen.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/view_model/data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentTabIndex = 0;
  final PageController _pageViewController = PageController();
  final _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  Widget _body = const SizedBox(
    height: 64,
    width: 64,
    child: CircularProgressIndicator(
      color: Colors.amber,
    ),
  );

  void setBody() {
    _body = PageView(
        controller: _pageViewController,
        onPageChanged: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        children: <Widget>[
          Navigator(
            key: _navigatorKeys[0],
            onGenerateRoute: (routeSettings) {
              return MaterialPageRoute(
                builder: (context) {
                  return HomeScreen();
                },
              );
            },
          ),
          Navigator(
            key: _navigatorKeys[1],
            onGenerateRoute: (routeSettings) {
              return MaterialPageRoute(
                builder: (context) {
                  return CreateScreen(
                    () {
                      _selectTab(2);
                    },
                  );
                },
              );
            },
          ),
          Navigator(
            key: _navigatorKeys[2],
            onGenerateRoute: (routeSettings) {
              return MaterialPageRoute(
                builder: (context) {
                  return user != null
                      ? ProfileScreen(user!, () {
                          updateUser(null);
                          setState(() {
                            setBody();
                          });
                        }, () {
                          //print("object");
                          _selectTab(1);
                          setState(() {
                            setBody();
                          });
                        })
                      : AuthenticationScreen("resources/logo.png", (u) {
                          updateUser(u);
                          setState(() {
                            setBody();
                          });
                        });
                },
              );
            },
          )
        ]);
  }

  @override
  void initState() {
    super.initState();

    fillIngredientsMap().then((value) {
      readJsonFile("user").then((value) {
        user = value != null ? User.fromJson(value) : null;
        setState(() {
          setBody();
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }

  void _selectTab(int index) {
    //print(_pageViewController);
    _pageViewController.animateToPage(index,
        duration: Duration(milliseconds: 250), curve: Curves.linear);
    _currentTabIndex = index;
    setState(() {
      _currentTabIndex = index;
    });
  }

  void updateUser(User? newData) {
    print("user updated");
    setState(() {
      user = newData;
      writeJsonFile("user", user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter App',
        theme: ThemeData(primarySwatch: Colors.amber),
        home: Container(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: SafeArea(
                top: true,
                child: PopScope(
                  canPop: false,
                  onPopInvoked: (didPop) async {
                    if (didPop) {
                      return;
                    }
                    final isFirstRouteInCurrentTab =
                        !await _navigatorKeys[_currentTabIndex]
                            .currentState!
                            .maybePop();
                    if (isFirstRouteInCurrentTab) {
                      // if not on the 'main' tab
                      if (_currentTabIndex != 0) {
                        // select 'main' tab
                        _selectTab(0);
                      }
                    }
                  },
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    resizeToAvoidBottomInset: false,
                    body: _body,
                    bottomNavigationBar: BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.search),
                          label: "Поиск",
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.add_circle_outline),
                          label: "Создание рецептов",
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.person),
                          label: "Профиль",
                        ),
                      ],
                      onTap: (index) => _selectTab(index),
                      currentIndex: _currentTabIndex,
                      unselectedItemColor: Colors.grey,
                      selectedItemColor: Colors.amber,
                    ),
                  ),
                ))));
  }
}

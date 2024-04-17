import 'package:flutter/material.dart';
import 'package:recipes_app/screens/home/home_screen.dart';
import 'package:recipes_app/screens/create/create_screen.dart';
import 'package:recipes_app/screens/profile/auth_screen.dart';
import 'package:recipes_app/screens/profile/profile_screen.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/view_model/data.dart';

User? user;
void main() {
  loadData("user")
      .then((value) => user = value != null ? User.fromJson(value) : null)
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  int _currentTabIndex = 0;
  late PageController _pageViewController;
  final _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }

  void _selectTab(int index) {
    _pageViewController.animateToPage(index,
        duration: Duration(milliseconds: 250), curve: Curves.linear);
    setState(() {
      _currentTabIndex = index;
    });
  }

  void updateUser(User newData) {
    print("user updated");
    setState(() {
      user = newData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter App',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: PopScope(
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
            resizeToAvoidBottomInset: false,
            body: PageView(controller: _pageViewController, children: <Widget>[
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
                      return CreateScreen();
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
                          ? ProfileScreen(user!)
                          : AuthenticationScreen(
                              "resources/logo.png", updateUser);
                    },
                  );
                },
              )
            ]),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: "Поиск",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline),
                  label: "Добавить рецепт",
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
        ));
  }
}
 /* Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: _currentTabIndex != tabItem.index,
      child: TabNavigator(
        _navigatorKeys[tabItem.index],
        tabItem,
      ),
    );
  }
  */

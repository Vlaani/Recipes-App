import 'package:flutter/material.dart';
import 'package:recipes_app/components/tab_navigator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentTabIndex = 0;
  final _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void _selectTab(int index) {
    setState(() => _currentTabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter App',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: WillPopScope(
          onWillPop: () async {
            final isFirstRouteInCurrentTab =
                !await _navigatorKeys[_currentTabIndex]
                    .currentState!
                    .maybePop();
            if (isFirstRouteInCurrentTab) {
              // if not on the 'main' tab
              if (_currentTabIndex != TabItem.search.index) {
                // select 'main' tab
                _selectTab(TabItem.search.index);
                // back button handled by app
                return false;
              }
            }
            return isFirstRouteInCurrentTab;
          },
          child: Scaffold(
            body: Stack(children: [
              _buildOffstageNavigator(TabItem.search),
              _buildOffstageNavigator(TabItem.create),
              _buildOffstageNavigator(TabItem.profile)
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

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: _currentTabIndex != tabItem.index,
      child: TabNavigator(
        _navigatorKeys[tabItem.index],
        tabItem,
      ),
    );
  }
}

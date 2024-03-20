import 'package:flutter/material.dart';
import 'package:recipes_app/screens/home/home_screen.dart';
import 'package:recipes_app/screens/create/create_screen.dart';
import 'package:recipes_app/screens/profile/profile_screen.dart';

enum TabItem { search, create, profile }

class TabNavigatorRoutes {
  static const String home = '/';
  static const String details = '/details';
}

class TabNavigator extends StatelessWidget {
  const TabNavigator(this.navigatorKey, this.tabItem, {Key? key})
      : super(key: key);
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.home,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) {
            switch (tabItem) {
              case TabItem.create:
                return CreateScreen();
              case TabItem.profile:
                return ProfileScreen();
              default:
                return HomeScreen();
            }
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

class ObserverNavigator extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    print('Navigated to ${route.settings.name}');
    _printArguments(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    print('Popped from ${route.settings.name}');
    _printArguments(route);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    print('Removed ${route.settings.name}');
    _printArguments(route);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    print('Replaced ${oldRoute?.settings.name} with ${newRoute?.settings.name}');
    _printArguments(newRoute);
  }

  void _printArguments(Route? route) {
    if (route != null) {
      final arguments = route.settings.arguments;
      if (arguments != null) {
        print('Arguments for ${route.settings.name}: $arguments');
      } else {
        print('No arguments for ${route.settings.name}');
      }
    }
  }
}

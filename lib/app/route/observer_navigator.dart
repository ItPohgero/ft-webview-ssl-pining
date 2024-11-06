import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ObserverNavigator extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (kDebugMode) {
      print('Navigated to ${route.settings.name}');
    }
    _printArguments(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (kDebugMode) {
      print('Popped from ${route.settings.name}');
    }
    _printArguments(route);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    if (kDebugMode) {
      print('Removed ${route.settings.name}');
    }
    _printArguments(route);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (kDebugMode) {
      print('Replaced ${oldRoute?.settings.name} with ${newRoute?.settings.name}');
    }
    _printArguments(newRoute);
  }

  void _printArguments(Route? route) {
    if (route != null) {
      final arguments = route.settings.arguments;
      if (arguments != null) {
        if (kDebugMode) {
          print('Arguments for ${route.settings.name}: $arguments');
        }
      } else {
        if (kDebugMode) {
          print('No arguments for ${route.settings.name}');
        }
      }
    }
  }
}

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:librometro/dashboard/presentation/views/create_book_page.dart';
import 'package:librometro/dashboard/presentation/views/dashboard.dart';

class AppRoutes {
  static const String home = '/';
  static const String createBook = "create-books";

  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static final Map<String, Widget Function(BuildContext)> routes = {
    home: (context) => Dashboard(),
    createBook: (context) => CreateBookPage(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final String? routeName = settings.name;
    final Widget Function(BuildContext)? routeBuilder = routes[routeName];
    if (routeBuilder != null) {
      return MaterialPageRoute(settings: settings, builder: routeBuilder);
    }
    return MaterialPageRoute(
        settings: settings,
        builder: (context) => Dashboard());
  }

  static void navigateTo(BuildContext context, String routeName,
      {Object? arguments}) {
    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushNamed(context, routeName, arguments: arguments);
    }
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  static void resetTo(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false,
        arguments: arguments);
  }

  static void navigateAndRemoveUntil(
      BuildContext context, String routeName, String removeUntilRoute,
      {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
          (routes) {
        return routes.settings.name == removeUntilRoute;
      },
      arguments: arguments,
    );
  }
}

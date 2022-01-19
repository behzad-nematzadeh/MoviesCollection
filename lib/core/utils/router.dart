import 'package:flutter/material.dart';
import 'package:moviescollection/core/enums/route_name.dart';
import 'package:moviescollection/src/presentation/pages/details_page.dart';
import 'package:moviescollection/src/presentation/pages/home_page.dart';
import 'package:moviescollection/src/presentation/pages/login_page.dart';
import 'package:moviescollection/src/presentation/pages/search_page.dart';
import 'package:moviescollection/src/presentation/pages/signup_page.dart';
import 'package:moviescollection/src/presentation/pages/splash_page.dart';
import 'package:moviescollection/src/presentation/pages/unknown_view.dart';

class AppRouting {
  static Route? generateRoute(RouteSettings settings) {
    Widget builder;
    if (settings.name == RouteName.splash.name) {
      builder = SplashPage(key: GlobalKey());
    } else if (settings.name == RouteName.login.name) {
      builder = LoginPage(key: GlobalKey());
    } else if (settings.name == RouteName.signup.name) {
      builder = SignupPage(key: GlobalKey());
    } else if (settings.name == RouteName.home.name) {
      builder = HomePage(key: GlobalKey());
    } else if (settings.name == RouteName.search.name) {
      builder = SearchPage(key: GlobalKey());
    } else if (settings.name == RouteName.details.name) {
      int id = settings.arguments as int;
      builder = DetailsPage(key: GlobalKey(), movieId: id);
    } else {
      return null;
    }

    return MaterialPageRoute(builder: (_) => builder);
  }

  static Route onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => const UnknownView());
  }
}

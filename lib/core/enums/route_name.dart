enum RouteName {
  splash,
  login,
  signup,
  home,
  search,
  details,
  setting,
}

extension RouteNameExtension on RouteName {
  String get name {
    switch (this) {
      case RouteName.splash:
        return '/Splash';
      case RouteName.login:
        return '/Login';
      case RouteName.signup:
        return '/Signup';
      case RouteName.home:
        return '/Home';
      case RouteName.search:
        return '/Search';
      case RouteName.details:
        return '/Details';
      case RouteName.setting:
        return '/Setting';
    }
  }
}

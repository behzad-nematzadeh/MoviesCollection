import 'package:flutter/material.dart';
import 'package:moviescollection/core/enums/route_name.dart';
import 'package:moviescollection/core/utils/theme.dart';
import 'package:moviescollection/core/utils/router.dart';
import 'injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const BaseApplication());
}

class BaseApplication extends StatelessWidget {
  const BaseApplication({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies Collection',
      theme: AppTheme.mainTheme,

      initialRoute: RouteName.home.name,
      onGenerateRoute: AppRouting.generateRoute,
      onUnknownRoute: AppRouting.onUnknownRoute,
    );
  }
}

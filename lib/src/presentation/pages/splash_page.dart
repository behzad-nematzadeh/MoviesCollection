import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:moviescollection/core/enums/route_name.dart';
import 'package:moviescollection/src/presentation/blocs/genre/genre_cubit.dart';
import 'package:moviescollection/src/presentation/blocs/splash/splash_cubit.dart';

import '../../../injection.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late SplashCubit _splashCubit;

  AnimationController? _animationController;
  bool isUserAuthenticated = false;

  @override
  void initState() {
    super.initState();

    _splashCubit = sl<SplashCubit>();
    _splashCubit.authenticationEvent();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.of(context).pushReplacementNamed(RouteName.home.name);
          /*if (isUserAuthenticated) {
            Navigator.of(context).pushReplacementNamed(RouteName.home.name);
          } else {
            Navigator.of(context).pushReplacementNamed(RouteName.login.name);
          }*/
        }
      });
  }

  @override
  void dispose() {
    _splashCubit.close();
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      bloc: _splashCubit,
      listener: (context, state) {
        if (state is SplashToHomePage) isUserAuthenticated = true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/movie-loading.json',
                      width: 200,
                      height: 200,
                      fit: BoxFit.scaleDown,
                      repeat: false,
                      controller: _animationController,
                      onLoaded: (composition) {
                        _animationController!
                          ..duration = composition.duration
                          ..reset()
                          ..forward();
                      },
                    ),
                    const Text(
                      'Movies Collection',
                      style: TextStyle(
                          letterSpacing: 3.0,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviescollection/core/enums/route_name.dart';
import 'package:moviescollection/src/presentation/blocs/login/login_cubit.dart';

import '../../../injection.dart';

class EmailFieldValidator {
  static String? validate(String? value) {
    return value!.isEmpty ? 'Email can\'t be empty' : null;
  }
}

class PasswordFieldValidator {
  static String? validate(String? value) {
    return value!.isEmpty ? 'Password can\'t be empty' : null;
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginCubit _loginCubit;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isProgress = false;

  String? _userName;
  String? _password;

  final Color _primary = const Color(0xFF000000);
  final Color _secondary = const Color(0xFFCC0000);

  @override
  void initState() {
    _loginCubit = sl<LoginCubit>();
    super.initState();
  }

  void _handleOnPressedObscurePassword() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  bool validateAndSave() {
    final FormState form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _loginCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      bloc: _loginCubit,
      listener: (context, state) {
        setState(() {
          _isProgress = (state is LoginLoading);
        });

        if (state is NoConnection) {
          final snackBar = SnackBar(
            content: const Text('Check Your Network Connection',
                style: TextStyle(color: Colors.white)),
            backgroundColor: _secondary,
          );
          ScaffoldMessenger.of(context)
              .hideCurrentSnackBar(reason: SnackBarClosedReason.hide);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (state is LoginError) {
          final snackBar = SnackBar(
            content: Text(state.message,
                style: const TextStyle(color: Colors.white)),
            backgroundColor: _secondary,
          );
          ScaffoldMessenger.of(context)
              .hideCurrentSnackBar(reason: SnackBarClosedReason.hide);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (state is LoginLoaded) {
          final snackBar = SnackBar(
            content: SizedBox(
              height: 32,
              child: Text(
                'Login Successful',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context).hideCurrentSnackBar(
            reason: SnackBarClosedReason.hide,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Scaffold(
        backgroundColor: _primary,
        resizeToAvoidBottomInset: false,
        body: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 32, top: 48),
                height: 50,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                        child: Image.asset(
                      'assets/images/movies.png',
                      fit: BoxFit.fill,
                      color: Colors.white,
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                margin: const EdgeInsets.only(left: 32),
                child: Row(
                  children: const <Widget>[
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.only(left: 32),
                child: Row(
                  children: const <Widget>[
                    Text(
                      'Welcome back,',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Container(
                margin: const EdgeInsets.only(left: 32),
                child: Row(
                  children: const <Widget>[
                    Text(
                      'Please login to your account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(child: Container()),
              Container(
                margin: const EdgeInsets.only(top: 32, left: 32, right: 32),
                child: TextFormField(
                  key: const Key('userName'),
                  enabled: !_isProgress,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                  decoration: InputDecoration(
                    errorBorder: _focusBorder(),
                    enabledBorder: _enableBorder(),
                    disabledBorder: _disableBorder(),
                    focusedBorder: _focusBorder(),
                    border: _focusBorder(),
                    filled: true,
                    labelText: 'UserName',
                    labelStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white54),
                  ),
                  validator: EmailFieldValidator.validate,
                  onSaved: (String? value) => _userName = value,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                margin: const EdgeInsets.only(left: 32, right: 32),
                child: TextFormField(
                  key: const Key('password'),
                  enabled: !_isProgress,
                  obscureText: _obscurePassword,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                  decoration: InputDecoration(
                    errorBorder: _focusBorder(),
                    enabledBorder: _enableBorder(),
                    disabledBorder: _disableBorder(),
                    focusedBorder: _focusBorder(),
                    border: _focusBorder(),
                    labelText: 'PASSWORD',
                    labelStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white54),
                    suffixIcon: GestureDetector(
                      onTap: _handleOnPressedObscurePassword,
                      child: Icon(
                          (_obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          color: Colors.white),
                    ),
                  ),
                  validator: PasswordFieldValidator.validate,
                  onSaved: (String? value) => _password = value,
                ),
              ),
              const SizedBox(height: 48),
              Container(
                margin: const EdgeInsets.only(left: 32, right: 32),
                child: _isProgress
                    ? const Padding(
                        padding: EdgeInsets.only(top: 42, bottom: 42),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              color: Color(0xFFCC0000)),
                        ),
                      )
                    : Column(
                        children: [
                          MaterialButton(
                            height: 60,
                            key: const Key('login'),
                            onPressed: () => validateAndSave()
                                ? _loginCubit.userLoginEvent(
                                    _userName!, _password!, 'password')
                                : null,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            padding: const EdgeInsets.all(16),
                            color: Theme.of(context).primaryColor,
                            child: Row(
                              children: <Widget>[
                                const Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                                Expanded(child: Container()),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          GestureDetector(
                            onTap: _callSignupPage,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  'Don´t have an account?',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: _secondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }

  _callSignupPage() async {
    dynamic result =
        await Navigator.of(context).pushNamed(RouteName.signup.name);
    if (result as bool) {
      final snackBar = SnackBar(
        content: SizedBox(
          height: 32,
          child: Text(
            'Registration Completed Successfully',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).hideCurrentSnackBar(
        reason: SnackBarClosedReason.hide,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _enableBorder() => const OutlineInputBorder(
      //Outline border type for TextFeild
      borderRadius: BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(
        color: Colors.white,
        width: 2,
      ));

  _disableBorder() => const OutlineInputBorder(
      //Outline border type for TextField
      borderRadius: BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(color: Colors.white38, width: 2));

  _focusBorder() => const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(
        color: Color(0xFFFF3333),
        width: 2,
      ));
}

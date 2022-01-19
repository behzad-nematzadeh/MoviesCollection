import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviescollection/injection.dart';
import 'package:moviescollection/src/presentation/blocs/signup/signup_cubit.dart';

class EmailFieldValidator {
  static String? validate(String? value) {
    return value!.isEmpty ? 'Email can\'t be empty' : null;
  }
}

class UserNameFieldValidator {
  static String? validate(String? value) {
    return value!.isEmpty ? 'UserName can\'t be empty' : null;
  }
}

class PasswordFieldValidator {
  static String? validate(String? value) {
    return value!.isEmpty ? 'Password can\'t be empty' : null;
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late SignupCubit _signupCubit;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isProgress = false;

  String? _email;
  String? _userName;
  String? _password;

  final Color _primary = const Color(0xFF000000);
  final Color _secondary = const Color(0xFFCC0000);

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
  void initState() {
    _signupCubit = sl<SignupCubit>();
    super.initState();
  }

  @override
  void dispose() {
    _signupCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      bloc: _signupCubit,
      listener: (context, state) {
        setState(() {
          _isProgress = (state is SignupLoading);
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
        } else if (state is SignupError) {
          final snackBar = SnackBar(
            content: Text(state.message,
                style: const TextStyle(color: Colors.white)),
            backgroundColor: _secondary,
          );
          ScaffoldMessenger.of(context)
              .hideCurrentSnackBar(reason: SnackBarClosedReason.hide);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (state is SignupLoaded) {
          Navigator.pop(context, true);
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
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
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
                  key: const Key('email'),
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
                    labelText: 'EMAIL',
                    labelStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white54),
                  ),
                  validator: EmailFieldValidator.validate,
                  onSaved: (String? value) => _email = value,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                margin: const EdgeInsets.only(top: 0, left: 32, right: 32),
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
                    labelText: 'User Name',
                    labelStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white54),
                  ),
                  validator: UserNameFieldValidator.validate,
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
                        padding: EdgeInsets.only(top: 18, bottom: 18),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              color: Color(0xFFCC0000)),
                        ),
                      )
                    : MaterialButton(
                        height: 60,
                        key: const Key('signUp'),
                        onPressed: () {
                          if (validateAndSave()) {
                            _signupCubit.registerEvent(
                                _userName!, _password!, _email!);
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        padding: const EdgeInsets.only(
                            left: 16, top: 16, bottom: 16, right: 16),
                        color: Theme.of(context).primaryColor,
                        child: Row(
                          children: <Widget>[
                            const Text(
                              'SIGN UP',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
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
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }

  _enableBorder() => const OutlineInputBorder(
      //Outline border type for TextField
      borderRadius: BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(color: Colors.white, width: 2));

  _disableBorder() => const OutlineInputBorder(
      //Outline border type for TextField
      borderRadius: BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(color: Colors.white38, width: 2));

  _focusBorder() => OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(color: _secondary, width: 2));
}

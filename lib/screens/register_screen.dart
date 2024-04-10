import 'package:apple_shop/bloc/authentication/auth_bloc.dart';
import 'package:apple_shop/bloc/authentication/auth_event.dart';
import 'package:apple_shop/bloc/authentication/auth_state.dart';
import 'package:apple_shop/screens/dashbord_screen.dart';
import 'package:apple_shop/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final _usernamecontroller = TextEditingController(text: "");
  final _passwordcontroller = TextEditingController(text: "");
  final _passwordConfirmcontroller = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: ViewContainer(
          usernamecontroller: _usernamecontroller,
          passwordcontroller: _passwordcontroller,
          passwordConfirmcontroller: _passwordConfirmcontroller),
    );
  }
}

class ViewContainer extends StatelessWidget {
  const ViewContainer({
    super.key,
    required TextEditingController usernamecontroller,
    required TextEditingController passwordcontroller,
    required TextEditingController passwordConfirmcontroller,
  })  : _usernamecontroller = usernamecontroller,
        _passwordcontroller = passwordcontroller,
        _passwordConfirmcontroller = passwordConfirmcontroller;

  final TextEditingController _usernamecontroller;
  final TextEditingController _passwordcontroller;
  final TextEditingController _passwordConfirmcontroller;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                Image.asset(
                  'assets/images/register_icon.png',
                ),
                const SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "نام کاربری",
                        style: TextStyle(
                          fontFamily: "sm",
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.grey[300],
                        child: TextField(
                          controller: _usernamecontroller,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "رمز عبور",
                        style: TextStyle(
                          fontFamily: "sm",
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.grey[300],
                        child: TextField(
                          controller: _passwordcontroller,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 19,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "تکرار مز عبور",
                        style: TextStyle(
                          fontFamily: "sm",
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.grey[300],
                        child: TextField(
                          controller: _passwordConfirmcontroller,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
                  if (state is AuthResponseState) {
                    state.response.fold((l) {
                      _usernamecontroller.text = '';
                      _passwordcontroller.text = '';
                      _passwordConfirmcontroller.text = '';
                      var snackBar = const SnackBar(
                        content: Text("این نام کاربری قبلا ثبت شده "),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }, (r) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const DashbordScreen(),
                      ));
                    });
                  }
                }, builder: ((context, state) {
                  if (state is AuthinitState) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(
                          fontFamily: "sb",
                          fontSize: 18,
                        ),
                        minimumSize: const Size(200, 48),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context).add(
                          AuthRegisterRequset(
                            _usernamecontroller.text,
                            _passwordcontroller.text,
                            _passwordConfirmcontroller.text,
                          ),
                        );
                      },
                      child: const Text("ثبت نام"),
                    );
                  }
                  if (state is AuthLoadingState) {
                    return const CircularProgressIndicator();
                  }
                  if (state is AuthResponseState) {
                    return state.response.fold((l) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(
                            fontFamily: "sb",
                            fontSize: 18,
                          ),
                          minimumSize: const Size(200, 48),
                        ),
                        onPressed: () {
                          BlocProvider.of<AuthBloc>(context).add(
                            AuthLoginRequset(
                              _usernamecontroller.text,
                              _passwordcontroller.text,
                            ),
                          );
                        },
                        child: const Text("ورود به حساب کاربری"),
                      );
                    }, (r) => Text(r));
                  }
                  return const Text("خطا");
                })),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return LoginScreen();
                      }),
                    );
                  },
                  child: const Text(
                    "اگر حساب کاربری دارید وارد شوید",
                    style: TextStyle(
                      fontFamily: "sb",
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

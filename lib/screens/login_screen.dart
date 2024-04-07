import 'package:apple_shop/bloc/authentication/auth_bloc.dart';
import 'package:apple_shop/bloc/authentication/auth_event.dart';
import 'package:apple_shop/bloc/authentication/auth_state.dart';
import 'package:apple_shop/screens/dashbord_screen.dart';
import 'package:apple_shop/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final _usernamecontroller = TextEditingController(text: "sizam");
  final _passwordcontroller = TextEditingController(text: "12345678");

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: ViewContainer(
          usernamecontroller: _usernamecontroller,
          passwordcontroller: _passwordcontroller),
    );
  }
}

class ViewContainer extends StatelessWidget {
  const ViewContainer({
    super.key,
    required TextEditingController usernamecontroller,
    required TextEditingController passwordcontroller,
  })  : _usernamecontroller = usernamecontroller,
        _passwordcontroller = passwordcontroller;

  final TextEditingController _usernamecontroller;
  final TextEditingController _passwordcontroller;

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
                SizedBox(
                  height: 60,
                ),
                Image.asset(
                  'assets/images/login_icon.png',
                ),
                SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "نام کاربری",
                        style: TextStyle(
                          fontFamily: "sm",
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
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
                Padding(
                  padding:
                      const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "رمز عبور",
                        style: TextStyle(
                          fontFamily: "sm",
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
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
                  height: 20,
                ),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthResponseState) {
                      state.response.fold((l) {
                        _usernamecontroller.text = '';
                        _passwordcontroller.text = '';
                        var snackBar = SnackBar(
                            content: Text("نام کاربری یا رمز عبور اشتباه است"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }, (r) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => DashbordScreen(),
                        ));
                      });
                    }
                  },
                  builder: ((context, state) {
                    if (state is AuthinitState) {
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
                    }
                    if (state is AuthLoadingState) {
                      return const CircularProgressIndicator();
                    }
                    if (state is AuthResponseState) {
                      Widget widget = Text("");
                      state.response.fold((l) {
                        widget = ElevatedButton(
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
                      }, (r) {
                        widget = Text(r);
                      });
                      return widget;
                    }
                    return Text("خطای نامشخض");
                  }),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return RegisterScreen();
                      }),
                    );
                  },
                  child: Text(
                    "ثبت نام",
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

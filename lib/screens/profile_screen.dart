import 'package:apple_shop/constants/colors.dart';
import 'package:apple_shop/screens/login_screen.dart';
import 'package:apple_shop/util/auth_manager.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundScreenColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 44, right: 44, bottom: 32, top: 20),
              child: Container(
                height: 46,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Image.asset('assets/images/icon_apple_blue.png'),
                    const Expanded(
                      child: Text(
                        "حساب کاربری",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "sb",
                          fontSize: 16,
                          color: CustomColors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Text(
              "کاربر",
              style: TextStyle(
                fontFamily: "sb",
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(100, 35),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),

              ///
              onPressed: (() {
                AuthManager.logout();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              }),
              child: Text(
                "خروج",
                style: const TextStyle(
                  fontFamily: "sb",
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Directionality(
              textDirection: TextDirection.rtl,
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [],
              ),
            ),
            const Spacer(),
            const Text(
              'اپل شاپ',
              style: TextStyle(
                fontFamily: "sm",
                fontSize: 10,
                color: CustomColors.green,
              ),
            ),
            const Text(
              'V1.0.0',
              style: TextStyle(
                fontFamily: "sm",
                fontSize: 10,
                color: CustomColors.green,
              ),
            ),
            const Text(
              "By m.e",
              style: TextStyle(
                fontFamily: "sm",
                fontSize: 10,
                color: CustomColors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

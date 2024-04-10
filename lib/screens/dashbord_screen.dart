import 'dart:ui';
import 'package:apple_shop/bloc/basket/basket_bloc.dart';
import 'package:apple_shop/bloc/basket/basket_event.dart';
import 'package:apple_shop/bloc/category/category_bloc.dart';
import 'package:apple_shop/bloc/home/home_bloc.dart';
import 'package:apple_shop/bloc/home/home_event.dart';
import 'package:apple_shop/constants/Colors.dart';
import 'package:apple_shop/di/di.dart';
import 'package:apple_shop/screens/card_screen.dart';
import 'package:apple_shop/screens/category_screen.dart';
import 'package:apple_shop/screens/home_screen.dart';
import 'package:apple_shop/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashbordScreen extends StatefulWidget {
  const DashbordScreen({super.key});

  @override
  State<DashbordScreen> createState() => _DashbordScreenState();
}

class _DashbordScreenState extends State<DashbordScreen> {
  // This widget is the root of your application.
  int selectedPageIndex = 3;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: IndexedStack(
          index: selectedPageIndex,
          children: getScreens(),
        ),
        bottomNavigationBar: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: BottomNavigationBar(
              onTap: (int index) {
                setState(() {
                  selectedPageIndex = index;
                });
              },
              currentIndex: selectedPageIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedLabelStyle: const TextStyle(
                fontFamily: "sb",
                fontSize: 10,
                color: CustomColors.blue,
              ),
              //
              unselectedLabelStyle: const TextStyle(
                fontFamily: "sb",
                fontSize: 10,
                color: Colors.black,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Image.asset("assets/images/icon_profile.png"),
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: CustomColors.blue,
                            blurRadius: 20,
                            spreadRadius: -7,
                            offset: Offset(00, 10),
                          ),
                        ],
                      ),
                      child:
                          Image.asset("assets/images/icon_profile_active.png"),
                    ),
                  ),
                  label: 'حساب کاربری',
                ),
                //
                BottomNavigationBarItem(
                  icon: Image.asset("assets/images/icon_basket.png"),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: CustomColors.blue,
                            blurRadius: 20,
                            spreadRadius: -7,
                            offset: Offset(00, 10),
                          ),
                        ],
                      ),
                      child:
                          Image.asset("assets/images/icon_basket_active.png"),
                    ),
                  ),
                  label: 'سبد خرید',
                ),
                //
                BottomNavigationBarItem(
                  icon: Image.asset("assets/images/icon_category.png"),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: CustomColors.blue,
                            blurRadius: 20,
                            spreadRadius: -7,
                            offset: Offset(00, 10),
                          ),
                        ],
                      ),
                      child:
                          Image.asset("assets/images/icon_category_active.png"),
                    ),
                  ),
                  label: 'دسته بندی',
                ),
                //
                BottomNavigationBarItem(
                  icon: Image.asset("assets/images/icon_home.png"),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: CustomColors.blue,
                            blurRadius: 20,
                            spreadRadius: -7,
                            offset: Offset(00, 10),
                          ),
                        ],
                      ),
                      child: Image.asset("assets/images/icon_home_active.png"),
                    ),
                  ),
                  label: 'خانه',
                ),
                //
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<Widget> getScreens() {
  return <Widget>[
    ProfileScreen(),
    BlocProvider(
      create: ((context) {
        var bloc = locator.get<BasketBloc>();
        bloc.add(BasketFetchFromHiveEvent());
        return bloc;
      }),
      child: const CardScreen(),
    ),
    BlocProvider(
      create: (context) => CategoryBloc(),
      child: const CategoryScreen(),
    ),
    Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) {
          var bloc = HomeBloc();
          bloc.add(HomeGetInitilzeData());
          return bloc;
        },
        child: const HomeScreen(),
      ),
    ),
  ];
}

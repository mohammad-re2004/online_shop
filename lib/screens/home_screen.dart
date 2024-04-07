import 'package:apple_shop/bloc/home/home_bloc.dart';
import 'package:apple_shop/bloc/home/home_event.dart';
import 'package:apple_shop/bloc/home/home_state.dart';
import 'package:apple_shop/constants/colors.dart';
import 'package:apple_shop/data/model/banner.dart';
import 'package:apple_shop/data/model/category.dart';
import 'package:apple_shop/data/model/product.dart';
import 'package:apple_shop/widgets/Category_icon_item_chip.dart';
import 'package:apple_shop/widgets/banner_slider.dart';
import 'package:apple_shop/widgets/loading_animation.dart';
import 'package:apple_shop/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundScreenColor,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: ((context, state) {
            return _getHomeScreenContent(state, context);
          }),
        ),
      ),
    );
  }
}

Widget _getHomeScreenContent(HomeState state, BuildContext context) {
  if (state is HomeLoadingState) {
    return const Center(
      child: LoadingAnimation(),
    );
    ////
  } else if (state is HomeRequestSuccessState) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read()<HomeBloc>(context).add(HomeGetInitilzeData());
      },
      child: CustomScrollView(
        slivers: [
          const GetSearchBox(),
          //

          state.bannerList.fold(
            (exceptionMassage) {
              return SliverToBoxAdapter(
                child: Text(exceptionMassage),
              );
            },
            (bannersList) {
              return GetBanners(bannersList);
            },
          ),

          const GetCategoryListTitle(),
          //

          state.categoryList.fold(
            (error) {
              return SliverToBoxAdapter(
                child: Text(error),
              );
            },
            (categoryList) {
              return GetCategoryList(categoryList);
            },
          ),

          const GetBestSellerTitle(),

          state.BestsellerProductList.fold(
            (error) {
              return SliverToBoxAdapter(
                child: Text(error),
              );
            },
            (productList) {
              return GetBestSellerProducts(productList);
            },
          ),

          const GetMostViewedTitle(),

          state.hotestProductList.fold(
            (error) {
              return SliverToBoxAdapter(
                child: Text(error),
              );
            },
            (productList) {
              return GetMostViewedProduct(productList);
            },
          ),
          SliverPadding(padding: EdgeInsets.all(12)),
        ],
      ),
    );
  } else {
    return const Center(
      child: Text("خطای دریافت اطلاعات"),
    );
  }
}

class GetMostViewedProduct extends StatelessWidget {
  final List<Product> productList;
  const GetMostViewedProduct(
    this.productList, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
        ),
        child: SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: PorductItem(productList[index]));
            },
            itemCount: productList.length,
          ),
        ),
      ),
    );
  }
}

class GetMostViewedTitle extends StatelessWidget {
  const GetMostViewedTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 44, right: 44, bottom: 20, top: 32),
        child: Row(
          children: [
            const Text(
              "پربازدید ترین ها",
              style: TextStyle(
                fontFamily: "sb",
                fontSize: 12,
                color: CustomColors.gery,
              ),
            ),
            const Spacer(),
            const Text(
              "مشاهده همه",
              style: TextStyle(
                fontFamily: "sb",
                color: CustomColors.blue,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Image.asset("assets/images/icon_left_categroy.png"),
          ],
        ),
      ),
    );
  }
}

class GetBestSellerProducts extends StatelessWidget {
  final List<Product> productList;
  const GetBestSellerProducts(
    this.productList, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productList.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 20),
                child: PorductItem(productList[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}

class GetBestSellerTitle extends StatelessWidget {
  const GetBestSellerTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 44, right: 44, bottom: 20),
        child: Row(
          children: [
            const Text(
              "پرفروش ترین ها",
              style: TextStyle(
                fontFamily: "sb",
                fontSize: 12,
                color: CustomColors.gery,
              ),
            ),
            const Spacer(),
            const Text(
              "مشاهده همه",
              style: TextStyle(
                fontFamily: "sb",
                color: CustomColors.blue,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Image.asset("assets/images/icon_left_categroy.png"),
          ],
        ),
      ),
    );
  }
}

class GetCategoryList extends StatelessWidget {
  final List<Category> categoryList;
  const GetCategoryList(
    this.categoryList, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoryList.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 20),
                child: CategoryItemChip(categoryList[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}

class GetCategoryListTitle extends StatelessWidget {
  const GetCategoryListTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(left: 44, right: 44, top: 32, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "دسته بندی",
              style: TextStyle(
                fontFamily: "sb",
                fontSize: 12,
                color: CustomColors.gery,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GetBanners extends StatelessWidget {
  final List<BannerChampin> bannerChampin;
  const GetBanners(
    this.bannerChampin, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      // بنر های قرزمز بلا صفحه
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 5,
        ),
        child: BannerSlider(bannerChampin),
      ),
    );
  }
}

class GetSearchBox extends StatelessWidget {
  const GetSearchBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 44, right: 44, bottom: 32, top: 20),
        child: Container(
          height: 46,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Image.asset('assets/images/icon_search.png'),
              const SizedBox(
                width: 18,
              ),
              const Expanded(
                child: Text(
                  "جست و جو",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: "sb",
                    fontSize: 16,
                    color: CustomColors.gery,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Image.asset('assets/images/icon_apple_blue.png'),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}

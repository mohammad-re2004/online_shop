import 'package:apple_shop/bloc/basket/basket_bloc.dart';

import 'package:apple_shop/constants/colors.dart';
import 'package:apple_shop/data/model/product.dart';
import 'package:apple_shop/di/di.dart';
import 'package:apple_shop/screens/product_detail_screen.dart';
import 'package:apple_shop/util/extenstions/double_extenstions.dart';
import 'package:apple_shop/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PorductItem extends StatelessWidget {
  final Product product;
  const PorductItem(
    this.product, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider<BasketBloc>.value(
              value: locator.get<BasketBloc>(),
              child: ProductDetailScreen(product),
            ),
          ),
        );
      },
      child: Container(
        //کانتینر سفید
        width: 160,
        height: 100,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Expanded(
                  child: Container(),
                ), // trick
                SizedBox(
                  width: 80,
                  height: 98,
                  child: CachedImage(
                    imageUrl: product.thumbnail,
                  ),
                ),
                Positioned(
                  top: -10,
                  right: 10,
                  child: SizedBox(
                      width: 20,
                      height: 40,
                      child:
                          Image.asset("assets/images/active_fav_product.png")),
                ),
                Positioned(
                  bottom: 0,
                  left: 5,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: CustomColors.red,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: Text(
                        "%${product.persent!.round().toString()}",
                        style: const TextStyle(
                          fontFamily: "sb",
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 18, right: 10),
                  child: Text(
                    product.name,
                    maxLines: 1,
                    style: const TextStyle(
                      fontFamily: "sm",
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  //  کاننیر آبی
                  height: 55,
                  decoration: const BoxDecoration(
                    color: CustomColors.blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: CustomColors.blue,
                        blurRadius: 25,
                        spreadRadius: -12,
                        offset: Offset(00, 15),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: [
                          const Text(
                            "تومان",
                            style: TextStyle(
                              fontFamily: "sm",
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                product.price.toString(),
                                style: const TextStyle(
                                  fontFamily: "sm",
                                  fontSize: 13,
                                  color: Colors.white,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                product.realPrice.convertToPrice(),
                                style: const TextStyle(
                                  fontFamily: "sm",
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 20,
                            child: Image.asset(
                                "assets/images/icon_right_arrow_cricle.png"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

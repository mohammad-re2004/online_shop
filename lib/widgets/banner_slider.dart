import 'package:apple_shop/constants/Colors.dart';
import 'package:apple_shop/data/model/banner.dart';
import 'package:apple_shop/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerSlider extends StatelessWidget {
  final List<BannerChampin> bannerList;
  const BannerSlider(this.bannerList, {super.key});

  @override
  Widget build(BuildContext context) {
    var controller = PageController(viewportFraction: 0.9);
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        SizedBox(
          height: 177,
          child: PageView.builder(
            controller: controller,
            itemCount: bannerList.length,
            itemBuilder: ((context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 7),
                child: CachedImage(
                  imageUrl: bannerList[index].thumbnail,
                  radius: 15,
                ),
              );
            }),
          ),
        ),
        Positioned(
          bottom: 10,
          child: SmoothPageIndicator(
            controller: controller,
            count: 3,
            effect: const ExpandingDotsEffect(
              expansionFactor: 3.0,
              dotHeight: 6,
              dotWidth: 6,
              dotColor: Colors.white,
              activeDotColor: CustomColors.blueIndicator,
            ),
          ),
        ),
      ],
    );
  }
}

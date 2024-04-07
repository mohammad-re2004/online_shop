import 'dart:ui';
import 'package:apple_shop/bloc/basket/basket_bloc.dart';
import 'package:apple_shop/bloc/basket/basket_event.dart';
import 'package:apple_shop/bloc/comment/bloc/comment_bloc.dart';
import 'package:apple_shop/bloc/product/product_bloc.dart';
import 'package:apple_shop/bloc/product/product_event.dart';
import 'package:apple_shop/bloc/product/product_state.dart';
import 'package:apple_shop/constants/colors.dart';
import 'package:apple_shop/data/model/product.dart';
import 'package:apple_shop/data/model/product_image.dart';
import 'package:apple_shop/data/model/product_peroperty.dart';
import 'package:apple_shop/data/model/product_variant.dart';
import 'package:apple_shop/data/model/variant.dart';
import 'package:apple_shop/data/model/variant_type.dart';
import 'package:apple_shop/di/di.dart';
import 'package:apple_shop/widgets/cached_image.dart';
import 'package:apple_shop/widgets/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen(this.product, {super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) {
        var bloc = ProductBloc();
        bloc.add(ProductInitializeEvent(
            widget.product.id, widget.product.categoryId));
        return bloc;
      }),
      child: DetailScreenContent(parentWidget: widget),
    );
  }
}

class DetailScreenContent extends StatelessWidget {
  const DetailScreenContent({
    super.key,
    required this.parentWidget,
  });

  final ProductDetailScreen parentWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundScreenColor,
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductDetailLoadingState) {
            return const Center(
              child: LoadingAnimation(),
            );
          }
          return SafeArea(
            child: CustomScrollView(
              slivers: [
                if (state is ProductDetailLoadingState) ...{
                  const SliverToBoxAdapter(
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: LoadingAnimation(),
                      ),
                    ),
                  ),
                },

                if (state is ProductDetailResponseState) ...{
                  SliverToBoxAdapter(
                    child: Padding(
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
                            const SizedBox(width: 15),
                            Image.asset('assets/images/icon_apple_blue.png'),
                            Expanded(
                              child: state.productCategory.fold((l) {
                                return const Text(
                                  "جزیات محصول",
                                  style: TextStyle(
                                    fontFamily: "sb",
                                    fontSize: 16,
                                    color: CustomColors.blue,
                                  ),
                                );
                              }, (productCategory) {
                                return Text(
                                  productCategory.title!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: "sb",
                                    fontSize: 16,
                                    color: CustomColors.blue,
                                  ),
                                );
                              }),
                            ),
                            Image.asset("assets/images/icon_back.png"),
                            const SizedBox(
                              width: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                },

                ///
                if (state is ProductDetailResponseState) ...{
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        parentWidget.product.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: "sb",
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                },

                ///
                if (state is ProductDetailResponseState) ...{
                  state.productImages.fold((error) {
                    return SliverToBoxAdapter(
                      child: Text(error),
                    );
                  }, (productImagelist) {
                    return GalleryWidget(
                        parentWidget.product.thumbnail, productImagelist);
                  }),
                },

                ///
                if (state is ProductDetailResponseState) ...{
                  state.productVariant.fold(
                    (l) {
                      return SliverToBoxAdapter(
                        child: Text(l),
                      );
                    },
                    (productVariantList) {
                      return VariantContainerGenerator(productVariantList);
                    },
                  ),
                },

                ///
                if (state is ProductDetailResponseState) ...{
                  state.productProperties.fold((l) {
                    return SliverToBoxAdapter(
                      child: Text(l),
                    );
                  }, (propertyList) {
                    return ProductProperties(propertyList);
                  }),
                },
                //
                if (state is ProductDetailResponseState) ...{
                  ProductDescription(parentWidget.product.description),
                },

                ///
                if (state is ProductDetailResponseState) ...{
                  SliverToBoxAdapter(
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isDismissible: true,
                          isScrollControlled: true,
                          useSafeArea: true,
                          showDragHandle: true,
                          builder: (context) {
                            return BlocProvider(
                                create: (context) {
                                  final bloc = CommentBloc(locator.get());
                                  bloc.add(CommentInitializeEvent(
                                      parentWidget.product.id));
                                  return bloc;
                                },
                                child: CommentButtonsheet(
                                  productId: parentWidget.product.id,
                                ));
                          },
                        );
                      },
                      child: Container(
                        height: 46,
                        margin:
                            const EdgeInsets.only(left: 44, right: 44, top: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(width: 1, color: CustomColors.gery),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Image.asset("assets/images/icon_left_categroy.png"),
                            const SizedBox(width: 10),
                            const Text(
                              "مشاهده",
                              style: TextStyle(
                                fontFamily: "sb",
                                fontSize: 12,
                                color: CustomColors.blue,
                              ),
                            ),
                            const Spacer(),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    margin: const EdgeInsets.only(left: 10),
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Image.asset(
                                      "assets/images/avatar.png",
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 15,
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    margin: const EdgeInsets.only(left: 10),
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Image.asset(
                                      "assets/images/avatar.png",
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 30,
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    margin: const EdgeInsets.only(left: 10),
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Image.asset(
                                      "assets/images/avatar.png",
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 45,
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    margin: const EdgeInsets.only(left: 10),
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      color: Colors.grey,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "+10",
                                        style: TextStyle(
                                          fontFamily: "sb",
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              ": نظرات کاربران",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "sm",
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                },

                ///
                if (state is ProductDetailResponseState) ...{
                  const SliverPadding(padding: EdgeInsets.only(top: 20)),
                  SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const PriceTagButton(),
                        AddToBasketButton(parentWidget.product),
                      ],
                    ),
                  ),
                },
              ],
            ),
          );
        },
      ),
    );
  }
}

class CommentButtonsheet extends StatelessWidget {
  CommentButtonsheet({
    required this.productId,
    super.key,
  });

  final String productId;

  final TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        if (state is CommentLoading) {
          const Center(
            child: LoadingAnimation(),
          );
        }

        return Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  ///
                  if (state is CommentResponse) ...{
                    state.response.fold((l) {
                      return const SliverToBoxAdapter(
                        child: Text("خطا"),
                      );
                    }, (commentList) {
                      if (commentList.isEmpty) {
                        return const SliverToBoxAdapter(
                          child: Center(
                            child: Text("کامنتی برای این محصول وجود ندارد"),
                          ),
                        );
                      }
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Container(
                              padding: const EdgeInsets.all(16.0),
                              margin: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          (commentList[index].username.isEmpty)
                                              ? "کاربر"
                                              : commentList[index].username,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          textAlign: TextAlign.end,
                                          commentList[index].text,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Image.asset(
                                      "assets/images/avatar.png",
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: commentList.length,
                        ),
                      );
                    })
                  }
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(
                          fontFamily: "sm",
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              BorderSide(color: CustomColors.blue, width: 3),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    ///
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Positioned(
                            child: Container(
                              height: 60,
                              decoration: const BoxDecoration(
                                color: CustomColors.blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                            ),
                          ),
                          Positioned(
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    if (textController.text.isEmpty) {
                                      return;
                                    }

                                    ///
                                    context.read<CommentBloc>().add(
                                          CommentPostEvent(
                                            textController.text,
                                            productId,
                                          ),
                                        );
                                    textController.text = "";
                                  },
                                  child: const SizedBox(
                                    height: 60,
                                    width: 340,
                                    child: Center(
                                      child: Text(
                                        "افزودن نظر",
                                        style: TextStyle(
                                          fontFamily: 'sb',
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProductProperties extends StatefulWidget {
  final List<Property> productPropertyList;
  const ProductProperties(
    this.productPropertyList, {
    super.key,
  });

  @override
  State<ProductProperties> createState() => _ProductPropertiesState();
}

class _ProductPropertiesState extends State<ProductProperties> {
  bool _isvisiable = false;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isvisiable = !_isvisiable;
              });
            },
            child: Container(
              height: 46,
              margin: const EdgeInsets.only(left: 44, right: 44, top: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: CustomColors.gery),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Image.asset("assets/images/icon_left_categroy.png"),
                  const SizedBox(width: 10),
                  const Text(
                    "مشاهده",
                    style: TextStyle(
                      fontFamily: "sb",
                      fontSize: 12,
                      color: CustomColors.blue,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    ": مشخصات فنی",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "sm",
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),

          ///
          Visibility(
            visible: _isvisiable,
            child: Container(
              margin: const EdgeInsets.only(left: 44, right: 44, top: 24),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: CustomColors.gery),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.productPropertyList.length,
                itemBuilder: (BuildContext context, int index) {
                  var property = widget.productPropertyList[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          '${property.value!} : ${property.title!}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontFamily: 'sm',
                            fontSize: 14,
                            height: 1.8,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDescription extends StatefulWidget {
  final String productDescription;

  const ProductDescription(
    this.productDescription, {
    super.key,
  });

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool _isVisible = false;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isVisible = !_isVisible;
              });
            },
            child: Container(
              height: 46,
              margin: const EdgeInsets.only(left: 44, right: 44, top: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: CustomColors.gery),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Image.asset("assets/images/icon_left_categroy.png"),
                  const SizedBox(width: 10),
                  const Text(
                    "مشاهده",
                    style: TextStyle(
                      fontFamily: "sb",
                      fontSize: 12,
                      color: CustomColors.blue,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    ":  توضیحات محصول",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "sm",
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),

          ///
          Visibility(
            visible: _isVisible,
            child: Container(
              height: 70,
              margin: const EdgeInsets.only(left: 40, right: 44, top: 20),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1, color: CustomColors.gery),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: Text(
                widget.productDescription,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.8,
                  fontFamily: "sm",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VariantContainerGenerator extends StatelessWidget {
  //VariantType variantType;
  final List<ProductVariant> productVariantList;
  const VariantContainerGenerator(
    //this.variantType,
    this.productVariantList, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          for (var productVariant in productVariantList) ...{
            if (productVariant.variantList.isNotEmpty) ...{
              VariantGeneratorchild(productVariant),
            },
          },
        ],
      ),
    );
  }
}

class VariantGeneratorchild extends StatelessWidget {
  final ProductVariant _productVariant;
  const VariantGeneratorchild(this._productVariant, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 44, right: 44, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _productVariant.variantType.title!,
            style: const TextStyle(
              fontFamily: "sm",
              fontSize: 12,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (_productVariant.variantType.type == VariantTypeEnum.COLOR) ...{
            ColorVariantList(_productVariant.variantList),
          },
          if (_productVariant.variantType.type == VariantTypeEnum.STORAGE) ...{
            StorageVariantList(_productVariant.variantList),
          },
        ],
      ),
    );
  }
}

class GalleryWidget extends StatefulWidget {
  final List<ProductImage> productImagesList;
  final String? defaultProductThumbnail;
  const GalleryWidget(
    this.defaultProductThumbnail,
    this.productImagesList, {
    super.key,
  });

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  int selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 44,
        ),
        child: Container(
          height: 284,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset("assets/images/icon_star.png"),
                          const SizedBox(
                            width: 2,
                          ),
                          const Text(
                            '4.6',
                            style: TextStyle(
                              fontFamily: "sm",
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 200,
                        width: 150,
                        child: CachedImage(
                          imageUrl: (widget.productImagesList.isEmpty)
                              ? widget.defaultProductThumbnail
                              : widget.productImagesList[selectedItem].imageUrl,
                        ),
                      ),
                      const Spacer(),
                      Image.asset(
                        "assets/images/icon_favorite_deactive.png",
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.productImagesList.isNotEmpty) ...{
                SizedBox(
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 44, right: 44, top: 5),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.productImagesList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedItem = index;
                            });
                          },
                          child: Container(
                            // عکس های زیر عکس اصلی
                            width: 54,
                            height: 70,
                            margin: const EdgeInsets.only(left: 50),
                            // padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                width: 1,
                                color: CustomColors.gery,
                              ),
                            ),
                            child: CachedImage(
                              imageUrl:
                                  widget.productImagesList[index].imageUrl,
                              radius: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}

class AddToBasketButton extends StatelessWidget {
  final Product product;
  AddToBasketButton(this.product, {super.key});
  var snackbar = const SnackBar(
    content: Text("محصول به سبد اضافه شد"),
    duration: Duration(seconds: 2),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Positioned(
          child: Container(
            height: 60,
            width: 140,
            decoration: const BoxDecoration(
              color: CustomColors.blue,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
          ),
        ),
        Positioned(
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: GestureDetector(
                onTap: () {
                  context.read<ProductBloc>().add(ProductAddToBasket(product));
                  context.read<BasketBloc>().add(BasketFetchFromHiveEvent());
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                },
                child: const SizedBox(
                  height: 53,
                  width: 160,
                  child: Center(
                    child: Text(
                      "افزودن به سبد خرید",
                      style: TextStyle(
                        fontFamily: 'sb',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PriceTagButton extends StatelessWidget {
  const PriceTagButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Positioned(
          child: Container(
            height: 60,
            width: 140,
            decoration: const BoxDecoration(
              color: CustomColors.green,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
          ),
        ),
        Positioned(
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: 53,
                width: 160,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
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
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "49.800.000",
                              style: TextStyle(
                                fontFamily: "sm",
                                fontSize: 13,
                                color: Colors.white,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "47.800.000",
                              style: TextStyle(
                                fontFamily: "sm",
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          decoration: const BoxDecoration(
                            color: CustomColors.red,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: const Padding(
                            padding:
                                EdgeInsets.only(right: 2, top: 2, bottom: 2),
                            child: Text(
                              "%3",
                              style: TextStyle(
                                fontFamily: "sb",
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ColorVariantList extends StatefulWidget {
  final List<Variant> variantList;
  const ColorVariantList(this.variantList, {super.key});

  @override
  State<ColorVariantList> createState() => _ColorVariantListState();
}

class _ColorVariantListState extends State<ColorVariantList> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: 26,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.variantList.length,
          itemBuilder: (BuildContext context, int index) {
            String categoryColor = 'ff${widget.variantList[index].value}';
            int hexColor = int.parse(categoryColor, radix: 16);
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: Container(
                width: 26,
                height: 26,
                margin: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  border: (_selectedIndex == index)
                      ? Border.all(
                          width: 6.0,
                          color: Colors.white,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )
                      : Border.all(width: 2.0, color: Colors.white),
                  color: Color(hexColor),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class StorageVariantList extends StatefulWidget {
  final List<Variant> storagevariants;
  const StorageVariantList(this.storagevariants, {super.key});

  @override
  State<StorageVariantList> createState() => _StorgeVariantListState();
}

class _StorgeVariantListState extends State<StorageVariantList> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: 26,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.storagevariants.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: Container(
                height: 25,
                margin: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: (_selectedIndex == index)
                      ? Border.all(
                          width: 6.0,
                          color: CustomColors.blueIndicator,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )
                      : Border.all(width: 2.0, color: CustomColors.gery),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Center(
                    child: Text(
                      widget.storagevariants[index].value!,
                      style: const TextStyle(
                        fontFamily: "sb",
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

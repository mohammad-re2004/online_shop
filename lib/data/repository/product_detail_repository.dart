import 'package:apple_shop/data/datasource/product_detail_datasource.dart';
import 'package:apple_shop/data/model/category.dart';
import 'package:apple_shop/data/model/product_image.dart';
import 'package:apple_shop/data/model/product_peroperty.dart';
import 'package:apple_shop/data/model/product_variant.dart';
import 'package:apple_shop/data/model/variant_type.dart';
import 'package:apple_shop/di/di.dart';
import 'package:apple_shop/util/api_exception.dart';
import 'package:dartz/dartz.dart';

abstract class IDetailProductRepository {
  Future<Either<String, List<ProductImage>>> getProductImage(String productId);
  Future<Either<String, List<VariantType>>> getVariantTypes();
  Future<Either<String, List<ProductVariant>>> getProductVariants(
      String productId);
  Future<Either<String, Category>> getProductCategory(String categoryId);
  Future<Either<String, List<Property>>> getProductProperties(String productId);
}

class DetailProductRepository extends IDetailProductRepository {
  final IDetailProductDatasource _datasource = locator.get();
  @override
  Future<Either<String, List<ProductImage>>> getProductImage(
      String productId) async {
    try {
      var response = await _datasource.getGallery(productId);
      return right(response);
    } on ApiException catch (ex) {
      return left(ex.message ?? 'خطا محتوای متنی ندارد');
    }
  }

  @override
  Future<Either<String, List<VariantType>>> getVariantTypes() async {
    try {
      var response = await _datasource.getVariantType();
      return right(response);
    } on ApiException catch (ex) {
      return left(ex.message ?? 'خطا محتوای متنی ندارد');
    }
  }

  @override
  Future<Either<String, List<ProductVariant>>> getProductVariants(
      String productId) async {
    try {
      var response = await _datasource.getProductVariants(productId);
      return right(response);
    } on ApiException catch (ex) {
      return left(ex.message ?? 'خطا محتوای متنی ندارد');
    }
  }

  @override
  Future<Either<String, Category>> getProductCategory(String categoryId) async {
    try {
      var response = await _datasource.getProductCategory(categoryId);
      return right(response);
    } on ApiException catch (ex) {
      return left(ex.message ?? 'خطا محتوای متنی ندارد');
    }
  }

  @override
  Future<Either<String, List<Property>>> getProductProperties(
      String productId) async {
    try {
      var response = await _datasource.getProductProperties(productId);
      return right(response);
    } on ApiException catch (ex) {
      return left(ex.message ?? 'خطا محتوای متنی ندارد');
    }
  }
}

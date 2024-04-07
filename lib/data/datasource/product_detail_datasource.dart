import 'package:apple_shop/data/model/category.dart';
import 'package:apple_shop/data/model/product_image.dart';
import 'package:apple_shop/data/model/product_peroperty.dart';
import 'package:apple_shop/data/model/product_variant.dart';
import 'package:apple_shop/data/model/variant.dart';
import 'package:apple_shop/data/model/variant_type.dart';
import 'package:apple_shop/di/di.dart';
import 'package:apple_shop/util/api_exception.dart';
import 'package:dio/dio.dart';

abstract class IDetailProductDatasource {
  Future<List<ProductImage>> getGallery(String productId);
  Future<List<VariantType>> getVariantType();
  Future<List<Variant>> getVariants(String productId);
  Future<List<ProductVariant>> getProductVariants(String productId);
  Future<Category> getProductCategory(String categoryId);
  Future<List<Property>> getProductProperties(String productId);
}

class DetailProductRemoteDatasource extends IDetailProductDatasource {
  final Dio _dio = locator.get();
  @override
  Future<List<ProductImage>> getGallery(String productId) async {
    try {
      Map<String, String> qParams = {'filter': 'product_id ="$productId"'};
      var respones = await _dio.get("collections/gallery/records",
          queryParameters: qParams);
      return respones.data['items']
          .map<ProductImage>((jsonObject) => ProductImage.fromJson(jsonObject))
          .toList();
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiException(0, 'unknown erorr');
    }
  }

  @override
  Future<List<VariantType>> getVariantType() async {
    try {
      var respones = await _dio.get("collections/variants_type/records");
      return respones.data['items']
          .map<VariantType>((jsonObject) => VariantType.fromjson(jsonObject))
          .toList();
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiException(0, 'unknown erorr');
    }
  }

  @override
  Future<List<Variant>> getVariants(String productId) async {
    try {
      Map<String, String> qParams = {'filter': 'product_id ="$productId"'};
      var respones = await _dio.get("collections/variants/records",
          queryParameters: qParams);
      return respones.data['items']
          .map<Variant>((jsonObject) => Variant.fromjson(jsonObject))
          .toList();
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiException(0, 'unknown erorr');
    }
  }

  @override
  Future<List<ProductVariant>> getProductVariants(String productId) async {
    try {
      var variantTypeList = await getVariantType();
      var VariantList = await getVariants(productId);
      List<ProductVariant> productVariantList = [];

      for (var VariantType in variantTypeList) {
        var variant =
            VariantList.where((element) => element.typeId == VariantType.id)
                .toList();
        productVariantList.add(ProductVariant(VariantType, variant));
      }
      return productVariantList;
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiException(0, 'unknown erorr');
    }
  }

  @override
  Future<Category> getProductCategory(String categoryId) async {
    try {
      Map<String, String> qParams = {'filter': 'id="$categoryId"'};
      var response = await _dio.get("collections/category/records",
          queryParameters: qParams);
      return Category.fromMapJson(response.data['items'][0]);
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiException(0, 'unknown erorr');
    }
  }

  @override
  Future<List<Property>> getProductProperties(String productId) async {
    try {
      Map<String, String> qParams = {'filter': 'product_id="$productId"'};

      var respones = await _dio.get('collections/properties/records',
          queryParameters: qParams);

      return respones.data['items']
          .map<Property>((jsonObject) => Property.fromJson(jsonObject))
          .toList();
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiException(0, 'unknown erorr');
    }
  }
}

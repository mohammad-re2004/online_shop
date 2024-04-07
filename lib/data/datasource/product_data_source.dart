import 'package:apple_shop/data/model/product.dart';
import 'package:apple_shop/di/di.dart';
import 'package:apple_shop/util/api_exception.dart';
import 'package:dio/dio.dart';

abstract class IProductDatasource {
  Future<List<Product>> getProducts();
  Future<List<Product>> getHotest();
  Future<List<Product>> getBestSeller();
}

class ProductRemoteDatasource extends IProductDatasource {
  final Dio _dio = locator.get();
  @override
  Future<List<Product>> getProducts() async {
    try {
      var respones = await _dio.get('collections/products/records');
      return respones.data['items']
          .map<Product>((jsonObject) => Product.fromJson(jsonObject))
          .toList();
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiException(0, 'unknown erorr');
    }
  }

  @override
  Future<List<Product>> getBestSeller() async {
    try {
      Map<String, String> qParams = {'filter': 'popularity="Best Seller"'};
      var respones = await _dio.get('collections/products/records',
          queryParameters: qParams);
      return respones.data['items']
          .map<Product>((jsonObject) => Product.fromJson(jsonObject))
          .toList();
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiException(0, 'unknown erorr');
    }
  }

  @override
  Future<List<Product>> getHotest() async {
    try {
      Map<String, String> qParams = {'filter': 'popularity="Hotest"'};
      var respones = await _dio.get('collections/products/records',
          queryParameters: qParams);
      return respones.data['items']
          .map<Product>((jsonObject) => Product.fromJson(jsonObject))
          .toList();
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiException(0, 'unknown erorr');
    }
  }
}

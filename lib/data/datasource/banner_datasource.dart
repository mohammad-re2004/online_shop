import 'package:apple_shop/data/model/banner.dart';
import 'package:apple_shop/di/di.dart';
import 'package:apple_shop/util/api_exception.dart';
import 'package:dio/dio.dart';

abstract class IBannerDatasource {
  Future<List<BannerChampin>> getBanners();
}

class BannerRemoteDatasource extends IBannerDatasource {
  final Dio _dio = locator.get();
  @override
  Future<List<BannerChampin>> getBanners() async {
    try {
      var respones = await _dio.get('collections/banner/records');
      return respones.data['items']
          .map<BannerChampin>(
              (jsonObject) => BannerChampin.fromJson(jsonObject))
          .toList();
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiException(0, 'unknown erorr');
    }
  }
}

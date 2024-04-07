import 'package:apple_shop/bloc/categoryProduct/category_product_event.dart';
import 'package:apple_shop/bloc/categoryProduct/category_product_state.dart';
import 'package:apple_shop/data/repository/category_product_repository.dart';
import 'package:apple_shop/di/di.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryProductBloc
    extends Bloc<CategoryProductEvent, CategoryProductState> {
  final ICategoryProductRepository _repository = locator.get();
  CategoryProductBloc() : super(CategoryProductLoadingState()) {
    on<CategoryProductInitialize>((event, emit) async {
      var response = await _repository.getProductByCategoryId(event.categoryId);
      emit(CategoryProductResponseSuccessState(response));
    });
  }
}

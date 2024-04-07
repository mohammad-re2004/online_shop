import 'package:apple_shop/bloc/basket/basket_event.dart';
import 'package:apple_shop/bloc/basket/basket_state.dart';
import 'package:apple_shop/data/repository/basket_repository.dart';
import 'package:apple_shop/util/pyament_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasketBloc extends Bloc<BasketEvent, BasketState> {
  final IBasketRepository _basketRepository;
  final PaymentHandler _paymentHandler;

  BasketBloc(this._paymentHandler, this._basketRepository)
      : super(BasketInitState()) {
    on<BasketFetchFromHiveEvent>(((event, emit) async {
      var basketItemList = await _basketRepository.getAllBasketItems();
      var finalPrice = await _basketRepository.getBasketFinalPrice();

      emit(BasketDataFetchedState(basketItemList, finalPrice));
    }));

    on<BasketPaymentInitEvent>(((event, emit) async {
      var finalPrice = await _basketRepository.getBasketFinalPrice();
      _paymentHandler.initPaymentRequest(finalPrice);
    }));

    on<BasketPaymentRequestEvent>(((event, emit) async {
      _paymentHandler.sendPaymentRequest();
    }));

    on<BasketRmoveProductEvent>(((event, emit) async {
      _basketRepository.deleteProduct(event.index);
      var basketItemList = await _basketRepository.getAllBasketItems();
      var finalPrice = await _basketRepository.getBasketFinalPrice();

      emit(BasketDataFetchedState(basketItemList, finalPrice));
    }));
  }
}

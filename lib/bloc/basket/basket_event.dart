abstract class BasketEvent {}

class BasketFetchFromHiveEvent extends BasketEvent {}

class BasketPaymentInitEvent extends BasketEvent {}

class BasketPaymentRequestEvent extends BasketEvent {}

class BasketRmoveProductEvent extends BasketEvent {
  int index;
  BasketRmoveProductEvent(this.index);
}

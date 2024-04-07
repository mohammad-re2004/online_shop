import 'package:apple_shop/util/extenstions/string_extenstions.dart';
import 'package:apple_shop/util/url_handler.dart';
import 'package:uni_links/uni_links.dart';
import 'package:zarinpal/zarinpal.dart';

abstract class PaymentHandler {
  Future<void> initPaymentRequest(int finalPrice);
  Future<void> sendPaymentRequest();
  Future<void> verifyPaymentRequest();
}

class ZarinpalPaymentHandler extends PaymentHandler {
  ZarinpalPaymentHandler(this.urlHandler);
  final PaymentRequest _paymentRequest = PaymentRequest();
  String? _authority;
  String? _status;
  UrlHandler urlHandler;

  @override
  Future<void> initPaymentRequest(int finalPrice) async {
    _paymentRequest.setIsSandBox(true);
    _paymentRequest.setAmount(finalPrice);
    _paymentRequest.setDescription("this just for test");
    _paymentRequest.setMerchantID('77d52d3e-e902-4569-84fe-18062f8a928e');
    _paymentRequest.setCallbackURL("reza://shop");

    linkStream.listen((deeplink) {
      if (deeplink!.toLowerCase().contains('authority')) {
        _authority = deeplink.extractValueFromQuery('Authority');
        _status = deeplink.extractValueFromQuery('Status');
        verifyPaymentRequest();

        // print(authority);
        // print(status);
      }
    });
  }

  @override
  Future<void> sendPaymentRequest() async {
    ZarinPal().startPayment(_paymentRequest, (status, paymentGatewayUri) {
      if (status == 100) {
        urlHandler.openUrl(paymentGatewayUri!);
      }
    });
  }

  @override
  Future<void> verifyPaymentRequest() async {
    ZarinPal().verificationPayment(_status!, _authority!, _paymentRequest,
        (isPaymentSuccess, refID, paymentRequest) {
      if (isPaymentSuccess) {
        print(refID);
      } else {
        print("error");
      }
    });
  }
}

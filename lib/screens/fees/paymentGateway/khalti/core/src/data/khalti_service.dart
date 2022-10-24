// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:infixedu/screens/fees/paymentGateway/khalti/core/src/config/url.dart';
import 'package:infixedu/screens/fees/paymentGateway/khalti/core/src/core/http_client/http_response.dart'
    as HTTPResponse;
import '../../khalti_core.dart';

class KhaltiService {
  final String _baseUrl = 'https://khalti.com';
  final int _apiVersion = 5;

  final KhaltiClient _client;

  static bool enableDebugging = false;
  static String _publicKey;

  static String get publicKey {
    assert(
      _publicKey != null,
      'Provide a public key using "KhaltiService.publicKey = <khalti-pk>;"',
    );
    return _publicKey;
  }

  static set publicKey(String key) => _publicKey = key;

  static KhaltiConfig config = KhaltiConfig.sourceOnly();

  KhaltiService({@required KhaltiClient client}) : _client = client;

  Future<BankListModel> getBanks(
      {@required BankPaymentType paymentType}) async {
    final params = {
      'page': '1',
      'page_size': '200',
      'payment_type': paymentType.value,
    };

    final url = _buildUrl(banks);
    final logger = _Logger('GET', url);

    logger.request(params);
    final response = await _client.get(url, params);
    logger.response(response);

    if (response is HTTPResponse.ExceptionHttpResponse) {
      throw response.message;
    } else if (response is HTTPResponse.FailureHttpResponse) {
      throw response.data;
    } else {
      return BankListModel.fromMap(response.data as Map<String, dynamic>);
    }
  }

  Future<PaymentInitiationResponseModel> initiatePayment({
    @required PaymentInitiationRequestModel request,
  }) async {
    final url = _buildUrl(initiateTransaction);
    final logger = _Logger('POST', url);

    logger.request(request);
    final response = await _client.post(url, request.toMap());
    logger.response(response);

    if (response is HTTPResponse.ExceptionHttpResponse) {
      throw response.message;
    } else if (response is HTTPResponse.FailureHttpResponse) {
      throw response.data;
    } else {
      return PaymentInitiationResponseModel.fromMap(
        response.data as Map<String, dynamic>,
      );
    }
  }

  Future<PaymentConfirmationResponseModel> confirmPayment({
    @required PaymentConfirmationRequestModel request,
  }) async {
    final url = _buildUrl(confirmTransaction);
    final logger = _Logger('POST', url);

    logger.request(request);
    final response = await _client.post(url, request.toMap());
    logger.response(response);

    if (response is HTTPResponse.ExceptionHttpResponse) {
      throw response.message;
    } else if (response is HTTPResponse.FailureHttpResponse) {
      throw response.data;
    } else {
      return PaymentConfirmationResponseModel.fromMap(
        response.data as Map<String, dynamic>,
      );
    }
  }

  String buildBankUrl({
    @required String bankId,
    @required String mobile,
    @required int amount,
    @required String productIdentity,
    @required String productName,
    @required BankPaymentType paymentType,
    @required String returnUrl,
  }) {
    final params = {
      'bank': bankId,
      'public_key': publicKey,
      'amount': amount.toString(),
      'mobile': mobile,
      'product_identity': productIdentity,
      'product_name': productName,
      ...config.raw,
      'return_url': returnUrl,
      'payment_type': paymentType.value,
    };
    final uri = Uri.https('khalti.com', 'ebanking/initiate/', params);
    return uri.toString();
  }

  String _buildUrl(String path) {
    return '$_baseUrl/api/v$_apiVersion/$path';
  }
}

class _Logger {
  _Logger(this.method, this.url);

  final String method;
  final String url;

  void request(Object data) {
    _divider();
    _logHeading();
    _log(
      data.toString(),
      name: method == 'GET' ? 'Query Parameters' : 'Request Data',
    );
    _divider();
  }

  void response(HttpResponse response) {
    _divider();
    _logHeading();
    _log(response.toString(), name: 'Response');
    _divider();
  }

  void _logHeading() => _log(url, name: method);

  void _log(String message, {@required String name}) {
    if (KhaltiService.enableDebugging) print('[$name] $message');
  }

  void _divider() {
    if (KhaltiService.enableDebugging) print('-' * 140);
  }
}

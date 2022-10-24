// Dart imports:
import 'dart:async';
import 'dart:convert' as convert;
import 'dart:developer';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart';

// Project imports:
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/utils/model/PaypalResponse.dart';

class PaypalServices {
  String domain = paypalDomain;

  Future<String> getAccessToken() async {
    try {
      Uri url =
          Uri.parse('$domain/v1/oauth2/token?grant_type=client_credentials');
      var client = BasicAuthClient(paypalClientId, paypalClientSecret);
      var response = await client.post(url);
      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        print(body["access_token"]);
        return body["access_token"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // for creating the payment request with Paypal
  Future<Map<String, String>> createPaypalPayment(
      transactions, accessToken) async {
    try {
      Uri url = Uri.parse('$domain/v1/payments/payment');
      var response = await http.post(url,
          body: convert.jsonEncode(transactions),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        return null;
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  // for executing the payment transaction
  Future<PaypalResponse> executePayment(url, payerId, accessToken) async {
    try {
      final uri = Uri.parse(url);
      var response = await http.post(uri,
          body: convert.jsonEncode({"payer_id": payerId}),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      log(response.body);
      // final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        final paypalResponse = paypalResponseFromJson(response.body);
        return paypalResponse;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';

class SSLPinning {
  SSLPinning._();

  static Future<HttpClient> createHttpClient() async {
    final sslCert = await rootBundle.load('core/certificates/certificate.pem');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    return HttpClient(context: securityContext);
  }

  static Future<http.Client> createPinnedClient() async {
    final httpClient = await createHttpClient();
    return IOClient(httpClient);
  }
}

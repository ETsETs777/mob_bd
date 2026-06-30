import 'dart:io';

import 'package:shelf/shelf.dart';

/// Client IP for rate limiting (supports reverse proxy headers).
String clientIp(Request request) {
  final forwarded = request.headers['x-forwarded-for'];
  if (forwarded != null && forwarded.trim().isNotEmpty) {
    return forwarded.split(',').first.trim();
  }
  final realIp = request.headers['x-real-ip'];
  if (realIp != null && realIp.trim().isNotEmpty) {
    return realIp.trim();
  }
  final info = request.context['shelf.io.connection_info'];
  if (info is HttpConnectionInfo) {
    return info.remoteAddress.address;
  }
  return 'unknown';
}

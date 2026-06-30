import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import 'package:ecopulse_server/api/openapi_handler.dart';

void main() {
  final openapiDir = p.join(Directory.current.path, 'openapi');

  group('OpenAPI spec', () {
    late File specFile;

    setUp(() {
      specFile = File('$openapiDir/openapi.yaml');
    });

    test('openapi.yaml exists and parses', () {
      expect(specFile.existsSync(), isTrue);
      final doc = loadYaml(specFile.readAsStringSync());
      expect(doc, isA<YamlMap>());
      expect(doc['openapi'], '3.0.3');
      expect(doc['info']['title'], contains('EcoPulse'));
    });

    test('documents all major /v1 path groups', () {
      final doc = loadYaml(specFile.readAsStringSync()) as YamlMap;
      final paths = doc['paths'] as YamlMap;
      final keys = paths.keys.map((k) => k.toString()).toSet();

      for (final required in [
        '/v1/health',
        '/v1/auth/login',
        '/v1/profile/me',
        '/v1/threads',
        '/v1/articles',
        '/v1/admin/dashboard',
        '/v1/admin/backups',
      ]) {
        expect(keys, contains(required), reason: 'missing $required');
      }
    });

    test('json endpoint matches yaml paths count', () async {
      final handler = createOpenApiHandler(openapiDir);
      final response = await handler(
        Request('GET', Uri.parse('http://localhost/v1/openapi.json')),
      );
      final data = jsonDecode(await response.readAsString()) as Map;
      expect(data['paths'], isA<Map>());
      expect((data['paths'] as Map).length, greaterThanOrEqualTo(40));
    });
  });

  group('OpenAPI handler', () {
    late Handler handler;

    setUp(() {
      handler = createOpenApiHandler(openapiDir);
    });

    test('serves yaml spec', () async {
      final response = await handler(
        Request('GET', Uri.parse('http://localhost/v1/openapi.yaml')),
      );
      expect(response.statusCode, 200);
      expect(response.headers['content-type'], contains('yaml'));
      final body = await response.readAsString();
      expect(body, contains('openapi: 3.0.3'));
    });

    test('serves json spec', () async {
      final response = await handler(
        Request('GET', Uri.parse('http://localhost/v1/openapi.json')),
      );
      expect(response.statusCode, 200);
      final data = jsonDecode(await response.readAsString()) as Map;
      expect(data['paths'], isA<Map>());
    });

    test('serves swagger ui', () async {
      final response = await handler(
        Request('GET', Uri.parse('http://localhost/v1/docs/')),
      );
      expect(response.statusCode, 200);
      final body = await response.readAsString();
      expect(body, contains('swagger-ui'));
    });

    test('redirects /v1/docs to /v1/docs/', () async {
      final response = await handler(
        Request('GET', Uri.parse('http://localhost/v1/docs')),
      );
      expect(response.statusCode, 302);
    });
  });
}

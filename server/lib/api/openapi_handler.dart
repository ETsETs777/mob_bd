import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:yaml/yaml.dart';

/// Раздаёт OpenAPI spec и Swagger UI из [openapiDir].
Handler createOpenApiHandler(String openapiDir) {
  final specFile = File(p.join(openapiDir, 'openapi.yaml'));
  final router = Router();

  router.get('/v1/openapi.yaml', (_) async {
    if (!specFile.existsSync()) {
      return Response.notFound('OpenAPI spec not found');
    }
    return Response.ok(
      await specFile.readAsString(),
      headers: {
        'Content-Type': 'application/yaml; charset=utf-8',
        'Cache-Control': 'no-cache',
      },
    );
  });

  router.get('/v1/openapi.json', (_) async {
    if (!specFile.existsSync()) {
      return Response.notFound('OpenAPI spec not found');
    }
    final yaml = loadYaml(await specFile.readAsString());
    return Response.ok(
      jsonEncode(_yamlToJson(yaml)),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Cache-Control': 'no-cache',
      },
    );
  });

  router.get('/v1/docs', (Request request) {
    final base = request.url.replace(path: '/v1/docs/').toString();
    return Response.found(base);
  });

  router.get('/v1/docs/', (_) {
    return Response.ok(
      _swaggerUiHtml,
      headers: {
        'Content-Type': 'text/html; charset=utf-8',
        'Cache-Control': 'no-cache',
      },
    );
  });

  return router.call;
}

String resolveOpenApiDir(String serverRoot) => p.join(serverRoot, 'openapi');

dynamic _yamlToJson(dynamic node) {
  if (node is YamlMap) {
    return {for (final e in node.entries) e.key.toString(): _yamlToJson(e.value)};
  }
  if (node is YamlList) {
    return node.map(_yamlToJson).toList();
  }
  return node;
}

/// Paths that skip the app-version gate (public docs).
bool isOpenApiPublicPath(String path) =>
    path.contains('openapi') || path.startsWith('v1/docs');

const _swaggerUiHtml = '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>EcoPulse API — Swagger UI</title>
  <link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@5/swagger-ui.css">
</head>
<body>
  <div id="swagger-ui"></div>
  <script src="https://unpkg.com/swagger-ui-dist@5/swagger-ui-bundle.js"></script>
  <script>
    SwaggerUIBundle({
      url: '/v1/openapi.yaml',
      dom_id: '#swagger-ui',
      deepLinking: true,
      presets: [SwaggerUIBundle.presets.apis],
      layout: 'BaseLayout',
    });
  </script>
</body>
</html>
''';

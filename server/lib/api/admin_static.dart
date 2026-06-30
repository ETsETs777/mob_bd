import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:shelf/shelf.dart';

/// Раздаёт статику админ-панели из [webAdminDir].
Handler createAdminStaticHandler(String webAdminDir) {
  final root = Directory(webAdminDir);
  final mime = {
    '.html': 'text/html; charset=utf-8',
    '.css': 'text/css; charset=utf-8',
    '.js': 'application/javascript; charset=utf-8',
    '.svg': 'image/svg+xml',
    '.png': 'image/png',
    '.ico': 'image/x-icon',
  };

  return (Request request) async {
    var path = request.url.path;
    if (path.startsWith('admin/')) {
      path = path.substring('admin/'.length);
    } else if (path == 'admin') {
      path = '';
    }
    if (path.isEmpty || path.endsWith('/')) {
      path = 'index.html';
    }

    final file = File(p.join(root.path, p.normalize(path)));
    if (!file.path.startsWith(root.path)) {
      return Response.forbidden('Forbidden');
    }
    if (!file.existsSync()) {
      return Response.notFound('Not found');
    }

    final ext = p.extension(file.path).toLowerCase();
    final headers = {
      'Content-Type': mime[ext] ?? 'application/octet-stream',
      'Cache-Control': 'no-cache',
    };
    return Response.ok(await file.readAsBytes(), headers: headers);
  };
}

String resolveWebAdminDir(String serverRoot) =>
    p.join(serverRoot, 'web_admin');

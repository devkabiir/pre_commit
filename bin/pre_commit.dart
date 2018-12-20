// pre_commit, Copyright (C) 2018 Dinesh Ahuja <dev@kabiir.me>.
// See the included LICENSE file for more info.

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pre_commit/pre_commit.dart';

void main([List<String> args]) {
  final user = File(p.join(pubspec.parent.path, 'bin', 'pre_commit.dart'));
  if (user.existsSync() && pubspecYaml['name'] != 'pre_commit') {
    print('Running project specific pre_commit.dart');

    exitCode = runTask('dart', [user.path]..addAll(args), pubspec.parent.path);
  } else {
    exitCode = preCommit(args.isNotEmpty ? int.tryParse(args?.first) : -1);
  }
}

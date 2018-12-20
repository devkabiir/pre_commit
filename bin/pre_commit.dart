// pre_commit, Copyright (C) 2018 Dinesh Ahuja <dev@kabiir.me>.
// See the included LICENSE file for more info.

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pre_commit/pre_commit.dart';

void main([List<String> args]) {
  final user = File(p.join(pubspec.parent.path, 'bin', 'pre_commit.dart'));
  if (user.existsSync() && pubspecYaml['name'] != 'pre_commit') {
    print('Running project specific pre_commit.dart');
    print('Running dart ${user.path} ${args.join(' ')}');
    final pr = Process.runSync(
      'dart',
      [user.path]..addAll(args),
      runInShell: Platform.isWindows,
      workingDirectory: pubspec.parent.path,
    );

    if (pr.stdout.toString().isNotEmpty) {
      print(pr.stdout);
    }
    if (pr.stderr.toString().isNotEmpty) {
      print(pr.stderr);
    }

    exitCode = pr.exitCode;
  } else {
    if (args.isNotEmpty) {
      exitCode = preCommit();
    }
  }
}

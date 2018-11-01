// pre_commit, Copyright (C) 2018 Dinesh Ahuja <dev@kabiir.me>.
// See the included LICENSE file for more info.

import 'dart:io';

import 'package:find_config/find_config.dart';
import 'package:travis_ci/travis_ci.dart' as travis;
import 'package:yaml/yaml.dart';

final _cwd = Directory.current.path;

final _scriptName =
    _scriptPath.substring(_scriptPath.lastIndexOf(Platform.pathSeparator) + 1);

final _scriptPath = Platform.script.toFilePath(windows: Platform.isWindows);

Map<String, List<String>> get _cmds {
  final pubspec = findConfig('pubspec.yaml')?.readAsStringSync();
  final Map deps = loadYaml(pubspec)['dependencies'];
  final isFlutterProject = deps?.containsKey('flutter') ?? false;

  return {
    'dartfmt': [
      '-n',
      '--set-exit-if-changed',
      '$_cwd${Platform.pathSeparator}lib',
      '$_cwd${Platform.pathSeparator}test'
    ],
    'dartanalyzer': [
      '--fatal-warnings',
      '--fatal-lints',
      '$_cwd${Platform.pathSeparator}lib',
      '$_cwd${Platform.pathSeparator}test'
    ],
  }..addEntries([
      isFlutterProject
          ? const MapEntry('flutter', ['test'])
          : const MapEntry('pub', ['run', 'test'])
    ]);
}

/// Runs tedious tasks for a dart based project in the given [workingDirectory],
/// defaults to current working directory
void preCommit({String workingDirectory}) async {
  // ignore: parameter_assignments
  workingDirectory = workingDirectory ?? _cwd;

  print(''.padLeft(80, '#'));
  print('Executing $_scriptName script from');
  print('$_scriptPath');
  print('Working directory: $workingDirectory');
  print('Is CI: ${travis.isCi}');
  print('\n'.padLeft(81, '#'));

  final cmds = _cmds;

  for (var cmd in cmds.keys) {
    print('Running "$cmd ${cmds[cmd].join(' ')}"');

    final process = Process.runSync(
      cmd,
      cmds[cmd],
      runInShell: Platform.isWindows,
      workingDirectory: workingDirectory,
    );

    print(process.stdout);
    print(process.stderr);

    if (process.exitCode != 0) {
      print('Failed $cmd with exit code: ${process.exitCode}');

      print('Please fix all of the issues before commiting your changes!');
      exit(process.exitCode);
    }
  }

  print('Everything looks fine, you can commit the changes!');
  exit(0);
}

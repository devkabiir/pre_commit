// pre_commit, Copyright (C) 2018 Dinesh Ahuja <dev@kabiir.me>.
// See the included LICENSE file for more info.

// TODO(devkabiir): auto create screenshots for all routes (`flutter run --route` can run a specific route), https://github.com/devkabiir/pre_commit/issues/2
// TODO(devkabiir): check for commit message, https://github.com/devkabiir/pre_commit/issues/1

import 'dart:io';

import 'package:find_config/find_config.dart';
import 'package:path/path.dart' as p;
import 'package:travis_ci/travis_ci.dart' as travis;
import 'package:yaml/yaml.dart';

/// Pubspec file handle
final File pubspec = findConfig('pubspec.yaml');

/// Pubspec as a map
final YamlMap pubspecYaml = loadYaml(pubspec?.readAsStringSync());

final _cwd = Directory.current.path;

final _scriptName =
    _scriptPath.substring(_scriptPath.lastIndexOf(Platform.pathSeparator) + 1);

final _scriptPath = Platform.script.toFilePath(windows: Platform.isWindows);

Map<String, List<String>> get _tasks {
  final Map deps = loadYaml(pubspec?.readAsStringSync())['dependencies'];
  final isFlutterProject = deps?.containsKey('flutter') ?? false;

  return {
    'dartfmt': [
      '-n',
      '--set-exit-if-changed',
      p.join(_cwd, 'lib'),
      p.join(_cwd, 'test'),
    ],
    'dartanalyzer': [
      '--fatal-warnings',
      '--fatal-lints',
      p.join(_cwd, 'lib'),
      p.join(_cwd, 'test'),
    ],
  }..addEntries([
      isFlutterProject
          ? const MapEntry('flutter', ['test'])
          : const MapEntry('pub', ['run', 'test'])
    ]);
}

/// Runs tedious tasks for a dart based project in the given [workingDirectory],
/// defaults to current working directory
///
/// returns exit code 0 if all [_tasks] where successful, exit code of those
/// cmds otherwise
int preCommit([int taskId, String workingDirectory]) {
  taskId ??= -1;
  // ignore: parameter_assignments
  workingDirectory = workingDirectory ?? _cwd;

  print(''.padLeft(80, '#'));
  print('Executing $_scriptName script from');
  print('$_scriptPath');
  print('Working directory: $workingDirectory');
  print('Is CI: ${travis.isCi}');
  print('\n'.padLeft(81, '#'));

  final tasks = _tasks;

  if (taskId == -1) {
    for (var task in tasks.keys) {
      exitCode = runTask(task, tasks[task], workingDirectory);

      if (exitCode != 0) {
        break;
      }
    }
  } else {
    final cmd = tasks.keys.elementAt(taskId);
    final args = tasks[cmd];

    exitCode = runTask(cmd, args, workingDirectory);
  }

  if (exitCode == 0) {
    print('Everything looks fine, you can commit the changes!');
  }

  return exitCode;
}

/// Run a task
int runTask(String cmd, List<String> args, String workingDirectory) {
  print('Running "$cmd ${args.join(' ')}"');

  final pr = Process.runSync(
    cmd,
    args,
    runInShell: Platform.isWindows,
    workingDirectory: workingDirectory,
  );

  if (pr.stdout.toString().isNotEmpty) {
    print(pr.stdout);
  }
  if (pr.stderr.toString().isNotEmpty) {
    print(pr.stderr);
  }

  if (pr.exitCode != 0) {
    print('Failed $cmd with exit code: ${pr.exitCode}');

    print('Please fix all of the issues before commiting your changes!');
  }

  return pr.exitCode;
}

import 'dart:io';
import 'dart:convert';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as path;

void main() async {
  // 创建.vscode目录（如果不存在）
  final vscodeDir = Directory('.vscode');
  if (!await vscodeDir.exists()) {
    await vscodeDir.create();
  }

  // 读取melos.yaml配置
  final melosConfig = await File('melos.yaml').readAsString();
  final melosYaml = loadYaml(melosConfig);

  final String projectName = melosYaml['name'] ?? 'flutter_monorepo';
  final Map<String, dynamic> melosScripts =
      melosYaml['scripts'] is Map ? Map<String, dynamic>.from(melosYaml['scripts']) : {};

  // 获取所有Flutter应用包
  final packages = await _findFlutterApps();

  // 生成tasks.json
  await _generateTasksJson(packages, projectName, melosScripts);

  // 生成launch.json
  await _generateLaunchJson(packages);

  print('VSCode 配置文件已成功生成！');
}

Future<List<Map<String, String>>> _findFlutterApps() async {
  final List<Map<String, String>> flutterApps = [];

  // 查找apps目录下的所有Flutter应用
  final appsDir = Directory('apps');
  if (await appsDir.exists()) {
    await for (var entity in appsDir.list()) {
      if (entity is Directory) {
        final pubspecFile = File(path.join(entity.path, 'pubspec.yaml'));
        if (await pubspecFile.exists()) {
          final pubspecContent = await pubspecFile.readAsString();
          final pubspec = loadYaml(pubspecContent);

          // 检查是否是Flutter应用
          if (pubspec['dependencies'] != null && pubspec['dependencies']['flutter'] != null) {
            flutterApps.add({
              'name': path.basename(entity.path),
              'path': entity.path,
              'main': path.join(entity.path, 'lib/main.dart'),
              'args': """['--no-enable-impeller']"""
            });
          }
        }
      }
    }
  }

  return flutterApps;
}

Future<void> _generateTasksJson(
    List<Map<String, String>> apps, String projectName, Map<String, dynamic> melosScripts) async {
  final Map<String, dynamic> tasksJson = {
    'version': '2.0.0',
    'tasks': [
      {
        'label': 'melos: bootstrap',
        'type': 'shell',
        'command': 'melos bootstrap',
        'presentation': {'reveal': 'always', 'panel': 'new'},
        'problemMatcher': [],
        'group': {'kind': 'build', 'isDefault': true}
      }
    ]
  };

  // 从melos.yaml添加脚本任务
  melosScripts.forEach((name, scriptConfig) {
    String command = '';
    String description = '';

    if (scriptConfig is Map) {
      command = 'melos run $name';
      description = scriptConfig['description'] ?? '';
    } else if (scriptConfig is String) {
      command = 'melos run $name';
    }

    if (command.isNotEmpty) {
      tasksJson['tasks'].add({
        'label': 'melos: $name',
        'type': 'shell',
        'command': command,
        'presentation': {'reveal': 'always', 'panel': 'new'},
        'problemMatcher': [],
        'detail': description
      });
    }
  });

  // 为每个应用添加运行任务
  for (final app in apps) {
    tasksJson['tasks'].add({
      'label': 'flutter: run ${app['name']}',
      'type': 'shell',
      'command': 'cd ${app['path']} && flutter run',
      'presentation': {'reveal': 'always', 'panel': 'new'},
      'problemMatcher': []
    });

    // 添加构建任务
    tasksJson['tasks'].add({
      'label': 'flutter: build ${app['name']} (debug)',
      'type': 'shell',
      'command': 'cd ${app['path']} && flutter build apk --debug',
      'presentation': {'reveal': 'always', 'panel': 'new'},
      'problemMatcher': []
    });

    tasksJson['tasks'].add({
      'label': 'flutter: build ${app['name']} (release)',
      'type': 'shell',
      'command': 'cd ${app['path']} && flutter build apk --release',
      'presentation': {'reveal': 'always', 'panel': 'new'},
      'problemMatcher': []
    });
  }

  // 写入tasks.json
  final tasksFile = File('.vscode/tasks.json');
  await tasksFile.writeAsString(JsonEncoder.withIndent('  ').convert(tasksJson));
}

Future<void> _generateLaunchJson(List<Map<String, String>> apps) async {
  final Map<String, dynamic> launchJson = {'version': '0.2.0', 'configurations': []};

  // 为每个应用添加调试配置
  for (final app in apps) {
    final appName = app['name'];
    final mainDart = app['main'];

    // 添加debug模式
    launchJson['configurations'].add({
      'name': '$appName (debug)',
      'request': 'launch',
      'type': 'dart',
      'program': mainDart,
      'flutterMode': 'debug',
    });

    // 添加profile模式
    launchJson['configurations'].add({
      'name': '$appName (profile)',
      'request': 'launch',
      'type': 'dart',
      'program': mainDart,
      'flutterMode': 'profile',
    });

    // 添加release模式
    launchJson['configurations'].add({
      'name': '$appName (release)',
      'request': 'launch',
      'type': 'dart',
      'program': mainDart,
      'flutterMode': 'release',
    });
  }

  // 写入launch.json
  final launchFile = File('.vscode/launch.json');
  await launchFile.writeAsString(JsonEncoder.withIndent('  ').convert(launchJson));
}

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart';

class AssetStruct {
  final String name;

  AssetStruct? _parent;

  AssetStruct? get parent => _parent;

  /// 檔案名稱列表
  final List<String> files;

  /// 第一層子目錄
  final List<AssetStruct> structs;

  String get path => parent == null ? name : '${parent!.path}/$name';

  /// package名稱
  /// 套件名稱, 當有值時會將路徑聲明為特定套件內的資源路徑
  /// 例如:
  /// 有值時 (packages/[packageName]/assets/images/a.png)
  /// 無值時 (assets/images/a.png)
  final String? packageName;

  /// 是否有packageName
  bool get hasPackageName => packageName != null && packageName!.isNotEmpty;

  /// 類別名稱, 當呼叫過toDartCode後才會有值
  String? classname;

  /// 取得所有層級的子目錄, 包含自己
  List<AssetStruct> get allStructs {
    final all = <AssetStruct>[];
    all.add(this);
    for (var element in structs) {
      all.add(element);
      all.addAll(element.allStructs);
    }
    return all;
  }

  AssetStruct({
    required this.name,
    required this.files,
    required this.structs,
    required this.packageName,
  });

  /// from directory
  factory AssetStruct.fromDirectory(
    Directory directory, {
    AssetStruct? parent,
    String? packageName,
  }) {
    final name = basename(directory.path);
    final files = <String>[];
    final structs = <AssetStruct>[];

    for (final entity in directory.listSync()) {
      if (entity is File) {
        files.add(basename(entity.path));
      } else if (entity is Directory) {
        structs.add(AssetStruct.fromDirectory(
          entity,
          packageName: packageName,
        ));
      }
    }

    final current = AssetStruct(
      name: name,
      files: files,
      structs: structs,
      packageName: packageName,
    );

    for (var element in structs) {
      element._parent = current;
    }

    return current;
  }

  /// to json
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'files': files,
      'structs': structs.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'AssetStruct{name: $name, files: $files, structs: $structs}';
  }

  /// to dart code
  /// [classNamePrefix] 類別名稱的前綴
  /// [fieldStatic] 所有欄位是否為static
  /// [classNamePath] 類別名稱的路徑
  /// [generateInstance] 是否產生實體
  /// [instanceName] 實體名稱
  String toDartCode({
    String classNamePrefix = '',
    bool fieldStatic = false,
    List<String> classNamePath = const [],
    bool generateInstance = false,
    String? instanceName,
  }) {
    // 第一層結構才會有前綴文字, 並且field需要是static

    final classCode = _toSelfDartCode(
      classNamePrefix: classNamePrefix,
      fieldStatic: fieldStatic,
      classNamePath: [...classNamePath, name],
      generateInstance: generateInstance,
      instanceName: instanceName,
    );

    final structCode = structs.map((e) {
      return e.toDartCode(
        classNamePrefix: classNamePrefix,
        fieldStatic: false,
        classNamePath: [...classNamePath, name],
        generateInstance: false,
        instanceName: null,
      );
    }).join('\n');

    return '$classCode\n\n$structCode';
  }

  /// 產生只有自己class的dart code
  /// [classNamePrefix] 類別名稱的前綴
  /// [fieldStatic] 所有欄位是否為static
  /// [classNamePath] 類別名稱的路徑
  /// [generateInstance] 是否產生實體
  /// [instanceName] 實體名稱
  String _toSelfDartCode({
    String classNamePrefix = '',
    bool fieldStatic = false,
    List<String> classNamePath = const [],
    bool generateInstance = false,
    String? instanceName,
  }) {
    final namePathJoin = classNamePath.join('/');
    // 大駝峰命名
    var className = namePathJoin.upperCamelCase;

    // 加上前綴
    final classNameWithPrefix = '$classNamePrefix$className';

    classname = classNameWithPrefix;

    String insCode = '';
    if (generateInstance) {
      if (instanceName?.isEmpty ?? true) {
        insCode = 'const r$className = $classNameWithPrefix._();\n';
      } else {
        insCode = 'const $instanceName = $classNameWithPrefix._();\n';
      }
    }

    // 第一個路徑代碼
    String pathCode = path;
    if (hasPackageName) {
      pathCode = 'packages/$packageName/$pathCode';
    }

    // 檔案的代碼, 先加入必定會有的path
    String filesCode = 'final path = \'$pathCode\';\n';

    for (var element in files) {
      // 名稱轉成小駝峰, 去除副檔名
      final elementName = basenameWithoutExtension(element).upperCamelCase;
      var elementPath = join(path, element);
      if (hasPackageName) {
        elementPath = 'packages/$packageName/$elementPath';
      }
      final code = 'f$elementName = \'$elementPath\';\n';
      if (fieldStatic) {
        filesCode += 'static const $code';
      } else {
        filesCode += 'final $code';
      }
    }

    String structCode = '';
    for (var element in structs) {
      final elementName = element.name.upperCamelCase;
      var elementClassName = '$namePathJoin/${element.name}'.upperCamelCase;
      elementClassName = '$classNamePrefix$elementClassName';
      if (fieldStatic) {
        final code = 'd$elementName = $elementClassName._();\n';
        structCode += 'static const $code';
      } else {
        final code = 'd$elementName = const $elementClassName._();\n';
        structCode += 'final $code';
      }
    }

    final classPattern = '''
$insCode

class $classNameWithPrefix {
  $filesCode
  $structCode
  
  const $classNameWithPrefix._();
}
    ''';

    return classPattern;
  }
}

kk() {
  // Assets.dImages.dLight.fBgChangelogNewL.upperCamelCase
}

final BB = AA.bb;

class AA {
  static final aa = '';
  static final bb = _BB();
}

class _BB {
  final bb = '';
  final cc = _CC();
}

class _CC {
  final cc = '';
}

extension NameCamelCase on String {
  String get upperCamelCase {
    final pattern = RegExp('[_./-]');
    return this.split(pattern).mapIndexed((i, e) {
      if (e.length > 1) {
        return e[0].toUpperCase() + e.substring(1);
      } else if (e.length == 1) {
        return e.toUpperCase();
      } else {
        return e;
      }
    }).join();
  }

  String get lowerCamelCase {
    final pattern = RegExp('[_./-]');
    return this.split(pattern).mapIndexed((i, e) {
      if (e.length > 1) {
        if (i == 0) {
          return e[0].toLowerCase() + e.substring(1);
        } else {
          return e[0].toUpperCase() + e.substring(1);
        }
      } else if (e.length == 1) {
        if (i == 0) {
          return e[0].toLowerCase();
        } else {
          return e[0].toUpperCase();
        }
      } else {
        return e;
      }
    }).join();
  }

  String get camelToSnakeCase =>
      replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_${match.group(0)}')
          .toLowerCase();
}

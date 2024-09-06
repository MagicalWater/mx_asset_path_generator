import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:mx_asset_path_generator/asset_struct.dart';
import 'package:path/path.dart';

/// 生成單一結構的檔案
/// 也就是只生成根目錄的檔案
void generatedWithSingleFile({
  required AssetStruct struct,
  required Directory outputDir,
  required String instanceName,
  required String partFileName,
}) {
  final code = struct.toDartCode(
    fieldStatic: false,
    generateInstance: false,
  );

  final filename = basename(outputDir.path);

  // 在code開頭加入part
  final partCode = 'part of \'$filename.dart\';';

  final formatter = DartFormatter();
  final formattedCode = formatter.format('$partCode\n$code');

  final outputFile = File(join(outputDir.path, '$filename.dart'));

  // 輸出檔案的檔名, instance將會放置在此處
  final outputFileName = basename(outputFile.path);

  // part檔案, 生成的class將會放置此處
  final partFilePath = join(outputDir.path, partFileName);
  final partFile = File(partFilePath);

  if (outputFileName == partFileName) {
    stderr.write('輸出檔案名稱不得與part檔案名稱相同, 請檢查\n');
    exit(1);
  }

  outputDir.createSync(recursive: true);
  partFile.writeAsStringSync(formattedCode);

  if (!outputFile.existsSync()) {
    // 若export檔案不存在則自動生成
    final content = '''
// 此檔案自動生成, 生成path class不會覆蓋檔案, 可在此創建調用asset的實體

part \'$partFileName\';

const $instanceName = ${struct.classname}._();
''';
    outputFile.writeAsStringSync(content);
  }
}

// /// 生層多個檔案
// /// 也就是從第一層資料夾出發
// void _generatedWithMultiFile({
//   required AssetStruct struct,
//   required Directory outputDir,
//   required String partFileName,
// }) {
//   final formatter = DartFormatter();
//   for (var element in struct.structs) {
//     final code = element.toDartCode(
//       fieldStatic: false,
//       generateInstance: true,
//     );
//     final formattedCode = formatter.format(code);
//     // 小駝峰轉蛇底式
//     final fileName = element.name.camelToSnakeCase;
//     final outputFile = File(join(outputDir.path, '$fileName.dart'));
//     outputDir.createSync(recursive: true);
//     outputFile.writeAsStringSync(formattedCode);
//   }
// }

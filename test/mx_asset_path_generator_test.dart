import 'dart:io';

import 'package:mx_asset_path_generator/mx_asset_path_generator.dart';
import 'package:test/test.dart';

void main() {
  test('generate_with_package', () {

    // 檢測目標資料夾 assets/
    // 並且asset的資源路徑來源為test_package
    final struct = AssetStruct.fromDirectory(
      Directory('assets/'),
      packageName: 'test_package',
    );

    // 輸出目標位於專案根目錄下的r/資料夾
    final outputDir = Directory('r/');

    // 進行書出
    generatedWithSingleFile(
      struct: struct,
      outputDir: outputDir,
      instanceName: 'r_aa',
      partFileName: 'r_part.dart',
    );

    // 打印全部的資料夾結構(過濾底下無檔案的), 方便複製引入pubspec.yaml
    printAllStructDir(struct);
  });
}

import 'package:mx_asset_path_generator/asset_struct.dart';

/// 打印全部的資料夾結構(過濾底下無檔案的), 方便複製引入pubspec.yaml
/// 過濾底下無檔案
/// 過濾重複path
void printAllStructDir(AssetStruct struct) {
  final allStructs =
  struct.allStructs.where((element) => element.files.isNotEmpty);
  final allPath = allStructs.map((e) => e.path).toSet();
  print('資料夾結構如下');
  print('flutter:\n  assets:');
  for (var element in allPath) {
    print('    - $element/');
  }
}

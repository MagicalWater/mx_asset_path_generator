import 'package:args/args.dart';
import 'dart:io';
import 'package:mx_asset_path_generator/mx_asset_path_generator.dart';

void main(List<String> arguments) {
  final parser = _initArgParser();

  final results = parser.parse(arguments);

  // 是否需要打印幫助
  final needHelp = results['help'] as bool;

  if (needHelp) {
    printHelp(parser, results: results);
    return;
  }

  final dirPath = results['directory'];
  final outputDirPath = results['output'];
  final partFileName = results['part'];

  final inputDirectory = Directory(dirPath);

  // 語系檔案不存在, 拋出錯誤
  if (!inputDirectory.existsSync()) {
    stderr.write('找不到輸入的資料夾: ${inputDirectory.path}\n');
    exit(1);
  }

  final struct = AssetStruct.fromDirectory(
    inputDirectory,
    packageName: results['package'],
  );

  // 輸出
  generatedWithSingleFile(
    struct: struct,
    outputDir: Directory(outputDirPath),
    instanceName: 'r',
    partFileName: partFileName,
  );

  if (results['print_struct'] as bool) {
    printAllStructDir(struct);
  }
}

ArgParser _initArgParser() {
  return ArgParser()
    ..addOption(
      'directory',
      abbr: 'd',
      help: '需要檢測並生成的資料夾結構入口',
      defaultsTo: 'assets/',
    )
    ..addOption(
      'output',
      abbr: 'o',
      help: '輸出的資料夾路徑, 檔案名稱將會與資料夾名稱相同, 以預設為例子則會生成r/r.dart, 此檔案交由使用者自行修改引入的instance, 所以重新生成將不會覆蓋',
      defaultsTo: 'lib/r/',
    )
    ..addOption(
      'part',
      abbr: 'p',
      help: 'part文件名稱, 輸出的路徑dart class將會以私有類的型態放置在這, 由output目錄中的文件進行part引入',
      defaultsTo: 'r_part.dart',
    )
    ..addOption(
      'package',
      help:
          '套件名稱, 當有值時會將路徑聲明為特定套件內的資源路徑, 例如(packages/{套件名稱}/assets/images/a.png)',
    )
    ..addFlag('print_struct', abbr: 's', help: '打印全部的資料夾結構', defaultsTo: false)
    ..addFlag('help', abbr: 'h', help: '說明');
}

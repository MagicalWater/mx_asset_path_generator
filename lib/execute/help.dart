import 'package:args/args.dart';

/// 打印幫助
void printHelp(ArgParser parser, {ArgResults? results}) {
  void printAll() {
    print('使用方法:');
    print(parser.usage);
  }

  final isHelp = results?['help'] as bool? ?? false;
  if (isHelp) {
    print('LocalizationBridge多國語系橋接工具');
  }
  printAll();
}

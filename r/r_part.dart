part of 'r.dart';

class _Assets {
  final fFile1 = 'packages/test_package/assets/file1';

  final dDir2 = const _AssetsDir2._();
  final dDir1 = const _AssetsDir1._();

  const _Assets._();
}

class _AssetsDir2 {
  final dDir3 = const _AssetsDir2Dir3._();

  const _AssetsDir2._();
}

class _AssetsDir2Dir3 {
  final fFile2 = 'packages/test_package/assets/dir2/dir3/file2';

  const _AssetsDir2Dir3._();
}

class _AssetsDir1 {
  final fFile1 = 'packages/test_package/assets/dir1/file1';

  const _AssetsDir1._();
}

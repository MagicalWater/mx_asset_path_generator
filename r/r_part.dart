part of 'r.dart';

class DAssets {
  final path = 'packages/test_package/assets';
  final fFile1 = 'packages/test_package/assets/file1';

  final dDir2 = const DAssetsDir2._();
  final dDir1 = const DAssetsDir1._();

  const DAssets._();
}

class DAssetsDir2 {
  final path = 'packages/test_package/assets/dir2';

  final dDir3 = const DAssetsDir2Dir3._();

  const DAssetsDir2._();
}

class DAssetsDir2Dir3 {
  final path = 'packages/test_package/assets/dir2/dir3';
  final fFile2 = 'packages/test_package/assets/dir2/dir3/file2';

  const DAssetsDir2Dir3._();
}

class DAssetsDir1 {
  final path = 'packages/test_package/assets/dir1';
  final fFile1 = 'packages/test_package/assets/dir1/file1';

  const DAssetsDir1._();
}

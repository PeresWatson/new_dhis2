import 'dart:convert';
import 'package:disk_space_plus/disk_space_plus.dart';

String formatSize(int bytes) {
  if (bytes < 1024) {
    return '$bytes B';
  } else if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).toStringAsFixed(2)} KB';
  } else {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}

/// Returns size of a single object in bytes
int getDataSizeBytes(dynamic data) {
  return utf8.encode(jsonEncode(data)).length;
}

/// Returns total size of multiple objects in bytes
int getTotalSizeBytes(List<dynamic> dataList) {
  int totalBytes = 0;

  for (final data in dataList) {
    totalBytes += utf8.encode(jsonEncode(data)).length;
  }

  return totalBytes;
}

Future<void> getStorageInfo() async {
  var freeSpace = await DiskSpacePlus().getFreeDiskSpace;
  var totalSpace = await DiskSpacePlus().getTotalDiskSpace;

  print('Free: $freeSpace GB');
  print('Total: $totalSpace GB');
}

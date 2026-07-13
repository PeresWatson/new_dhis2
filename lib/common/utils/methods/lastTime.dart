import 'package:intl/intl.dart';

String lastTime(String dateTimeString) {
  final DateTime dateTime = DateTime.parse(dateTimeString);
  final DateTime now = DateTime.now();

  final Duration difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'Just now';
  }

  if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
  }

  if (difference.inHours < 24) {
    return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
  }

  if (difference.inDays == 1) {
    return 'Yesterday at ${DateFormat('h:mm a').format(dateTime)}';
  }

  if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  }

  if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).floor();
    return '$weeks week${weeks == 1 ? '' : 's'} ago';
  }

  if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return '$months month${months == 1 ? '' : 's'} ago';
  }

  final years = (difference.inDays / 365).floor();
  return '$years year${years == 1 ? '' : 's'} ago';
}
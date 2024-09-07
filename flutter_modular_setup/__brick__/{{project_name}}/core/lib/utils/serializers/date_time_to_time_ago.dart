 import 'package:packages/packages.dart';
import 'package:flutter/widgets.dart';

String? timeAgoSinceDate(
{bool numericDates = false, String? createdTime,required BuildContext context}) { // TODO:  add translations
if (createdTime == null) {
return null;
}

var inputFormat = DateFormat('y-MM-dd HH:mm:ss');
var inputDate = inputFormat.parse(createdTime.toString());

DateTime date = inputDate.toLocal();
final date2 = DateTime.now().toLocal();
final difference = date2.difference(date);

if (difference.inSeconds < 5) {
return 'Just now';
} else if (difference.inSeconds <= 60) {
return '${difference.inSeconds} seconds ago';
} else if (difference.inMinutes <= 1) {
return (numericDates) ? '1 minute ago' : 'A minute ago';
} else if (difference.inMinutes <= 60) {
return '${difference.inMinutes} minutes ago';
} else if (difference.inHours <= 1) {
return (numericDates) ? '1 hour ago' : 'An hour ago';
} else if (difference.inHours <= 24) {
return '${difference.inHours} hours ago';
} else if (difference.inDays <= 1) {
return (numericDates) ? '1 day ago' : 'Yesterday';
} else if (difference.inDays <= 6) {
return '${difference.inDays} days ago';
} else if ((difference.inDays / 7).ceil() <= 1) {
return (numericDates) ? '1 week ago' : 'Last week';
} else if ((difference.inDays / 7).ceil() <= 4) {
return '${(difference.inDays / 7).ceil()} weeks ago';
} else if ((difference.inDays / 30).ceil() <= 1) {
return (numericDates) ? '1 month ago' : 'Last month'; //and this much days ago for mumeric
} else if ((difference.inDays / 30).ceil() <= 30) {
return '${(difference.inDays / 30).ceil()} months ago';
} else if ((difference.inDays / 365).ceil() <= 1) {
return (numericDates) ? '1 year ago' : 'Last year';
}
return '${(difference.inDays / 365).floor()} years ago';
}


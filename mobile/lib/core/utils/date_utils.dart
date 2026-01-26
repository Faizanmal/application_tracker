import 'package:intl/intl.dart';

/// Date and time utility functions
class DateTimeUtils {
  DateTimeUtils._();

  /// Format date as "Jan 15, 2024"
  static String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  /// Format date as "Jan 15"
  static String formatShortDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  /// Format time as "2:30 PM"
  static String formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  /// Format datetime as "Jan 15, 2024 at 2:30 PM"
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, yyyy \'at\' h:mm a').format(dateTime);
  }

  /// Format relative time (e.g., "2 hours ago", "in 3 days")
  static String formatRelative(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    final absDiff = difference.abs();

    if (difference.isNegative) {
      // Past
      if (absDiff.inSeconds < 60) {
        return 'Just now';
      } else if (absDiff.inMinutes < 60) {
        final minutes = absDiff.inMinutes;
        return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
      } else if (absDiff.inHours < 24) {
        final hours = absDiff.inHours;
        return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
      } else if (absDiff.inDays < 7) {
        final days = absDiff.inDays;
        return '$days ${days == 1 ? 'day' : 'days'} ago';
      } else if (absDiff.inDays < 30) {
        final weeks = (absDiff.inDays / 7).floor();
        return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
      } else {
        return formatDate(dateTime);
      }
    } else {
      // Future
      if (absDiff.inSeconds < 60) {
        return 'In a moment';
      } else if (absDiff.inMinutes < 60) {
        final minutes = absDiff.inMinutes;
        return 'In $minutes ${minutes == 1 ? 'minute' : 'minutes'}';
      } else if (absDiff.inHours < 24) {
        final hours = absDiff.inHours;
        return 'In $hours ${hours == 1 ? 'hour' : 'hours'}';
      } else if (absDiff.inDays < 7) {
        final days = absDiff.inDays;
        return 'In $days ${days == 1 ? 'day' : 'days'}';
      } else if (absDiff.inDays < 30) {
        final weeks = (absDiff.inDays / 7).floor();
        return 'In $weeks ${weeks == 1 ? 'week' : 'weeks'}';
      } else {
        return formatDate(dateTime);
      }
    }
  }

  /// Get countdown text for upcoming events
  static String getCountdown(DateTime eventTime) {
    final now = DateTime.now();
    final difference = eventTime.difference(now);

    if (difference.isNegative) {
      return 'Already passed';
    }

    if (difference.inDays > 0) {
      final days = difference.inDays;
      final hours = difference.inHours % 24;
      return '$days${days == 1 ? 'd' : 'd'} ${hours}h';
    } else if (difference.inHours > 0) {
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      return '$hours${hours == 1 ? 'h' : 'h'} ${minutes}m';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Starting soon';
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// Check if date is overdue
  static bool isOverdue(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  /// Parse ISO date string
  static DateTime? parseISO(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return null;
    }
    try {
      return DateTime.parse(dateString);
    } catch (_) {
      return null;
    }
  }

  /// Format to ISO string
  static String toISO(DateTime date) {
    return date.toIso8601String();
  }
}

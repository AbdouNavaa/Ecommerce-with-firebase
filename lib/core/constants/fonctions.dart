String formatDate(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    return '${date.day}-${date.month}-${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  } catch (e) {
    return dateString;
  }
}

String? getFileNameFromContentDisposition(String contentDisposition) {
  const String pattern = 'filename[^;=\n]*=(([\'"]).*?\2|[^;\n]*)';
  final RegExp regExp = RegExp(pattern, caseSensitive: true, multiLine: false);
  final String? match = regExp.stringMatch(contentDisposition);

  if (match == null) {
    return null;
  }

  return match
      .replaceFirst('filename=', '')
      .replaceAll('"', '')
      .replaceAll('\'', '');
}
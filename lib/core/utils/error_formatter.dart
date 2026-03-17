// Maps raw exceptions to user-friendly error messages.

String friendlyError(Object error) {
  final msg = error.toString().toLowerCase();

  if (msg.contains('socket') ||
      msg.contains('connection') ||
      msg.contains('network') ||
      msg.contains('host lookup')) {
    return 'No internet connection. Please check your network and try again.';
  }

  if (msg.contains('timeout')) {
    return 'The request timed out. Please try again.';
  }

  if (msg.contains('database') || msg.contains('sql')) {
    return 'A local data error occurred. Try restarting the app.';
  }

  if (msg.contains('format') || msg.contains('parse')) {
    return 'Could not read this content. It may be corrupted.';
  }

  if (msg.contains('permission') || msg.contains('denied')) {
    return 'Permission denied. Check your app settings.';
  }

  if (msg.contains('not found') || msg.contains('404')) {
    return 'Content not found. It may not be downloaded yet.';
  }

  return 'Something went wrong. Please try again.';
}

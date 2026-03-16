class SearchResult {
  const SearchResult({
    required this.uid,
    required this.title,
    required this.nikaya,
    required this.language,
    required this.snippet,
    this.translator,
    this.book,
    this.chapter,
  });

  final String uid;
  final String title;
  final String nikaya;
  final String language;
  final String snippet;
  final String? translator;
  final String? book;
  final String? chapter;
}

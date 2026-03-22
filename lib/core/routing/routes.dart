abstract final class Routes {
  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String library = '/library';
  static const String libraryNikaya = '/library/:nikaya';
  static const String libraryBook = '/library/:nikaya/:book';
  static const String reader = '/reader/:uid';
  static const String search = '/search';
  static const String daily = '/daily';
  static const String study = '/study';
  static const String downloads = '/downloads';
  static const String settings = '/settings';
  static const String planDetail = '/daily/plan/:planId';
  static const String collections = '/collections';
  static const String collectionDetail = '/collections/:id';
  static const String audio = '/audio';
  static const String audioBrowse = '/audio/browse';
  static const String chanting = '/audio/chanting';
  static const String meditation = '/audio/meditation';
  static const String dhammaTalks = '/audio/talks';
  static const String myTranslations = '/translations';
  static const String dictionary = '/dictionary';
  static const String community = '/community';
  static const String communityPackages = '/community';
  static const String packageDetail = '/community/:id';
  static const String studyGroups = '/community/groups';
  static const String login = '/login';
  static const String profile = '/profile';
  static const String help = '/help';

  static String readerPath(String uid, {int? scrollTo}) {
    final base = '/reader/$uid';
    if (scrollTo != null) return '$base?scrollTo=$scrollTo';
    return base;
  }
  static String nikayaPath(String nikaya) => '/library/$nikaya';
  static String bookPath(String nikaya, String book) =>
      '/library/$nikaya/$book';
  static String planDetailPath(String planId) => '/daily/plan/$planId';
  static String collectionDetailPath(int id) => '/collections/$id';
  static String packageDetailPath(int id) => '/community/$id';
}

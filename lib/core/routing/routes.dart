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

  static String readerPath(String uid) => '/reader/$uid';
  static String nikayaPath(String nikaya) => '/library/$nikaya';
  static String bookPath(String nikaya, String book) =>
      '/library/$nikaya/$book';
  static String planDetailPath(String planId) => '/daily/plan/$planId';
}

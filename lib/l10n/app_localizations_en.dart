// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Dhamma App';

  @override
  String get navLibrary => 'Library';

  @override
  String get navSearch => 'Search';

  @override
  String get navDaily => 'Daily';

  @override
  String get navAudio => 'Audio';

  @override
  String get navStudy => 'Study';

  @override
  String get navDownloads => 'Saved';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsReading => 'Reading';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsFontSize => 'Font size';

  @override
  String get settingsLineSpacing => 'Line spacing';

  @override
  String get settingsDefaultLanguage => 'Default language';

  @override
  String get settingsAppLanguage => 'App language';

  @override
  String get settingsAppLanguageSubtitle => 'Change the interface language';

  @override
  String get settingsSystemDefault => 'System default';

  @override
  String get settingsDownloads => 'Downloads';

  @override
  String get settingsWifiOnly => 'Wi-Fi only downloads';

  @override
  String get settingsWifiOnlySubtitle => 'Prevents downloads on mobile data';

  @override
  String get settingsAudioMobileData => 'Audio only on mobile data';

  @override
  String get settingsAudioMobileDataSubtitle => 'Restrict streaming to Wi-Fi';

  @override
  String get settingsAccount => 'Account';

  @override
  String get settingsManageAccount => 'Manage account';

  @override
  String get settingsSignIn => 'Sign in';

  @override
  String get settingsSignInSubtitle => 'Sync your progress across devices';

  @override
  String get settingsSyncWifiOnly => 'Sync on Wi-Fi only';

  @override
  String get settingsSyncWifiOnlySubtitle => 'Prevents sync on mobile data';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsLicences => 'Licences';

  @override
  String get settingsSourceCode => 'Source code';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System default';

  @override
  String get settingsFontSmall => 'Small';

  @override
  String get settingsFontMedium => 'Medium';

  @override
  String get settingsFontLarge => 'Large';

  @override
  String get settingsFontXL => 'Extra Large';

  @override
  String get settingsLineCompact => 'Compact';

  @override
  String get settingsLineNormal => 'Normal';

  @override
  String get settingsLineRelaxed => 'Relaxed';

  @override
  String get dailyTitle => 'Daily';

  @override
  String get dailySuttaOfTheDay => 'SUTTA OF THE DAY';

  @override
  String get dailyReadNow => 'Read now';

  @override
  String get dailyNoSutta =>
      'No daily sutta available. Please download the Dhammapada pack to start.';

  @override
  String get dailyContinueReading => 'CONTINUE READING';

  @override
  String get dailyCompleted => 'Completed';

  @override
  String get dailyInProgress => 'In progress';

  @override
  String get dailyCategoryClassics => 'CLASSICS';

  @override
  String get dailyCategoryDoctrinal => 'DOCTRINAL';

  @override
  String get dailyCategoryMeditation => 'MEDITATION';

  @override
  String get dailyCategoryNikayaStudy => 'NIKĀYA STUDY';

  @override
  String dailyDaysCount(int count, String description) {
    return '$count days — $description';
  }

  @override
  String get dailyBeginner => 'Beginner';

  @override
  String get dailyIntermediate => 'Intermediate';

  @override
  String get dailyAdvanced => 'Advanced';

  @override
  String get searchHint => 'Search suttas, keywords, titles…';

  @override
  String get searchEmpty =>
      'Search the Pali Canon\nby title, keyword, or phrase';

  @override
  String get searchTip => 'Tip: “satipaṭṭhāna” or “satipatthana” both work';

  @override
  String searchNoResults(String query) {
    return 'No results for “$query”';
  }

  @override
  String get searchTryDifferent =>
      'Try a different keyword or download more packs';

  @override
  String get searchRecentSearches => 'RECENT SEARCHES';

  @override
  String get searchClear => 'Clear';

  @override
  String get searchFilterResults => 'Filter Results';

  @override
  String get searchClearAll => 'Clear all';

  @override
  String get searchNikaya => 'Nikāya';

  @override
  String get searchLanguage => 'Language';

  @override
  String get searchApply => 'Apply';

  @override
  String get libraryTitle => 'Library';

  @override
  String get downloadsTitle => 'Downloads';

  @override
  String get downloadsWifiOnly => 'Wi-Fi only downloads';

  @override
  String get downloadsWifiOnlySubtitle => 'Recommended to save mobile data';

  @override
  String get downloadsInstalled => 'INSTALLED';

  @override
  String get downloadsAvailable => 'AVAILABLE TO DOWNLOAD';

  @override
  String get downloadsNoPacks =>
      'No packs available. Check your internet connection.';

  @override
  String get downloadsAllInstalled => 'All available packs are installed.';

  @override
  String get downloadsStorageUsed => 'Storage used by Dhamma App';

  @override
  String get downloadsUpdateAvailable => 'Update available';

  @override
  String get downloadsUpdatePack => 'Update pack';

  @override
  String get downloadsDeletePack => 'Delete pack';

  @override
  String get downloadsDeleteConfirm => 'Delete pack?';

  @override
  String downloadsDeleteMessage(String packName, String sizeMb) {
    return 'This will remove “$packName” and free $sizeMb MB of storage.';
  }

  @override
  String get downloadsInstalling => 'Installing…';

  @override
  String get downloadsDownloadFailed => 'Download failed';

  @override
  String get readerSharePassage => 'Share passage';

  @override
  String get readerExportPdf => 'Export PDF';

  @override
  String get readerAddToCollection => 'Add to collection';

  @override
  String get readerMyTranslation => 'My translation';

  @override
  String get readerHideMyTranslation => 'Hide my translation';

  @override
  String get readerAddAnnotation => 'Add annotation';

  @override
  String get readerShowCommentary => 'Show commentary';

  @override
  String get readerHideCommentary => 'Hide commentary';

  @override
  String get readerBookmark => 'Bookmark';

  @override
  String get readerRemoveBookmark => 'Remove bookmark';

  @override
  String get readerNotes => 'Notes';

  @override
  String get readerSmaller => 'Smaller';

  @override
  String get readerLarger => 'Larger';

  @override
  String get readerSwitchToScroll => 'Switch to scroll';

  @override
  String get readerSwitchToPages => 'Switch to pages';

  @override
  String get readerSingleView => 'Single view';

  @override
  String get readerSideBySide => 'Side by side (Pāli)';

  @override
  String get readerPrevSutta => 'Previous sutta';

  @override
  String get readerNextSutta => 'Next sutta';

  @override
  String get readerPrevPage => 'Previous page';

  @override
  String get readerNextPage => 'Next page';

  @override
  String readerPageOf(int current, int total) {
    return '$current of $total';
  }

  @override
  String get readerPrevious => 'Previous';

  @override
  String get readerNext => 'Next';

  @override
  String get readerSuttaNotFound =>
      'Sutta not found.\nDownload the content pack first.';

  @override
  String get readerHighlightNote => 'Highlight Note';

  @override
  String get readerWriteNoteHint => 'Write your note here…';

  @override
  String get readerEdit => 'Edit';

  @override
  String get readerShare => 'Share';

  @override
  String get readerDelete => 'Delete';

  @override
  String get dictionaryTitle => 'Pali Dictionary';

  @override
  String get dictionarySearchHint => 'Search Pali words…';

  @override
  String get dictionaryEnterWord => 'Enter a Pali word to search';

  @override
  String get dictionaryNoResults => 'No results found';

  @override
  String get dictionarySeeAlso => 'See also: ';

  @override
  String get communityTitle => 'Community Packages';

  @override
  String get communityNewest => 'Newest first';

  @override
  String get communityMostDownloaded => 'Most downloaded';

  @override
  String get communityAll => 'All';

  @override
  String get communityEnglish => 'English';

  @override
  String get communityGerman => 'German';

  @override
  String get communitySpanish => 'Spanish';

  @override
  String get communityNoPackages => 'No packages found';

  @override
  String communityBy(String author) {
    return 'by $author';
  }

  @override
  String communityTranslations(int count) {
    return '$count translations';
  }

  @override
  String get translationsTitle => 'My Translations';

  @override
  String get translationsTab => 'Translations';

  @override
  String get annotationsTab => 'Annotations';

  @override
  String get translationsExportAll => 'Export all as package';

  @override
  String get translationsImport => 'Import package';

  @override
  String get translationsPublish => 'Publish to community';

  @override
  String get translationsEmpty => 'No translations yet';

  @override
  String get translationsEmptySubtitle =>
      'Open any sutta and select \"My translation\" from the menu to start writing.';

  @override
  String get annotationsEmpty => 'No annotations yet';

  @override
  String get annotationsEmptySubtitle =>
      'Open any sutta and select \"Add annotation\" from the menu to add commentary.';

  @override
  String get translationsImportTitle => 'Import Package';

  @override
  String translationsAuthor(String author) {
    return 'Author: $author';
  }

  @override
  String translationsDescription(String desc) {
    return 'Description: $desc';
  }

  @override
  String translationsCount(int count) {
    return 'Translations: $count';
  }

  @override
  String annotationsCount(int count) {
    return 'Annotations: $count';
  }

  @override
  String get translationsMergeNote =>
      'This will merge the package contents with your existing translations.';

  @override
  String translationsImported(int translations, int commentary) {
    return 'Imported $translations translations and $commentary annotations';
  }

  @override
  String get translationsPublishTitle => 'Publish to Community';

  @override
  String get translationsPublishTitleLabel => 'Title';

  @override
  String get translationsPublishTitleHint => 'My Dhamma Translations';

  @override
  String get translationsPublishAuthorLabel => 'Author name';

  @override
  String get translationsPublishDescLabel => 'Description (optional)';

  @override
  String get translationsPublishTitleRequired => 'Title is required';

  @override
  String get translationsPublished => 'Published to community!';

  @override
  String get onboardingHeading => 'Dhamma App';

  @override
  String get onboardingSubtitle =>
      'The Pali Canon, in your pocket.\nFree, forever.';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingChooseLanguage => 'Choose your language';

  @override
  String get onboardingChangeLanguageLater =>
      'You can change this later in Settings';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingSkipForNow => 'Skip for now';

  @override
  String get onboardingDownloadFirst => 'Download your first pack';

  @override
  String get onboardingDownloadHint =>
      'Start with the Middle-Length Discourses — a great introduction to the Dhamma';

  @override
  String get onboardingDownloadError =>
      'Could not load pack list. You can download packs later.';

  @override
  String onboardingDownloading(int percent) {
    return 'Downloading… $percent%';
  }

  @override
  String get onboardingInstalling => 'Installing…';

  @override
  String get onboardingDownload => 'Download';

  @override
  String get onboardingSkipDownload => 'Skip — download later';

  @override
  String get onboardingHowToNavigate => 'How to navigate';

  @override
  String get onboardingNavLibrary => 'Library';

  @override
  String get onboardingNavLibraryDesc =>
      'Browse the Pali Canon by Nikāya — from the Dīgha to the Khuddaka.';

  @override
  String get onboardingNavSearch => 'Search';

  @override
  String get onboardingNavSearchDesc =>
      'Find any sutta by keyword, title, or phrase — even with or without diacritics.';

  @override
  String get onboardingNavDaily => 'Daily';

  @override
  String get onboardingNavDailyDesc =>
      'A different sutta every day, plus structured reading plans.';

  @override
  String get onboardingGotIt => 'Got it';

  @override
  String get onboardingReady => 'You’re ready';

  @override
  String get onboardingReadySubtitle =>
      'May your study be a source of wisdom\nand liberation.';

  @override
  String get onboardingStartReading => 'Start reading';

  @override
  String get authCreateAccount => 'Create Account';

  @override
  String get authSignIn => 'Sign In';

  @override
  String get authSyncDescription =>
      'Sync your bookmarks, highlights,\nand notes across devices';

  @override
  String get authContinueGoogle => 'Continue with Google';

  @override
  String get authContinueApple => 'Continue with Apple';

  @override
  String get authOr => 'OR';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authEmailInvalid => 'Enter a valid email';

  @override
  String get authPasswordShort => 'At least 6 characters';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authAlreadyHaveAccount => 'Already have an account? Sign in';

  @override
  String get authDontHaveAccount => 'Don’t have an account? Create one';

  @override
  String get authContinueWithout => 'Continue without account';

  @override
  String get authPasswordResetSent => 'Password reset email sent';

  @override
  String get authEnterEmailFirst => 'Enter your email first';

  @override
  String get profileTitle => 'Account';

  @override
  String get profileSyncNow => 'Sync Now';

  @override
  String profileLastSynced(String time) {
    return 'Last synced at $time';
  }

  @override
  String get profileTapToSync => 'Tap to sync your data';

  @override
  String get profileSyncing => 'Syncing...';

  @override
  String get profileSyncCompleted => 'Sync completed';

  @override
  String get profileSyncFailed => 'Some tables failed — tap to retry';

  @override
  String get profileSignOut => 'Sign Out';

  @override
  String get audioTitle => 'Audio';

  @override
  String get audioChanting => 'Chanting';

  @override
  String get audioChantingSubtitle => 'Pāli chants and recitations';

  @override
  String get audioGuidedMeditation => 'Guided Meditation';

  @override
  String get audioGuidedMeditationSubtitle =>
      'Mettā, ānāpānasati, body scan & more';

  @override
  String get audioDhammaTalks => 'Dhamma Talks';

  @override
  String get audioDhammaTalksSubtitle => 'Teachings from respected monastics';

  @override
  String get audioUnguided => 'UNGUIDED TIMER';

  @override
  String get audioUnguidedDesc =>
      'Sit in silence with a bell at the start and end.';

  @override
  String audioMinutes(int mins) {
    return '$mins min';
  }

  @override
  String get audioDone => 'Done';

  @override
  String get audioClose => 'Close';

  @override
  String get audioEndEarly => 'End early';

  @override
  String get audioOpenSutta => 'Open sutta';

  @override
  String get audioPlayAll => 'Play All';

  @override
  String get studyBookmarks => 'Bookmarks';

  @override
  String get studyHighlights => 'Highlights';

  @override
  String get studyNotes => 'Notes';

  @override
  String get studyCollections => 'Collections';

  @override
  String get studyTranslations => 'Translations';

  @override
  String get studyDictionary => 'Dictionary';

  @override
  String get studyCommunity => 'Community';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get import_ => 'Import';

  @override
  String get publish => 'Publish';

  @override
  String error(String message) {
    return 'Error: $message';
  }

  @override
  String exportFailed(String message) {
    return 'Export failed: $message';
  }

  @override
  String importFailed(String message) {
    return 'Import failed: $message';
  }

  @override
  String publishFailed(String message) {
    return 'Publish failed: $message';
  }

  @override
  String get notDownloaded => 'Not downloaded';

  @override
  String get filter => 'Filter';
}

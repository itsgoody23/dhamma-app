// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Sinhala Sinhalese (`si`).
class AppLocalizationsSi extends AppLocalizations {
  AppLocalizationsSi([String locale = 'si']) : super(locale);

  @override
  String get appTitle => 'ධම්ම ඇප්';

  @override
  String get navLibrary => 'පුස්තකාලය';

  @override
  String get navSearch => 'සොයන්න';

  @override
  String get navDaily => 'දෛනික';

  @override
  String get navAudio => 'ශ්‍රව්‍ය';

  @override
  String get navStudy => 'අධ්‍යයනය';

  @override
  String get navDownloads => 'බාගැනීම්';

  @override
  String get settingsTitle => 'සැකසුම්';

  @override
  String get settingsReading => 'කියවීම';

  @override
  String get settingsTheme => 'තේමාව';

  @override
  String get settingsFontSize => 'අකුරු ප්‍රමාණය';

  @override
  String get settingsLineSpacing => 'පේළි පරතරය';

  @override
  String get settingsDefaultLanguage => 'පෙරනිමි භාෂාව';

  @override
  String get settingsAppLanguage => 'යෙදුම් භාෂාව';

  @override
  String get settingsAppLanguageSubtitle => 'අතුරු මුහුණතේ භාෂාව වෙනස් කරන්න';

  @override
  String get settingsSystemDefault => 'පද්ධති පෙරනිමිය';

  @override
  String get settingsDownloads => 'බාගැනීම්';

  @override
  String get settingsWifiOnly => 'Wi-Fi පමණක් බාගැනීම්';

  @override
  String get settingsWifiOnlySubtitle => 'ජංගම දත්ත මත බාගැනීම් වළක්වයි';

  @override
  String get settingsAudioMobileData => 'ජංගම දත්ත මත ශ්‍රව්‍ය පමණි';

  @override
  String get settingsAudioMobileDataSubtitle => 'ප්‍රවාහය Wi-Fi වෙත සීමා කරන්න';

  @override
  String get settingsAccount => 'ගිණුම';

  @override
  String get settingsManageAccount => 'ගිණුම කළමනාකරණය';

  @override
  String get settingsSignIn => 'පුරන්න';

  @override
  String get settingsSignInSubtitle =>
      'ඔබේ ප්‍රගතිය උපාංග හරහා සමමුහුර්ත කරන්න';

  @override
  String get settingsSyncWifiOnly => 'Wi-Fi මත පමණක් සමමුහුර්ත කරන්න';

  @override
  String get settingsSyncWifiOnlySubtitle => 'ජංගම දත්ත මත සමමුහුර්තය වළක්වයි';

  @override
  String get settingsAbout => 'පිළිබඳව';

  @override
  String get settingsLicences => 'බලපත්‍ර';

  @override
  String get settingsSourceCode => 'මූලාශ්‍ර කේතය';

  @override
  String get settingsVersion => 'අනුවාදය';

  @override
  String get settingsThemeLight => 'සැහැල්ලු';

  @override
  String get settingsThemeDark => 'අඳුරු';

  @override
  String get settingsThemeSystem => 'පද්ධති පෙරනිමිය';

  @override
  String get settingsFontSmall => 'කුඩා';

  @override
  String get settingsFontMedium => 'මධ්‍යම';

  @override
  String get settingsFontLarge => 'විශාල';

  @override
  String get settingsFontXL => 'ඉතා විශාල';

  @override
  String get settingsLineCompact => 'සංක්ෂිප්ත';

  @override
  String get settingsLineNormal => 'සාමාන්‍ය';

  @override
  String get settingsLineRelaxed => 'ලිහිල්';

  @override
  String get dailyTitle => 'දෛනික';

  @override
  String get dailySuttaOfTheDay => 'අද සූත්‍රය';

  @override
  String get dailyReadNow => 'දැන් කියවන්න';

  @override
  String get dailyNoSutta =>
      'දෛනික සූත්‍රයක් නොමැත. කරුණාකර ධම්මපද පැකේජය බාගන්න.';

  @override
  String get dailyContinueReading => 'කියවීම දිගටම';

  @override
  String get dailyCompleted => 'සම්පූර්ණයි';

  @override
  String get dailyInProgress => 'ක්‍රියාත්මක වෙමින්';

  @override
  String get dailyCategoryClassics => 'සම්භාව්‍ය';

  @override
  String get dailyCategoryDoctrinal => 'ධර්මානුකූල';

  @override
  String get dailyCategoryMeditation => 'භාවනා';

  @override
  String get dailyCategoryNikayaStudy => 'නිකාය අධ්‍යයනය';

  @override
  String dailyDaysCount(int count, String description) {
    return 'දින $count — $description';
  }

  @override
  String get dailyBeginner => 'ආරම්භක';

  @override
  String get dailyIntermediate => 'මධ්‍යම';

  @override
  String get dailyAdvanced => 'උසස්';

  @override
  String get searchHint => 'සූත්‍ර, මූල පද, මාතෘකා සොයන්න…';

  @override
  String get searchEmpty =>
      'පාළි ත්‍රිපිටකයේ සොයන්න\nමාතෘකාව, මූල පදය, හෝ වාක්‍ය ඛණ්ඩය අනුව';

  @override
  String get searchTip =>
      'ඉඟිය: “satipaṭṭhāna” හෝ “satipatthana” දෙකම ක්‍රියා කරයි';

  @override
  String searchNoResults(String query) {
    return '“$query“ සඳහා ප්‍රතිඵල නැත';
  }

  @override
  String get searchTryDifferent =>
      'වෙනත් මූල පදයක් උත්සාහ කරන්න හෝ තවත් පැකේජ බාගන්න';

  @override
  String get searchRecentSearches => 'මෑත සෙවීම්';

  @override
  String get searchClear => 'මකන්න';

  @override
  String get searchFilterResults => 'ප්‍රතිඵල පෙරන්න';

  @override
  String get searchClearAll => 'සියල්ල මකන්න';

  @override
  String get searchNikaya => 'නිකාය';

  @override
  String get searchLanguage => 'භාෂාව';

  @override
  String get searchApply => 'යොදන්න';

  @override
  String get libraryTitle => 'පුස්තකාලය';

  @override
  String get downloadsTitle => 'බාගැනීම්';

  @override
  String get downloadsWifiOnly => 'Wi-Fi පමණක් බාගැනීම්';

  @override
  String get downloadsWifiOnlySubtitle => 'ජංගම දත්ත ඉතිරි කිරීමට නිර්දේශිතයි';

  @override
  String get downloadsInstalled => 'ස්ථාපිත';

  @override
  String get downloadsAvailable => 'බාගැනීමට ඇත';

  @override
  String get downloadsNoPacks =>
      'පැකේජ නොමැත. ඔබේ අන්තර්ජාල සම්බන්ධතාවය පරීක්ෂා කරන්න.';

  @override
  String get downloadsAllInstalled => 'සියලුම පැකේජ ස්ථාපිතයි.';

  @override
  String get downloadsStorageUsed => 'ධම්ම ඇප් භාවිත ගබඩාව';

  @override
  String get downloadsUpdateAvailable => 'යාවත්කාලීනයක් ඇත';

  @override
  String get downloadsUpdatePack => 'පැකේජය යාවත්කාලීන කරන්න';

  @override
  String get downloadsDeletePack => 'පැකේජය මකන්න';

  @override
  String get downloadsDeleteConfirm => 'පැකේජය මකන්නද?';

  @override
  String downloadsDeleteMessage(String packName, String sizeMb) {
    return 'මෙය “$packName“ ඉවත් කර $sizeMb MB ගබඩාව නිදහස් කරයි.';
  }

  @override
  String get downloadsInstalling => 'ස්ථාපනය වෙමින්…';

  @override
  String get downloadsDownloadFailed => 'බාගැනීම අසාර්ථකයි';

  @override
  String get readerSharePassage => 'ඡේදය බෙදාගන්න';

  @override
  String get readerExportPdf => 'PDF අපනයනය';

  @override
  String get readerAddToCollection => 'එකතුවට එක් කරන්න';

  @override
  String get readerMyTranslation => 'මගේ පරිවර්තනය';

  @override
  String get readerHideMyTranslation => 'මගේ පරිවර්තනය සඟවන්න';

  @override
  String get readerAddAnnotation => 'විවරණයක් එක් කරන්න';

  @override
  String get readerShowCommentary => 'අට්ඨකථා පෙන්වන්න';

  @override
  String get readerHideCommentary => 'අට්ඨකථා සඟවන්න';

  @override
  String get readerBookmark => 'පොත්සලකුණ';

  @override
  String get readerRemoveBookmark => 'පොත්සලකුණ ඉවත් කරන්න';

  @override
  String get readerNotes => 'සටහන්';

  @override
  String get readerSmaller => 'කුඩා';

  @override
  String get readerLarger => 'විශාල';

  @override
  String get readerSwitchToScroll => 'අනුචලනයට මාරු වන්න';

  @override
  String get readerSwitchToPages => 'පිටු වලට මාරු වන්න';

  @override
  String get readerSingleView => 'තනි දසුන';

  @override
  String get readerSideBySide => 'පැත්තෙන් පැත්ත (පාළි)';

  @override
  String get readerPrevSutta => 'පෙර සූත්‍රය';

  @override
  String get readerNextSutta => 'ඊළඟ සූත්‍රය';

  @override
  String get readerPrevPage => 'පෙර පිටුව';

  @override
  String get readerNextPage => 'ඊළඟ පිටුව';

  @override
  String readerPageOf(int current, int total) {
    return '$total න් $current';
  }

  @override
  String get readerPrevious => 'පෙර';

  @override
  String get readerNext => 'ඊළඟ';

  @override
  String get readerSuttaNotFound =>
      'සූත්‍රය හමු නොවීය.\nකරුණාකර පළමුව අන්තර්ගත පැකේජය බාගන්න.';

  @override
  String get readerHighlightNote => 'උද්දීපන සටහන';

  @override
  String get readerWriteNoteHint => 'ඔබේ සටහන මෙහි ලියන්න…';

  @override
  String get readerEdit => 'සංස්කරණය';

  @override
  String get readerShare => 'බෙදාගන්න';

  @override
  String get readerDelete => 'මකන්න';

  @override
  String get dictionaryTitle => 'පාළි ශබ්දකෝෂය';

  @override
  String get dictionarySearchHint => 'පාළි වචන සොයන්න…';

  @override
  String get dictionaryEnterWord => 'සෙවීමට පාළි වචනයක් ඇතුළත් කරන්න';

  @override
  String get dictionaryNoResults => 'ප්‍රතිඵල හමු නොවීය';

  @override
  String get dictionarySeeAlso => 'මෙයද බලන්න: ';

  @override
  String get communityTitle => 'ප්‍රජා පැකේජ';

  @override
  String get communityNewest => 'නවතම පළමුව';

  @override
  String get communityMostDownloaded => 'වැඩිපුරම බාගත';

  @override
  String get communityAll => 'සියල්ල';

  @override
  String get communityEnglish => 'ඉංග්‍රීසි';

  @override
  String get communityGerman => 'ජර්මන්';

  @override
  String get communitySpanish => 'ස්පාඤ්ඤ';

  @override
  String get communityNoPackages => 'පැකේජ හමු නොවීය';

  @override
  String communityBy(String author) {
    return '$author විසින්';
  }

  @override
  String communityTranslations(int count) {
    return 'පරිවර්තන $count';
  }

  @override
  String get translationsTitle => 'මගේ පරිවර්තන';

  @override
  String get translationsTab => 'පරිවර්තන';

  @override
  String get annotationsTab => 'විවරණ';

  @override
  String get translationsExportAll => 'සියල්ල පැකේජයක් ලෙස අපනයනය';

  @override
  String get translationsImport => 'පැකේජයක් ආයාත කරන්න';

  @override
  String get translationsPublish => 'ප්‍රජාවට ප්‍රකාශ කරන්න';

  @override
  String get translationsEmpty => 'තවම පරිවර්තන නැත';

  @override
  String get translationsEmptySubtitle =>
      'ඕනෑම සූත්‍රයක් විවෘත කර මෙනුවෙන් \"මගේ පරිවර්තනය\" තෝරන්න.';

  @override
  String get annotationsEmpty => 'තවම විවරණ නැත';

  @override
  String get annotationsEmptySubtitle =>
      'ඕනෑම සූත්‍රයක් විවෘත කර මෙනුවෙන් \"විවරණයක් එක් කරන්න\" තෝරන්න.';

  @override
  String get translationsImportTitle => 'පැකේජය ආයාත කරන්න';

  @override
  String translationsAuthor(String author) {
    return 'කතෘ: $author';
  }

  @override
  String translationsDescription(String desc) {
    return 'විස්තරය: $desc';
  }

  @override
  String translationsCount(int count) {
    return 'පරිවර්තන: $count';
  }

  @override
  String annotationsCount(int count) {
    return 'විවරණ: $count';
  }

  @override
  String get translationsMergeNote =>
      'මෙය පැකේජ අන්තර්ගතය ඔබේ පවතින පරිවර්තන සමඟ ඒකාබද්ධ කරයි.';

  @override
  String translationsImported(int translations, int commentary) {
    return 'පරිවර්තන $translations ක් සහ විවරණ $commentary ක් ආයාත කරන ලදී';
  }

  @override
  String get translationsPublishTitle => 'ප්‍රජාවට ප්‍රකාශ කරන්න';

  @override
  String get translationsPublishTitleLabel => 'මාතෘකාව';

  @override
  String get translationsPublishTitleHint => 'මගේ ධම්ම පරිවර්තන';

  @override
  String get translationsPublishAuthorLabel => 'කතෘ නම';

  @override
  String get translationsPublishDescLabel => 'විස්තරය (අමතර)';

  @override
  String get translationsPublishTitleRequired => 'මාතෘකාව අවශ්‍යයි';

  @override
  String get translationsPublished => 'ප්‍රජාවට ප්‍රකාශ කරන ලදී!';

  @override
  String get onboardingHeading => 'ධම්ම ඇප්';

  @override
  String get onboardingSubtitle =>
      'පාළි ත්‍රිපිටකය, ඔබේ සාක්කුවේ.\nනොමිලේ, සදාකාලිකව.';

  @override
  String get onboardingGetStarted => 'ආරම්භ කරන්න';

  @override
  String get onboardingChooseLanguage => 'ඔබේ භාෂාව තෝරන්න';

  @override
  String get onboardingChangeLanguageLater =>
      'මෙය පසුව සැකසුම් වලින් වෙනස් කළ හැක';

  @override
  String get onboardingContinue => 'ඉදිරියට';

  @override
  String get onboardingSkipForNow => 'දැනට මඟ හරින්න';

  @override
  String get onboardingDownloadFirst => 'ඔබේ පළමු පැකේජය බාගන්න';

  @override
  String get onboardingDownloadHint =>
      'මජ්ඣිම නිකායෙන් ආරම්භ කරන්න — ධම්මයට හොඳ හැඳින්වීමක්';

  @override
  String get onboardingDownloadError =>
      'පැකේජ ලැයිස්තුව පූරණය කළ නොහැක. පසුව පැකේජ බාගත හැක.';

  @override
  String onboardingDownloading(int percent) {
    return 'බාගනිමින්… $percent%';
  }

  @override
  String get onboardingInstalling => 'ස්ථාපනය වෙමින්…';

  @override
  String get onboardingDownload => 'බාගන්න';

  @override
  String get onboardingSkipDownload => 'මඟ හරින්න — පසුව බාගන්න';

  @override
  String get onboardingHowToNavigate => 'සැරිසැරීම් ආකාරය';

  @override
  String get onboardingNavLibrary => 'පුස්තකාලය';

  @override
  String get onboardingNavLibraryDesc =>
      'නිකාය අනුව පාළි ත්‍රිපිටකය බ්‍රවුස් කරන්න — දීඝ සිට ඛුද්දක දක්වා.';

  @override
  String get onboardingNavSearch => 'සොයන්න';

  @override
  String get onboardingNavSearchDesc =>
      'ඕනෑම සූත්‍රයක් මූල පදය, මාතෘකාව, හෝ වාක්‍ය ඛණ්ඩය මඟින් සොයන්න.';

  @override
  String get onboardingNavDaily => 'දෛනික';

  @override
  String get onboardingNavDailyDesc =>
      'දිනපතා වෙනස් සූත්‍රයක්, සහ ව්‍යුහගත කියවීම් සැලැස්ම්.';

  @override
  String get onboardingGotIt => 'තේරුණා';

  @override
  String get onboardingReady => 'ඔබ සූදානම්';

  @override
  String get onboardingReadySubtitle =>
      'ඔබේ අධ්‍යයනය ප්‍රඥාවේ\nසහ විමුක්තියේ මූලාශ්‍රයක් වේවා.';

  @override
  String get onboardingStartReading => 'කියවීම ආරම්භ කරන්න';

  @override
  String get authCreateAccount => 'ගිණුමක් සාදන්න';

  @override
  String get authSignIn => 'පුරන්න';

  @override
  String get authSyncDescription =>
      'ඔබේ පොත්සලකුණු, උද්දීපන,\nසහ සටහන් උපාංග හරහා සමමුහුර්ත කරන්න';

  @override
  String get authContinueGoogle => 'Google සමඟ ඉදිරියට';

  @override
  String get authContinueApple => 'Apple සමඟ ඉදිරියට';

  @override
  String get authOr => 'හෝ';

  @override
  String get authEmail => 'විද්‍යුත් තැපෑල';

  @override
  String get authPassword => 'මුරපදය';

  @override
  String get authEmailInvalid => 'වලංගු විද්‍යුත් තැපෑලක් ඇතුළත් කරන්න';

  @override
  String get authPasswordShort => 'අවම වශයෙන් අක්ෂර 6 ක්';

  @override
  String get authForgotPassword => 'මුරපදය අමතකද?';

  @override
  String get authAlreadyHaveAccount => 'දැනටමත් ගිණුමක් තිබේද? පුරන්න';

  @override
  String get authDontHaveAccount => 'ගිණුමක් නැද්ද? එකක් සාදන්න';

  @override
  String get authContinueWithout => 'ගිණුමක් නොමැතිව ඉදිරියට';

  @override
  String get authPasswordResetSent =>
      'මුරපද යළි සැකසීමේ විද්‍යුත් තැපෑල යවන ලදී';

  @override
  String get authEnterEmailFirst => 'පළමුව ඔබේ විද්‍යුත් තැපෑල ඇතුළත් කරන්න';

  @override
  String get profileTitle => 'ගිණුම';

  @override
  String get profileSyncNow => 'දැන් සමමුහුර්ත කරන්න';

  @override
  String profileLastSynced(String time) {
    return 'අවසන් වරට සමමුහුර්ත කළේ $time ට';
  }

  @override
  String get profileTapToSync => 'ඔබේ දත්ත සමමුහුර්ත කිරීමට තට්ටු කරන්න';

  @override
  String get profileSyncing => 'සමමුහුර්ත වෙමින්...';

  @override
  String get profileSyncCompleted => 'සමමුහුර්තය සම්පූර්ණයි';

  @override
  String get profileSyncFailed =>
      'සමහර වගු අසාර්ථකයි — නැවත උත්සාහ කිරීමට තට්ටු කරන්න';

  @override
  String get profileSignOut => 'වරන්න';

  @override
  String get audioTitle => 'ශ්‍රව්‍ය';

  @override
  String get audioChanting => 'ස්වරය';

  @override
  String get audioChantingSubtitle => 'පාළි ස්වර හා පාරායණ';

  @override
  String get audioGuidedMeditation => 'මඟ පෙන්වන භාවනා';

  @override
  String get audioGuidedMeditationSubtitle =>
      'මෙත්තා, ආනාපානසති, කායානුපස්සනා සහ තවත්';

  @override
  String get audioDhammaTalks => 'ධම්ම දේශනා';

  @override
  String get audioDhammaTalksSubtitle => 'ගෞරවනීය භික්ෂූන්ගේ ඉගැන්වීම්';

  @override
  String get audioUnguided => 'මඟ නොපෙන්වන ටයිමරය';

  @override
  String get audioUnguidedDesc =>
      'ආරම්භයේ සහ අවසානයේ සීනුවක් සමඟ නිහඬව වාඩි වන්න.';

  @override
  String audioMinutes(int mins) {
    return 'මිනි. $mins';
  }

  @override
  String get audioDone => 'හරි';

  @override
  String get audioClose => 'වසන්න';

  @override
  String get audioEndEarly => 'කලින් අවසන් කරන්න';

  @override
  String get audioOpenSutta => 'සූත්‍රය විවෘත කරන්න';

  @override
  String get audioPlayAll => 'සියල්ල වාදනය';

  @override
  String get studyBookmarks => 'පොත්සලකුණු';

  @override
  String get studyHighlights => 'උද්දීපන';

  @override
  String get studyNotes => 'සටහන්';

  @override
  String get studyCollections => 'එකතු';

  @override
  String get studyTranslations => 'පරිවර්තන';

  @override
  String get studyDictionary => 'ශබ්දකෝෂය';

  @override
  String get studyCommunity => 'ප්‍රජාව';

  @override
  String get cancel => 'අවලංගු';

  @override
  String get save => 'සුරකින්න';

  @override
  String get delete => 'මකන්න';

  @override
  String get import_ => 'ආයාත';

  @override
  String get publish => 'ප්‍රකාශ';

  @override
  String error(String message) {
    return 'දෝෂය: $message';
  }

  @override
  String exportFailed(String message) {
    return 'අපනයනය අසාර්ථකයි: $message';
  }

  @override
  String importFailed(String message) {
    return 'ආයාතය අසාර්ථකයි: $message';
  }

  @override
  String publishFailed(String message) {
    return 'ප්‍රකාශනය අසාර්ථකයි: $message';
  }

  @override
  String get notDownloaded => 'බාගත කර නැත';

  @override
  String get filter => 'පෙරහන';
}

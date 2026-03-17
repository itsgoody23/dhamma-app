import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_si.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('si')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Dhamma App'**
  String get appTitle;

  /// No description provided for @navLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get navDaily;

  /// No description provided for @navAudio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get navAudio;

  /// No description provided for @navStudy.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get navStudy;

  /// No description provided for @navDownloads.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get navDownloads;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsReading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get settingsReading;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsFontSize.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get settingsFontSize;

  /// No description provided for @settingsLineSpacing.
  ///
  /// In en, this message translates to:
  /// **'Line spacing'**
  String get settingsLineSpacing;

  /// No description provided for @settingsDefaultLanguage.
  ///
  /// In en, this message translates to:
  /// **'Default language'**
  String get settingsDefaultLanguage;

  /// No description provided for @settingsAppLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get settingsAppLanguage;

  /// No description provided for @settingsAppLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change the interface language'**
  String get settingsAppLanguageSubtitle;

  /// No description provided for @settingsSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsSystemDefault;

  /// No description provided for @settingsDownloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get settingsDownloads;

  /// No description provided for @settingsWifiOnly.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi only downloads'**
  String get settingsWifiOnly;

  /// No description provided for @settingsWifiOnlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prevents downloads on mobile data'**
  String get settingsWifiOnlySubtitle;

  /// No description provided for @settingsAudioMobileData.
  ///
  /// In en, this message translates to:
  /// **'Audio only on mobile data'**
  String get settingsAudioMobileData;

  /// No description provided for @settingsAudioMobileDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restrict streaming to Wi-Fi'**
  String get settingsAudioMobileDataSubtitle;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsManageAccount.
  ///
  /// In en, this message translates to:
  /// **'Manage account'**
  String get settingsManageAccount;

  /// No description provided for @settingsSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get settingsSignIn;

  /// No description provided for @settingsSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sync your progress across devices'**
  String get settingsSignInSubtitle;

  /// No description provided for @settingsSyncWifiOnly.
  ///
  /// In en, this message translates to:
  /// **'Sync on Wi-Fi only'**
  String get settingsSyncWifiOnly;

  /// No description provided for @settingsSyncWifiOnlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prevents sync on mobile data'**
  String get settingsSyncWifiOnlySubtitle;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsLicences.
  ///
  /// In en, this message translates to:
  /// **'Licences'**
  String get settingsLicences;

  /// No description provided for @settingsSourceCode.
  ///
  /// In en, this message translates to:
  /// **'Source code'**
  String get settingsSourceCode;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsThemeSystem;

  /// No description provided for @settingsFontSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get settingsFontSmall;

  /// No description provided for @settingsFontMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get settingsFontMedium;

  /// No description provided for @settingsFontLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get settingsFontLarge;

  /// No description provided for @settingsFontXL.
  ///
  /// In en, this message translates to:
  /// **'Extra Large'**
  String get settingsFontXL;

  /// No description provided for @settingsLineCompact.
  ///
  /// In en, this message translates to:
  /// **'Compact'**
  String get settingsLineCompact;

  /// No description provided for @settingsLineNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get settingsLineNormal;

  /// No description provided for @settingsLineRelaxed.
  ///
  /// In en, this message translates to:
  /// **'Relaxed'**
  String get settingsLineRelaxed;

  /// No description provided for @dailyTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get dailyTitle;

  /// No description provided for @dailySuttaOfTheDay.
  ///
  /// In en, this message translates to:
  /// **'SUTTA OF THE DAY'**
  String get dailySuttaOfTheDay;

  /// No description provided for @dailyReadNow.
  ///
  /// In en, this message translates to:
  /// **'Read now'**
  String get dailyReadNow;

  /// No description provided for @dailyNoSutta.
  ///
  /// In en, this message translates to:
  /// **'No daily sutta available. Please download the Dhammapada pack to start.'**
  String get dailyNoSutta;

  /// No description provided for @dailyContinueReading.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE READING'**
  String get dailyContinueReading;

  /// No description provided for @dailyCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get dailyCompleted;

  /// No description provided for @dailyInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get dailyInProgress;

  /// No description provided for @dailyCategoryClassics.
  ///
  /// In en, this message translates to:
  /// **'CLASSICS'**
  String get dailyCategoryClassics;

  /// No description provided for @dailyCategoryDoctrinal.
  ///
  /// In en, this message translates to:
  /// **'DOCTRINAL'**
  String get dailyCategoryDoctrinal;

  /// No description provided for @dailyCategoryMeditation.
  ///
  /// In en, this message translates to:
  /// **'MEDITATION'**
  String get dailyCategoryMeditation;

  /// No description provided for @dailyCategoryNikayaStudy.
  ///
  /// In en, this message translates to:
  /// **'NIKĀYA STUDY'**
  String get dailyCategoryNikayaStudy;

  /// No description provided for @dailyDaysCount.
  ///
  /// In en, this message translates to:
  /// **'{count} days — {description}'**
  String dailyDaysCount(int count, String description);

  /// No description provided for @dailyBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get dailyBeginner;

  /// No description provided for @dailyIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get dailyIntermediate;

  /// No description provided for @dailyAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get dailyAdvanced;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search suttas, keywords, titles…'**
  String get searchHint;

  /// No description provided for @searchEmpty.
  ///
  /// In en, this message translates to:
  /// **'Search the Pali Canon\nby title, keyword, or phrase'**
  String get searchEmpty;

  /// No description provided for @searchTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: “satipaṭṭhāna” or “satipatthana” both work'**
  String get searchTip;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results for “{query}”'**
  String searchNoResults(String query);

  /// No description provided for @searchTryDifferent.
  ///
  /// In en, this message translates to:
  /// **'Try a different keyword or download more packs'**
  String get searchTryDifferent;

  /// No description provided for @searchRecentSearches.
  ///
  /// In en, this message translates to:
  /// **'RECENT SEARCHES'**
  String get searchRecentSearches;

  /// No description provided for @searchClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get searchClear;

  /// No description provided for @searchFilterResults.
  ///
  /// In en, this message translates to:
  /// **'Filter Results'**
  String get searchFilterResults;

  /// No description provided for @searchClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get searchClearAll;

  /// No description provided for @searchNikaya.
  ///
  /// In en, this message translates to:
  /// **'Nikāya'**
  String get searchNikaya;

  /// No description provided for @searchLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get searchLanguage;

  /// No description provided for @searchApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get searchApply;

  /// No description provided for @libraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get libraryTitle;

  /// No description provided for @downloadsTitle.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get downloadsTitle;

  /// No description provided for @downloadsWifiOnly.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi only downloads'**
  String get downloadsWifiOnly;

  /// No description provided for @downloadsWifiOnlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recommended to save mobile data'**
  String get downloadsWifiOnlySubtitle;

  /// No description provided for @downloadsInstalled.
  ///
  /// In en, this message translates to:
  /// **'INSTALLED'**
  String get downloadsInstalled;

  /// No description provided for @downloadsAvailable.
  ///
  /// In en, this message translates to:
  /// **'AVAILABLE TO DOWNLOAD'**
  String get downloadsAvailable;

  /// No description provided for @downloadsNoPacks.
  ///
  /// In en, this message translates to:
  /// **'No packs available. Check your internet connection.'**
  String get downloadsNoPacks;

  /// No description provided for @downloadsAllInstalled.
  ///
  /// In en, this message translates to:
  /// **'All available packs are installed.'**
  String get downloadsAllInstalled;

  /// No description provided for @downloadsStorageUsed.
  ///
  /// In en, this message translates to:
  /// **'Storage used by Dhamma App'**
  String get downloadsStorageUsed;

  /// No description provided for @downloadsUpdateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get downloadsUpdateAvailable;

  /// No description provided for @downloadsUpdatePack.
  ///
  /// In en, this message translates to:
  /// **'Update pack'**
  String get downloadsUpdatePack;

  /// No description provided for @downloadsDeletePack.
  ///
  /// In en, this message translates to:
  /// **'Delete pack'**
  String get downloadsDeletePack;

  /// No description provided for @downloadsDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete pack?'**
  String get downloadsDeleteConfirm;

  /// No description provided for @downloadsDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'This will remove “{packName}” and free {sizeMb} MB of storage.'**
  String downloadsDeleteMessage(String packName, String sizeMb);

  /// No description provided for @downloadsInstalling.
  ///
  /// In en, this message translates to:
  /// **'Installing…'**
  String get downloadsInstalling;

  /// No description provided for @downloadsDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get downloadsDownloadFailed;

  /// No description provided for @readerSharePassage.
  ///
  /// In en, this message translates to:
  /// **'Share passage'**
  String get readerSharePassage;

  /// No description provided for @readerExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get readerExportPdf;

  /// No description provided for @readerAddToCollection.
  ///
  /// In en, this message translates to:
  /// **'Add to collection'**
  String get readerAddToCollection;

  /// No description provided for @readerMyTranslation.
  ///
  /// In en, this message translates to:
  /// **'My translation'**
  String get readerMyTranslation;

  /// No description provided for @readerHideMyTranslation.
  ///
  /// In en, this message translates to:
  /// **'Hide my translation'**
  String get readerHideMyTranslation;

  /// No description provided for @readerAddAnnotation.
  ///
  /// In en, this message translates to:
  /// **'Add annotation'**
  String get readerAddAnnotation;

  /// No description provided for @readerShowCommentary.
  ///
  /// In en, this message translates to:
  /// **'Show commentary'**
  String get readerShowCommentary;

  /// No description provided for @readerHideCommentary.
  ///
  /// In en, this message translates to:
  /// **'Hide commentary'**
  String get readerHideCommentary;

  /// No description provided for @readerBookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get readerBookmark;

  /// No description provided for @readerRemoveBookmark.
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark'**
  String get readerRemoveBookmark;

  /// No description provided for @readerNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get readerNotes;

  /// No description provided for @readerSmaller.
  ///
  /// In en, this message translates to:
  /// **'Smaller'**
  String get readerSmaller;

  /// No description provided for @readerLarger.
  ///
  /// In en, this message translates to:
  /// **'Larger'**
  String get readerLarger;

  /// No description provided for @readerSwitchToScroll.
  ///
  /// In en, this message translates to:
  /// **'Switch to scroll'**
  String get readerSwitchToScroll;

  /// No description provided for @readerSwitchToPages.
  ///
  /// In en, this message translates to:
  /// **'Switch to pages'**
  String get readerSwitchToPages;

  /// No description provided for @readerSingleView.
  ///
  /// In en, this message translates to:
  /// **'Single view'**
  String get readerSingleView;

  /// No description provided for @readerSideBySide.
  ///
  /// In en, this message translates to:
  /// **'Side by side (Pāli)'**
  String get readerSideBySide;

  /// No description provided for @readerPrevSutta.
  ///
  /// In en, this message translates to:
  /// **'Previous sutta'**
  String get readerPrevSutta;

  /// No description provided for @readerNextSutta.
  ///
  /// In en, this message translates to:
  /// **'Next sutta'**
  String get readerNextSutta;

  /// No description provided for @readerPrevPage.
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get readerPrevPage;

  /// No description provided for @readerNextPage.
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get readerNextPage;

  /// No description provided for @readerPageOf.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String readerPageOf(int current, int total);

  /// No description provided for @readerPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get readerPrevious;

  /// No description provided for @readerNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get readerNext;

  /// No description provided for @readerSuttaNotFound.
  ///
  /// In en, this message translates to:
  /// **'Sutta not found.\nDownload the content pack first.'**
  String get readerSuttaNotFound;

  /// No description provided for @readerHighlightNote.
  ///
  /// In en, this message translates to:
  /// **'Highlight Note'**
  String get readerHighlightNote;

  /// No description provided for @readerWriteNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Write your note here…'**
  String get readerWriteNoteHint;

  /// No description provided for @readerEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get readerEdit;

  /// No description provided for @readerShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get readerShare;

  /// No description provided for @readerDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get readerDelete;

  /// No description provided for @dictionaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Pali Dictionary'**
  String get dictionaryTitle;

  /// No description provided for @dictionarySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search Pali words…'**
  String get dictionarySearchHint;

  /// No description provided for @dictionaryEnterWord.
  ///
  /// In en, this message translates to:
  /// **'Enter a Pali word to search'**
  String get dictionaryEnterWord;

  /// No description provided for @dictionaryNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get dictionaryNoResults;

  /// No description provided for @dictionarySeeAlso.
  ///
  /// In en, this message translates to:
  /// **'See also: '**
  String get dictionarySeeAlso;

  /// No description provided for @communityTitle.
  ///
  /// In en, this message translates to:
  /// **'Community Packages'**
  String get communityTitle;

  /// No description provided for @communityNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get communityNewest;

  /// No description provided for @communityMostDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Most downloaded'**
  String get communityMostDownloaded;

  /// No description provided for @communityAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get communityAll;

  /// No description provided for @communityEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get communityEnglish;

  /// No description provided for @communityGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get communityGerman;

  /// No description provided for @communitySpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get communitySpanish;

  /// No description provided for @communityNoPackages.
  ///
  /// In en, this message translates to:
  /// **'No packages found'**
  String get communityNoPackages;

  /// No description provided for @communityBy.
  ///
  /// In en, this message translates to:
  /// **'by {author}'**
  String communityBy(String author);

  /// No description provided for @communityTranslations.
  ///
  /// In en, this message translates to:
  /// **'{count} translations'**
  String communityTranslations(int count);

  /// No description provided for @translationsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Translations'**
  String get translationsTitle;

  /// No description provided for @translationsTab.
  ///
  /// In en, this message translates to:
  /// **'Translations'**
  String get translationsTab;

  /// No description provided for @annotationsTab.
  ///
  /// In en, this message translates to:
  /// **'Annotations'**
  String get annotationsTab;

  /// No description provided for @translationsExportAll.
  ///
  /// In en, this message translates to:
  /// **'Export all as package'**
  String get translationsExportAll;

  /// No description provided for @translationsImport.
  ///
  /// In en, this message translates to:
  /// **'Import package'**
  String get translationsImport;

  /// No description provided for @translationsPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish to community'**
  String get translationsPublish;

  /// No description provided for @translationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No translations yet'**
  String get translationsEmpty;

  /// No description provided for @translationsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open any sutta and select \"My translation\" from the menu to start writing.'**
  String get translationsEmptySubtitle;

  /// No description provided for @annotationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No annotations yet'**
  String get annotationsEmpty;

  /// No description provided for @annotationsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open any sutta and select \"Add annotation\" from the menu to add commentary.'**
  String get annotationsEmptySubtitle;

  /// No description provided for @translationsImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import Package'**
  String get translationsImportTitle;

  /// No description provided for @translationsAuthor.
  ///
  /// In en, this message translates to:
  /// **'Author: {author}'**
  String translationsAuthor(String author);

  /// No description provided for @translationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Description: {desc}'**
  String translationsDescription(String desc);

  /// No description provided for @translationsCount.
  ///
  /// In en, this message translates to:
  /// **'Translations: {count}'**
  String translationsCount(int count);

  /// No description provided for @annotationsCount.
  ///
  /// In en, this message translates to:
  /// **'Annotations: {count}'**
  String annotationsCount(int count);

  /// No description provided for @translationsMergeNote.
  ///
  /// In en, this message translates to:
  /// **'This will merge the package contents with your existing translations.'**
  String get translationsMergeNote;

  /// No description provided for @translationsImported.
  ///
  /// In en, this message translates to:
  /// **'Imported {translations} translations and {commentary} annotations'**
  String translationsImported(int translations, int commentary);

  /// No description provided for @translationsPublishTitle.
  ///
  /// In en, this message translates to:
  /// **'Publish to Community'**
  String get translationsPublishTitle;

  /// No description provided for @translationsPublishTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get translationsPublishTitleLabel;

  /// No description provided for @translationsPublishTitleHint.
  ///
  /// In en, this message translates to:
  /// **'My Dhamma Translations'**
  String get translationsPublishTitleHint;

  /// No description provided for @translationsPublishAuthorLabel.
  ///
  /// In en, this message translates to:
  /// **'Author name'**
  String get translationsPublishAuthorLabel;

  /// No description provided for @translationsPublishDescLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get translationsPublishDescLabel;

  /// No description provided for @translationsPublishTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get translationsPublishTitleRequired;

  /// No description provided for @translationsPublished.
  ///
  /// In en, this message translates to:
  /// **'Published to community!'**
  String get translationsPublished;

  /// No description provided for @onboardingHeading.
  ///
  /// In en, this message translates to:
  /// **'Dhamma App'**
  String get onboardingHeading;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The Pali Canon, in your pocket.\nFree, forever.'**
  String get onboardingSubtitle;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingChooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get onboardingChooseLanguage;

  /// No description provided for @onboardingChangeLanguageLater.
  ///
  /// In en, this message translates to:
  /// **'You can change this later in Settings'**
  String get onboardingChangeLanguageLater;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// No description provided for @onboardingSkipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get onboardingSkipForNow;

  /// No description provided for @onboardingDownloadFirst.
  ///
  /// In en, this message translates to:
  /// **'Download your first pack'**
  String get onboardingDownloadFirst;

  /// No description provided for @onboardingDownloadHint.
  ///
  /// In en, this message translates to:
  /// **'Start with the Middle-Length Discourses — a great introduction to the Dhamma'**
  String get onboardingDownloadHint;

  /// No description provided for @onboardingDownloadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load pack list. You can download packs later.'**
  String get onboardingDownloadError;

  /// No description provided for @onboardingDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading… {percent}%'**
  String onboardingDownloading(int percent);

  /// No description provided for @onboardingInstalling.
  ///
  /// In en, this message translates to:
  /// **'Installing…'**
  String get onboardingInstalling;

  /// No description provided for @onboardingDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get onboardingDownload;

  /// No description provided for @onboardingSkipDownload.
  ///
  /// In en, this message translates to:
  /// **'Skip — download later'**
  String get onboardingSkipDownload;

  /// No description provided for @onboardingHowToNavigate.
  ///
  /// In en, this message translates to:
  /// **'How to navigate'**
  String get onboardingHowToNavigate;

  /// No description provided for @onboardingNavLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get onboardingNavLibrary;

  /// No description provided for @onboardingNavLibraryDesc.
  ///
  /// In en, this message translates to:
  /// **'Browse the Pali Canon by Nikāya — from the Dīgha to the Khuddaka.'**
  String get onboardingNavLibraryDesc;

  /// No description provided for @onboardingNavSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get onboardingNavSearch;

  /// No description provided for @onboardingNavSearchDesc.
  ///
  /// In en, this message translates to:
  /// **'Find any sutta by keyword, title, or phrase — even with or without diacritics.'**
  String get onboardingNavSearchDesc;

  /// No description provided for @onboardingNavDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get onboardingNavDaily;

  /// No description provided for @onboardingNavDailyDesc.
  ///
  /// In en, this message translates to:
  /// **'A different sutta every day, plus structured reading plans.'**
  String get onboardingNavDailyDesc;

  /// No description provided for @onboardingGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get onboardingGotIt;

  /// No description provided for @onboardingReady.
  ///
  /// In en, this message translates to:
  /// **'You’re ready'**
  String get onboardingReady;

  /// No description provided for @onboardingReadySubtitle.
  ///
  /// In en, this message translates to:
  /// **'May your study be a source of wisdom\nand liberation.'**
  String get onboardingReadySubtitle;

  /// No description provided for @onboardingStartReading.
  ///
  /// In en, this message translates to:
  /// **'Start reading'**
  String get onboardingStartReading;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccount;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignIn;

  /// No description provided for @authSyncDescription.
  ///
  /// In en, this message translates to:
  /// **'Sync your bookmarks, highlights,\nand notes across devices'**
  String get authSyncDescription;

  /// No description provided for @authContinueGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueGoogle;

  /// No description provided for @authContinueApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get authContinueApple;

  /// No description provided for @authOr.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get authOr;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get authEmailInvalid;

  /// No description provided for @authPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get authPasswordShort;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get authAlreadyHaveAccount;

  /// No description provided for @authDontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account? Create one'**
  String get authDontHaveAccount;

  /// No description provided for @authContinueWithout.
  ///
  /// In en, this message translates to:
  /// **'Continue without account'**
  String get authContinueWithout;

  /// No description provided for @authPasswordResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent'**
  String get authPasswordResetSent;

  /// No description provided for @authEnterEmailFirst.
  ///
  /// In en, this message translates to:
  /// **'Enter your email first'**
  String get authEnterEmailFirst;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileTitle;

  /// No description provided for @profileSyncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get profileSyncNow;

  /// No description provided for @profileLastSynced.
  ///
  /// In en, this message translates to:
  /// **'Last synced at {time}'**
  String profileLastSynced(String time);

  /// No description provided for @profileTapToSync.
  ///
  /// In en, this message translates to:
  /// **'Tap to sync your data'**
  String get profileTapToSync;

  /// No description provided for @profileSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get profileSyncing;

  /// No description provided for @profileSyncCompleted.
  ///
  /// In en, this message translates to:
  /// **'Sync completed'**
  String get profileSyncCompleted;

  /// No description provided for @profileSyncFailed.
  ///
  /// In en, this message translates to:
  /// **'Some tables failed — tap to retry'**
  String get profileSyncFailed;

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get profileSignOut;

  /// No description provided for @audioTitle.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get audioTitle;

  /// No description provided for @audioChanting.
  ///
  /// In en, this message translates to:
  /// **'Chanting'**
  String get audioChanting;

  /// No description provided for @audioChantingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pāli chants and recitations'**
  String get audioChantingSubtitle;

  /// No description provided for @audioGuidedMeditation.
  ///
  /// In en, this message translates to:
  /// **'Guided Meditation'**
  String get audioGuidedMeditation;

  /// No description provided for @audioGuidedMeditationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mettā, ānāpānasati, body scan & more'**
  String get audioGuidedMeditationSubtitle;

  /// No description provided for @audioDhammaTalks.
  ///
  /// In en, this message translates to:
  /// **'Dhamma Talks'**
  String get audioDhammaTalks;

  /// No description provided for @audioDhammaTalksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Teachings from respected monastics'**
  String get audioDhammaTalksSubtitle;

  /// No description provided for @audioUnguided.
  ///
  /// In en, this message translates to:
  /// **'UNGUIDED TIMER'**
  String get audioUnguided;

  /// No description provided for @audioUnguidedDesc.
  ///
  /// In en, this message translates to:
  /// **'Sit in silence with a bell at the start and end.'**
  String get audioUnguidedDesc;

  /// No description provided for @audioMinutes.
  ///
  /// In en, this message translates to:
  /// **'{mins} min'**
  String audioMinutes(int mins);

  /// No description provided for @audioDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get audioDone;

  /// No description provided for @audioClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get audioClose;

  /// No description provided for @audioEndEarly.
  ///
  /// In en, this message translates to:
  /// **'End early'**
  String get audioEndEarly;

  /// No description provided for @audioOpenSutta.
  ///
  /// In en, this message translates to:
  /// **'Open sutta'**
  String get audioOpenSutta;

  /// No description provided for @audioPlayAll.
  ///
  /// In en, this message translates to:
  /// **'Play All'**
  String get audioPlayAll;

  /// No description provided for @studyBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get studyBookmarks;

  /// No description provided for @studyHighlights.
  ///
  /// In en, this message translates to:
  /// **'Highlights'**
  String get studyHighlights;

  /// No description provided for @studyNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get studyNotes;

  /// No description provided for @studyCollections.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get studyCollections;

  /// No description provided for @studyTranslations.
  ///
  /// In en, this message translates to:
  /// **'Translations'**
  String get studyTranslations;

  /// No description provided for @studyDictionary.
  ///
  /// In en, this message translates to:
  /// **'Dictionary'**
  String get studyDictionary;

  /// No description provided for @studyCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get studyCommunity;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @import_.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import_;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String error(String message);

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {message}'**
  String exportFailed(String message);

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {message}'**
  String importFailed(String message);

  /// No description provided for @publishFailed.
  ///
  /// In en, this message translates to:
  /// **'Publish failed: {message}'**
  String publishFailed(String message);

  /// No description provided for @notDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Not downloaded'**
  String get notDownloaded;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'si'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'si':
      return AppLocalizationsSi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

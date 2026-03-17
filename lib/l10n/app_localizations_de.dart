// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Dhamma App';

  @override
  String get navLibrary => 'Bibliothek';

  @override
  String get navSearch => 'Suche';

  @override
  String get navDaily => 'Täglich';

  @override
  String get navAudio => 'Audio';

  @override
  String get navStudy => 'Studium';

  @override
  String get navDownloads => 'Laden';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsReading => 'Lesen';

  @override
  String get settingsTheme => 'Design';

  @override
  String get settingsFontSize => 'Schriftgröße';

  @override
  String get settingsLineSpacing => 'Zeilenabstand';

  @override
  String get settingsDefaultLanguage => 'Standardsprache';

  @override
  String get settingsAppLanguage => 'App-Sprache';

  @override
  String get settingsAppLanguageSubtitle =>
      'Sprache der Benutzeroberfläche ändern';

  @override
  String get settingsSystemDefault => 'Systemstandard';

  @override
  String get settingsDownloads => 'Downloads';

  @override
  String get settingsWifiOnly => 'Nur über WLAN herunterladen';

  @override
  String get settingsWifiOnlySubtitle =>
      'Verhindert Downloads über mobile Daten';

  @override
  String get settingsAudioMobileData => 'Audio nur über mobile Daten';

  @override
  String get settingsAudioMobileDataSubtitle =>
      'Streaming auf WLAN beschränken';

  @override
  String get settingsAccount => 'Konto';

  @override
  String get settingsManageAccount => 'Konto verwalten';

  @override
  String get settingsSignIn => 'Anmelden';

  @override
  String get settingsSignInSubtitle =>
      'Fortschritt geräteübergreifend synchronisieren';

  @override
  String get settingsSyncWifiOnly => 'Nur über WLAN synchronisieren';

  @override
  String get settingsSyncWifiOnlySubtitle =>
      'Verhindert Synchronisierung über mobile Daten';

  @override
  String get settingsAbout => 'Über';

  @override
  String get settingsLicences => 'Lizenzen';

  @override
  String get settingsSourceCode => 'Quellcode';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get settingsThemeSystem => 'Systemstandard';

  @override
  String get settingsFontSmall => 'Klein';

  @override
  String get settingsFontMedium => 'Mittel';

  @override
  String get settingsFontLarge => 'Groß';

  @override
  String get settingsFontXL => 'Sehr groß';

  @override
  String get settingsLineCompact => 'Kompakt';

  @override
  String get settingsLineNormal => 'Normal';

  @override
  String get settingsLineRelaxed => 'Entspannt';

  @override
  String get dailyTitle => 'Täglich';

  @override
  String get dailySuttaOfTheDay => 'SUTTA DES TAGES';

  @override
  String get dailyReadNow => 'Jetzt lesen';

  @override
  String get dailyNoSutta =>
      'Kein tägliches Sutta verfügbar. Bitte laden Sie das Dhammapada-Paket herunter.';

  @override
  String get dailyContinueReading => 'WEITERLESEN';

  @override
  String get dailyCompleted => 'Abgeschlossen';

  @override
  String get dailyInProgress => 'In Bearbeitung';

  @override
  String get dailyCategoryClassics => 'KLASSIKER';

  @override
  String get dailyCategoryDoctrinal => 'LEHRE';

  @override
  String get dailyCategoryMeditation => 'MEDITATION';

  @override
  String get dailyCategoryNikayaStudy => 'NIKĀYA-STUDIUM';

  @override
  String dailyDaysCount(int count, String description) {
    return '$count Tage — $description';
  }

  @override
  String get dailyBeginner => 'Anfänger';

  @override
  String get dailyIntermediate => 'Mittelstufe';

  @override
  String get dailyAdvanced => 'Fortgeschritten';

  @override
  String get searchHint => 'Suttas, Stichwörter, Titel suchen…';

  @override
  String get searchEmpty =>
      'Den Pali-Kanon durchsuchen\nnach Titel, Stichwort oder Ausdruck';

  @override
  String get searchTip =>
      'Tipp: „satipaṭṭhāna“ oder „satipatthana“ funktionieren beide';

  @override
  String searchNoResults(String query) {
    return 'Keine Ergebnisse für „$query“';
  }

  @override
  String get searchTryDifferent =>
      'Versuchen Sie ein anderes Stichwort oder laden Sie weitere Pakete herunter';

  @override
  String get searchRecentSearches => 'LETZTE SUCHEN';

  @override
  String get searchClear => 'Löschen';

  @override
  String get searchFilterResults => 'Ergebnisse filtern';

  @override
  String get searchClearAll => 'Alle löschen';

  @override
  String get searchNikaya => 'Nikāya';

  @override
  String get searchLanguage => 'Sprache';

  @override
  String get searchApply => 'Anwenden';

  @override
  String get libraryTitle => 'Bibliothek';

  @override
  String get downloadsTitle => 'Downloads';

  @override
  String get downloadsWifiOnly => 'Nur über WLAN herunterladen';

  @override
  String get downloadsWifiOnlySubtitle =>
      'Empfohlen, um mobile Daten zu sparen';

  @override
  String get downloadsInstalled => 'INSTALLIERT';

  @override
  String get downloadsAvailable => 'ZUM HERUNTERLADEN VERFÜGBAR';

  @override
  String get downloadsNoPacks =>
      'Keine Pakete verfügbar. Überprüfen Sie Ihre Internetverbindung.';

  @override
  String get downloadsAllInstalled =>
      'Alle verfügbaren Pakete sind installiert.';

  @override
  String get downloadsStorageUsed => 'Von Dhamma App genutzter Speicher';

  @override
  String get downloadsUpdateAvailable => 'Update verfügbar';

  @override
  String get downloadsUpdatePack => 'Paket aktualisieren';

  @override
  String get downloadsDeletePack => 'Paket löschen';

  @override
  String get downloadsDeleteConfirm => 'Paket löschen?';

  @override
  String downloadsDeleteMessage(String packName, String sizeMb) {
    return 'Dies entfernt „$packName“ und gibt $sizeMb MB Speicher frei.';
  }

  @override
  String get downloadsInstalling => 'Wird installiert…';

  @override
  String get downloadsDownloadFailed => 'Download fehlgeschlagen';

  @override
  String get readerSharePassage => 'Passage teilen';

  @override
  String get readerExportPdf => 'PDF exportieren';

  @override
  String get readerAddToCollection => 'Zur Sammlung hinzufügen';

  @override
  String get readerMyTranslation => 'Meine Übersetzung';

  @override
  String get readerHideMyTranslation => 'Meine Übersetzung ausblenden';

  @override
  String get readerAddAnnotation => 'Anmerkung hinzufügen';

  @override
  String get readerShowCommentary => 'Kommentar anzeigen';

  @override
  String get readerHideCommentary => 'Kommentar ausblenden';

  @override
  String get readerBookmark => 'Lesezeichen';

  @override
  String get readerRemoveBookmark => 'Lesezeichen entfernen';

  @override
  String get readerNotes => 'Notizen';

  @override
  String get readerSmaller => 'Kleiner';

  @override
  String get readerLarger => 'Größer';

  @override
  String get readerSwitchToScroll => 'Zum Scrollen wechseln';

  @override
  String get readerSwitchToPages => 'Zu Seiten wechseln';

  @override
  String get readerSingleView => 'Einzelansicht';

  @override
  String get readerSideBySide => 'Nebeneinander (Pāli)';

  @override
  String get readerPrevSutta => 'Vorheriges Sutta';

  @override
  String get readerNextSutta => 'Nächstes Sutta';

  @override
  String get readerPrevPage => 'Vorherige Seite';

  @override
  String get readerNextPage => 'Nächste Seite';

  @override
  String readerPageOf(int current, int total) {
    return '$current von $total';
  }

  @override
  String get readerPrevious => 'Zurück';

  @override
  String get readerNext => 'Weiter';

  @override
  String get readerSuttaNotFound =>
      'Sutta nicht gefunden.\nLaden Sie zuerst das Inhaltspaket herunter.';

  @override
  String get readerHighlightNote => 'Markierungsnotiz';

  @override
  String get readerWriteNoteHint => 'Schreiben Sie Ihre Notiz hier…';

  @override
  String get readerEdit => 'Bearbeiten';

  @override
  String get readerShare => 'Teilen';

  @override
  String get readerDelete => 'Löschen';

  @override
  String get dictionaryTitle => 'Pali-Wörterbuch';

  @override
  String get dictionarySearchHint => 'Pali-Wörter suchen…';

  @override
  String get dictionaryEnterWord => 'Geben Sie ein Pali-Wort ein';

  @override
  String get dictionaryNoResults => 'Keine Ergebnisse gefunden';

  @override
  String get dictionarySeeAlso => 'Siehe auch: ';

  @override
  String get communityTitle => 'Community-Pakete';

  @override
  String get communityNewest => 'Neueste zuerst';

  @override
  String get communityMostDownloaded => 'Am häufigsten heruntergeladen';

  @override
  String get communityAll => 'Alle';

  @override
  String get communityEnglish => 'Englisch';

  @override
  String get communityGerman => 'Deutsch';

  @override
  String get communitySpanish => 'Spanisch';

  @override
  String get communityNoPackages => 'Keine Pakete gefunden';

  @override
  String communityBy(String author) {
    return 'von $author';
  }

  @override
  String communityTranslations(int count) {
    return '$count Übersetzungen';
  }

  @override
  String get translationsTitle => 'Meine Übersetzungen';

  @override
  String get translationsTab => 'Übersetzungen';

  @override
  String get annotationsTab => 'Anmerkungen';

  @override
  String get translationsExportAll => 'Alle als Paket exportieren';

  @override
  String get translationsImport => 'Paket importieren';

  @override
  String get translationsPublish => 'In der Community veröffentlichen';

  @override
  String get translationsEmpty => 'Noch keine Übersetzungen';

  @override
  String get translationsEmptySubtitle =>
      'Öffnen Sie ein Sutta und wählen Sie \"Meine Übersetzung\" im Menü, um zu beginnen.';

  @override
  String get annotationsEmpty => 'Noch keine Anmerkungen';

  @override
  String get annotationsEmptySubtitle =>
      'Öffnen Sie ein Sutta und wählen Sie \"Anmerkung hinzufügen\" im Menü.';

  @override
  String get translationsImportTitle => 'Paket importieren';

  @override
  String translationsAuthor(String author) {
    return 'Autor: $author';
  }

  @override
  String translationsDescription(String desc) {
    return 'Beschreibung: $desc';
  }

  @override
  String translationsCount(int count) {
    return 'Übersetzungen: $count';
  }

  @override
  String annotationsCount(int count) {
    return 'Anmerkungen: $count';
  }

  @override
  String get translationsMergeNote =>
      'Dies wird den Paketinhalt mit Ihren bestehenden Übersetzungen zusammenführen.';

  @override
  String translationsImported(int translations, int commentary) {
    return '$translations Übersetzungen und $commentary Anmerkungen importiert';
  }

  @override
  String get translationsPublishTitle => 'In der Community veröffentlichen';

  @override
  String get translationsPublishTitleLabel => 'Titel';

  @override
  String get translationsPublishTitleHint => 'Meine Dhamma-Übersetzungen';

  @override
  String get translationsPublishAuthorLabel => 'Autorenname';

  @override
  String get translationsPublishDescLabel => 'Beschreibung (optional)';

  @override
  String get translationsPublishTitleRequired => 'Titel ist erforderlich';

  @override
  String get translationsPublished => 'In der Community veröffentlicht!';

  @override
  String get onboardingHeading => 'Dhamma App';

  @override
  String get onboardingSubtitle =>
      'Der Pali-Kanon in Ihrer Tasche.\nKostenlos, für immer.';

  @override
  String get onboardingGetStarted => 'Loslegen';

  @override
  String get onboardingChooseLanguage => 'Wählen Sie Ihre Sprache';

  @override
  String get onboardingChangeLanguageLater =>
      'Sie können dies später in den Einstellungen ändern';

  @override
  String get onboardingContinue => 'Weiter';

  @override
  String get onboardingSkipForNow => 'Vorerst überspringen';

  @override
  String get onboardingDownloadFirst => 'Laden Sie Ihr erstes Paket herunter';

  @override
  String get onboardingDownloadHint =>
      'Beginnen Sie mit den Mittleren Lehrreden — eine großartige Einführung in den Dhamma';

  @override
  String get onboardingDownloadError =>
      'Paketliste konnte nicht geladen werden. Sie können Pakete später herunterladen.';

  @override
  String onboardingDownloading(int percent) {
    return 'Wird heruntergeladen… $percent%';
  }

  @override
  String get onboardingInstalling => 'Wird installiert…';

  @override
  String get onboardingDownload => 'Herunterladen';

  @override
  String get onboardingSkipDownload => 'Überspringen — später herunterladen';

  @override
  String get onboardingHowToNavigate => 'So navigieren Sie';

  @override
  String get onboardingNavLibrary => 'Bibliothek';

  @override
  String get onboardingNavLibraryDesc =>
      'Durchsuchen Sie den Pali-Kanon nach Nikāya — vom Dīgha bis zum Khuddaka.';

  @override
  String get onboardingNavSearch => 'Suche';

  @override
  String get onboardingNavSearchDesc =>
      'Finden Sie jedes Sutta nach Stichwort, Titel oder Ausdruck — mit oder ohne Diakritika.';

  @override
  String get onboardingNavDaily => 'Täglich';

  @override
  String get onboardingNavDailyDesc =>
      'Jeden Tag ein anderes Sutta, plus strukturierte Lesepläne.';

  @override
  String get onboardingGotIt => 'Verstanden';

  @override
  String get onboardingReady => 'Sie sind bereit';

  @override
  String get onboardingReadySubtitle =>
      'Möge Ihr Studium eine Quelle der Weisheit\nund Befreiung sein.';

  @override
  String get onboardingStartReading => 'Lesen beginnen';

  @override
  String get authCreateAccount => 'Konto erstellen';

  @override
  String get authSignIn => 'Anmelden';

  @override
  String get authSyncDescription =>
      'Synchronisieren Sie Lesezeichen, Markierungen\nund Notizen geräteübergreifend';

  @override
  String get authContinueGoogle => 'Weiter mit Google';

  @override
  String get authContinueApple => 'Weiter mit Apple';

  @override
  String get authOr => 'ODER';

  @override
  String get authEmail => 'E-Mail';

  @override
  String get authPassword => 'Passwort';

  @override
  String get authEmailInvalid => 'Geben Sie eine gültige E-Mail ein';

  @override
  String get authPasswordShort => 'Mindestens 6 Zeichen';

  @override
  String get authForgotPassword => 'Passwort vergessen?';

  @override
  String get authAlreadyHaveAccount => 'Haben Sie bereits ein Konto? Anmelden';

  @override
  String get authDontHaveAccount => 'Kein Konto? Erstellen Sie eines';

  @override
  String get authContinueWithout => 'Ohne Konto fortfahren';

  @override
  String get authPasswordResetSent =>
      'E-Mail zum Zurücksetzen des Passworts gesendet';

  @override
  String get authEnterEmailFirst => 'Geben Sie zuerst Ihre E-Mail ein';

  @override
  String get profileTitle => 'Konto';

  @override
  String get profileSyncNow => 'Jetzt synchronisieren';

  @override
  String profileLastSynced(String time) {
    return 'Zuletzt synchronisiert um $time';
  }

  @override
  String get profileTapToSync => 'Tippen Sie, um Ihre Daten zu synchronisieren';

  @override
  String get profileSyncing => 'Synchronisierung...';

  @override
  String get profileSyncCompleted => 'Synchronisierung abgeschlossen';

  @override
  String get profileSyncFailed =>
      'Einige Tabellen fehlgeschlagen — tippen Sie zum Wiederholen';

  @override
  String get profileSignOut => 'Abmelden';

  @override
  String get audioTitle => 'Audio';

  @override
  String get audioChanting => 'Rezitation';

  @override
  String get audioChantingSubtitle => 'Pāli-Gesänge und Rezitationen';

  @override
  String get audioGuidedMeditation => 'Geführte Meditation';

  @override
  String get audioGuidedMeditationSubtitle =>
      'Mettā, Ānāpānasati, Body-Scan & mehr';

  @override
  String get audioDhammaTalks => 'Dhamma-Vorträge';

  @override
  String get audioDhammaTalksSubtitle => 'Lehren von angesehenen Mönchen';

  @override
  String get audioUnguided => 'TIMER OHNE ANLEITUNG';

  @override
  String get audioUnguidedDesc =>
      'Sitzen Sie in Stille mit einer Glocke am Anfang und Ende.';

  @override
  String audioMinutes(int mins) {
    return '$mins Min.';
  }

  @override
  String get audioDone => 'Fertig';

  @override
  String get audioClose => 'Schließen';

  @override
  String get audioEndEarly => 'Vorzeitig beenden';

  @override
  String get audioOpenSutta => 'Sutta öffnen';

  @override
  String get audioPlayAll => 'Alle abspielen';

  @override
  String get studyBookmarks => 'Lesezeichen';

  @override
  String get studyHighlights => 'Markierungen';

  @override
  String get studyNotes => 'Notizen';

  @override
  String get studyCollections => 'Sammlungen';

  @override
  String get studyTranslations => 'Übersetzungen';

  @override
  String get studyDictionary => 'Wörterbuch';

  @override
  String get studyCommunity => 'Community';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get delete => 'Löschen';

  @override
  String get import_ => 'Importieren';

  @override
  String get publish => 'Veröffentlichen';

  @override
  String error(String message) {
    return 'Fehler: $message';
  }

  @override
  String exportFailed(String message) {
    return 'Export fehlgeschlagen: $message';
  }

  @override
  String importFailed(String message) {
    return 'Import fehlgeschlagen: $message';
  }

  @override
  String publishFailed(String message) {
    return 'Veröffentlichung fehlgeschlagen: $message';
  }

  @override
  String get notDownloaded => 'Nicht heruntergeladen';

  @override
  String get filter => 'Filter';
}

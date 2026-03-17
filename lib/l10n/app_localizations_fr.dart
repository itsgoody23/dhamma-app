// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Dhamma App';

  @override
  String get navLibrary => 'Bibliothèque';

  @override
  String get navSearch => 'Recherche';

  @override
  String get navDaily => 'Quotidien';

  @override
  String get navAudio => 'Audio';

  @override
  String get navStudy => 'Étude';

  @override
  String get navDownloads => 'Fichiers';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsReading => 'Lecture';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsFontSize => 'Taille de police';

  @override
  String get settingsLineSpacing => 'Interligne';

  @override
  String get settingsDefaultLanguage => 'Langue par défaut';

  @override
  String get settingsAppLanguage => 'Langue de l\'application';

  @override
  String get settingsAppLanguageSubtitle => 'Changer la langue de l\'interface';

  @override
  String get settingsSystemDefault => 'Par défaut du système';

  @override
  String get settingsDownloads => 'Téléchargements';

  @override
  String get settingsWifiOnly => 'Téléchargements Wi-Fi uniquement';

  @override
  String get settingsWifiOnlySubtitle =>
      'Empêche les téléchargements sur données mobiles';

  @override
  String get settingsAudioMobileData => 'Audio sur données mobiles uniquement';

  @override
  String get settingsAudioMobileDataSubtitle => 'Limiter le streaming au Wi-Fi';

  @override
  String get settingsAccount => 'Compte';

  @override
  String get settingsManageAccount => 'Gérer le compte';

  @override
  String get settingsSignIn => 'Se connecter';

  @override
  String get settingsSignInSubtitle =>
      'Synchroniser votre progression entre appareils';

  @override
  String get settingsSyncWifiOnly => 'Synchroniser via Wi-Fi uniquement';

  @override
  String get settingsSyncWifiOnlySubtitle =>
      'Empêche la synchronisation sur données mobiles';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsLicences => 'Licences';

  @override
  String get settingsSourceCode => 'Code source';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsThemeSystem => 'Par défaut du système';

  @override
  String get settingsFontSmall => 'Petit';

  @override
  String get settingsFontMedium => 'Moyen';

  @override
  String get settingsFontLarge => 'Grand';

  @override
  String get settingsFontXL => 'Très grand';

  @override
  String get settingsLineCompact => 'Compact';

  @override
  String get settingsLineNormal => 'Normal';

  @override
  String get settingsLineRelaxed => 'Aéré';

  @override
  String get dailyTitle => 'Quotidien';

  @override
  String get dailySuttaOfTheDay => 'SUTTA DU JOUR';

  @override
  String get dailyReadNow => 'Lire maintenant';

  @override
  String get dailyNoSutta =>
      'Aucun sutta quotidien disponible. Veuillez télécharger le pack Dhammapada.';

  @override
  String get dailyContinueReading => 'CONTINUER LA LECTURE';

  @override
  String get dailyCompleted => 'Terminé';

  @override
  String get dailyInProgress => 'En cours';

  @override
  String get dailyCategoryClassics => 'CLASSIQUES';

  @override
  String get dailyCategoryDoctrinal => 'DOCTRINAL';

  @override
  String get dailyCategoryMeditation => 'MÉDITATION';

  @override
  String get dailyCategoryNikayaStudy => 'ÉTUDE DES NIKĀYA';

  @override
  String dailyDaysCount(int count, String description) {
    return '$count jours — $description';
  }

  @override
  String get dailyBeginner => 'Débutant';

  @override
  String get dailyIntermediate => 'Intermédiaire';

  @override
  String get dailyAdvanced => 'Avancé';

  @override
  String get searchHint => 'Rechercher suttas, mots-clés, titres…';

  @override
  String get searchEmpty =>
      'Rechercher dans le Canon pali\npar titre, mot-clé ou expression';

  @override
  String get searchTip =>
      'Astuce : « satipaṭṭhāna » ou « satipatthana » fonctionnent tous les deux';

  @override
  String searchNoResults(String query) {
    return 'Aucun résultat pour « $query »';
  }

  @override
  String get searchTryDifferent =>
      'Essayez un autre mot-clé ou téléchargez plus de packs';

  @override
  String get searchRecentSearches => 'RECHERCHES RÉCENTES';

  @override
  String get searchClear => 'Effacer';

  @override
  String get searchFilterResults => 'Filtrer les résultats';

  @override
  String get searchClearAll => 'Tout effacer';

  @override
  String get searchNikaya => 'Nikāya';

  @override
  String get searchLanguage => 'Langue';

  @override
  String get searchApply => 'Appliquer';

  @override
  String get libraryTitle => 'Bibliothèque';

  @override
  String get downloadsTitle => 'Téléchargements';

  @override
  String get downloadsWifiOnly => 'Téléchargements Wi-Fi uniquement';

  @override
  String get downloadsWifiOnlySubtitle =>
      'Recommandé pour économiser les données mobiles';

  @override
  String get downloadsInstalled => 'INSTALLÉS';

  @override
  String get downloadsAvailable => 'DISPONIBLES AU TÉLÉCHARGEMENT';

  @override
  String get downloadsNoPacks =>
      'Aucun pack disponible. Vérifiez votre connexion internet.';

  @override
  String get downloadsAllInstalled =>
      'Tous les packs disponibles sont installés.';

  @override
  String get downloadsStorageUsed => 'Stockage utilisé par Dhamma App';

  @override
  String get downloadsUpdateAvailable => 'Mise à jour disponible';

  @override
  String get downloadsUpdatePack => 'Mettre à jour le pack';

  @override
  String get downloadsDeletePack => 'Supprimer le pack';

  @override
  String get downloadsDeleteConfirm => 'Supprimer le pack ?';

  @override
  String downloadsDeleteMessage(String packName, String sizeMb) {
    return 'Cela supprimera « $packName » et libérera $sizeMb Mo de stockage.';
  }

  @override
  String get downloadsInstalling => 'Installation…';

  @override
  String get downloadsDownloadFailed => 'Échec du téléchargement';

  @override
  String get readerSharePassage => 'Partager le passage';

  @override
  String get readerExportPdf => 'Exporter en PDF';

  @override
  String get readerAddToCollection => 'Ajouter à la collection';

  @override
  String get readerMyTranslation => 'Ma traduction';

  @override
  String get readerHideMyTranslation => 'Masquer ma traduction';

  @override
  String get readerAddAnnotation => 'Ajouter une annotation';

  @override
  String get readerShowCommentary => 'Afficher le commentaire';

  @override
  String get readerHideCommentary => 'Masquer le commentaire';

  @override
  String get readerBookmark => 'Signet';

  @override
  String get readerRemoveBookmark => 'Supprimer le signet';

  @override
  String get readerNotes => 'Notes';

  @override
  String get readerSmaller => 'Plus petit';

  @override
  String get readerLarger => 'Plus grand';

  @override
  String get readerSwitchToScroll => 'Passer au défilement';

  @override
  String get readerSwitchToPages => 'Passer aux pages';

  @override
  String get readerSingleView => 'Vue simple';

  @override
  String get readerSideBySide => 'Côte à côte (Pāli)';

  @override
  String get readerPrevSutta => 'Sutta précédent';

  @override
  String get readerNextSutta => 'Sutta suivant';

  @override
  String get readerPrevPage => 'Page précédente';

  @override
  String get readerNextPage => 'Page suivante';

  @override
  String readerPageOf(int current, int total) {
    return '$current sur $total';
  }

  @override
  String get readerPrevious => 'Précédent';

  @override
  String get readerNext => 'Suivant';

  @override
  String get readerSuttaNotFound =>
      'Sutta introuvable.\nTéléchargez d\'abord le pack de contenu.';

  @override
  String get readerHighlightNote => 'Note de surlignage';

  @override
  String get readerWriteNoteHint => 'Écrivez votre note ici…';

  @override
  String get readerEdit => 'Modifier';

  @override
  String get readerShare => 'Partager';

  @override
  String get readerDelete => 'Supprimer';

  @override
  String get dictionaryTitle => 'Dictionnaire pali';

  @override
  String get dictionarySearchHint => 'Rechercher des mots pali…';

  @override
  String get dictionaryEnterWord => 'Entrez un mot pali à rechercher';

  @override
  String get dictionaryNoResults => 'Aucun résultat trouvé';

  @override
  String get dictionarySeeAlso => 'Voir aussi : ';

  @override
  String get communityTitle => 'Packs communautaires';

  @override
  String get communityNewest => 'Plus récents';

  @override
  String get communityMostDownloaded => 'Plus téléchargés';

  @override
  String get communityAll => 'Tous';

  @override
  String get communityEnglish => 'Anglais';

  @override
  String get communityGerman => 'Allemand';

  @override
  String get communitySpanish => 'Espagnol';

  @override
  String get communityNoPackages => 'Aucun pack trouvé';

  @override
  String communityBy(String author) {
    return 'par $author';
  }

  @override
  String communityTranslations(int count) {
    return '$count traductions';
  }

  @override
  String get translationsTitle => 'Mes traductions';

  @override
  String get translationsTab => 'Traductions';

  @override
  String get annotationsTab => 'Annotations';

  @override
  String get translationsExportAll => 'Tout exporter en pack';

  @override
  String get translationsImport => 'Importer un pack';

  @override
  String get translationsPublish => 'Publier dans la communauté';

  @override
  String get translationsEmpty => 'Pas encore de traductions';

  @override
  String get translationsEmptySubtitle =>
      'Ouvrez un sutta et sélectionnez « Ma traduction » dans le menu pour commencer.';

  @override
  String get annotationsEmpty => 'Pas encore d\'annotations';

  @override
  String get annotationsEmptySubtitle =>
      'Ouvrez un sutta et sélectionnez « Ajouter une annotation » dans le menu.';

  @override
  String get translationsImportTitle => 'Importer un pack';

  @override
  String translationsAuthor(String author) {
    return 'Auteur : $author';
  }

  @override
  String translationsDescription(String desc) {
    return 'Description : $desc';
  }

  @override
  String translationsCount(int count) {
    return 'Traductions : $count';
  }

  @override
  String annotationsCount(int count) {
    return 'Annotations : $count';
  }

  @override
  String get translationsMergeNote =>
      'Cela fusionnera le contenu du pack avec vos traductions existantes.';

  @override
  String translationsImported(int translations, int commentary) {
    return '$translations traductions et $commentary annotations importées';
  }

  @override
  String get translationsPublishTitle => 'Publier dans la communauté';

  @override
  String get translationsPublishTitleLabel => 'Titre';

  @override
  String get translationsPublishTitleHint => 'Mes traductions du Dhamma';

  @override
  String get translationsPublishAuthorLabel => 'Nom de l\'auteur';

  @override
  String get translationsPublishDescLabel => 'Description (optionnel)';

  @override
  String get translationsPublishTitleRequired => 'Le titre est requis';

  @override
  String get translationsPublished => 'Publié dans la communauté !';

  @override
  String get onboardingHeading => 'Dhamma App';

  @override
  String get onboardingSubtitle =>
      'Le Canon pali, dans votre poche.\nGratuit, pour toujours.';

  @override
  String get onboardingGetStarted => 'Commencer';

  @override
  String get onboardingChooseLanguage => 'Choisissez votre langue';

  @override
  String get onboardingChangeLanguageLater =>
      'Vous pouvez changer cela plus tard dans les Paramètres';

  @override
  String get onboardingContinue => 'Continuer';

  @override
  String get onboardingSkipForNow => 'Passer pour l\'instant';

  @override
  String get onboardingDownloadFirst => 'Téléchargez votre premier pack';

  @override
  String get onboardingDownloadHint =>
      'Commencez par les Discours de longueur moyenne — une excellente introduction au Dhamma';

  @override
  String get onboardingDownloadError =>
      'Impossible de charger la liste des packs. Vous pourrez télécharger des packs plus tard.';

  @override
  String onboardingDownloading(int percent) {
    return 'Téléchargement… $percent%';
  }

  @override
  String get onboardingInstalling => 'Installation…';

  @override
  String get onboardingDownload => 'Télécharger';

  @override
  String get onboardingSkipDownload => 'Passer — télécharger plus tard';

  @override
  String get onboardingHowToNavigate => 'Comment naviguer';

  @override
  String get onboardingNavLibrary => 'Bibliothèque';

  @override
  String get onboardingNavLibraryDesc =>
      'Parcourez le Canon pali par Nikāya — du Dīgha au Khuddaka.';

  @override
  String get onboardingNavSearch => 'Recherche';

  @override
  String get onboardingNavSearchDesc =>
      'Trouvez n\'importe quel sutta par mot-clé, titre ou expression — avec ou sans signes diacritiques.';

  @override
  String get onboardingNavDaily => 'Quotidien';

  @override
  String get onboardingNavDailyDesc =>
      'Un sutta différent chaque jour, plus des plans de lecture structurés.';

  @override
  String get onboardingGotIt => 'Compris';

  @override
  String get onboardingReady => 'Vous êtes prêt';

  @override
  String get onboardingReadySubtitle =>
      'Que votre étude soit une source de sagesse\net de libération.';

  @override
  String get onboardingStartReading => 'Commencer la lecture';

  @override
  String get authCreateAccount => 'Créer un compte';

  @override
  String get authSignIn => 'Se connecter';

  @override
  String get authSyncDescription =>
      'Synchronisez vos signets, surlignages\net notes entre appareils';

  @override
  String get authContinueGoogle => 'Continuer avec Google';

  @override
  String get authContinueApple => 'Continuer avec Apple';

  @override
  String get authOr => 'OU';

  @override
  String get authEmail => 'E-mail';

  @override
  String get authPassword => 'Mot de passe';

  @override
  String get authEmailInvalid => 'Entrez un e-mail valide';

  @override
  String get authPasswordShort => 'Au moins 6 caractères';

  @override
  String get authForgotPassword => 'Mot de passe oublié ?';

  @override
  String get authAlreadyHaveAccount => 'Déjà un compte ? Se connecter';

  @override
  String get authDontHaveAccount => 'Pas de compte ? Créez-en un';

  @override
  String get authContinueWithout => 'Continuer sans compte';

  @override
  String get authPasswordResetSent => 'E-mail de réinitialisation envoyé';

  @override
  String get authEnterEmailFirst => 'Entrez d\'abord votre e-mail';

  @override
  String get profileTitle => 'Compte';

  @override
  String get profileSyncNow => 'Synchroniser maintenant';

  @override
  String profileLastSynced(String time) {
    return 'Dernière synchronisation à $time';
  }

  @override
  String get profileTapToSync => 'Appuyez pour synchroniser vos données';

  @override
  String get profileSyncing => 'Synchronisation...';

  @override
  String get profileSyncCompleted => 'Synchronisation terminée';

  @override
  String get profileSyncFailed =>
      'Certaines tables ont échoué — appuyez pour réessayer';

  @override
  String get profileSignOut => 'Se déconnecter';

  @override
  String get audioTitle => 'Audio';

  @override
  String get audioChanting => 'Récitation';

  @override
  String get audioChantingSubtitle => 'Chants et récitations en pāli';

  @override
  String get audioGuidedMeditation => 'Méditation guidée';

  @override
  String get audioGuidedMeditationSubtitle =>
      'Mettā, ānāpānasati, scan corporel & plus';

  @override
  String get audioDhammaTalks => 'Enseignements du Dhamma';

  @override
  String get audioDhammaTalksSubtitle => 'Enseignements de moines respectés';

  @override
  String get audioUnguided => 'MINUTERIE SANS GUIDE';

  @override
  String get audioUnguidedDesc =>
      'Asseyez-vous en silence avec une cloche au début et à la fin.';

  @override
  String audioMinutes(int mins) {
    return '$mins min';
  }

  @override
  String get audioDone => 'Terminé';

  @override
  String get audioClose => 'Fermer';

  @override
  String get audioEndEarly => 'Terminer plus tôt';

  @override
  String get audioOpenSutta => 'Ouvrir le sutta';

  @override
  String get audioPlayAll => 'Tout lire';

  @override
  String get studyBookmarks => 'Signets';

  @override
  String get studyHighlights => 'Surlignages';

  @override
  String get studyNotes => 'Notes';

  @override
  String get studyCollections => 'Collections';

  @override
  String get studyTranslations => 'Traductions';

  @override
  String get studyDictionary => 'Dictionnaire';

  @override
  String get studyCommunity => 'Communauté';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get import_ => 'Importer';

  @override
  String get publish => 'Publier';

  @override
  String error(String message) {
    return 'Erreur : $message';
  }

  @override
  String exportFailed(String message) {
    return 'Échec de l\'exportation : $message';
  }

  @override
  String importFailed(String message) {
    return 'Échec de l\'importation : $message';
  }

  @override
  String publishFailed(String message) {
    return 'Échec de la publication : $message';
  }

  @override
  String get notDownloaded => 'Non téléchargé';

  @override
  String get filter => 'Filtrer';
}

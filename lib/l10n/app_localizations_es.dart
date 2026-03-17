// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Dhamma App';

  @override
  String get navLibrary => 'Biblioteca';

  @override
  String get navSearch => 'Buscar';

  @override
  String get navDaily => 'Diario';

  @override
  String get navAudio => 'Audio';

  @override
  String get navStudy => 'Estudio';

  @override
  String get navDownloads => 'Guardado';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsReading => 'Lectura';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsFontSize => 'Tamaño de fuente';

  @override
  String get settingsLineSpacing => 'Interlineado';

  @override
  String get settingsDefaultLanguage => 'Idioma predeterminado';

  @override
  String get settingsAppLanguage => 'Idioma de la aplicación';

  @override
  String get settingsAppLanguageSubtitle => 'Cambiar el idioma de la interfaz';

  @override
  String get settingsSystemDefault => 'Predeterminado del sistema';

  @override
  String get settingsDownloads => 'Descargas';

  @override
  String get settingsWifiOnly => 'Descargas solo por Wi-Fi';

  @override
  String get settingsWifiOnlySubtitle => 'Impide descargas con datos móviles';

  @override
  String get settingsAudioMobileData => 'Audio solo con datos móviles';

  @override
  String get settingsAudioMobileDataSubtitle => 'Restringir streaming a Wi-Fi';

  @override
  String get settingsAccount => 'Cuenta';

  @override
  String get settingsManageAccount => 'Administrar cuenta';

  @override
  String get settingsSignIn => 'Iniciar sesión';

  @override
  String get settingsSignInSubtitle =>
      'Sincroniza tu progreso entre dispositivos';

  @override
  String get settingsSyncWifiOnly => 'Sincronizar solo por Wi-Fi';

  @override
  String get settingsSyncWifiOnlySubtitle =>
      'Impide la sincronización con datos móviles';

  @override
  String get settingsAbout => 'Acerca de';

  @override
  String get settingsLicences => 'Licencias';

  @override
  String get settingsSourceCode => 'Código fuente';

  @override
  String get settingsVersion => 'Versión';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsThemeSystem => 'Predeterminado del sistema';

  @override
  String get settingsFontSmall => 'Pequeño';

  @override
  String get settingsFontMedium => 'Mediano';

  @override
  String get settingsFontLarge => 'Grande';

  @override
  String get settingsFontXL => 'Extra grande';

  @override
  String get settingsLineCompact => 'Compacto';

  @override
  String get settingsLineNormal => 'Normal';

  @override
  String get settingsLineRelaxed => 'Espaciado';

  @override
  String get dailyTitle => 'Diario';

  @override
  String get dailySuttaOfTheDay => 'SUTTA DEL DÍA';

  @override
  String get dailyReadNow => 'Leer ahora';

  @override
  String get dailyNoSutta =>
      'No hay sutta diario disponible. Por favor descarga el pack del Dhammapada.';

  @override
  String get dailyContinueReading => 'CONTINUAR LEYENDO';

  @override
  String get dailyCompleted => 'Completado';

  @override
  String get dailyInProgress => 'En progreso';

  @override
  String get dailyCategoryClassics => 'CLÁSICOS';

  @override
  String get dailyCategoryDoctrinal => 'DOCTRINAL';

  @override
  String get dailyCategoryMeditation => 'MEDITACIÓN';

  @override
  String get dailyCategoryNikayaStudy => 'ESTUDIO DE NIKĀYA';

  @override
  String dailyDaysCount(int count, String description) {
    return '$count días — $description';
  }

  @override
  String get dailyBeginner => 'Principiante';

  @override
  String get dailyIntermediate => 'Intermedio';

  @override
  String get dailyAdvanced => 'Avanzado';

  @override
  String get searchHint => 'Buscar suttas, palabras clave, títulos…';

  @override
  String get searchEmpty =>
      'Buscar en el Canon Pali\npor título, palabra clave o frase';

  @override
  String get searchTip =>
      'Consejo: «satipaṭṭhāna» o «satipatthana» ambos funcionan';

  @override
  String searchNoResults(String query) {
    return 'Sin resultados para «$query»';
  }

  @override
  String get searchTryDifferent =>
      'Prueba otra palabra clave o descarga más packs';

  @override
  String get searchRecentSearches => 'BÚSQUEDAS RECIENTES';

  @override
  String get searchClear => 'Borrar';

  @override
  String get searchFilterResults => 'Filtrar resultados';

  @override
  String get searchClearAll => 'Borrar todo';

  @override
  String get searchNikaya => 'Nikāya';

  @override
  String get searchLanguage => 'Idioma';

  @override
  String get searchApply => 'Aplicar';

  @override
  String get libraryTitle => 'Biblioteca';

  @override
  String get downloadsTitle => 'Descargas';

  @override
  String get downloadsWifiOnly => 'Descargas solo por Wi-Fi';

  @override
  String get downloadsWifiOnlySubtitle =>
      'Recomendado para ahorrar datos móviles';

  @override
  String get downloadsInstalled => 'INSTALADOS';

  @override
  String get downloadsAvailable => 'DISPONIBLES PARA DESCARGAR';

  @override
  String get downloadsNoPacks =>
      'No hay packs disponibles. Verifica tu conexión a internet.';

  @override
  String get downloadsAllInstalled =>
      'Todos los packs disponibles están instalados.';

  @override
  String get downloadsStorageUsed => 'Almacenamiento usado por Dhamma App';

  @override
  String get downloadsUpdateAvailable => 'Actualización disponible';

  @override
  String get downloadsUpdatePack => 'Actualizar pack';

  @override
  String get downloadsDeletePack => 'Eliminar pack';

  @override
  String get downloadsDeleteConfirm => '¿Eliminar pack?';

  @override
  String downloadsDeleteMessage(String packName, String sizeMb) {
    return 'Esto eliminará «$packName» y liberará $sizeMb MB de almacenamiento.';
  }

  @override
  String get downloadsInstalling => 'Instalando…';

  @override
  String get downloadsDownloadFailed => 'Descarga fallida';

  @override
  String get readerSharePassage => 'Compartir pasaje';

  @override
  String get readerExportPdf => 'Exportar PDF';

  @override
  String get readerAddToCollection => 'Añadir a colección';

  @override
  String get readerMyTranslation => 'Mi traducción';

  @override
  String get readerHideMyTranslation => 'Ocultar mi traducción';

  @override
  String get readerAddAnnotation => 'Añadir anotación';

  @override
  String get readerShowCommentary => 'Mostrar comentario';

  @override
  String get readerHideCommentary => 'Ocultar comentario';

  @override
  String get readerBookmark => 'Marcador';

  @override
  String get readerRemoveBookmark => 'Eliminar marcador';

  @override
  String get readerNotes => 'Notas';

  @override
  String get readerSmaller => 'Más pequeño';

  @override
  String get readerLarger => 'Más grande';

  @override
  String get readerSwitchToScroll => 'Cambiar a desplazamiento';

  @override
  String get readerSwitchToPages => 'Cambiar a páginas';

  @override
  String get readerSingleView => 'Vista simple';

  @override
  String get readerSideBySide => 'Lado a lado (Pāli)';

  @override
  String get readerPrevSutta => 'Sutta anterior';

  @override
  String get readerNextSutta => 'Sutta siguiente';

  @override
  String get readerPrevPage => 'Página anterior';

  @override
  String get readerNextPage => 'Página siguiente';

  @override
  String readerPageOf(int current, int total) {
    return '$current de $total';
  }

  @override
  String get readerPrevious => 'Anterior';

  @override
  String get readerNext => 'Siguiente';

  @override
  String get readerSuttaNotFound =>
      'Sutta no encontrado.\nDescarga primero el pack de contenido.';

  @override
  String get readerHighlightNote => 'Nota de resaltado';

  @override
  String get readerWriteNoteHint => 'Escribe tu nota aquí…';

  @override
  String get readerEdit => 'Editar';

  @override
  String get readerShare => 'Compartir';

  @override
  String get readerDelete => 'Eliminar';

  @override
  String get dictionaryTitle => 'Diccionario Pali';

  @override
  String get dictionarySearchHint => 'Buscar palabras pali…';

  @override
  String get dictionaryEnterWord => 'Introduce una palabra pali para buscar';

  @override
  String get dictionaryNoResults => 'No se encontraron resultados';

  @override
  String get dictionarySeeAlso => 'Ver también: ';

  @override
  String get communityTitle => 'Packs de la comunidad';

  @override
  String get communityNewest => 'Más recientes';

  @override
  String get communityMostDownloaded => 'Más descargados';

  @override
  String get communityAll => 'Todos';

  @override
  String get communityEnglish => 'Inglés';

  @override
  String get communityGerman => 'Alemán';

  @override
  String get communitySpanish => 'Español';

  @override
  String get communityNoPackages => 'No se encontraron packs';

  @override
  String communityBy(String author) {
    return 'por $author';
  }

  @override
  String communityTranslations(int count) {
    return '$count traducciones';
  }

  @override
  String get translationsTitle => 'Mis traducciones';

  @override
  String get translationsTab => 'Traducciones';

  @override
  String get annotationsTab => 'Anotaciones';

  @override
  String get translationsExportAll => 'Exportar todo como pack';

  @override
  String get translationsImport => 'Importar pack';

  @override
  String get translationsPublish => 'Publicar en la comunidad';

  @override
  String get translationsEmpty => 'Aún no hay traducciones';

  @override
  String get translationsEmptySubtitle =>
      'Abre cualquier sutta y selecciona \"Mi traducción\" en el menú para empezar.';

  @override
  String get annotationsEmpty => 'Aún no hay anotaciones';

  @override
  String get annotationsEmptySubtitle =>
      'Abre cualquier sutta y selecciona \"Añadir anotación\" en el menú.';

  @override
  String get translationsImportTitle => 'Importar pack';

  @override
  String translationsAuthor(String author) {
    return 'Autor: $author';
  }

  @override
  String translationsDescription(String desc) {
    return 'Descripción: $desc';
  }

  @override
  String translationsCount(int count) {
    return 'Traducciones: $count';
  }

  @override
  String annotationsCount(int count) {
    return 'Anotaciones: $count';
  }

  @override
  String get translationsMergeNote =>
      'Esto fusionará el contenido del pack con tus traducciones existentes.';

  @override
  String translationsImported(int translations, int commentary) {
    return '$translations traducciones y $commentary anotaciones importadas';
  }

  @override
  String get translationsPublishTitle => 'Publicar en la comunidad';

  @override
  String get translationsPublishTitleLabel => 'Título';

  @override
  String get translationsPublishTitleHint => 'Mis traducciones del Dhamma';

  @override
  String get translationsPublishAuthorLabel => 'Nombre del autor';

  @override
  String get translationsPublishDescLabel => 'Descripción (opcional)';

  @override
  String get translationsPublishTitleRequired => 'El título es obligatorio';

  @override
  String get translationsPublished => '¡Publicado en la comunidad!';

  @override
  String get onboardingHeading => 'Dhamma App';

  @override
  String get onboardingSubtitle =>
      'El Canon Pali, en tu bolsillo.\nGratis, para siempre.';

  @override
  String get onboardingGetStarted => 'Empezar';

  @override
  String get onboardingChooseLanguage => 'Elige tu idioma';

  @override
  String get onboardingChangeLanguageLater =>
      'Puedes cambiar esto más tarde en Ajustes';

  @override
  String get onboardingContinue => 'Continuar';

  @override
  String get onboardingSkipForNow => 'Saltar por ahora';

  @override
  String get onboardingDownloadFirst => 'Descarga tu primer pack';

  @override
  String get onboardingDownloadHint =>
      'Empieza con los Discursos de longitud media — una gran introducción al Dhamma';

  @override
  String get onboardingDownloadError =>
      'No se pudo cargar la lista de packs. Puedes descargar packs más tarde.';

  @override
  String onboardingDownloading(int percent) {
    return 'Descargando… $percent%';
  }

  @override
  String get onboardingInstalling => 'Instalando…';

  @override
  String get onboardingDownload => 'Descargar';

  @override
  String get onboardingSkipDownload => 'Saltar — descargar después';

  @override
  String get onboardingHowToNavigate => 'Cómo navegar';

  @override
  String get onboardingNavLibrary => 'Biblioteca';

  @override
  String get onboardingNavLibraryDesc =>
      'Explora el Canon Pali por Nikāya — desde el Dīgha hasta el Khuddaka.';

  @override
  String get onboardingNavSearch => 'Buscar';

  @override
  String get onboardingNavSearchDesc =>
      'Encuentra cualquier sutta por palabra clave, título o frase — con o sin signos diacríticos.';

  @override
  String get onboardingNavDaily => 'Diario';

  @override
  String get onboardingNavDailyDesc =>
      'Un sutta diferente cada día, más planes de lectura estructurados.';

  @override
  String get onboardingGotIt => 'Entendido';

  @override
  String get onboardingReady => 'Estás listo';

  @override
  String get onboardingReadySubtitle =>
      'Que tu estudio sea una fuente de sabiduría\ny liberación.';

  @override
  String get onboardingStartReading => 'Empezar a leer';

  @override
  String get authCreateAccount => 'Crear cuenta';

  @override
  String get authSignIn => 'Iniciar sesión';

  @override
  String get authSyncDescription =>
      'Sincroniza tus marcadores, resaltados\ny notas entre dispositivos';

  @override
  String get authContinueGoogle => 'Continuar con Google';

  @override
  String get authContinueApple => 'Continuar con Apple';

  @override
  String get authOr => 'O';

  @override
  String get authEmail => 'Correo electrónico';

  @override
  String get authPassword => 'Contraseña';

  @override
  String get authEmailInvalid => 'Introduce un correo válido';

  @override
  String get authPasswordShort => 'Al menos 6 caracteres';

  @override
  String get authForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get authAlreadyHaveAccount => '¿Ya tienes cuenta? Inicia sesión';

  @override
  String get authDontHaveAccount => '¿No tienes cuenta? Crea una';

  @override
  String get authContinueWithout => 'Continuar sin cuenta';

  @override
  String get authPasswordResetSent => 'Correo de restablecimiento enviado';

  @override
  String get authEnterEmailFirst => 'Introduce primero tu correo';

  @override
  String get profileTitle => 'Cuenta';

  @override
  String get profileSyncNow => 'Sincronizar ahora';

  @override
  String profileLastSynced(String time) {
    return 'Última sincronización a las $time';
  }

  @override
  String get profileTapToSync => 'Toca para sincronizar tus datos';

  @override
  String get profileSyncing => 'Sincronizando...';

  @override
  String get profileSyncCompleted => 'Sincronización completada';

  @override
  String get profileSyncFailed =>
      'Algunas tablas fallaron — toca para reintentar';

  @override
  String get profileSignOut => 'Cerrar sesión';

  @override
  String get audioTitle => 'Audio';

  @override
  String get audioChanting => 'Recitación';

  @override
  String get audioChantingSubtitle => 'Cantos y recitaciones en pāli';

  @override
  String get audioGuidedMeditation => 'Meditación guiada';

  @override
  String get audioGuidedMeditationSubtitle =>
      'Mettā, ānāpānasati, escaneo corporal y más';

  @override
  String get audioDhammaTalks => 'Charlas del Dhamma';

  @override
  String get audioDhammaTalksSubtitle => 'Enseñanzas de monásticos respetados';

  @override
  String get audioUnguided => 'TEMPORIZADOR SIN GUÍA';

  @override
  String get audioUnguidedDesc =>
      'Siéntate en silencio con una campana al inicio y al final.';

  @override
  String audioMinutes(int mins) {
    return '$mins min';
  }

  @override
  String get audioDone => 'Hecho';

  @override
  String get audioClose => 'Cerrar';

  @override
  String get audioEndEarly => 'Terminar antes';

  @override
  String get audioOpenSutta => 'Abrir sutta';

  @override
  String get audioPlayAll => 'Reproducir todo';

  @override
  String get studyBookmarks => 'Marcadores';

  @override
  String get studyHighlights => 'Resaltados';

  @override
  String get studyNotes => 'Notas';

  @override
  String get studyCollections => 'Colecciones';

  @override
  String get studyTranslations => 'Traducciones';

  @override
  String get studyDictionary => 'Diccionario';

  @override
  String get studyCommunity => 'Comunidad';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get import_ => 'Importar';

  @override
  String get publish => 'Publicar';

  @override
  String error(String message) {
    return 'Error: $message';
  }

  @override
  String exportFailed(String message) {
    return 'Error al exportar: $message';
  }

  @override
  String importFailed(String message) {
    return 'Error al importar: $message';
  }

  @override
  String publishFailed(String message) {
    return 'Error al publicar: $message';
  }

  @override
  String get notDownloaded => 'No descargado';

  @override
  String get filter => 'Filtrar';
}

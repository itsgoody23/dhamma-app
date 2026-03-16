// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TextsTable extends Texts with TableInfo<$TextsTable, SuttaText> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TextsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
      'uid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _collectionMeta =
      const VerificationMeta('collection');
  @override
  late final GeneratedColumn<String> collection = GeneratedColumn<String>(
      'collection', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nikayaMeta = const VerificationMeta('nikaya');
  @override
  late final GeneratedColumn<String> nikaya = GeneratedColumn<String>(
      'nikaya', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bookMeta = const VerificationMeta('book');
  @override
  late final GeneratedColumn<String> book = GeneratedColumn<String>(
      'book', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _chapterMeta =
      const VerificationMeta('chapter');
  @override
  late final GeneratedColumn<String> chapter = GeneratedColumn<String>(
      'chapter', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _translatorMeta =
      const VerificationMeta('translator');
  @override
  late final GeneratedColumn<String> translator = GeneratedColumn<String>(
      'translator', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contentHtmlMeta =
      const VerificationMeta('contentHtml');
  @override
  late final GeneratedColumn<String> contentHtml = GeneratedColumn<String>(
      'content_html', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contentPlainMeta =
      const VerificationMeta('contentPlain');
  @override
  late final GeneratedColumn<String> contentPlain = GeneratedColumn<String>(
      'content_plain', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uid,
        title,
        collection,
        nikaya,
        book,
        chapter,
        language,
        translator,
        source,
        contentHtml,
        contentPlain
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'texts';
  @override
  VerificationContext validateIntegrity(Insertable<SuttaText> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uid')) {
      context.handle(
          _uidMeta, uid.isAcceptableOrUnknown(data['uid']!, _uidMeta));
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('collection')) {
      context.handle(
          _collectionMeta,
          collection.isAcceptableOrUnknown(
              data['collection']!, _collectionMeta));
    }
    if (data.containsKey('nikaya')) {
      context.handle(_nikayaMeta,
          nikaya.isAcceptableOrUnknown(data['nikaya']!, _nikayaMeta));
    } else if (isInserting) {
      context.missing(_nikayaMeta);
    }
    if (data.containsKey('book')) {
      context.handle(
          _bookMeta, book.isAcceptableOrUnknown(data['book']!, _bookMeta));
    }
    if (data.containsKey('chapter')) {
      context.handle(_chapterMeta,
          chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta));
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('translator')) {
      context.handle(
          _translatorMeta,
          translator.isAcceptableOrUnknown(
              data['translator']!, _translatorMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('content_html')) {
      context.handle(
          _contentHtmlMeta,
          contentHtml.isAcceptableOrUnknown(
              data['content_html']!, _contentHtmlMeta));
    }
    if (data.containsKey('content_plain')) {
      context.handle(
          _contentPlainMeta,
          contentPlain.isAcceptableOrUnknown(
              data['content_plain']!, _contentPlainMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {uid, language},
      ];
  @override
  SuttaText map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SuttaText(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uid'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      collection: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}collection']),
      nikaya: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nikaya'])!,
      book: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}book']),
      chapter: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chapter']),
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      translator: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}translator']),
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source']),
      contentHtml: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_html']),
      contentPlain: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_plain']),
    );
  }

  @override
  $TextsTable createAlias(String alias) {
    return $TextsTable(attachedDatabase, alias);
  }
}

class SuttaText extends DataClass implements Insertable<SuttaText> {
  final int id;
  final String uid;
  final String title;
  final String? collection;
  final String nikaya;
  final String? book;
  final String? chapter;
  final String language;
  final String? translator;
  final String? source;
  final String? contentHtml;
  final String? contentPlain;
  const SuttaText(
      {required this.id,
      required this.uid,
      required this.title,
      this.collection,
      required this.nikaya,
      this.book,
      this.chapter,
      required this.language,
      this.translator,
      this.source,
      this.contentHtml,
      this.contentPlain});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uid'] = Variable<String>(uid);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || collection != null) {
      map['collection'] = Variable<String>(collection);
    }
    map['nikaya'] = Variable<String>(nikaya);
    if (!nullToAbsent || book != null) {
      map['book'] = Variable<String>(book);
    }
    if (!nullToAbsent || chapter != null) {
      map['chapter'] = Variable<String>(chapter);
    }
    map['language'] = Variable<String>(language);
    if (!nullToAbsent || translator != null) {
      map['translator'] = Variable<String>(translator);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    if (!nullToAbsent || contentHtml != null) {
      map['content_html'] = Variable<String>(contentHtml);
    }
    if (!nullToAbsent || contentPlain != null) {
      map['content_plain'] = Variable<String>(contentPlain);
    }
    return map;
  }

  TextsCompanion toCompanion(bool nullToAbsent) {
    return TextsCompanion(
      id: Value(id),
      uid: Value(uid),
      title: Value(title),
      collection: collection == null && nullToAbsent
          ? const Value.absent()
          : Value(collection),
      nikaya: Value(nikaya),
      book: book == null && nullToAbsent ? const Value.absent() : Value(book),
      chapter: chapter == null && nullToAbsent
          ? const Value.absent()
          : Value(chapter),
      language: Value(language),
      translator: translator == null && nullToAbsent
          ? const Value.absent()
          : Value(translator),
      source:
          source == null && nullToAbsent ? const Value.absent() : Value(source),
      contentHtml: contentHtml == null && nullToAbsent
          ? const Value.absent()
          : Value(contentHtml),
      contentPlain: contentPlain == null && nullToAbsent
          ? const Value.absent()
          : Value(contentPlain),
    );
  }

  factory SuttaText.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SuttaText(
      id: serializer.fromJson<int>(json['id']),
      uid: serializer.fromJson<String>(json['uid']),
      title: serializer.fromJson<String>(json['title']),
      collection: serializer.fromJson<String?>(json['collection']),
      nikaya: serializer.fromJson<String>(json['nikaya']),
      book: serializer.fromJson<String?>(json['book']),
      chapter: serializer.fromJson<String?>(json['chapter']),
      language: serializer.fromJson<String>(json['language']),
      translator: serializer.fromJson<String?>(json['translator']),
      source: serializer.fromJson<String?>(json['source']),
      contentHtml: serializer.fromJson<String?>(json['contentHtml']),
      contentPlain: serializer.fromJson<String?>(json['contentPlain']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uid': serializer.toJson<String>(uid),
      'title': serializer.toJson<String>(title),
      'collection': serializer.toJson<String?>(collection),
      'nikaya': serializer.toJson<String>(nikaya),
      'book': serializer.toJson<String?>(book),
      'chapter': serializer.toJson<String?>(chapter),
      'language': serializer.toJson<String>(language),
      'translator': serializer.toJson<String?>(translator),
      'source': serializer.toJson<String?>(source),
      'contentHtml': serializer.toJson<String?>(contentHtml),
      'contentPlain': serializer.toJson<String?>(contentPlain),
    };
  }

  SuttaText copyWith(
          {int? id,
          String? uid,
          String? title,
          Value<String?> collection = const Value.absent(),
          String? nikaya,
          Value<String?> book = const Value.absent(),
          Value<String?> chapter = const Value.absent(),
          String? language,
          Value<String?> translator = const Value.absent(),
          Value<String?> source = const Value.absent(),
          Value<String?> contentHtml = const Value.absent(),
          Value<String?> contentPlain = const Value.absent()}) =>
      SuttaText(
        id: id ?? this.id,
        uid: uid ?? this.uid,
        title: title ?? this.title,
        collection: collection.present ? collection.value : this.collection,
        nikaya: nikaya ?? this.nikaya,
        book: book.present ? book.value : this.book,
        chapter: chapter.present ? chapter.value : this.chapter,
        language: language ?? this.language,
        translator: translator.present ? translator.value : this.translator,
        source: source.present ? source.value : this.source,
        contentHtml: contentHtml.present ? contentHtml.value : this.contentHtml,
        contentPlain:
            contentPlain.present ? contentPlain.value : this.contentPlain,
      );
  SuttaText copyWithCompanion(TextsCompanion data) {
    return SuttaText(
      id: data.id.present ? data.id.value : this.id,
      uid: data.uid.present ? data.uid.value : this.uid,
      title: data.title.present ? data.title.value : this.title,
      collection:
          data.collection.present ? data.collection.value : this.collection,
      nikaya: data.nikaya.present ? data.nikaya.value : this.nikaya,
      book: data.book.present ? data.book.value : this.book,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      language: data.language.present ? data.language.value : this.language,
      translator:
          data.translator.present ? data.translator.value : this.translator,
      source: data.source.present ? data.source.value : this.source,
      contentHtml:
          data.contentHtml.present ? data.contentHtml.value : this.contentHtml,
      contentPlain: data.contentPlain.present
          ? data.contentPlain.value
          : this.contentPlain,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SuttaText(')
          ..write('id: $id, ')
          ..write('uid: $uid, ')
          ..write('title: $title, ')
          ..write('collection: $collection, ')
          ..write('nikaya: $nikaya, ')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('language: $language, ')
          ..write('translator: $translator, ')
          ..write('source: $source, ')
          ..write('contentHtml: $contentHtml, ')
          ..write('contentPlain: $contentPlain')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uid, title, collection, nikaya, book,
      chapter, language, translator, source, contentHtml, contentPlain);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SuttaText &&
          other.id == this.id &&
          other.uid == this.uid &&
          other.title == this.title &&
          other.collection == this.collection &&
          other.nikaya == this.nikaya &&
          other.book == this.book &&
          other.chapter == this.chapter &&
          other.language == this.language &&
          other.translator == this.translator &&
          other.source == this.source &&
          other.contentHtml == this.contentHtml &&
          other.contentPlain == this.contentPlain);
}

class TextsCompanion extends UpdateCompanion<SuttaText> {
  final Value<int> id;
  final Value<String> uid;
  final Value<String> title;
  final Value<String?> collection;
  final Value<String> nikaya;
  final Value<String?> book;
  final Value<String?> chapter;
  final Value<String> language;
  final Value<String?> translator;
  final Value<String?> source;
  final Value<String?> contentHtml;
  final Value<String?> contentPlain;
  const TextsCompanion({
    this.id = const Value.absent(),
    this.uid = const Value.absent(),
    this.title = const Value.absent(),
    this.collection = const Value.absent(),
    this.nikaya = const Value.absent(),
    this.book = const Value.absent(),
    this.chapter = const Value.absent(),
    this.language = const Value.absent(),
    this.translator = const Value.absent(),
    this.source = const Value.absent(),
    this.contentHtml = const Value.absent(),
    this.contentPlain = const Value.absent(),
  });
  TextsCompanion.insert({
    this.id = const Value.absent(),
    required String uid,
    required String title,
    this.collection = const Value.absent(),
    required String nikaya,
    this.book = const Value.absent(),
    this.chapter = const Value.absent(),
    required String language,
    this.translator = const Value.absent(),
    this.source = const Value.absent(),
    this.contentHtml = const Value.absent(),
    this.contentPlain = const Value.absent(),
  })  : uid = Value(uid),
        title = Value(title),
        nikaya = Value(nikaya),
        language = Value(language);
  static Insertable<SuttaText> custom({
    Expression<int>? id,
    Expression<String>? uid,
    Expression<String>? title,
    Expression<String>? collection,
    Expression<String>? nikaya,
    Expression<String>? book,
    Expression<String>? chapter,
    Expression<String>? language,
    Expression<String>? translator,
    Expression<String>? source,
    Expression<String>? contentHtml,
    Expression<String>? contentPlain,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uid != null) 'uid': uid,
      if (title != null) 'title': title,
      if (collection != null) 'collection': collection,
      if (nikaya != null) 'nikaya': nikaya,
      if (book != null) 'book': book,
      if (chapter != null) 'chapter': chapter,
      if (language != null) 'language': language,
      if (translator != null) 'translator': translator,
      if (source != null) 'source': source,
      if (contentHtml != null) 'content_html': contentHtml,
      if (contentPlain != null) 'content_plain': contentPlain,
    });
  }

  TextsCompanion copyWith(
      {Value<int>? id,
      Value<String>? uid,
      Value<String>? title,
      Value<String?>? collection,
      Value<String>? nikaya,
      Value<String?>? book,
      Value<String?>? chapter,
      Value<String>? language,
      Value<String?>? translator,
      Value<String?>? source,
      Value<String?>? contentHtml,
      Value<String?>? contentPlain}) {
    return TextsCompanion(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      collection: collection ?? this.collection,
      nikaya: nikaya ?? this.nikaya,
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      language: language ?? this.language,
      translator: translator ?? this.translator,
      source: source ?? this.source,
      contentHtml: contentHtml ?? this.contentHtml,
      contentPlain: contentPlain ?? this.contentPlain,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (collection.present) {
      map['collection'] = Variable<String>(collection.value);
    }
    if (nikaya.present) {
      map['nikaya'] = Variable<String>(nikaya.value);
    }
    if (book.present) {
      map['book'] = Variable<String>(book.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<String>(chapter.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (translator.present) {
      map['translator'] = Variable<String>(translator.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (contentHtml.present) {
      map['content_html'] = Variable<String>(contentHtml.value);
    }
    if (contentPlain.present) {
      map['content_plain'] = Variable<String>(contentPlain.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TextsCompanion(')
          ..write('id: $id, ')
          ..write('uid: $uid, ')
          ..write('title: $title, ')
          ..write('collection: $collection, ')
          ..write('nikaya: $nikaya, ')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('language: $language, ')
          ..write('translator: $translator, ')
          ..write('source: $source, ')
          ..write('contentHtml: $contentHtml, ')
          ..write('contentPlain: $contentPlain')
          ..write(')'))
        .toString();
  }
}

class $TranslationsTable extends Translations
    with TableInfo<$TranslationsTable, Translation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TranslationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _textUidMeta =
      const VerificationMeta('textUid');
  @override
  late final GeneratedColumn<String> textUid = GeneratedColumn<String>(
      'text_uid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _translatorMeta =
      const VerificationMeta('translator');
  @override
  late final GeneratedColumn<String> translator = GeneratedColumn<String>(
      'translator', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contentHtmlMeta =
      const VerificationMeta('contentHtml');
  @override
  late final GeneratedColumn<String> contentHtml = GeneratedColumn<String>(
      'content_html', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contentPlainMeta =
      const VerificationMeta('contentPlain');
  @override
  late final GeneratedColumn<String> contentPlain = GeneratedColumn<String>(
      'content_plain', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, textUid, language, translator, source, contentHtml, contentPlain];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'translations';
  @override
  VerificationContext validateIntegrity(Insertable<Translation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('text_uid')) {
      context.handle(_textUidMeta,
          textUid.isAcceptableOrUnknown(data['text_uid']!, _textUidMeta));
    } else if (isInserting) {
      context.missing(_textUidMeta);
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('translator')) {
      context.handle(
          _translatorMeta,
          translator.isAcceptableOrUnknown(
              data['translator']!, _translatorMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('content_html')) {
      context.handle(
          _contentHtmlMeta,
          contentHtml.isAcceptableOrUnknown(
              data['content_html']!, _contentHtmlMeta));
    }
    if (data.containsKey('content_plain')) {
      context.handle(
          _contentPlainMeta,
          contentPlain.isAcceptableOrUnknown(
              data['content_plain']!, _contentPlainMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {textUid, language, translator},
      ];
  @override
  Translation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Translation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      textUid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text_uid'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      translator: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}translator']),
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source']),
      contentHtml: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_html']),
      contentPlain: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_plain']),
    );
  }

  @override
  $TranslationsTable createAlias(String alias) {
    return $TranslationsTable(attachedDatabase, alias);
  }
}

class Translation extends DataClass implements Insertable<Translation> {
  final int id;
  final String textUid;
  final String language;
  final String? translator;
  final String? source;
  final String? contentHtml;
  final String? contentPlain;
  const Translation(
      {required this.id,
      required this.textUid,
      required this.language,
      this.translator,
      this.source,
      this.contentHtml,
      this.contentPlain});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['text_uid'] = Variable<String>(textUid);
    map['language'] = Variable<String>(language);
    if (!nullToAbsent || translator != null) {
      map['translator'] = Variable<String>(translator);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    if (!nullToAbsent || contentHtml != null) {
      map['content_html'] = Variable<String>(contentHtml);
    }
    if (!nullToAbsent || contentPlain != null) {
      map['content_plain'] = Variable<String>(contentPlain);
    }
    return map;
  }

  TranslationsCompanion toCompanion(bool nullToAbsent) {
    return TranslationsCompanion(
      id: Value(id),
      textUid: Value(textUid),
      language: Value(language),
      translator: translator == null && nullToAbsent
          ? const Value.absent()
          : Value(translator),
      source:
          source == null && nullToAbsent ? const Value.absent() : Value(source),
      contentHtml: contentHtml == null && nullToAbsent
          ? const Value.absent()
          : Value(contentHtml),
      contentPlain: contentPlain == null && nullToAbsent
          ? const Value.absent()
          : Value(contentPlain),
    );
  }

  factory Translation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Translation(
      id: serializer.fromJson<int>(json['id']),
      textUid: serializer.fromJson<String>(json['textUid']),
      language: serializer.fromJson<String>(json['language']),
      translator: serializer.fromJson<String?>(json['translator']),
      source: serializer.fromJson<String?>(json['source']),
      contentHtml: serializer.fromJson<String?>(json['contentHtml']),
      contentPlain: serializer.fromJson<String?>(json['contentPlain']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'textUid': serializer.toJson<String>(textUid),
      'language': serializer.toJson<String>(language),
      'translator': serializer.toJson<String?>(translator),
      'source': serializer.toJson<String?>(source),
      'contentHtml': serializer.toJson<String?>(contentHtml),
      'contentPlain': serializer.toJson<String?>(contentPlain),
    };
  }

  Translation copyWith(
          {int? id,
          String? textUid,
          String? language,
          Value<String?> translator = const Value.absent(),
          Value<String?> source = const Value.absent(),
          Value<String?> contentHtml = const Value.absent(),
          Value<String?> contentPlain = const Value.absent()}) =>
      Translation(
        id: id ?? this.id,
        textUid: textUid ?? this.textUid,
        language: language ?? this.language,
        translator: translator.present ? translator.value : this.translator,
        source: source.present ? source.value : this.source,
        contentHtml: contentHtml.present ? contentHtml.value : this.contentHtml,
        contentPlain:
            contentPlain.present ? contentPlain.value : this.contentPlain,
      );
  Translation copyWithCompanion(TranslationsCompanion data) {
    return Translation(
      id: data.id.present ? data.id.value : this.id,
      textUid: data.textUid.present ? data.textUid.value : this.textUid,
      language: data.language.present ? data.language.value : this.language,
      translator:
          data.translator.present ? data.translator.value : this.translator,
      source: data.source.present ? data.source.value : this.source,
      contentHtml:
          data.contentHtml.present ? data.contentHtml.value : this.contentHtml,
      contentPlain: data.contentPlain.present
          ? data.contentPlain.value
          : this.contentPlain,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Translation(')
          ..write('id: $id, ')
          ..write('textUid: $textUid, ')
          ..write('language: $language, ')
          ..write('translator: $translator, ')
          ..write('source: $source, ')
          ..write('contentHtml: $contentHtml, ')
          ..write('contentPlain: $contentPlain')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, textUid, language, translator, source, contentHtml, contentPlain);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Translation &&
          other.id == this.id &&
          other.textUid == this.textUid &&
          other.language == this.language &&
          other.translator == this.translator &&
          other.source == this.source &&
          other.contentHtml == this.contentHtml &&
          other.contentPlain == this.contentPlain);
}

class TranslationsCompanion extends UpdateCompanion<Translation> {
  final Value<int> id;
  final Value<String> textUid;
  final Value<String> language;
  final Value<String?> translator;
  final Value<String?> source;
  final Value<String?> contentHtml;
  final Value<String?> contentPlain;
  const TranslationsCompanion({
    this.id = const Value.absent(),
    this.textUid = const Value.absent(),
    this.language = const Value.absent(),
    this.translator = const Value.absent(),
    this.source = const Value.absent(),
    this.contentHtml = const Value.absent(),
    this.contentPlain = const Value.absent(),
  });
  TranslationsCompanion.insert({
    this.id = const Value.absent(),
    required String textUid,
    required String language,
    this.translator = const Value.absent(),
    this.source = const Value.absent(),
    this.contentHtml = const Value.absent(),
    this.contentPlain = const Value.absent(),
  })  : textUid = Value(textUid),
        language = Value(language);
  static Insertable<Translation> custom({
    Expression<int>? id,
    Expression<String>? textUid,
    Expression<String>? language,
    Expression<String>? translator,
    Expression<String>? source,
    Expression<String>? contentHtml,
    Expression<String>? contentPlain,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (textUid != null) 'text_uid': textUid,
      if (language != null) 'language': language,
      if (translator != null) 'translator': translator,
      if (source != null) 'source': source,
      if (contentHtml != null) 'content_html': contentHtml,
      if (contentPlain != null) 'content_plain': contentPlain,
    });
  }

  TranslationsCompanion copyWith(
      {Value<int>? id,
      Value<String>? textUid,
      Value<String>? language,
      Value<String?>? translator,
      Value<String?>? source,
      Value<String?>? contentHtml,
      Value<String?>? contentPlain}) {
    return TranslationsCompanion(
      id: id ?? this.id,
      textUid: textUid ?? this.textUid,
      language: language ?? this.language,
      translator: translator ?? this.translator,
      source: source ?? this.source,
      contentHtml: contentHtml ?? this.contentHtml,
      contentPlain: contentPlain ?? this.contentPlain,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (textUid.present) {
      map['text_uid'] = Variable<String>(textUid.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (translator.present) {
      map['translator'] = Variable<String>(translator.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (contentHtml.present) {
      map['content_html'] = Variable<String>(contentHtml.value);
    }
    if (contentPlain.present) {
      map['content_plain'] = Variable<String>(contentPlain.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TranslationsCompanion(')
          ..write('id: $id, ')
          ..write('textUid: $textUid, ')
          ..write('language: $language, ')
          ..write('translator: $translator, ')
          ..write('source: $source, ')
          ..write('contentHtml: $contentHtml, ')
          ..write('contentPlain: $contentPlain')
          ..write(')'))
        .toString();
  }
}

class $TranslatorsTable extends Translators
    with TableInfo<$TranslatorsTable, Translator> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TranslatorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _traditionMeta =
      const VerificationMeta('tradition');
  @override
  late final GeneratedColumn<String> tradition = GeneratedColumn<String>(
      'tradition', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
      'bio', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceUrlMeta =
      const VerificationMeta('sourceUrl');
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
      'source_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, tradition, bio, sourceUrl];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'translators';
  @override
  VerificationContext validateIntegrity(Insertable<Translator> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('tradition')) {
      context.handle(_traditionMeta,
          tradition.isAcceptableOrUnknown(data['tradition']!, _traditionMeta));
    }
    if (data.containsKey('bio')) {
      context.handle(
          _bioMeta, bio.isAcceptableOrUnknown(data['bio']!, _bioMeta));
    }
    if (data.containsKey('source_url')) {
      context.handle(_sourceUrlMeta,
          sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Translator map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Translator(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      tradition: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tradition']),
      bio: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bio']),
      sourceUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_url']),
    );
  }

  @override
  $TranslatorsTable createAlias(String alias) {
    return $TranslatorsTable(attachedDatabase, alias);
  }
}

class Translator extends DataClass implements Insertable<Translator> {
  final int id;
  final String name;
  final String? tradition;
  final String? bio;
  final String? sourceUrl;
  const Translator(
      {required this.id,
      required this.name,
      this.tradition,
      this.bio,
      this.sourceUrl});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || tradition != null) {
      map['tradition'] = Variable<String>(tradition);
    }
    if (!nullToAbsent || bio != null) {
      map['bio'] = Variable<String>(bio);
    }
    if (!nullToAbsent || sourceUrl != null) {
      map['source_url'] = Variable<String>(sourceUrl);
    }
    return map;
  }

  TranslatorsCompanion toCompanion(bool nullToAbsent) {
    return TranslatorsCompanion(
      id: Value(id),
      name: Value(name),
      tradition: tradition == null && nullToAbsent
          ? const Value.absent()
          : Value(tradition),
      bio: bio == null && nullToAbsent ? const Value.absent() : Value(bio),
      sourceUrl: sourceUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceUrl),
    );
  }

  factory Translator.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Translator(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      tradition: serializer.fromJson<String?>(json['tradition']),
      bio: serializer.fromJson<String?>(json['bio']),
      sourceUrl: serializer.fromJson<String?>(json['sourceUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'tradition': serializer.toJson<String?>(tradition),
      'bio': serializer.toJson<String?>(bio),
      'sourceUrl': serializer.toJson<String?>(sourceUrl),
    };
  }

  Translator copyWith(
          {int? id,
          String? name,
          Value<String?> tradition = const Value.absent(),
          Value<String?> bio = const Value.absent(),
          Value<String?> sourceUrl = const Value.absent()}) =>
      Translator(
        id: id ?? this.id,
        name: name ?? this.name,
        tradition: tradition.present ? tradition.value : this.tradition,
        bio: bio.present ? bio.value : this.bio,
        sourceUrl: sourceUrl.present ? sourceUrl.value : this.sourceUrl,
      );
  Translator copyWithCompanion(TranslatorsCompanion data) {
    return Translator(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      tradition: data.tradition.present ? data.tradition.value : this.tradition,
      bio: data.bio.present ? data.bio.value : this.bio,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Translator(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('tradition: $tradition, ')
          ..write('bio: $bio, ')
          ..write('sourceUrl: $sourceUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, tradition, bio, sourceUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Translator &&
          other.id == this.id &&
          other.name == this.name &&
          other.tradition == this.tradition &&
          other.bio == this.bio &&
          other.sourceUrl == this.sourceUrl);
}

class TranslatorsCompanion extends UpdateCompanion<Translator> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> tradition;
  final Value<String?> bio;
  final Value<String?> sourceUrl;
  const TranslatorsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.tradition = const Value.absent(),
    this.bio = const Value.absent(),
    this.sourceUrl = const Value.absent(),
  });
  TranslatorsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.tradition = const Value.absent(),
    this.bio = const Value.absent(),
    this.sourceUrl = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Translator> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? tradition,
    Expression<String>? bio,
    Expression<String>? sourceUrl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (tradition != null) 'tradition': tradition,
      if (bio != null) 'bio': bio,
      if (sourceUrl != null) 'source_url': sourceUrl,
    });
  }

  TranslatorsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? tradition,
      Value<String?>? bio,
      Value<String?>? sourceUrl}) {
    return TranslatorsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      tradition: tradition ?? this.tradition,
      bio: bio ?? this.bio,
      sourceUrl: sourceUrl ?? this.sourceUrl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (tradition.present) {
      map['tradition'] = Variable<String>(tradition.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TranslatorsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('tradition: $tradition, ')
          ..write('bio: $bio, ')
          ..write('sourceUrl: $sourceUrl')
          ..write(')'))
        .toString();
  }
}

class $UserBookmarksTable extends UserBookmarks
    with TableInfo<$UserBookmarksTable, UserBookmark> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserBookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _textUidMeta =
      const VerificationMeta('textUid');
  @override
  late final GeneratedColumn<String> textUid = GeneratedColumn<String>(
      'text_uid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, textUid, label, userId, createdAt, updatedAt, syncedAt, isDeleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_bookmarks';
  @override
  VerificationContext validateIntegrity(Insertable<UserBookmark> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('text_uid')) {
      context.handle(_textUidMeta,
          textUid.isAcceptableOrUnknown(data['text_uid']!, _textUidMeta));
    } else if (isInserting) {
      context.missing(_textUidMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {textUid, userId},
      ];
  @override
  UserBookmark map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserBookmark(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      textUid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text_uid'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $UserBookmarksTable createAlias(String alias) {
    return $UserBookmarksTable(attachedDatabase, alias);
  }
}

class UserBookmark extends DataClass implements Insertable<UserBookmark> {
  final int id;
  final String textUid;
  final String label;
  final String? userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  final bool isDeleted;
  const UserBookmark(
      {required this.id,
      required this.textUid,
      required this.label,
      this.userId,
      required this.createdAt,
      required this.updatedAt,
      this.syncedAt,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['text_uid'] = Variable<String>(textUid);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  UserBookmarksCompanion toCompanion(bool nullToAbsent) {
    return UserBookmarksCompanion(
      id: Value(id),
      textUid: Value(textUid),
      label: Value(label),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory UserBookmark.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserBookmark(
      id: serializer.fromJson<int>(json['id']),
      textUid: serializer.fromJson<String>(json['textUid']),
      label: serializer.fromJson<String>(json['label']),
      userId: serializer.fromJson<String?>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'textUid': serializer.toJson<String>(textUid),
      'label': serializer.toJson<String>(label),
      'userId': serializer.toJson<String?>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  UserBookmark copyWith(
          {int? id,
          String? textUid,
          String? label,
          Value<String?> userId = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> syncedAt = const Value.absent(),
          bool? isDeleted}) =>
      UserBookmark(
        id: id ?? this.id,
        textUid: textUid ?? this.textUid,
        label: label ?? this.label,
        userId: userId.present ? userId.value : this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  UserBookmark copyWithCompanion(UserBookmarksCompanion data) {
    return UserBookmark(
      id: data.id.present ? data.id.value : this.id,
      textUid: data.textUid.present ? data.textUid.value : this.textUid,
      label: data.label.present ? data.label.value : this.label,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserBookmark(')
          ..write('id: $id, ')
          ..write('textUid: $textUid, ')
          ..write('label: $label, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, textUid, label, userId, createdAt, updatedAt, syncedAt, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserBookmark &&
          other.id == this.id &&
          other.textUid == this.textUid &&
          other.label == this.label &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt &&
          other.isDeleted == this.isDeleted);
}

class UserBookmarksCompanion extends UpdateCompanion<UserBookmark> {
  final Value<int> id;
  final Value<String> textUid;
  final Value<String> label;
  final Value<String?> userId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<bool> isDeleted;
  const UserBookmarksCompanion({
    this.id = const Value.absent(),
    this.textUid = const Value.absent(),
    this.label = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  UserBookmarksCompanion.insert({
    this.id = const Value.absent(),
    required String textUid,
    this.label = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
  }) : textUid = Value(textUid);
  static Insertable<UserBookmark> custom({
    Expression<int>? id,
    Expression<String>? textUid,
    Expression<String>? label,
    Expression<String>? userId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (textUid != null) 'text_uid': textUid,
      if (label != null) 'label': label,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  UserBookmarksCompanion copyWith(
      {Value<int>? id,
      Value<String>? textUid,
      Value<String>? label,
      Value<String?>? userId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? syncedAt,
      Value<bool>? isDeleted}) {
    return UserBookmarksCompanion(
      id: id ?? this.id,
      textUid: textUid ?? this.textUid,
      label: label ?? this.label,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (textUid.present) {
      map['text_uid'] = Variable<String>(textUid.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserBookmarksCompanion(')
          ..write('id: $id, ')
          ..write('textUid: $textUid, ')
          ..write('label: $label, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $UserHighlightsTable extends UserHighlights
    with TableInfo<$UserHighlightsTable, UserHighlight> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserHighlightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _textUidMeta =
      const VerificationMeta('textUid');
  @override
  late final GeneratedColumn<String> textUid = GeneratedColumn<String>(
      'text_uid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startOffsetMeta =
      const VerificationMeta('startOffset');
  @override
  late final GeneratedColumn<int> startOffset = GeneratedColumn<int>(
      'start_offset', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endOffsetMeta =
      const VerificationMeta('endOffset');
  @override
  late final GeneratedColumn<int> endOffset = GeneratedColumn<int>(
      'end_offset', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _colourMeta = const VerificationMeta('colour');
  @override
  late final GeneratedColumn<String> colour = GeneratedColumn<String>(
      'colour', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        textUid,
        startOffset,
        endOffset,
        colour,
        userId,
        createdAt,
        updatedAt,
        syncedAt,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_highlights';
  @override
  VerificationContext validateIntegrity(Insertable<UserHighlight> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('text_uid')) {
      context.handle(_textUidMeta,
          textUid.isAcceptableOrUnknown(data['text_uid']!, _textUidMeta));
    } else if (isInserting) {
      context.missing(_textUidMeta);
    }
    if (data.containsKey('start_offset')) {
      context.handle(
          _startOffsetMeta,
          startOffset.isAcceptableOrUnknown(
              data['start_offset']!, _startOffsetMeta));
    } else if (isInserting) {
      context.missing(_startOffsetMeta);
    }
    if (data.containsKey('end_offset')) {
      context.handle(_endOffsetMeta,
          endOffset.isAcceptableOrUnknown(data['end_offset']!, _endOffsetMeta));
    } else if (isInserting) {
      context.missing(_endOffsetMeta);
    }
    if (data.containsKey('colour')) {
      context.handle(_colourMeta,
          colour.isAcceptableOrUnknown(data['colour']!, _colourMeta));
    } else if (isInserting) {
      context.missing(_colourMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserHighlight map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserHighlight(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      textUid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text_uid'])!,
      startOffset: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_offset'])!,
      endOffset: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_offset'])!,
      colour: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}colour'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $UserHighlightsTable createAlias(String alias) {
    return $UserHighlightsTable(attachedDatabase, alias);
  }
}

class UserHighlight extends DataClass implements Insertable<UserHighlight> {
  final int id;
  final String textUid;
  final int startOffset;
  final int endOffset;
  final String colour;
  final String? userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  final bool isDeleted;
  const UserHighlight(
      {required this.id,
      required this.textUid,
      required this.startOffset,
      required this.endOffset,
      required this.colour,
      this.userId,
      required this.createdAt,
      required this.updatedAt,
      this.syncedAt,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['text_uid'] = Variable<String>(textUid);
    map['start_offset'] = Variable<int>(startOffset);
    map['end_offset'] = Variable<int>(endOffset);
    map['colour'] = Variable<String>(colour);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  UserHighlightsCompanion toCompanion(bool nullToAbsent) {
    return UserHighlightsCompanion(
      id: Value(id),
      textUid: Value(textUid),
      startOffset: Value(startOffset),
      endOffset: Value(endOffset),
      colour: Value(colour),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory UserHighlight.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserHighlight(
      id: serializer.fromJson<int>(json['id']),
      textUid: serializer.fromJson<String>(json['textUid']),
      startOffset: serializer.fromJson<int>(json['startOffset']),
      endOffset: serializer.fromJson<int>(json['endOffset']),
      colour: serializer.fromJson<String>(json['colour']),
      userId: serializer.fromJson<String?>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'textUid': serializer.toJson<String>(textUid),
      'startOffset': serializer.toJson<int>(startOffset),
      'endOffset': serializer.toJson<int>(endOffset),
      'colour': serializer.toJson<String>(colour),
      'userId': serializer.toJson<String?>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  UserHighlight copyWith(
          {int? id,
          String? textUid,
          int? startOffset,
          int? endOffset,
          String? colour,
          Value<String?> userId = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> syncedAt = const Value.absent(),
          bool? isDeleted}) =>
      UserHighlight(
        id: id ?? this.id,
        textUid: textUid ?? this.textUid,
        startOffset: startOffset ?? this.startOffset,
        endOffset: endOffset ?? this.endOffset,
        colour: colour ?? this.colour,
        userId: userId.present ? userId.value : this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  UserHighlight copyWithCompanion(UserHighlightsCompanion data) {
    return UserHighlight(
      id: data.id.present ? data.id.value : this.id,
      textUid: data.textUid.present ? data.textUid.value : this.textUid,
      startOffset:
          data.startOffset.present ? data.startOffset.value : this.startOffset,
      endOffset: data.endOffset.present ? data.endOffset.value : this.endOffset,
      colour: data.colour.present ? data.colour.value : this.colour,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserHighlight(')
          ..write('id: $id, ')
          ..write('textUid: $textUid, ')
          ..write('startOffset: $startOffset, ')
          ..write('endOffset: $endOffset, ')
          ..write('colour: $colour, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, textUid, startOffset, endOffset, colour,
      userId, createdAt, updatedAt, syncedAt, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserHighlight &&
          other.id == this.id &&
          other.textUid == this.textUid &&
          other.startOffset == this.startOffset &&
          other.endOffset == this.endOffset &&
          other.colour == this.colour &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt &&
          other.isDeleted == this.isDeleted);
}

class UserHighlightsCompanion extends UpdateCompanion<UserHighlight> {
  final Value<int> id;
  final Value<String> textUid;
  final Value<int> startOffset;
  final Value<int> endOffset;
  final Value<String> colour;
  final Value<String?> userId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<bool> isDeleted;
  const UserHighlightsCompanion({
    this.id = const Value.absent(),
    this.textUid = const Value.absent(),
    this.startOffset = const Value.absent(),
    this.endOffset = const Value.absent(),
    this.colour = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  UserHighlightsCompanion.insert({
    this.id = const Value.absent(),
    required String textUid,
    required int startOffset,
    required int endOffset,
    required String colour,
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
  })  : textUid = Value(textUid),
        startOffset = Value(startOffset),
        endOffset = Value(endOffset),
        colour = Value(colour);
  static Insertable<UserHighlight> custom({
    Expression<int>? id,
    Expression<String>? textUid,
    Expression<int>? startOffset,
    Expression<int>? endOffset,
    Expression<String>? colour,
    Expression<String>? userId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (textUid != null) 'text_uid': textUid,
      if (startOffset != null) 'start_offset': startOffset,
      if (endOffset != null) 'end_offset': endOffset,
      if (colour != null) 'colour': colour,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  UserHighlightsCompanion copyWith(
      {Value<int>? id,
      Value<String>? textUid,
      Value<int>? startOffset,
      Value<int>? endOffset,
      Value<String>? colour,
      Value<String?>? userId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? syncedAt,
      Value<bool>? isDeleted}) {
    return UserHighlightsCompanion(
      id: id ?? this.id,
      textUid: textUid ?? this.textUid,
      startOffset: startOffset ?? this.startOffset,
      endOffset: endOffset ?? this.endOffset,
      colour: colour ?? this.colour,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (textUid.present) {
      map['text_uid'] = Variable<String>(textUid.value);
    }
    if (startOffset.present) {
      map['start_offset'] = Variable<int>(startOffset.value);
    }
    if (endOffset.present) {
      map['end_offset'] = Variable<int>(endOffset.value);
    }
    if (colour.present) {
      map['colour'] = Variable<String>(colour.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserHighlightsCompanion(')
          ..write('id: $id, ')
          ..write('textUid: $textUid, ')
          ..write('startOffset: $startOffset, ')
          ..write('endOffset: $endOffset, ')
          ..write('colour: $colour, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $UserNotesTable extends UserNotes
    with TableInfo<$UserNotesTable, UserNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _textUidMeta =
      const VerificationMeta('textUid');
  @override
  late final GeneratedColumn<String> textUid = GeneratedColumn<String>(
      'text_uid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, textUid, content, userId, createdAt, updatedAt, syncedAt, isDeleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_notes';
  @override
  VerificationContext validateIntegrity(Insertable<UserNote> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('text_uid')) {
      context.handle(_textUidMeta,
          textUid.isAcceptableOrUnknown(data['text_uid']!, _textUidMeta));
    } else if (isInserting) {
      context.missing(_textUidMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {textUid, userId},
      ];
  @override
  UserNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserNote(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      textUid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text_uid'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $UserNotesTable createAlias(String alias) {
    return $UserNotesTable(attachedDatabase, alias);
  }
}

class UserNote extends DataClass implements Insertable<UserNote> {
  final int id;
  final String textUid;
  final String content;
  final String? userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  final bool isDeleted;
  const UserNote(
      {required this.id,
      required this.textUid,
      required this.content,
      this.userId,
      required this.createdAt,
      required this.updatedAt,
      this.syncedAt,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['text_uid'] = Variable<String>(textUid);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  UserNotesCompanion toCompanion(bool nullToAbsent) {
    return UserNotesCompanion(
      id: Value(id),
      textUid: Value(textUid),
      content: Value(content),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory UserNote.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserNote(
      id: serializer.fromJson<int>(json['id']),
      textUid: serializer.fromJson<String>(json['textUid']),
      content: serializer.fromJson<String>(json['content']),
      userId: serializer.fromJson<String?>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'textUid': serializer.toJson<String>(textUid),
      'content': serializer.toJson<String>(content),
      'userId': serializer.toJson<String?>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  UserNote copyWith(
          {int? id,
          String? textUid,
          String? content,
          Value<String?> userId = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> syncedAt = const Value.absent(),
          bool? isDeleted}) =>
      UserNote(
        id: id ?? this.id,
        textUid: textUid ?? this.textUid,
        content: content ?? this.content,
        userId: userId.present ? userId.value : this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  UserNote copyWithCompanion(UserNotesCompanion data) {
    return UserNote(
      id: data.id.present ? data.id.value : this.id,
      textUid: data.textUid.present ? data.textUid.value : this.textUid,
      content: data.content.present ? data.content.value : this.content,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserNote(')
          ..write('id: $id, ')
          ..write('textUid: $textUid, ')
          ..write('content: $content, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, textUid, content, userId, createdAt, updatedAt, syncedAt, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserNote &&
          other.id == this.id &&
          other.textUid == this.textUid &&
          other.content == this.content &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt &&
          other.isDeleted == this.isDeleted);
}

class UserNotesCompanion extends UpdateCompanion<UserNote> {
  final Value<int> id;
  final Value<String> textUid;
  final Value<String> content;
  final Value<String?> userId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<bool> isDeleted;
  const UserNotesCompanion({
    this.id = const Value.absent(),
    this.textUid = const Value.absent(),
    this.content = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  UserNotesCompanion.insert({
    this.id = const Value.absent(),
    required String textUid,
    required String content,
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
  })  : textUid = Value(textUid),
        content = Value(content);
  static Insertable<UserNote> custom({
    Expression<int>? id,
    Expression<String>? textUid,
    Expression<String>? content,
    Expression<String>? userId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (textUid != null) 'text_uid': textUid,
      if (content != null) 'content': content,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  UserNotesCompanion copyWith(
      {Value<int>? id,
      Value<String>? textUid,
      Value<String>? content,
      Value<String?>? userId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? syncedAt,
      Value<bool>? isDeleted}) {
    return UserNotesCompanion(
      id: id ?? this.id,
      textUid: textUid ?? this.textUid,
      content: content ?? this.content,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (textUid.present) {
      map['text_uid'] = Variable<String>(textUid.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserNotesCompanion(')
          ..write('id: $id, ')
          ..write('textUid: $textUid, ')
          ..write('content: $content, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $UserProgressTable extends UserProgress
    with TableInfo<$UserProgressTable, UserProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _textUidMeta =
      const VerificationMeta('textUid');
  @override
  late final GeneratedColumn<String> textUid = GeneratedColumn<String>(
      'text_uid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastPositionMeta =
      const VerificationMeta('lastPosition');
  @override
  late final GeneratedColumn<int> lastPosition = GeneratedColumn<int>(
      'last_position', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastReadAtMeta =
      const VerificationMeta('lastReadAt');
  @override
  late final GeneratedColumn<DateTime> lastReadAt = GeneratedColumn<DateTime>(
      'last_read_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        textUid,
        lastPosition,
        completed,
        userId,
        lastReadAt,
        updatedAt,
        syncedAt,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_progress';
  @override
  VerificationContext validateIntegrity(Insertable<UserProgressData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('text_uid')) {
      context.handle(_textUidMeta,
          textUid.isAcceptableOrUnknown(data['text_uid']!, _textUidMeta));
    } else if (isInserting) {
      context.missing(_textUidMeta);
    }
    if (data.containsKey('last_position')) {
      context.handle(
          _lastPositionMeta,
          lastPosition.isAcceptableOrUnknown(
              data['last_position']!, _lastPositionMeta));
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('last_read_at')) {
      context.handle(
          _lastReadAtMeta,
          lastReadAt.isAcceptableOrUnknown(
              data['last_read_at']!, _lastReadAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {textUid, userId},
      ];
  @override
  UserProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProgressData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      textUid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text_uid'])!,
      lastPosition: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_position'])!,
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      lastReadAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_read_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $UserProgressTable createAlias(String alias) {
    return $UserProgressTable(attachedDatabase, alias);
  }
}

class UserProgressData extends DataClass
    implements Insertable<UserProgressData> {
  final int id;
  final String textUid;
  final int lastPosition;
  final bool completed;
  final String? userId;
  final DateTime lastReadAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  final bool isDeleted;
  const UserProgressData(
      {required this.id,
      required this.textUid,
      required this.lastPosition,
      required this.completed,
      this.userId,
      required this.lastReadAt,
      required this.updatedAt,
      this.syncedAt,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['text_uid'] = Variable<String>(textUid);
    map['last_position'] = Variable<int>(lastPosition);
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['last_read_at'] = Variable<DateTime>(lastReadAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  UserProgressCompanion toCompanion(bool nullToAbsent) {
    return UserProgressCompanion(
      id: Value(id),
      textUid: Value(textUid),
      lastPosition: Value(lastPosition),
      completed: Value(completed),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      lastReadAt: Value(lastReadAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory UserProgressData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProgressData(
      id: serializer.fromJson<int>(json['id']),
      textUid: serializer.fromJson<String>(json['textUid']),
      lastPosition: serializer.fromJson<int>(json['lastPosition']),
      completed: serializer.fromJson<bool>(json['completed']),
      userId: serializer.fromJson<String?>(json['userId']),
      lastReadAt: serializer.fromJson<DateTime>(json['lastReadAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'textUid': serializer.toJson<String>(textUid),
      'lastPosition': serializer.toJson<int>(lastPosition),
      'completed': serializer.toJson<bool>(completed),
      'userId': serializer.toJson<String?>(userId),
      'lastReadAt': serializer.toJson<DateTime>(lastReadAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  UserProgressData copyWith(
          {int? id,
          String? textUid,
          int? lastPosition,
          bool? completed,
          Value<String?> userId = const Value.absent(),
          DateTime? lastReadAt,
          DateTime? updatedAt,
          Value<DateTime?> syncedAt = const Value.absent(),
          bool? isDeleted}) =>
      UserProgressData(
        id: id ?? this.id,
        textUid: textUid ?? this.textUid,
        lastPosition: lastPosition ?? this.lastPosition,
        completed: completed ?? this.completed,
        userId: userId.present ? userId.value : this.userId,
        lastReadAt: lastReadAt ?? this.lastReadAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  UserProgressData copyWithCompanion(UserProgressCompanion data) {
    return UserProgressData(
      id: data.id.present ? data.id.value : this.id,
      textUid: data.textUid.present ? data.textUid.value : this.textUid,
      lastPosition: data.lastPosition.present
          ? data.lastPosition.value
          : this.lastPosition,
      completed: data.completed.present ? data.completed.value : this.completed,
      userId: data.userId.present ? data.userId.value : this.userId,
      lastReadAt:
          data.lastReadAt.present ? data.lastReadAt.value : this.lastReadAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressData(')
          ..write('id: $id, ')
          ..write('textUid: $textUid, ')
          ..write('lastPosition: $lastPosition, ')
          ..write('completed: $completed, ')
          ..write('userId: $userId, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, textUid, lastPosition, completed, userId,
      lastReadAt, updatedAt, syncedAt, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProgressData &&
          other.id == this.id &&
          other.textUid == this.textUid &&
          other.lastPosition == this.lastPosition &&
          other.completed == this.completed &&
          other.userId == this.userId &&
          other.lastReadAt == this.lastReadAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt &&
          other.isDeleted == this.isDeleted);
}

class UserProgressCompanion extends UpdateCompanion<UserProgressData> {
  final Value<int> id;
  final Value<String> textUid;
  final Value<int> lastPosition;
  final Value<bool> completed;
  final Value<String?> userId;
  final Value<DateTime> lastReadAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<bool> isDeleted;
  const UserProgressCompanion({
    this.id = const Value.absent(),
    this.textUid = const Value.absent(),
    this.lastPosition = const Value.absent(),
    this.completed = const Value.absent(),
    this.userId = const Value.absent(),
    this.lastReadAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  UserProgressCompanion.insert({
    this.id = const Value.absent(),
    required String textUid,
    this.lastPosition = const Value.absent(),
    this.completed = const Value.absent(),
    this.userId = const Value.absent(),
    this.lastReadAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
  }) : textUid = Value(textUid);
  static Insertable<UserProgressData> custom({
    Expression<int>? id,
    Expression<String>? textUid,
    Expression<int>? lastPosition,
    Expression<bool>? completed,
    Expression<String>? userId,
    Expression<DateTime>? lastReadAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (textUid != null) 'text_uid': textUid,
      if (lastPosition != null) 'last_position': lastPosition,
      if (completed != null) 'completed': completed,
      if (userId != null) 'user_id': userId,
      if (lastReadAt != null) 'last_read_at': lastReadAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  UserProgressCompanion copyWith(
      {Value<int>? id,
      Value<String>? textUid,
      Value<int>? lastPosition,
      Value<bool>? completed,
      Value<String?>? userId,
      Value<DateTime>? lastReadAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? syncedAt,
      Value<bool>? isDeleted}) {
    return UserProgressCompanion(
      id: id ?? this.id,
      textUid: textUid ?? this.textUid,
      lastPosition: lastPosition ?? this.lastPosition,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (textUid.present) {
      map['text_uid'] = Variable<String>(textUid.value);
    }
    if (lastPosition.present) {
      map['last_position'] = Variable<int>(lastPosition.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (lastReadAt.present) {
      map['last_read_at'] = Variable<DateTime>(lastReadAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressCompanion(')
          ..write('id: $id, ')
          ..write('textUid: $textUid, ')
          ..write('lastPosition: $lastPosition, ')
          ..write('completed: $completed, ')
          ..write('userId: $userId, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $VideoCacheTable extends VideoCache
    with TableInfo<$VideoCacheTable, VideoCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VideoCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _youtubeIdMeta =
      const VerificationMeta('youtubeId');
  @override
  late final GeneratedColumn<String> youtubeId = GeneratedColumn<String>(
      'youtube_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _teacherMeta =
      const VerificationMeta('teacher');
  @override
  late final GeneratedColumn<String> teacher = GeneratedColumn<String>(
      'teacher', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _suttaUidMeta =
      const VerificationMeta('suttaUid');
  @override
  late final GeneratedColumn<String> suttaUid = GeneratedColumn<String>(
      'sutta_uid', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _topicTagsMeta =
      const VerificationMeta('topicTags');
  @override
  late final GeneratedColumn<String> topicTags = GeneratedColumn<String>(
      'topic_tags', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _durationSecondsMeta =
      const VerificationMeta('durationSeconds');
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
      'duration_seconds', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _thumbnailUrlMeta =
      const VerificationMeta('thumbnailUrl');
  @override
  late final GeneratedColumn<String> thumbnailUrl = GeneratedColumn<String>(
      'thumbnail_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cachedAtMeta =
      const VerificationMeta('cachedAt');
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
      'cached_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        youtubeId,
        title,
        teacher,
        suttaUid,
        topicTags,
        durationSeconds,
        thumbnailUrl,
        cachedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'video_cache';
  @override
  VerificationContext validateIntegrity(Insertable<VideoCacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('youtube_id')) {
      context.handle(_youtubeIdMeta,
          youtubeId.isAcceptableOrUnknown(data['youtube_id']!, _youtubeIdMeta));
    } else if (isInserting) {
      context.missing(_youtubeIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('teacher')) {
      context.handle(_teacherMeta,
          teacher.isAcceptableOrUnknown(data['teacher']!, _teacherMeta));
    }
    if (data.containsKey('sutta_uid')) {
      context.handle(_suttaUidMeta,
          suttaUid.isAcceptableOrUnknown(data['sutta_uid']!, _suttaUidMeta));
    }
    if (data.containsKey('topic_tags')) {
      context.handle(_topicTagsMeta,
          topicTags.isAcceptableOrUnknown(data['topic_tags']!, _topicTagsMeta));
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
          _durationSecondsMeta,
          durationSeconds.isAcceptableOrUnknown(
              data['duration_seconds']!, _durationSecondsMeta));
    }
    if (data.containsKey('thumbnail_url')) {
      context.handle(
          _thumbnailUrlMeta,
          thumbnailUrl.isAcceptableOrUnknown(
              data['thumbnail_url']!, _thumbnailUrlMeta));
    }
    if (data.containsKey('cached_at')) {
      context.handle(_cachedAtMeta,
          cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VideoCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VideoCacheData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      youtubeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}youtube_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      teacher: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}teacher']),
      suttaUid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sutta_uid']),
      topicTags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}topic_tags']),
      durationSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_seconds']),
      thumbnailUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}thumbnail_url']),
      cachedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}cached_at'])!,
    );
  }

  @override
  $VideoCacheTable createAlias(String alias) {
    return $VideoCacheTable(attachedDatabase, alias);
  }
}

class VideoCacheData extends DataClass implements Insertable<VideoCacheData> {
  final int id;
  final String youtubeId;
  final String title;
  final String? teacher;
  final String? suttaUid;
  final String? topicTags;
  final int? durationSeconds;
  final String? thumbnailUrl;
  final DateTime cachedAt;
  const VideoCacheData(
      {required this.id,
      required this.youtubeId,
      required this.title,
      this.teacher,
      this.suttaUid,
      this.topicTags,
      this.durationSeconds,
      this.thumbnailUrl,
      required this.cachedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['youtube_id'] = Variable<String>(youtubeId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || teacher != null) {
      map['teacher'] = Variable<String>(teacher);
    }
    if (!nullToAbsent || suttaUid != null) {
      map['sutta_uid'] = Variable<String>(suttaUid);
    }
    if (!nullToAbsent || topicTags != null) {
      map['topic_tags'] = Variable<String>(topicTags);
    }
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    if (!nullToAbsent || thumbnailUrl != null) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  VideoCacheCompanion toCompanion(bool nullToAbsent) {
    return VideoCacheCompanion(
      id: Value(id),
      youtubeId: Value(youtubeId),
      title: Value(title),
      teacher: teacher == null && nullToAbsent
          ? const Value.absent()
          : Value(teacher),
      suttaUid: suttaUid == null && nullToAbsent
          ? const Value.absent()
          : Value(suttaUid),
      topicTags: topicTags == null && nullToAbsent
          ? const Value.absent()
          : Value(topicTags),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
      thumbnailUrl: thumbnailUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailUrl),
      cachedAt: Value(cachedAt),
    );
  }

  factory VideoCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VideoCacheData(
      id: serializer.fromJson<int>(json['id']),
      youtubeId: serializer.fromJson<String>(json['youtubeId']),
      title: serializer.fromJson<String>(json['title']),
      teacher: serializer.fromJson<String?>(json['teacher']),
      suttaUid: serializer.fromJson<String?>(json['suttaUid']),
      topicTags: serializer.fromJson<String?>(json['topicTags']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      thumbnailUrl: serializer.fromJson<String?>(json['thumbnailUrl']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'youtubeId': serializer.toJson<String>(youtubeId),
      'title': serializer.toJson<String>(title),
      'teacher': serializer.toJson<String?>(teacher),
      'suttaUid': serializer.toJson<String?>(suttaUid),
      'topicTags': serializer.toJson<String?>(topicTags),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'thumbnailUrl': serializer.toJson<String?>(thumbnailUrl),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  VideoCacheData copyWith(
          {int? id,
          String? youtubeId,
          String? title,
          Value<String?> teacher = const Value.absent(),
          Value<String?> suttaUid = const Value.absent(),
          Value<String?> topicTags = const Value.absent(),
          Value<int?> durationSeconds = const Value.absent(),
          Value<String?> thumbnailUrl = const Value.absent(),
          DateTime? cachedAt}) =>
      VideoCacheData(
        id: id ?? this.id,
        youtubeId: youtubeId ?? this.youtubeId,
        title: title ?? this.title,
        teacher: teacher.present ? teacher.value : this.teacher,
        suttaUid: suttaUid.present ? suttaUid.value : this.suttaUid,
        topicTags: topicTags.present ? topicTags.value : this.topicTags,
        durationSeconds: durationSeconds.present
            ? durationSeconds.value
            : this.durationSeconds,
        thumbnailUrl:
            thumbnailUrl.present ? thumbnailUrl.value : this.thumbnailUrl,
        cachedAt: cachedAt ?? this.cachedAt,
      );
  VideoCacheData copyWithCompanion(VideoCacheCompanion data) {
    return VideoCacheData(
      id: data.id.present ? data.id.value : this.id,
      youtubeId: data.youtubeId.present ? data.youtubeId.value : this.youtubeId,
      title: data.title.present ? data.title.value : this.title,
      teacher: data.teacher.present ? data.teacher.value : this.teacher,
      suttaUid: data.suttaUid.present ? data.suttaUid.value : this.suttaUid,
      topicTags: data.topicTags.present ? data.topicTags.value : this.topicTags,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      thumbnailUrl: data.thumbnailUrl.present
          ? data.thumbnailUrl.value
          : this.thumbnailUrl,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VideoCacheData(')
          ..write('id: $id, ')
          ..write('youtubeId: $youtubeId, ')
          ..write('title: $title, ')
          ..write('teacher: $teacher, ')
          ..write('suttaUid: $suttaUid, ')
          ..write('topicTags: $topicTags, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, youtubeId, title, teacher, suttaUid,
      topicTags, durationSeconds, thumbnailUrl, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VideoCacheData &&
          other.id == this.id &&
          other.youtubeId == this.youtubeId &&
          other.title == this.title &&
          other.teacher == this.teacher &&
          other.suttaUid == this.suttaUid &&
          other.topicTags == this.topicTags &&
          other.durationSeconds == this.durationSeconds &&
          other.thumbnailUrl == this.thumbnailUrl &&
          other.cachedAt == this.cachedAt);
}

class VideoCacheCompanion extends UpdateCompanion<VideoCacheData> {
  final Value<int> id;
  final Value<String> youtubeId;
  final Value<String> title;
  final Value<String?> teacher;
  final Value<String?> suttaUid;
  final Value<String?> topicTags;
  final Value<int?> durationSeconds;
  final Value<String?> thumbnailUrl;
  final Value<DateTime> cachedAt;
  const VideoCacheCompanion({
    this.id = const Value.absent(),
    this.youtubeId = const Value.absent(),
    this.title = const Value.absent(),
    this.teacher = const Value.absent(),
    this.suttaUid = const Value.absent(),
    this.topicTags = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  VideoCacheCompanion.insert({
    this.id = const Value.absent(),
    required String youtubeId,
    required String title,
    this.teacher = const Value.absent(),
    this.suttaUid = const Value.absent(),
    this.topicTags = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.thumbnailUrl = const Value.absent(),
    this.cachedAt = const Value.absent(),
  })  : youtubeId = Value(youtubeId),
        title = Value(title);
  static Insertable<VideoCacheData> custom({
    Expression<int>? id,
    Expression<String>? youtubeId,
    Expression<String>? title,
    Expression<String>? teacher,
    Expression<String>? suttaUid,
    Expression<String>? topicTags,
    Expression<int>? durationSeconds,
    Expression<String>? thumbnailUrl,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (youtubeId != null) 'youtube_id': youtubeId,
      if (title != null) 'title': title,
      if (teacher != null) 'teacher': teacher,
      if (suttaUid != null) 'sutta_uid': suttaUid,
      if (topicTags != null) 'topic_tags': topicTags,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (thumbnailUrl != null) 'thumbnail_url': thumbnailUrl,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  VideoCacheCompanion copyWith(
      {Value<int>? id,
      Value<String>? youtubeId,
      Value<String>? title,
      Value<String?>? teacher,
      Value<String?>? suttaUid,
      Value<String?>? topicTags,
      Value<int?>? durationSeconds,
      Value<String?>? thumbnailUrl,
      Value<DateTime>? cachedAt}) {
    return VideoCacheCompanion(
      id: id ?? this.id,
      youtubeId: youtubeId ?? this.youtubeId,
      title: title ?? this.title,
      teacher: teacher ?? this.teacher,
      suttaUid: suttaUid ?? this.suttaUid,
      topicTags: topicTags ?? this.topicTags,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (youtubeId.present) {
      map['youtube_id'] = Variable<String>(youtubeId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (teacher.present) {
      map['teacher'] = Variable<String>(teacher.value);
    }
    if (suttaUid.present) {
      map['sutta_uid'] = Variable<String>(suttaUid.value);
    }
    if (topicTags.present) {
      map['topic_tags'] = Variable<String>(topicTags.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (thumbnailUrl.present) {
      map['thumbnail_url'] = Variable<String>(thumbnailUrl.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VideoCacheCompanion(')
          ..write('id: $id, ')
          ..write('youtubeId: $youtubeId, ')
          ..write('title: $title, ')
          ..write('teacher: $teacher, ')
          ..write('suttaUid: $suttaUid, ')
          ..write('topicTags: $topicTags, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('thumbnailUrl: $thumbnailUrl, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

class $DownloadedPacksTable extends DownloadedPacks
    with TableInfo<$DownloadedPacksTable, DownloadedPack> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadedPacksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
      'pack_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _packNameMeta =
      const VerificationMeta('packName');
  @override
  late final GeneratedColumn<String> packName = GeneratedColumn<String>(
      'pack_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nikayaMeta = const VerificationMeta('nikaya');
  @override
  late final GeneratedColumn<String> nikaya = GeneratedColumn<String>(
      'nikaya', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sizeMbMeta = const VerificationMeta('sizeMb');
  @override
  late final GeneratedColumn<double> sizeMb = GeneratedColumn<double>(
      'size_mb', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _downloadedAtMeta =
      const VerificationMeta('downloadedAt');
  @override
  late final GeneratedColumn<DateTime> downloadedAt = GeneratedColumn<DateTime>(
      'downloaded_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, packId, packName, language, nikaya, sizeMb, downloadedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'downloaded_packs';
  @override
  VerificationContext validateIntegrity(Insertable<DownloadedPack> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pack_id')) {
      context.handle(_packIdMeta,
          packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta));
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('pack_name')) {
      context.handle(_packNameMeta,
          packName.isAcceptableOrUnknown(data['pack_name']!, _packNameMeta));
    } else if (isInserting) {
      context.missing(_packNameMeta);
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('nikaya')) {
      context.handle(_nikayaMeta,
          nikaya.isAcceptableOrUnknown(data['nikaya']!, _nikayaMeta));
    }
    if (data.containsKey('size_mb')) {
      context.handle(_sizeMbMeta,
          sizeMb.isAcceptableOrUnknown(data['size_mb']!, _sizeMbMeta));
    } else if (isInserting) {
      context.missing(_sizeMbMeta);
    }
    if (data.containsKey('downloaded_at')) {
      context.handle(
          _downloadedAtMeta,
          downloadedAt.isAcceptableOrUnknown(
              data['downloaded_at']!, _downloadedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DownloadedPack map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadedPack(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      packId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pack_id'])!,
      packName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pack_name'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      nikaya: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nikaya']),
      sizeMb: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}size_mb'])!,
      downloadedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}downloaded_at'])!,
    );
  }

  @override
  $DownloadedPacksTable createAlias(String alias) {
    return $DownloadedPacksTable(attachedDatabase, alias);
  }
}

class DownloadedPack extends DataClass implements Insertable<DownloadedPack> {
  final int id;
  final String packId;
  final String packName;
  final String language;
  final String? nikaya;
  final double sizeMb;
  final DateTime downloadedAt;
  const DownloadedPack(
      {required this.id,
      required this.packId,
      required this.packName,
      required this.language,
      this.nikaya,
      required this.sizeMb,
      required this.downloadedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pack_id'] = Variable<String>(packId);
    map['pack_name'] = Variable<String>(packName);
    map['language'] = Variable<String>(language);
    if (!nullToAbsent || nikaya != null) {
      map['nikaya'] = Variable<String>(nikaya);
    }
    map['size_mb'] = Variable<double>(sizeMb);
    map['downloaded_at'] = Variable<DateTime>(downloadedAt);
    return map;
  }

  DownloadedPacksCompanion toCompanion(bool nullToAbsent) {
    return DownloadedPacksCompanion(
      id: Value(id),
      packId: Value(packId),
      packName: Value(packName),
      language: Value(language),
      nikaya:
          nikaya == null && nullToAbsent ? const Value.absent() : Value(nikaya),
      sizeMb: Value(sizeMb),
      downloadedAt: Value(downloadedAt),
    );
  }

  factory DownloadedPack.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadedPack(
      id: serializer.fromJson<int>(json['id']),
      packId: serializer.fromJson<String>(json['packId']),
      packName: serializer.fromJson<String>(json['packName']),
      language: serializer.fromJson<String>(json['language']),
      nikaya: serializer.fromJson<String?>(json['nikaya']),
      sizeMb: serializer.fromJson<double>(json['sizeMb']),
      downloadedAt: serializer.fromJson<DateTime>(json['downloadedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'packId': serializer.toJson<String>(packId),
      'packName': serializer.toJson<String>(packName),
      'language': serializer.toJson<String>(language),
      'nikaya': serializer.toJson<String?>(nikaya),
      'sizeMb': serializer.toJson<double>(sizeMb),
      'downloadedAt': serializer.toJson<DateTime>(downloadedAt),
    };
  }

  DownloadedPack copyWith(
          {int? id,
          String? packId,
          String? packName,
          String? language,
          Value<String?> nikaya = const Value.absent(),
          double? sizeMb,
          DateTime? downloadedAt}) =>
      DownloadedPack(
        id: id ?? this.id,
        packId: packId ?? this.packId,
        packName: packName ?? this.packName,
        language: language ?? this.language,
        nikaya: nikaya.present ? nikaya.value : this.nikaya,
        sizeMb: sizeMb ?? this.sizeMb,
        downloadedAt: downloadedAt ?? this.downloadedAt,
      );
  DownloadedPack copyWithCompanion(DownloadedPacksCompanion data) {
    return DownloadedPack(
      id: data.id.present ? data.id.value : this.id,
      packId: data.packId.present ? data.packId.value : this.packId,
      packName: data.packName.present ? data.packName.value : this.packName,
      language: data.language.present ? data.language.value : this.language,
      nikaya: data.nikaya.present ? data.nikaya.value : this.nikaya,
      sizeMb: data.sizeMb.present ? data.sizeMb.value : this.sizeMb,
      downloadedAt: data.downloadedAt.present
          ? data.downloadedAt.value
          : this.downloadedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedPack(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('packName: $packName, ')
          ..write('language: $language, ')
          ..write('nikaya: $nikaya, ')
          ..write('sizeMb: $sizeMb, ')
          ..write('downloadedAt: $downloadedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, packId, packName, language, nikaya, sizeMb, downloadedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadedPack &&
          other.id == this.id &&
          other.packId == this.packId &&
          other.packName == this.packName &&
          other.language == this.language &&
          other.nikaya == this.nikaya &&
          other.sizeMb == this.sizeMb &&
          other.downloadedAt == this.downloadedAt);
}

class DownloadedPacksCompanion extends UpdateCompanion<DownloadedPack> {
  final Value<int> id;
  final Value<String> packId;
  final Value<String> packName;
  final Value<String> language;
  final Value<String?> nikaya;
  final Value<double> sizeMb;
  final Value<DateTime> downloadedAt;
  const DownloadedPacksCompanion({
    this.id = const Value.absent(),
    this.packId = const Value.absent(),
    this.packName = const Value.absent(),
    this.language = const Value.absent(),
    this.nikaya = const Value.absent(),
    this.sizeMb = const Value.absent(),
    this.downloadedAt = const Value.absent(),
  });
  DownloadedPacksCompanion.insert({
    this.id = const Value.absent(),
    required String packId,
    required String packName,
    required String language,
    this.nikaya = const Value.absent(),
    required double sizeMb,
    this.downloadedAt = const Value.absent(),
  })  : packId = Value(packId),
        packName = Value(packName),
        language = Value(language),
        sizeMb = Value(sizeMb);
  static Insertable<DownloadedPack> custom({
    Expression<int>? id,
    Expression<String>? packId,
    Expression<String>? packName,
    Expression<String>? language,
    Expression<String>? nikaya,
    Expression<double>? sizeMb,
    Expression<DateTime>? downloadedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packId != null) 'pack_id': packId,
      if (packName != null) 'pack_name': packName,
      if (language != null) 'language': language,
      if (nikaya != null) 'nikaya': nikaya,
      if (sizeMb != null) 'size_mb': sizeMb,
      if (downloadedAt != null) 'downloaded_at': downloadedAt,
    });
  }

  DownloadedPacksCompanion copyWith(
      {Value<int>? id,
      Value<String>? packId,
      Value<String>? packName,
      Value<String>? language,
      Value<String?>? nikaya,
      Value<double>? sizeMb,
      Value<DateTime>? downloadedAt}) {
    return DownloadedPacksCompanion(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      packName: packName ?? this.packName,
      language: language ?? this.language,
      nikaya: nikaya ?? this.nikaya,
      sizeMb: sizeMb ?? this.sizeMb,
      downloadedAt: downloadedAt ?? this.downloadedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (packName.present) {
      map['pack_name'] = Variable<String>(packName.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (nikaya.present) {
      map['nikaya'] = Variable<String>(nikaya.value);
    }
    if (sizeMb.present) {
      map['size_mb'] = Variable<double>(sizeMb.value);
    }
    if (downloadedAt.present) {
      map['downloaded_at'] = Variable<DateTime>(downloadedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedPacksCompanion(')
          ..write('id: $id, ')
          ..write('packId: $packId, ')
          ..write('packName: $packName, ')
          ..write('language: $language, ')
          ..write('nikaya: $nikaya, ')
          ..write('sizeMb: $sizeMb, ')
          ..write('downloadedAt: $downloadedAt')
          ..write(')'))
        .toString();
  }
}

class $SearchHistoryTable extends SearchHistory
    with TableInfo<$SearchHistoryTable, SearchHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SearchHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _queryMeta = const VerificationMeta('query');
  @override
  late final GeneratedColumn<String> query = GeneratedColumn<String>(
      'query', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _searchedAtMeta =
      const VerificationMeta('searchedAt');
  @override
  late final GeneratedColumn<DateTime> searchedAt = GeneratedColumn<DateTime>(
      'searched_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, query, searchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'search_history';
  @override
  VerificationContext validateIntegrity(Insertable<SearchHistoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('query')) {
      context.handle(
          _queryMeta, query.isAcceptableOrUnknown(data['query']!, _queryMeta));
    } else if (isInserting) {
      context.missing(_queryMeta);
    }
    if (data.containsKey('searched_at')) {
      context.handle(
          _searchedAtMeta,
          searchedAt.isAcceptableOrUnknown(
              data['searched_at']!, _searchedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SearchHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SearchHistoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      query: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}query'])!,
      searchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}searched_at'])!,
    );
  }

  @override
  $SearchHistoryTable createAlias(String alias) {
    return $SearchHistoryTable(attachedDatabase, alias);
  }
}

class SearchHistoryData extends DataClass
    implements Insertable<SearchHistoryData> {
  final int id;
  final String query;
  final DateTime searchedAt;
  const SearchHistoryData(
      {required this.id, required this.query, required this.searchedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['query'] = Variable<String>(query);
    map['searched_at'] = Variable<DateTime>(searchedAt);
    return map;
  }

  SearchHistoryCompanion toCompanion(bool nullToAbsent) {
    return SearchHistoryCompanion(
      id: Value(id),
      query: Value(query),
      searchedAt: Value(searchedAt),
    );
  }

  factory SearchHistoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SearchHistoryData(
      id: serializer.fromJson<int>(json['id']),
      query: serializer.fromJson<String>(json['query']),
      searchedAt: serializer.fromJson<DateTime>(json['searchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'query': serializer.toJson<String>(query),
      'searchedAt': serializer.toJson<DateTime>(searchedAt),
    };
  }

  SearchHistoryData copyWith({int? id, String? query, DateTime? searchedAt}) =>
      SearchHistoryData(
        id: id ?? this.id,
        query: query ?? this.query,
        searchedAt: searchedAt ?? this.searchedAt,
      );
  SearchHistoryData copyWithCompanion(SearchHistoryCompanion data) {
    return SearchHistoryData(
      id: data.id.present ? data.id.value : this.id,
      query: data.query.present ? data.query.value : this.query,
      searchedAt:
          data.searchedAt.present ? data.searchedAt.value : this.searchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SearchHistoryData(')
          ..write('id: $id, ')
          ..write('query: $query, ')
          ..write('searchedAt: $searchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, query, searchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SearchHistoryData &&
          other.id == this.id &&
          other.query == this.query &&
          other.searchedAt == this.searchedAt);
}

class SearchHistoryCompanion extends UpdateCompanion<SearchHistoryData> {
  final Value<int> id;
  final Value<String> query;
  final Value<DateTime> searchedAt;
  const SearchHistoryCompanion({
    this.id = const Value.absent(),
    this.query = const Value.absent(),
    this.searchedAt = const Value.absent(),
  });
  SearchHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String query,
    this.searchedAt = const Value.absent(),
  }) : query = Value(query);
  static Insertable<SearchHistoryData> custom({
    Expression<int>? id,
    Expression<String>? query,
    Expression<DateTime>? searchedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (query != null) 'query': query,
      if (searchedAt != null) 'searched_at': searchedAt,
    });
  }

  SearchHistoryCompanion copyWith(
      {Value<int>? id, Value<String>? query, Value<DateTime>? searchedAt}) {
    return SearchHistoryCompanion(
      id: id ?? this.id,
      query: query ?? this.query,
      searchedAt: searchedAt ?? this.searchedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (query.present) {
      map['query'] = Variable<String>(query.value);
    }
    if (searchedAt.present) {
      map['searched_at'] = Variable<DateTime>(searchedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchHistoryCompanion(')
          ..write('id: $id, ')
          ..write('query: $query, ')
          ..write('searchedAt: $searchedAt')
          ..write(')'))
        .toString();
  }
}

class $DailySuttasTable extends DailySuttas
    with TableInfo<$DailySuttasTable, DailySutta> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailySuttasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dayOfYearMeta =
      const VerificationMeta('dayOfYear');
  @override
  late final GeneratedColumn<int> dayOfYear = GeneratedColumn<int>(
      'day_of_year', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
      'uid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _verseExcerptMeta =
      const VerificationMeta('verseExcerpt');
  @override
  late final GeneratedColumn<String> verseExcerpt = GeneratedColumn<String>(
      'verse_excerpt', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nikayaMeta = const VerificationMeta('nikaya');
  @override
  late final GeneratedColumn<String> nikaya = GeneratedColumn<String>(
      'nikaya', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, dayOfYear, uid, title, verseExcerpt, nikaya];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_suttas';
  @override
  VerificationContext validateIntegrity(Insertable<DailySutta> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day_of_year')) {
      context.handle(
          _dayOfYearMeta,
          dayOfYear.isAcceptableOrUnknown(
              data['day_of_year']!, _dayOfYearMeta));
    } else if (isInserting) {
      context.missing(_dayOfYearMeta);
    }
    if (data.containsKey('uid')) {
      context.handle(
          _uidMeta, uid.isAcceptableOrUnknown(data['uid']!, _uidMeta));
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('verse_excerpt')) {
      context.handle(
          _verseExcerptMeta,
          verseExcerpt.isAcceptableOrUnknown(
              data['verse_excerpt']!, _verseExcerptMeta));
    }
    if (data.containsKey('nikaya')) {
      context.handle(_nikayaMeta,
          nikaya.isAcceptableOrUnknown(data['nikaya']!, _nikayaMeta));
    } else if (isInserting) {
      context.missing(_nikayaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailySutta map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailySutta(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      dayOfYear: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}day_of_year'])!,
      uid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uid'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      verseExcerpt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}verse_excerpt']),
      nikaya: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nikaya'])!,
    );
  }

  @override
  $DailySuttasTable createAlias(String alias) {
    return $DailySuttasTable(attachedDatabase, alias);
  }
}

class DailySutta extends DataClass implements Insertable<DailySutta> {
  final int id;
  final int dayOfYear;
  final String uid;
  final String title;
  final String? verseExcerpt;
  final String nikaya;
  const DailySutta(
      {required this.id,
      required this.dayOfYear,
      required this.uid,
      required this.title,
      this.verseExcerpt,
      required this.nikaya});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day_of_year'] = Variable<int>(dayOfYear);
    map['uid'] = Variable<String>(uid);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || verseExcerpt != null) {
      map['verse_excerpt'] = Variable<String>(verseExcerpt);
    }
    map['nikaya'] = Variable<String>(nikaya);
    return map;
  }

  DailySuttasCompanion toCompanion(bool nullToAbsent) {
    return DailySuttasCompanion(
      id: Value(id),
      dayOfYear: Value(dayOfYear),
      uid: Value(uid),
      title: Value(title),
      verseExcerpt: verseExcerpt == null && nullToAbsent
          ? const Value.absent()
          : Value(verseExcerpt),
      nikaya: Value(nikaya),
    );
  }

  factory DailySutta.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailySutta(
      id: serializer.fromJson<int>(json['id']),
      dayOfYear: serializer.fromJson<int>(json['dayOfYear']),
      uid: serializer.fromJson<String>(json['uid']),
      title: serializer.fromJson<String>(json['title']),
      verseExcerpt: serializer.fromJson<String?>(json['verseExcerpt']),
      nikaya: serializer.fromJson<String>(json['nikaya']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dayOfYear': serializer.toJson<int>(dayOfYear),
      'uid': serializer.toJson<String>(uid),
      'title': serializer.toJson<String>(title),
      'verseExcerpt': serializer.toJson<String?>(verseExcerpt),
      'nikaya': serializer.toJson<String>(nikaya),
    };
  }

  DailySutta copyWith(
          {int? id,
          int? dayOfYear,
          String? uid,
          String? title,
          Value<String?> verseExcerpt = const Value.absent(),
          String? nikaya}) =>
      DailySutta(
        id: id ?? this.id,
        dayOfYear: dayOfYear ?? this.dayOfYear,
        uid: uid ?? this.uid,
        title: title ?? this.title,
        verseExcerpt:
            verseExcerpt.present ? verseExcerpt.value : this.verseExcerpt,
        nikaya: nikaya ?? this.nikaya,
      );
  DailySutta copyWithCompanion(DailySuttasCompanion data) {
    return DailySutta(
      id: data.id.present ? data.id.value : this.id,
      dayOfYear: data.dayOfYear.present ? data.dayOfYear.value : this.dayOfYear,
      uid: data.uid.present ? data.uid.value : this.uid,
      title: data.title.present ? data.title.value : this.title,
      verseExcerpt: data.verseExcerpt.present
          ? data.verseExcerpt.value
          : this.verseExcerpt,
      nikaya: data.nikaya.present ? data.nikaya.value : this.nikaya,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailySutta(')
          ..write('id: $id, ')
          ..write('dayOfYear: $dayOfYear, ')
          ..write('uid: $uid, ')
          ..write('title: $title, ')
          ..write('verseExcerpt: $verseExcerpt, ')
          ..write('nikaya: $nikaya')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, dayOfYear, uid, title, verseExcerpt, nikaya);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailySutta &&
          other.id == this.id &&
          other.dayOfYear == this.dayOfYear &&
          other.uid == this.uid &&
          other.title == this.title &&
          other.verseExcerpt == this.verseExcerpt &&
          other.nikaya == this.nikaya);
}

class DailySuttasCompanion extends UpdateCompanion<DailySutta> {
  final Value<int> id;
  final Value<int> dayOfYear;
  final Value<String> uid;
  final Value<String> title;
  final Value<String?> verseExcerpt;
  final Value<String> nikaya;
  const DailySuttasCompanion({
    this.id = const Value.absent(),
    this.dayOfYear = const Value.absent(),
    this.uid = const Value.absent(),
    this.title = const Value.absent(),
    this.verseExcerpt = const Value.absent(),
    this.nikaya = const Value.absent(),
  });
  DailySuttasCompanion.insert({
    this.id = const Value.absent(),
    required int dayOfYear,
    required String uid,
    required String title,
    this.verseExcerpt = const Value.absent(),
    required String nikaya,
  })  : dayOfYear = Value(dayOfYear),
        uid = Value(uid),
        title = Value(title),
        nikaya = Value(nikaya);
  static Insertable<DailySutta> custom({
    Expression<int>? id,
    Expression<int>? dayOfYear,
    Expression<String>? uid,
    Expression<String>? title,
    Expression<String>? verseExcerpt,
    Expression<String>? nikaya,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayOfYear != null) 'day_of_year': dayOfYear,
      if (uid != null) 'uid': uid,
      if (title != null) 'title': title,
      if (verseExcerpt != null) 'verse_excerpt': verseExcerpt,
      if (nikaya != null) 'nikaya': nikaya,
    });
  }

  DailySuttasCompanion copyWith(
      {Value<int>? id,
      Value<int>? dayOfYear,
      Value<String>? uid,
      Value<String>? title,
      Value<String?>? verseExcerpt,
      Value<String>? nikaya}) {
    return DailySuttasCompanion(
      id: id ?? this.id,
      dayOfYear: dayOfYear ?? this.dayOfYear,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      verseExcerpt: verseExcerpt ?? this.verseExcerpt,
      nikaya: nikaya ?? this.nikaya,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dayOfYear.present) {
      map['day_of_year'] = Variable<int>(dayOfYear.value);
    }
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (verseExcerpt.present) {
      map['verse_excerpt'] = Variable<String>(verseExcerpt.value);
    }
    if (nikaya.present) {
      map['nikaya'] = Variable<String>(nikaya.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailySuttasCompanion(')
          ..write('id: $id, ')
          ..write('dayOfYear: $dayOfYear, ')
          ..write('uid: $uid, ')
          ..write('title: $title, ')
          ..write('verseExcerpt: $verseExcerpt, ')
          ..write('nikaya: $nikaya')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TextsTable texts = $TextsTable(this);
  late final $TranslationsTable translations = $TranslationsTable(this);
  late final $TranslatorsTable translators = $TranslatorsTable(this);
  late final $UserBookmarksTable userBookmarks = $UserBookmarksTable(this);
  late final $UserHighlightsTable userHighlights = $UserHighlightsTable(this);
  late final $UserNotesTable userNotes = $UserNotesTable(this);
  late final $UserProgressTable userProgress = $UserProgressTable(this);
  late final $VideoCacheTable videoCache = $VideoCacheTable(this);
  late final $DownloadedPacksTable downloadedPacks =
      $DownloadedPacksTable(this);
  late final $SearchHistoryTable searchHistory = $SearchHistoryTable(this);
  late final $DailySuttasTable dailySuttas = $DailySuttasTable(this);
  late final TextsDao textsDao = TextsDao(this as AppDatabase);
  late final SearchDao searchDao = SearchDao(this as AppDatabase);
  late final StudyToolsDao studyToolsDao = StudyToolsDao(this as AppDatabase);
  late final ProgressDao progressDao = ProgressDao(this as AppDatabase);
  late final PacksDao packsDao = PacksDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        texts,
        translations,
        translators,
        userBookmarks,
        userHighlights,
        userNotes,
        userProgress,
        videoCache,
        downloadedPacks,
        searchHistory,
        dailySuttas
      ];
}

typedef $$TextsTableCreateCompanionBuilder = TextsCompanion Function({
  Value<int> id,
  required String uid,
  required String title,
  Value<String?> collection,
  required String nikaya,
  Value<String?> book,
  Value<String?> chapter,
  required String language,
  Value<String?> translator,
  Value<String?> source,
  Value<String?> contentHtml,
  Value<String?> contentPlain,
});
typedef $$TextsTableUpdateCompanionBuilder = TextsCompanion Function({
  Value<int> id,
  Value<String> uid,
  Value<String> title,
  Value<String?> collection,
  Value<String> nikaya,
  Value<String?> book,
  Value<String?> chapter,
  Value<String> language,
  Value<String?> translator,
  Value<String?> source,
  Value<String?> contentHtml,
  Value<String?> contentPlain,
});

class $$TextsTableFilterComposer extends Composer<_$AppDatabase, $TextsTable> {
  $$TextsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uid => $composableBuilder(
      column: $table.uid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get collection => $composableBuilder(
      column: $table.collection, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nikaya => $composableBuilder(
      column: $table.nikaya, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get book => $composableBuilder(
      column: $table.book, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chapter => $composableBuilder(
      column: $table.chapter, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get translator => $composableBuilder(
      column: $table.translator, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentHtml => $composableBuilder(
      column: $table.contentHtml, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentPlain => $composableBuilder(
      column: $table.contentPlain, builder: (column) => ColumnFilters(column));
}

class $$TextsTableOrderingComposer
    extends Composer<_$AppDatabase, $TextsTable> {
  $$TextsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uid => $composableBuilder(
      column: $table.uid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get collection => $composableBuilder(
      column: $table.collection, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nikaya => $composableBuilder(
      column: $table.nikaya, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get book => $composableBuilder(
      column: $table.book, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chapter => $composableBuilder(
      column: $table.chapter, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get translator => $composableBuilder(
      column: $table.translator, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentHtml => $composableBuilder(
      column: $table.contentHtml, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentPlain => $composableBuilder(
      column: $table.contentPlain,
      builder: (column) => ColumnOrderings(column));
}

class $$TextsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TextsTable> {
  $$TextsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get collection => $composableBuilder(
      column: $table.collection, builder: (column) => column);

  GeneratedColumn<String> get nikaya =>
      $composableBuilder(column: $table.nikaya, builder: (column) => column);

  GeneratedColumn<String> get book =>
      $composableBuilder(column: $table.book, builder: (column) => column);

  GeneratedColumn<String> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get translator => $composableBuilder(
      column: $table.translator, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get contentHtml => $composableBuilder(
      column: $table.contentHtml, builder: (column) => column);

  GeneratedColumn<String> get contentPlain => $composableBuilder(
      column: $table.contentPlain, builder: (column) => column);
}

class $$TextsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TextsTable,
    SuttaText,
    $$TextsTableFilterComposer,
    $$TextsTableOrderingComposer,
    $$TextsTableAnnotationComposer,
    $$TextsTableCreateCompanionBuilder,
    $$TextsTableUpdateCompanionBuilder,
    (SuttaText, BaseReferences<_$AppDatabase, $TextsTable, SuttaText>),
    SuttaText,
    PrefetchHooks Function()> {
  $$TextsTableTableManager(_$AppDatabase db, $TextsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TextsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TextsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TextsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uid = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> collection = const Value.absent(),
            Value<String> nikaya = const Value.absent(),
            Value<String?> book = const Value.absent(),
            Value<String?> chapter = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<String?> translator = const Value.absent(),
            Value<String?> source = const Value.absent(),
            Value<String?> contentHtml = const Value.absent(),
            Value<String?> contentPlain = const Value.absent(),
          }) =>
              TextsCompanion(
            id: id,
            uid: uid,
            title: title,
            collection: collection,
            nikaya: nikaya,
            book: book,
            chapter: chapter,
            language: language,
            translator: translator,
            source: source,
            contentHtml: contentHtml,
            contentPlain: contentPlain,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String uid,
            required String title,
            Value<String?> collection = const Value.absent(),
            required String nikaya,
            Value<String?> book = const Value.absent(),
            Value<String?> chapter = const Value.absent(),
            required String language,
            Value<String?> translator = const Value.absent(),
            Value<String?> source = const Value.absent(),
            Value<String?> contentHtml = const Value.absent(),
            Value<String?> contentPlain = const Value.absent(),
          }) =>
              TextsCompanion.insert(
            id: id,
            uid: uid,
            title: title,
            collection: collection,
            nikaya: nikaya,
            book: book,
            chapter: chapter,
            language: language,
            translator: translator,
            source: source,
            contentHtml: contentHtml,
            contentPlain: contentPlain,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TextsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TextsTable,
    SuttaText,
    $$TextsTableFilterComposer,
    $$TextsTableOrderingComposer,
    $$TextsTableAnnotationComposer,
    $$TextsTableCreateCompanionBuilder,
    $$TextsTableUpdateCompanionBuilder,
    (SuttaText, BaseReferences<_$AppDatabase, $TextsTable, SuttaText>),
    SuttaText,
    PrefetchHooks Function()>;
typedef $$TranslationsTableCreateCompanionBuilder = TranslationsCompanion
    Function({
  Value<int> id,
  required String textUid,
  required String language,
  Value<String?> translator,
  Value<String?> source,
  Value<String?> contentHtml,
  Value<String?> contentPlain,
});
typedef $$TranslationsTableUpdateCompanionBuilder = TranslationsCompanion
    Function({
  Value<int> id,
  Value<String> textUid,
  Value<String> language,
  Value<String?> translator,
  Value<String?> source,
  Value<String?> contentHtml,
  Value<String?> contentPlain,
});

class $$TranslationsTableFilterComposer
    extends Composer<_$AppDatabase, $TranslationsTable> {
  $$TranslationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textUid => $composableBuilder(
      column: $table.textUid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get translator => $composableBuilder(
      column: $table.translator, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentHtml => $composableBuilder(
      column: $table.contentHtml, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentPlain => $composableBuilder(
      column: $table.contentPlain, builder: (column) => ColumnFilters(column));
}

class $$TranslationsTableOrderingComposer
    extends Composer<_$AppDatabase, $TranslationsTable> {
  $$TranslationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textUid => $composableBuilder(
      column: $table.textUid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get translator => $composableBuilder(
      column: $table.translator, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentHtml => $composableBuilder(
      column: $table.contentHtml, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentPlain => $composableBuilder(
      column: $table.contentPlain,
      builder: (column) => ColumnOrderings(column));
}

class $$TranslationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TranslationsTable> {
  $$TranslationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get textUid =>
      $composableBuilder(column: $table.textUid, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get translator => $composableBuilder(
      column: $table.translator, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get contentHtml => $composableBuilder(
      column: $table.contentHtml, builder: (column) => column);

  GeneratedColumn<String> get contentPlain => $composableBuilder(
      column: $table.contentPlain, builder: (column) => column);
}

class $$TranslationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TranslationsTable,
    Translation,
    $$TranslationsTableFilterComposer,
    $$TranslationsTableOrderingComposer,
    $$TranslationsTableAnnotationComposer,
    $$TranslationsTableCreateCompanionBuilder,
    $$TranslationsTableUpdateCompanionBuilder,
    (
      Translation,
      BaseReferences<_$AppDatabase, $TranslationsTable, Translation>
    ),
    Translation,
    PrefetchHooks Function()> {
  $$TranslationsTableTableManager(_$AppDatabase db, $TranslationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TranslationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TranslationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TranslationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> textUid = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<String?> translator = const Value.absent(),
            Value<String?> source = const Value.absent(),
            Value<String?> contentHtml = const Value.absent(),
            Value<String?> contentPlain = const Value.absent(),
          }) =>
              TranslationsCompanion(
            id: id,
            textUid: textUid,
            language: language,
            translator: translator,
            source: source,
            contentHtml: contentHtml,
            contentPlain: contentPlain,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String textUid,
            required String language,
            Value<String?> translator = const Value.absent(),
            Value<String?> source = const Value.absent(),
            Value<String?> contentHtml = const Value.absent(),
            Value<String?> contentPlain = const Value.absent(),
          }) =>
              TranslationsCompanion.insert(
            id: id,
            textUid: textUid,
            language: language,
            translator: translator,
            source: source,
            contentHtml: contentHtml,
            contentPlain: contentPlain,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TranslationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TranslationsTable,
    Translation,
    $$TranslationsTableFilterComposer,
    $$TranslationsTableOrderingComposer,
    $$TranslationsTableAnnotationComposer,
    $$TranslationsTableCreateCompanionBuilder,
    $$TranslationsTableUpdateCompanionBuilder,
    (
      Translation,
      BaseReferences<_$AppDatabase, $TranslationsTable, Translation>
    ),
    Translation,
    PrefetchHooks Function()>;
typedef $$TranslatorsTableCreateCompanionBuilder = TranslatorsCompanion
    Function({
  Value<int> id,
  required String name,
  Value<String?> tradition,
  Value<String?> bio,
  Value<String?> sourceUrl,
});
typedef $$TranslatorsTableUpdateCompanionBuilder = TranslatorsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String?> tradition,
  Value<String?> bio,
  Value<String?> sourceUrl,
});

class $$TranslatorsTableFilterComposer
    extends Composer<_$AppDatabase, $TranslatorsTable> {
  $$TranslatorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tradition => $composableBuilder(
      column: $table.tradition, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bio => $composableBuilder(
      column: $table.bio, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceUrl => $composableBuilder(
      column: $table.sourceUrl, builder: (column) => ColumnFilters(column));
}

class $$TranslatorsTableOrderingComposer
    extends Composer<_$AppDatabase, $TranslatorsTable> {
  $$TranslatorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tradition => $composableBuilder(
      column: $table.tradition, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bio => $composableBuilder(
      column: $table.bio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
      column: $table.sourceUrl, builder: (column) => ColumnOrderings(column));
}

class $$TranslatorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TranslatorsTable> {
  $$TranslatorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get tradition =>
      $composableBuilder(column: $table.tradition, builder: (column) => column);

  GeneratedColumn<String> get bio =>
      $composableBuilder(column: $table.bio, builder: (column) => column);

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);
}

class $$TranslatorsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TranslatorsTable,
    Translator,
    $$TranslatorsTableFilterComposer,
    $$TranslatorsTableOrderingComposer,
    $$TranslatorsTableAnnotationComposer,
    $$TranslatorsTableCreateCompanionBuilder,
    $$TranslatorsTableUpdateCompanionBuilder,
    (Translator, BaseReferences<_$AppDatabase, $TranslatorsTable, Translator>),
    Translator,
    PrefetchHooks Function()> {
  $$TranslatorsTableTableManager(_$AppDatabase db, $TranslatorsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TranslatorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TranslatorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TranslatorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> tradition = const Value.absent(),
            Value<String?> bio = const Value.absent(),
            Value<String?> sourceUrl = const Value.absent(),
          }) =>
              TranslatorsCompanion(
            id: id,
            name: name,
            tradition: tradition,
            bio: bio,
            sourceUrl: sourceUrl,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> tradition = const Value.absent(),
            Value<String?> bio = const Value.absent(),
            Value<String?> sourceUrl = const Value.absent(),
          }) =>
              TranslatorsCompanion.insert(
            id: id,
            name: name,
            tradition: tradition,
            bio: bio,
            sourceUrl: sourceUrl,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TranslatorsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TranslatorsTable,
    Translator,
    $$TranslatorsTableFilterComposer,
    $$TranslatorsTableOrderingComposer,
    $$TranslatorsTableAnnotationComposer,
    $$TranslatorsTableCreateCompanionBuilder,
    $$TranslatorsTableUpdateCompanionBuilder,
    (Translator, BaseReferences<_$AppDatabase, $TranslatorsTable, Translator>),
    Translator,
    PrefetchHooks Function()>;
typedef $$UserBookmarksTableCreateCompanionBuilder = UserBookmarksCompanion
    Function({
  Value<int> id,
  required String textUid,
  Value<String> label,
  Value<String?> userId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> syncedAt,
  Value<bool> isDeleted,
});
typedef $$UserBookmarksTableUpdateCompanionBuilder = UserBookmarksCompanion
    Function({
  Value<int> id,
  Value<String> textUid,
  Value<String> label,
  Value<String?> userId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> syncedAt,
  Value<bool> isDeleted,
});

class $$UserBookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $UserBookmarksTable> {
  $$UserBookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textUid => $composableBuilder(
      column: $table.textUid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$UserBookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $UserBookmarksTable> {
  $$UserBookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textUid => $composableBuilder(
      column: $table.textUid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$UserBookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserBookmarksTable> {
  $$UserBookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get textUid =>
      $composableBuilder(column: $table.textUid, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$UserBookmarksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserBookmarksTable,
    UserBookmark,
    $$UserBookmarksTableFilterComposer,
    $$UserBookmarksTableOrderingComposer,
    $$UserBookmarksTableAnnotationComposer,
    $$UserBookmarksTableCreateCompanionBuilder,
    $$UserBookmarksTableUpdateCompanionBuilder,
    (
      UserBookmark,
      BaseReferences<_$AppDatabase, $UserBookmarksTable, UserBookmark>
    ),
    UserBookmark,
    PrefetchHooks Function()> {
  $$UserBookmarksTableTableManager(_$AppDatabase db, $UserBookmarksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserBookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserBookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserBookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> textUid = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
          }) =>
              UserBookmarksCompanion(
            id: id,
            textUid: textUid,
            label: label,
            userId: userId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncedAt: syncedAt,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String textUid,
            Value<String> label = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
          }) =>
              UserBookmarksCompanion.insert(
            id: id,
            textUid: textUid,
            label: label,
            userId: userId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncedAt: syncedAt,
            isDeleted: isDeleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserBookmarksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserBookmarksTable,
    UserBookmark,
    $$UserBookmarksTableFilterComposer,
    $$UserBookmarksTableOrderingComposer,
    $$UserBookmarksTableAnnotationComposer,
    $$UserBookmarksTableCreateCompanionBuilder,
    $$UserBookmarksTableUpdateCompanionBuilder,
    (
      UserBookmark,
      BaseReferences<_$AppDatabase, $UserBookmarksTable, UserBookmark>
    ),
    UserBookmark,
    PrefetchHooks Function()>;
typedef $$UserHighlightsTableCreateCompanionBuilder = UserHighlightsCompanion
    Function({
  Value<int> id,
  required String textUid,
  required int startOffset,
  required int endOffset,
  required String colour,
  Value<String?> userId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> syncedAt,
  Value<bool> isDeleted,
});
typedef $$UserHighlightsTableUpdateCompanionBuilder = UserHighlightsCompanion
    Function({
  Value<int> id,
  Value<String> textUid,
  Value<int> startOffset,
  Value<int> endOffset,
  Value<String> colour,
  Value<String?> userId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> syncedAt,
  Value<bool> isDeleted,
});

class $$UserHighlightsTableFilterComposer
    extends Composer<_$AppDatabase, $UserHighlightsTable> {
  $$UserHighlightsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textUid => $composableBuilder(
      column: $table.textUid, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startOffset => $composableBuilder(
      column: $table.startOffset, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get endOffset => $composableBuilder(
      column: $table.endOffset, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colour => $composableBuilder(
      column: $table.colour, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$UserHighlightsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserHighlightsTable> {
  $$UserHighlightsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textUid => $composableBuilder(
      column: $table.textUid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startOffset => $composableBuilder(
      column: $table.startOffset, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get endOffset => $composableBuilder(
      column: $table.endOffset, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colour => $composableBuilder(
      column: $table.colour, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$UserHighlightsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserHighlightsTable> {
  $$UserHighlightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get textUid =>
      $composableBuilder(column: $table.textUid, builder: (column) => column);

  GeneratedColumn<int> get startOffset => $composableBuilder(
      column: $table.startOffset, builder: (column) => column);

  GeneratedColumn<int> get endOffset =>
      $composableBuilder(column: $table.endOffset, builder: (column) => column);

  GeneratedColumn<String> get colour =>
      $composableBuilder(column: $table.colour, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$UserHighlightsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserHighlightsTable,
    UserHighlight,
    $$UserHighlightsTableFilterComposer,
    $$UserHighlightsTableOrderingComposer,
    $$UserHighlightsTableAnnotationComposer,
    $$UserHighlightsTableCreateCompanionBuilder,
    $$UserHighlightsTableUpdateCompanionBuilder,
    (
      UserHighlight,
      BaseReferences<_$AppDatabase, $UserHighlightsTable, UserHighlight>
    ),
    UserHighlight,
    PrefetchHooks Function()> {
  $$UserHighlightsTableTableManager(
      _$AppDatabase db, $UserHighlightsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserHighlightsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserHighlightsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserHighlightsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> textUid = const Value.absent(),
            Value<int> startOffset = const Value.absent(),
            Value<int> endOffset = const Value.absent(),
            Value<String> colour = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
          }) =>
              UserHighlightsCompanion(
            id: id,
            textUid: textUid,
            startOffset: startOffset,
            endOffset: endOffset,
            colour: colour,
            userId: userId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncedAt: syncedAt,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String textUid,
            required int startOffset,
            required int endOffset,
            required String colour,
            Value<String?> userId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
          }) =>
              UserHighlightsCompanion.insert(
            id: id,
            textUid: textUid,
            startOffset: startOffset,
            endOffset: endOffset,
            colour: colour,
            userId: userId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncedAt: syncedAt,
            isDeleted: isDeleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserHighlightsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserHighlightsTable,
    UserHighlight,
    $$UserHighlightsTableFilterComposer,
    $$UserHighlightsTableOrderingComposer,
    $$UserHighlightsTableAnnotationComposer,
    $$UserHighlightsTableCreateCompanionBuilder,
    $$UserHighlightsTableUpdateCompanionBuilder,
    (
      UserHighlight,
      BaseReferences<_$AppDatabase, $UserHighlightsTable, UserHighlight>
    ),
    UserHighlight,
    PrefetchHooks Function()>;
typedef $$UserNotesTableCreateCompanionBuilder = UserNotesCompanion Function({
  Value<int> id,
  required String textUid,
  required String content,
  Value<String?> userId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> syncedAt,
  Value<bool> isDeleted,
});
typedef $$UserNotesTableUpdateCompanionBuilder = UserNotesCompanion Function({
  Value<int> id,
  Value<String> textUid,
  Value<String> content,
  Value<String?> userId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> syncedAt,
  Value<bool> isDeleted,
});

class $$UserNotesTableFilterComposer
    extends Composer<_$AppDatabase, $UserNotesTable> {
  $$UserNotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textUid => $composableBuilder(
      column: $table.textUid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$UserNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserNotesTable> {
  $$UserNotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textUid => $composableBuilder(
      column: $table.textUid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$UserNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserNotesTable> {
  $$UserNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get textUid =>
      $composableBuilder(column: $table.textUid, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$UserNotesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserNotesTable,
    UserNote,
    $$UserNotesTableFilterComposer,
    $$UserNotesTableOrderingComposer,
    $$UserNotesTableAnnotationComposer,
    $$UserNotesTableCreateCompanionBuilder,
    $$UserNotesTableUpdateCompanionBuilder,
    (UserNote, BaseReferences<_$AppDatabase, $UserNotesTable, UserNote>),
    UserNote,
    PrefetchHooks Function()> {
  $$UserNotesTableTableManager(_$AppDatabase db, $UserNotesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> textUid = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
          }) =>
              UserNotesCompanion(
            id: id,
            textUid: textUid,
            content: content,
            userId: userId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncedAt: syncedAt,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String textUid,
            required String content,
            Value<String?> userId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
          }) =>
              UserNotesCompanion.insert(
            id: id,
            textUid: textUid,
            content: content,
            userId: userId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncedAt: syncedAt,
            isDeleted: isDeleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserNotesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserNotesTable,
    UserNote,
    $$UserNotesTableFilterComposer,
    $$UserNotesTableOrderingComposer,
    $$UserNotesTableAnnotationComposer,
    $$UserNotesTableCreateCompanionBuilder,
    $$UserNotesTableUpdateCompanionBuilder,
    (UserNote, BaseReferences<_$AppDatabase, $UserNotesTable, UserNote>),
    UserNote,
    PrefetchHooks Function()>;
typedef $$UserProgressTableCreateCompanionBuilder = UserProgressCompanion
    Function({
  Value<int> id,
  required String textUid,
  Value<int> lastPosition,
  Value<bool> completed,
  Value<String?> userId,
  Value<DateTime> lastReadAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> syncedAt,
  Value<bool> isDeleted,
});
typedef $$UserProgressTableUpdateCompanionBuilder = UserProgressCompanion
    Function({
  Value<int> id,
  Value<String> textUid,
  Value<int> lastPosition,
  Value<bool> completed,
  Value<String?> userId,
  Value<DateTime> lastReadAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> syncedAt,
  Value<bool> isDeleted,
});

class $$UserProgressTableFilterComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textUid => $composableBuilder(
      column: $table.textUid, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastPosition => $composableBuilder(
      column: $table.lastPosition, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastReadAt => $composableBuilder(
      column: $table.lastReadAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$UserProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textUid => $composableBuilder(
      column: $table.textUid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastPosition => $composableBuilder(
      column: $table.lastPosition,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastReadAt => $composableBuilder(
      column: $table.lastReadAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$UserProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get textUid =>
      $composableBuilder(column: $table.textUid, builder: (column) => column);

  GeneratedColumn<int> get lastPosition => $composableBuilder(
      column: $table.lastPosition, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReadAt => $composableBuilder(
      column: $table.lastReadAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$UserProgressTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserProgressTable,
    UserProgressData,
    $$UserProgressTableFilterComposer,
    $$UserProgressTableOrderingComposer,
    $$UserProgressTableAnnotationComposer,
    $$UserProgressTableCreateCompanionBuilder,
    $$UserProgressTableUpdateCompanionBuilder,
    (
      UserProgressData,
      BaseReferences<_$AppDatabase, $UserProgressTable, UserProgressData>
    ),
    UserProgressData,
    PrefetchHooks Function()> {
  $$UserProgressTableTableManager(_$AppDatabase db, $UserProgressTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> textUid = const Value.absent(),
            Value<int> lastPosition = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<DateTime> lastReadAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
          }) =>
              UserProgressCompanion(
            id: id,
            textUid: textUid,
            lastPosition: lastPosition,
            completed: completed,
            userId: userId,
            lastReadAt: lastReadAt,
            updatedAt: updatedAt,
            syncedAt: syncedAt,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String textUid,
            Value<int> lastPosition = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<DateTime> lastReadAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
          }) =>
              UserProgressCompanion.insert(
            id: id,
            textUid: textUid,
            lastPosition: lastPosition,
            completed: completed,
            userId: userId,
            lastReadAt: lastReadAt,
            updatedAt: updatedAt,
            syncedAt: syncedAt,
            isDeleted: isDeleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserProgressTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserProgressTable,
    UserProgressData,
    $$UserProgressTableFilterComposer,
    $$UserProgressTableOrderingComposer,
    $$UserProgressTableAnnotationComposer,
    $$UserProgressTableCreateCompanionBuilder,
    $$UserProgressTableUpdateCompanionBuilder,
    (
      UserProgressData,
      BaseReferences<_$AppDatabase, $UserProgressTable, UserProgressData>
    ),
    UserProgressData,
    PrefetchHooks Function()>;
typedef $$VideoCacheTableCreateCompanionBuilder = VideoCacheCompanion Function({
  Value<int> id,
  required String youtubeId,
  required String title,
  Value<String?> teacher,
  Value<String?> suttaUid,
  Value<String?> topicTags,
  Value<int?> durationSeconds,
  Value<String?> thumbnailUrl,
  Value<DateTime> cachedAt,
});
typedef $$VideoCacheTableUpdateCompanionBuilder = VideoCacheCompanion Function({
  Value<int> id,
  Value<String> youtubeId,
  Value<String> title,
  Value<String?> teacher,
  Value<String?> suttaUid,
  Value<String?> topicTags,
  Value<int?> durationSeconds,
  Value<String?> thumbnailUrl,
  Value<DateTime> cachedAt,
});

class $$VideoCacheTableFilterComposer
    extends Composer<_$AppDatabase, $VideoCacheTable> {
  $$VideoCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get youtubeId => $composableBuilder(
      column: $table.youtubeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get teacher => $composableBuilder(
      column: $table.teacher, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get suttaUid => $composableBuilder(
      column: $table.suttaUid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get topicTags => $composableBuilder(
      column: $table.topicTags, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get thumbnailUrl => $composableBuilder(
      column: $table.thumbnailUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
      column: $table.cachedAt, builder: (column) => ColumnFilters(column));
}

class $$VideoCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $VideoCacheTable> {
  $$VideoCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get youtubeId => $composableBuilder(
      column: $table.youtubeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get teacher => $composableBuilder(
      column: $table.teacher, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get suttaUid => $composableBuilder(
      column: $table.suttaUid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get topicTags => $composableBuilder(
      column: $table.topicTags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get thumbnailUrl => $composableBuilder(
      column: $table.thumbnailUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
      column: $table.cachedAt, builder: (column) => ColumnOrderings(column));
}

class $$VideoCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $VideoCacheTable> {
  $$VideoCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get youtubeId =>
      $composableBuilder(column: $table.youtubeId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get teacher =>
      $composableBuilder(column: $table.teacher, builder: (column) => column);

  GeneratedColumn<String> get suttaUid =>
      $composableBuilder(column: $table.suttaUid, builder: (column) => column);

  GeneratedColumn<String> get topicTags =>
      $composableBuilder(column: $table.topicTags, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds, builder: (column) => column);

  GeneratedColumn<String> get thumbnailUrl => $composableBuilder(
      column: $table.thumbnailUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$VideoCacheTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VideoCacheTable,
    VideoCacheData,
    $$VideoCacheTableFilterComposer,
    $$VideoCacheTableOrderingComposer,
    $$VideoCacheTableAnnotationComposer,
    $$VideoCacheTableCreateCompanionBuilder,
    $$VideoCacheTableUpdateCompanionBuilder,
    (
      VideoCacheData,
      BaseReferences<_$AppDatabase, $VideoCacheTable, VideoCacheData>
    ),
    VideoCacheData,
    PrefetchHooks Function()> {
  $$VideoCacheTableTableManager(_$AppDatabase db, $VideoCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VideoCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VideoCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VideoCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> youtubeId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> teacher = const Value.absent(),
            Value<String?> suttaUid = const Value.absent(),
            Value<String?> topicTags = const Value.absent(),
            Value<int?> durationSeconds = const Value.absent(),
            Value<String?> thumbnailUrl = const Value.absent(),
            Value<DateTime> cachedAt = const Value.absent(),
          }) =>
              VideoCacheCompanion(
            id: id,
            youtubeId: youtubeId,
            title: title,
            teacher: teacher,
            suttaUid: suttaUid,
            topicTags: topicTags,
            durationSeconds: durationSeconds,
            thumbnailUrl: thumbnailUrl,
            cachedAt: cachedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String youtubeId,
            required String title,
            Value<String?> teacher = const Value.absent(),
            Value<String?> suttaUid = const Value.absent(),
            Value<String?> topicTags = const Value.absent(),
            Value<int?> durationSeconds = const Value.absent(),
            Value<String?> thumbnailUrl = const Value.absent(),
            Value<DateTime> cachedAt = const Value.absent(),
          }) =>
              VideoCacheCompanion.insert(
            id: id,
            youtubeId: youtubeId,
            title: title,
            teacher: teacher,
            suttaUid: suttaUid,
            topicTags: topicTags,
            durationSeconds: durationSeconds,
            thumbnailUrl: thumbnailUrl,
            cachedAt: cachedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VideoCacheTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VideoCacheTable,
    VideoCacheData,
    $$VideoCacheTableFilterComposer,
    $$VideoCacheTableOrderingComposer,
    $$VideoCacheTableAnnotationComposer,
    $$VideoCacheTableCreateCompanionBuilder,
    $$VideoCacheTableUpdateCompanionBuilder,
    (
      VideoCacheData,
      BaseReferences<_$AppDatabase, $VideoCacheTable, VideoCacheData>
    ),
    VideoCacheData,
    PrefetchHooks Function()>;
typedef $$DownloadedPacksTableCreateCompanionBuilder = DownloadedPacksCompanion
    Function({
  Value<int> id,
  required String packId,
  required String packName,
  required String language,
  Value<String?> nikaya,
  required double sizeMb,
  Value<DateTime> downloadedAt,
});
typedef $$DownloadedPacksTableUpdateCompanionBuilder = DownloadedPacksCompanion
    Function({
  Value<int> id,
  Value<String> packId,
  Value<String> packName,
  Value<String> language,
  Value<String?> nikaya,
  Value<double> sizeMb,
  Value<DateTime> downloadedAt,
});

class $$DownloadedPacksTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadedPacksTable> {
  $$DownloadedPacksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get packId => $composableBuilder(
      column: $table.packId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get packName => $composableBuilder(
      column: $table.packName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nikaya => $composableBuilder(
      column: $table.nikaya, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sizeMb => $composableBuilder(
      column: $table.sizeMb, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get downloadedAt => $composableBuilder(
      column: $table.downloadedAt, builder: (column) => ColumnFilters(column));
}

class $$DownloadedPacksTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadedPacksTable> {
  $$DownloadedPacksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get packId => $composableBuilder(
      column: $table.packId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get packName => $composableBuilder(
      column: $table.packName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nikaya => $composableBuilder(
      column: $table.nikaya, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sizeMb => $composableBuilder(
      column: $table.sizeMb, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get downloadedAt => $composableBuilder(
      column: $table.downloadedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$DownloadedPacksTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadedPacksTable> {
  $$DownloadedPacksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get packId =>
      $composableBuilder(column: $table.packId, builder: (column) => column);

  GeneratedColumn<String> get packName =>
      $composableBuilder(column: $table.packName, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get nikaya =>
      $composableBuilder(column: $table.nikaya, builder: (column) => column);

  GeneratedColumn<double> get sizeMb =>
      $composableBuilder(column: $table.sizeMb, builder: (column) => column);

  GeneratedColumn<DateTime> get downloadedAt => $composableBuilder(
      column: $table.downloadedAt, builder: (column) => column);
}

class $$DownloadedPacksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DownloadedPacksTable,
    DownloadedPack,
    $$DownloadedPacksTableFilterComposer,
    $$DownloadedPacksTableOrderingComposer,
    $$DownloadedPacksTableAnnotationComposer,
    $$DownloadedPacksTableCreateCompanionBuilder,
    $$DownloadedPacksTableUpdateCompanionBuilder,
    (
      DownloadedPack,
      BaseReferences<_$AppDatabase, $DownloadedPacksTable, DownloadedPack>
    ),
    DownloadedPack,
    PrefetchHooks Function()> {
  $$DownloadedPacksTableTableManager(
      _$AppDatabase db, $DownloadedPacksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadedPacksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadedPacksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadedPacksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> packId = const Value.absent(),
            Value<String> packName = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<String?> nikaya = const Value.absent(),
            Value<double> sizeMb = const Value.absent(),
            Value<DateTime> downloadedAt = const Value.absent(),
          }) =>
              DownloadedPacksCompanion(
            id: id,
            packId: packId,
            packName: packName,
            language: language,
            nikaya: nikaya,
            sizeMb: sizeMb,
            downloadedAt: downloadedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String packId,
            required String packName,
            required String language,
            Value<String?> nikaya = const Value.absent(),
            required double sizeMb,
            Value<DateTime> downloadedAt = const Value.absent(),
          }) =>
              DownloadedPacksCompanion.insert(
            id: id,
            packId: packId,
            packName: packName,
            language: language,
            nikaya: nikaya,
            sizeMb: sizeMb,
            downloadedAt: downloadedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DownloadedPacksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DownloadedPacksTable,
    DownloadedPack,
    $$DownloadedPacksTableFilterComposer,
    $$DownloadedPacksTableOrderingComposer,
    $$DownloadedPacksTableAnnotationComposer,
    $$DownloadedPacksTableCreateCompanionBuilder,
    $$DownloadedPacksTableUpdateCompanionBuilder,
    (
      DownloadedPack,
      BaseReferences<_$AppDatabase, $DownloadedPacksTable, DownloadedPack>
    ),
    DownloadedPack,
    PrefetchHooks Function()>;
typedef $$SearchHistoryTableCreateCompanionBuilder = SearchHistoryCompanion
    Function({
  Value<int> id,
  required String query,
  Value<DateTime> searchedAt,
});
typedef $$SearchHistoryTableUpdateCompanionBuilder = SearchHistoryCompanion
    Function({
  Value<int> id,
  Value<String> query,
  Value<DateTime> searchedAt,
});

class $$SearchHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $SearchHistoryTable> {
  $$SearchHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get query => $composableBuilder(
      column: $table.query, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get searchedAt => $composableBuilder(
      column: $table.searchedAt, builder: (column) => ColumnFilters(column));
}

class $$SearchHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $SearchHistoryTable> {
  $$SearchHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get query => $composableBuilder(
      column: $table.query, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get searchedAt => $composableBuilder(
      column: $table.searchedAt, builder: (column) => ColumnOrderings(column));
}

class $$SearchHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $SearchHistoryTable> {
  $$SearchHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get query =>
      $composableBuilder(column: $table.query, builder: (column) => column);

  GeneratedColumn<DateTime> get searchedAt => $composableBuilder(
      column: $table.searchedAt, builder: (column) => column);
}

class $$SearchHistoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SearchHistoryTable,
    SearchHistoryData,
    $$SearchHistoryTableFilterComposer,
    $$SearchHistoryTableOrderingComposer,
    $$SearchHistoryTableAnnotationComposer,
    $$SearchHistoryTableCreateCompanionBuilder,
    $$SearchHistoryTableUpdateCompanionBuilder,
    (
      SearchHistoryData,
      BaseReferences<_$AppDatabase, $SearchHistoryTable, SearchHistoryData>
    ),
    SearchHistoryData,
    PrefetchHooks Function()> {
  $$SearchHistoryTableTableManager(_$AppDatabase db, $SearchHistoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SearchHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SearchHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SearchHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> query = const Value.absent(),
            Value<DateTime> searchedAt = const Value.absent(),
          }) =>
              SearchHistoryCompanion(
            id: id,
            query: query,
            searchedAt: searchedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String query,
            Value<DateTime> searchedAt = const Value.absent(),
          }) =>
              SearchHistoryCompanion.insert(
            id: id,
            query: query,
            searchedAt: searchedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SearchHistoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SearchHistoryTable,
    SearchHistoryData,
    $$SearchHistoryTableFilterComposer,
    $$SearchHistoryTableOrderingComposer,
    $$SearchHistoryTableAnnotationComposer,
    $$SearchHistoryTableCreateCompanionBuilder,
    $$SearchHistoryTableUpdateCompanionBuilder,
    (
      SearchHistoryData,
      BaseReferences<_$AppDatabase, $SearchHistoryTable, SearchHistoryData>
    ),
    SearchHistoryData,
    PrefetchHooks Function()>;
typedef $$DailySuttasTableCreateCompanionBuilder = DailySuttasCompanion
    Function({
  Value<int> id,
  required int dayOfYear,
  required String uid,
  required String title,
  Value<String?> verseExcerpt,
  required String nikaya,
});
typedef $$DailySuttasTableUpdateCompanionBuilder = DailySuttasCompanion
    Function({
  Value<int> id,
  Value<int> dayOfYear,
  Value<String> uid,
  Value<String> title,
  Value<String?> verseExcerpt,
  Value<String> nikaya,
});

class $$DailySuttasTableFilterComposer
    extends Composer<_$AppDatabase, $DailySuttasTable> {
  $$DailySuttasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dayOfYear => $composableBuilder(
      column: $table.dayOfYear, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uid => $composableBuilder(
      column: $table.uid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get verseExcerpt => $composableBuilder(
      column: $table.verseExcerpt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nikaya => $composableBuilder(
      column: $table.nikaya, builder: (column) => ColumnFilters(column));
}

class $$DailySuttasTableOrderingComposer
    extends Composer<_$AppDatabase, $DailySuttasTable> {
  $$DailySuttasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dayOfYear => $composableBuilder(
      column: $table.dayOfYear, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uid => $composableBuilder(
      column: $table.uid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verseExcerpt => $composableBuilder(
      column: $table.verseExcerpt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nikaya => $composableBuilder(
      column: $table.nikaya, builder: (column) => ColumnOrderings(column));
}

class $$DailySuttasTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailySuttasTable> {
  $$DailySuttasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get dayOfYear =>
      $composableBuilder(column: $table.dayOfYear, builder: (column) => column);

  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get verseExcerpt => $composableBuilder(
      column: $table.verseExcerpt, builder: (column) => column);

  GeneratedColumn<String> get nikaya =>
      $composableBuilder(column: $table.nikaya, builder: (column) => column);
}

class $$DailySuttasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailySuttasTable,
    DailySutta,
    $$DailySuttasTableFilterComposer,
    $$DailySuttasTableOrderingComposer,
    $$DailySuttasTableAnnotationComposer,
    $$DailySuttasTableCreateCompanionBuilder,
    $$DailySuttasTableUpdateCompanionBuilder,
    (DailySutta, BaseReferences<_$AppDatabase, $DailySuttasTable, DailySutta>),
    DailySutta,
    PrefetchHooks Function()> {
  $$DailySuttasTableTableManager(_$AppDatabase db, $DailySuttasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailySuttasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailySuttasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailySuttasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> dayOfYear = const Value.absent(),
            Value<String> uid = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> verseExcerpt = const Value.absent(),
            Value<String> nikaya = const Value.absent(),
          }) =>
              DailySuttasCompanion(
            id: id,
            dayOfYear: dayOfYear,
            uid: uid,
            title: title,
            verseExcerpt: verseExcerpt,
            nikaya: nikaya,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int dayOfYear,
            required String uid,
            required String title,
            Value<String?> verseExcerpt = const Value.absent(),
            required String nikaya,
          }) =>
              DailySuttasCompanion.insert(
            id: id,
            dayOfYear: dayOfYear,
            uid: uid,
            title: title,
            verseExcerpt: verseExcerpt,
            nikaya: nikaya,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DailySuttasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DailySuttasTable,
    DailySutta,
    $$DailySuttasTableFilterComposer,
    $$DailySuttasTableOrderingComposer,
    $$DailySuttasTableAnnotationComposer,
    $$DailySuttasTableCreateCompanionBuilder,
    $$DailySuttasTableUpdateCompanionBuilder,
    (DailySutta, BaseReferences<_$AppDatabase, $DailySuttasTable, DailySutta>),
    DailySutta,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TextsTableTableManager get texts =>
      $$TextsTableTableManager(_db, _db.texts);
  $$TranslationsTableTableManager get translations =>
      $$TranslationsTableTableManager(_db, _db.translations);
  $$TranslatorsTableTableManager get translators =>
      $$TranslatorsTableTableManager(_db, _db.translators);
  $$UserBookmarksTableTableManager get userBookmarks =>
      $$UserBookmarksTableTableManager(_db, _db.userBookmarks);
  $$UserHighlightsTableTableManager get userHighlights =>
      $$UserHighlightsTableTableManager(_db, _db.userHighlights);
  $$UserNotesTableTableManager get userNotes =>
      $$UserNotesTableTableManager(_db, _db.userNotes);
  $$UserProgressTableTableManager get userProgress =>
      $$UserProgressTableTableManager(_db, _db.userProgress);
  $$VideoCacheTableTableManager get videoCache =>
      $$VideoCacheTableTableManager(_db, _db.videoCache);
  $$DownloadedPacksTableTableManager get downloadedPacks =>
      $$DownloadedPacksTableTableManager(_db, _db.downloadedPacks);
  $$SearchHistoryTableTableManager get searchHistory =>
      $$SearchHistoryTableTableManager(_db, _db.searchHistory);
  $$DailySuttasTableTableManager get dailySuttas =>
      $$DailySuttasTableTableManager(_db, _db.dailySuttas);
}

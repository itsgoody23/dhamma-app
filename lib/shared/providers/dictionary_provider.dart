import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/daos/dictionary_dao.dart';
import 'database_provider.dart';

final dictionaryDaoProvider = Provider<DictionaryDao>((ref) {
  return ref.watch(appDatabaseProvider).dictionaryDao;
});

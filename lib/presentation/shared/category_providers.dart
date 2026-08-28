import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/data_providers.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/transaction_type.dart';

final categoriesByTypeProvider =
    StreamProvider.family<List<CategoryEntity>, TransactionType>((ref, type) {
  return ref.watch(categoryRepositoryProvider).watchByType(type);
});

final allCategoriesProvider = StreamProvider<List<CategoryEntity>>((ref) {
  return ref.watch(categoryRepositoryProvider).watchAll();
});

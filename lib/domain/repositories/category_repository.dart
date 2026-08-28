import '../entities/category_entity.dart';
import '../entities/transaction_type.dart';

/// Категорию нельзя удалить, пока на неё ссылаются транзакции.
class CategoryInUseException implements Exception {}

abstract class CategoryRepository {
  Stream<List<CategoryEntity>> watchAll();
  Stream<List<CategoryEntity>> watchByType(TransactionType type);

  Future<CategoryEntity> create({
    required String name,
    required String iconKey,
    required int colorValue,
    required TransactionType type,
  });

  Future<void> update(CategoryEntity category);
  Future<void> delete(String id);
}

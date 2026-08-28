import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/data_providers.dart';
import '../../domain/entities/debt_profile_entity.dart';

final allDebtProfilesProvider = StreamProvider<List<DebtProfileEntity>>((ref) {
  return ref.watch(debtProfileRepositoryProvider).watchAll();
});

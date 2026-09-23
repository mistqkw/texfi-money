import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/banks.dart';
import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_page_transitions.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/haptics.dart';
import '../../data/providers/data_providers.dart';
import '../../domain/entities/account_entity.dart';
import '../settings/currency_provider.dart';
import '../shared/bank_mark.dart';
import '../shared/empty_state.dart';
import '../shared/pixel_card.dart';
import '../shared/pixel_fab.dart';
import '../shared/pixel_icon.dart';
import '../shared/pixel_spinner.dart';
import '../shared/staggered_entrance.dart';
import 'account_form_screen.dart';
import 'account_providers.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, AccountEntity account) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.accountsDeleteTitle),
        content: Text(l10n.accountsDeleteConfirm(account.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      Haptics.delete();
      await ref.read(accountRepositoryProvider).delete(account.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(allAccountsProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.accountsTitle)),
      // Пока список пуст, действие предлагает само пустое состояние —
      // плавающая кнопка рядом с ним была бы вторым «плюсом» на экране,
      // делающим ровно то же самое.
      floatingActionButton: (accountsAsync.valueOrNull?.isEmpty ?? true)
          ? null
          : PixelFab(
        onPressed: () {
          Haptics.select();
          Navigator.of(context).push(pixelDissolveRoute(const AccountFormScreen()));
        },
      ),
      body: accountsAsync.when(
        data: (accounts) {
          if (accounts.isEmpty) {
            return EmptyState(
              sprite: PixelIcons.wallet,
              message: l10n.accountsEmpty,
              actionLabel: l10n.accountFormTitleNew,
              onAction: () {
                Haptics.select();
                Navigator.of(context)
                    .push(pixelDissolveRoute(const AccountFormScreen()));
              },
            );
          }
          return ListView.separated(
            padding: AppSpacing.screenWithFab,
            itemCount: accounts.length,
            separatorBuilder: (context, i) => AppSpacing.gapMd,
            itemBuilder: (context, i) {
              final account = accounts[i];
              return StaggeredEntrance(
                index: i,
                child: Dismissible(
                  key: ValueKey(account.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) async {
                    await _confirmDelete(context, ref, account);
                    return false;
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: context.colors.expense.withValues(alpha: 0.15),
                      borderRadius: AppRadius.cardSmallAll,
                    ),
                    child: PixelIcon(PixelIcons.delete, color: context.colors.expense),
                  ),
                  child: _AccountCard(
                    account: account,
                    onTap: () => Navigator.of(context).push(
                      pixelDissolveRoute(AccountFormScreen(existing: account)),
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: PixelSpinner()),
        error: (e, st) => Center(child: Text(l10n.accountsLoadError, style: context.text.body)),
      ),
    );
  }
}

class _AccountCard extends ConsumerWidget {
  const _AccountCard({required this.account, required this.onTap});

  final AccountEntity account;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);
    final balanceAsync = ref.watch(accountBalanceProvider(account.id));

    final bank = BankCatalog.byId(account.bankId);

    return PixelCard(
      label: account.name.toLowerCase(),
      labelColor: account.color,
      onTap: onTap,
      child: Row(
        children: [
          if (bank != null)
            BankMark(bank: bank, size: 36)
          else
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: account.color.withValues(alpha: 0.16),
                shape: BoxShape.circle,
              ),
              child: PixelIcon(PixelIcons.creditCard, color: account.color, size: 18),
            ),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(account.name, style: context.text.title)),
          Text(
            formatAmount(balanceAsync.valueOrNull ?? 0, currency, context),
            style: context.text.amountMedium,
          ),
        ],
      ),
    );
  }
}

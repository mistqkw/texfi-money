import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_page_route.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/haptics.dart';
import '../../data/providers/data_providers.dart';
import '../../domain/entities/account_entity.dart';
import '../settings/currency_provider.dart';
import '../shared/press_scale.dart';
import '../shared/terminal_box.dart';
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
      floatingActionButton: PressScale(
        child: FloatingActionButton(
          onPressed: () {
            Haptics.select();
            Navigator.of(context).push(fadeSlideRoute(const AccountFormScreen()));
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: accountsAsync.when(
        data: (accounts) {
          if (accounts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(l10n.accountsEmpty, style: context.text.body, textAlign: TextAlign.center),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
            itemCount: accounts.length,
            separatorBuilder: (context, i) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final account = accounts[i];
              return Dismissible(
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
                    borderRadius: AppRadius.mediumAll,
                  ),
                  child: Icon(Icons.delete_outline, color: context.colors.expense),
                ),
                child: _AccountCard(
                  account: account,
                  onTap: () => Navigator.of(context).push(
                    fadeSlideRoute(AccountFormScreen(existing: account)),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
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

    return TerminalBox(
      label: account.name.toLowerCase(),
      labelColor: account.color,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: account.color.withValues(alpha: 0.16), shape: BoxShape.circle),
            child: Icon(Icons.credit_card, color: account.color, size: 18),
          ),
          const SizedBox(width: 12),
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

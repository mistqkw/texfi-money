import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_page_route.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/haptics.dart';
import '../../data/providers/data_providers.dart';
import '../../domain/entities/debt_profile_entity.dart';
import '../settings/currency_provider.dart';
import '../shared/press_scale.dart';
import '../shared/terminal_box.dart';
import 'debt_profile_form_screen.dart';
import 'debt_profile_providers.dart';

class DebtProfilesScreen extends ConsumerWidget {
  const DebtProfilesScreen({super.key});

  Future<void> _recordOperation(BuildContext context, WidgetRef ref, DebtProfileEntity profile) async {
    final currency = ref.read(currencyProvider);
    final l10n = context.l10n;
    final controller = TextEditingController();
    final delta = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.profilesRecordTitle(profile.name)),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
          style: context.text.amountLarge,
          decoration: InputDecoration(hintText: '0 ${currency.symbol}'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () {
              final value = double.tryParse(controller.text.replaceAll(',', '.')) ?? 0;
              Navigator.of(context).pop(-value);
            },
            child: Text(l10n.profilesTheyRepaid),
          ),
          TextButton(
            onPressed: () {
              final value = double.tryParse(controller.text.replaceAll(',', '.')) ?? 0;
              Navigator.of(context).pop(value);
            },
            child: Text(l10n.profilesTheyBorrowed),
          ),
        ],
      ),
    );

    if (delta != null && delta != 0) {
      Haptics.success();
      await ref.read(debtProfileRepositoryProvider).adjustBalance(id: profile.id, delta: delta);
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, DebtProfileEntity profile) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.profilesDeleteTitle),
        content: Text(l10n.profilesDeleteConfirm(profile.name)),
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
      await ref.read(debtProfileRepositoryProvider).delete(profile.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesAsync = ref.watch(allDebtProfilesProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profilesTitle)),
      floatingActionButton: PressScale(
        child: FloatingActionButton(
          onPressed: () {
            Haptics.select();
            Navigator.of(context).push(fadeSlideRoute(const DebtProfileFormScreen()));
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: profilesAsync.when(
        data: (profiles) {
          if (profiles.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(l10n.profilesEmpty, style: context.text.body, textAlign: TextAlign.center),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
            itemCount: profiles.length,
            separatorBuilder: (context, i) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final profile = profiles[i];
              return Dismissible(
                key: ValueKey(profile.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) async {
                  await _confirmDelete(context, ref, profile);
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
                child: _ProfileCard(
                  profile: profile,
                  onTap: () => Navigator.of(context).push(
                    fadeSlideRoute(DebtProfileFormScreen(existing: profile)),
                  ),
                  onRecord: () => _recordOperation(context, ref, profile),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(l10n.profilesLoadError, style: context.text.body)),
      ),
    );
  }
}

class _ProfileCard extends ConsumerWidget {
  const _ProfileCard({required this.profile, required this.onTap, required this.onRecord});

  final DebtProfileEntity profile;
  final VoidCallback onTap;
  final VoidCallback onRecord;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);
    final l10n = context.l10n;
    final balanceColor = profile.balance > 0
        ? context.colors.income
        : profile.balance < 0
            ? context.colors.expense
            : context.colors.textSecondary;
    final balanceLabel = profile.balance > 0
        ? l10n.profilesOwesYou(formatAmount(profile.balance, currency, context))
        : profile.balance < 0
            ? l10n.profilesYouOwe(formatAmount(-profile.balance, currency, context))
            : l10n.profilesSettled;

    return TerminalBox(
      label: profile.name.toLowerCase(),
      labelColor: profile.color,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: profile.color.withValues(alpha: 0.16), shape: BoxShape.circle),
            child: Icon(Icons.person_outline, color: profile.color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profile.name, style: context.text.title),
                Text(balanceLabel, style: context.text.caption.copyWith(color: balanceColor)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: context.colors.accent),
            onPressed: onRecord,
          ),
        ],
      ),
    );
  }
}

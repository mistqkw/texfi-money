import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/currencies.dart';
import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_text_styles_ext.dart';
import 'currency_provider.dart';

class CurrencyPickerScreen extends ConsumerWidget {
  const CurrencyPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Валюта')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: AppCurrency.values.length,
        separatorBuilder: (context, i) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final currency = AppCurrency.values[i];
          final selected = currency == current;
          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Text(currency.symbol, style: context.text.title),
            ),
            title: Text(currency.displayName, style: context.text.title),
            subtitle: Text(currency.code, style: context.text.caption),
            trailing: selected ? Icon(Icons.check, color: context.colors.accent) : null,
            onTap: () => ref.read(currencyProvider.notifier).setCurrency(currency),
          );
        },
      ),
    );
  }
}

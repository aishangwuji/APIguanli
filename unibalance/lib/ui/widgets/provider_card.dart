import 'dart:ui';
import 'package:flutter/material.dart';
import '../../models/models.dart';

/// Card widget displaying API provider balance information
class ProviderCard extends StatelessWidget {
  final ApiProvider provider;
  final BalanceInfo? balance;
  final bool isLoading;
  final String? error;
  final VoidCallback? onRefresh;
  final String currency;

  const ProviderCard({
    super.key,
    required this.provider,
    this.balance,
    this.isLoading = false,
    this.error,
    this.onRefresh,
    this.currency = 'USD',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.5),
                width: 1.5,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Colors.white.withValues(alpha: 0.12),
                        Colors.white.withValues(alpha: 0.05),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.7),
                        Colors.white.withValues(alpha: 0.4),
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onRefresh,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.secondary,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                provider.name[0],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  provider.name,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (error != null)
                                  Text(
                                    error!,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.error,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                          if (isLoading)
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.refresh,
                                color: theme.colorScheme.primary,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                      if (balance != null) ...[
                        const SizedBox(height: 20),
                        _GlassBalanceProgress(balance: balance!),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _GlassBalanceItem(
                              label: '已用',
                              value: '$currency ${balance!.used.toStringAsFixed(2)}',
                              theme: theme,
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : Colors.black.withValues(alpha: 0.1),
                            ),
                            _GlassBalanceItem(
                              label: '可用',
                              value: '$currency ${balance!.available.toStringAsFixed(2)}',
                              theme: theme,
                              highlight: true,
                            ),
                            if (balance!.total > 0) ...[
                              Container(
                                width: 1,
                                height: 40,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : Colors.black.withValues(alpha: 0.1),
                              ),
                              _GlassBalanceItem(
                                label: '总额',
                                value: '$currency ${balance!.total.toStringAsFixed(2)}',
                                theme: theme,
                              ),
                            ],
                          ],
                        ),
                      ] else if (!isLoading && error == null) ...[
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            '点击刷新余额',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassBalanceProgress extends StatelessWidget {
  final BalanceInfo balance;

  const _GlassBalanceProgress({required this.balance});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = balance.usagePercentage / 100;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.1),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    colors: percentage > 0.9
                        ? [Colors.red.shade400, Colors.red.shade300]
                        : [theme.colorScheme.primary, theme.colorScheme.secondary],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${(percentage * 100).toStringAsFixed(1)}% 已使用',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _GlassBalanceItem extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;
  final bool highlight;

  const _GlassBalanceItem({
    required this.label,
    required this.value,
    required this.theme,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isDark
                ? Colors.white.withValues(alpha: 0.5)
                : Colors.black.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: highlight
                ? theme.colorScheme.primary
                : (isDark ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'ui/dashboard/dashboard.dart';
import 'ui/widgets/app_lock_screen.dart';
import 'state/settings_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  runApp(
    const ProviderScope(
      child: UniBalanceApp(),
    ),
  );
}

class UniBalanceApp extends ConsumerStatefulWidget {
  const UniBalanceApp({super.key});

  @override
  ConsumerState<UniBalanceApp> createState() => _UniBalanceAppState();
}

class _UniBalanceAppState extends ConsumerState<UniBalanceApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App is going to background - enable lock
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final settings = ref.read(settingsProvider);
        if (settings.biometricEnabled) {
          ref.read(appLockProvider.notifier).state = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    ThemeMode themeMode;
    switch (settings.themeMode) {
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.system;
    }

    return MaterialApp(
      title: 'UniBalance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return supportedLocales.first;
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: const AppLockScreen(
        child: DashboardScreen(),
      ),
    );
  }
}

// main.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for rootBundle
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http; // For simulating network requests
import 'package:shared_preferences/shared_preferences.dart'; // For caching

// --- app_localizations.dart content starts here ---

/// A class that handles loading and providing localized strings.
/// It simulates fetching translations from a backend server and caches them locally.
class AppLocalizations {
  final Locale locale;
  Map<String, String> _localizedStrings = {};

  AppLocalizations(this.locale);

  /// Helper method to find the AppLocalizations instance in the widget tree.
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// The delegate for AppLocalizations. This tells Flutter how to load our custom localizations.
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// Loads the localized strings for the current locale.
  /// It first tries to load from SharedPreferences (cache),
  /// then simulates a network request to fetch the JSON data.
  Future<bool> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? cachedJson = prefs.getString('translations_${locale.languageCode}');

      if (cachedJson != null) {
        // Load from cache if available
        Map<String, dynamic> jsonMap = json.decode(cachedJson);
        _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
        debugPrint('Loaded translations from cache for ${locale.languageCode}');
        return true;
      }

      // Simulate network request to fetch translations
      // In a real application, replace this with an actual http.get or http.post call
      // to your backend API endpoint.
      debugPrint('Fetching translations from simulated server for ${locale.languageCode}...');
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay

      String jsonString;
      if (locale.languageCode == 'ru') {
        jsonString = '''
        {
          "app_title": "Серверная локализация",
          "hello_world": "Привет, мир!",
          "welcome_message": "Добро пожаловать, {name}!",
          "current_language": "Текущий язык: Русский",
          "switch_to_english": "Переключиться на английский",
          "switch_to_russian": "Переключиться на русский"
        }
        ''';
      } else {
        // Default to English if 'eng' or any other unsupported code
        jsonString = '''
        {
          "app_title": "Server Localization",
          "hello_world": "Hello World!",
          "welcome_message": "Welcome, {name}!",
          "current_language": "Current Language: English",
          "switch_to_english": "Switch to English",
          "switch_to_russian": "Switch to Russian"
        }
        ''';
      }

      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));

      // Cache the fetched translations
      await prefs.setString('translations_${locale.languageCode}', jsonString);
      debugPrint('Fetched and cached translations for ${locale.languageCode}');
      return true;
    } catch (e) {
      debugPrint('Error loading translations for ${locale.languageCode}: $e');
      // In a real app, you might want to load a default bundled translation here
      // or show an error message.
      return false;
    }
  }

  /// Retrieves the localized string for a given key.
  /// Supports simple argument replacement using `{argName}` syntax.
  String translate(String key, {Map<String, dynamic>? args}) {
    String? translated = _localizedStrings[key];
    if (translated == null) {
      debugPrint('Missing translation for key: $key in ${locale.languageCode}');
      return key; // Fallback to the key itself if translation is missing
    }

    if (args != null) {
      args.forEach((argKey, argValue) {
        translated = translated!.replaceAll('{$argKey}', argValue.toString());
      });
    }
    return translated!;
  }
}

/// A custom LocalizationsDelegate for AppLocalizations.
/// This delegate is responsible for creating and loading instances of AppLocalizations.
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  /// Checks if the given locale is supported by our application.
  @override
  bool isSupported(Locale locale) {
    // Only 'eng' and 'ru' are explicitly supported in this example.
    return ['en', 'ru'].contains(locale.languageCode);
  }

  /// Loads the AppLocalizations for the given locale.
  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load(); // Perform the actual loading (from server/cache)
    return localizations;
  }

  /// Determines if the delegate should reload its localizations.
  /// Setting to false means localizations are loaded once per locale.
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// --- main.dart content starts here ---

void main() async {
  // Ensure Flutter widgets binding is initialized before running the app,
  // especially if you need to access platform services like SharedPreferences.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

/// The root widget of the application.
/// It's a StatefulWidget to allow dynamic locale changes.
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  /// Helper to access the MyAppState from anywhere in the widget tree.
  static _MyAppState of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale; // The currently selected locale

  /// Sets the new locale and triggers a rebuild of the app.
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Server Localization',
      // Set the current locale. If null, it will be determined by localeResolutionCallback.
      locale: _locale,
      // Define the locales your app explicitly supports.
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('ru', ''), // Russian
      ],
      // Delegates responsible for providing localized resources.
      localizationsDelegates: const [
        AppLocalizations.delegate, // Our custom delegate for server-side translations
        GlobalMaterialLocalizations.delegate, // Material Design widgets localizations
        GlobalWidgetsLocalizations.delegate, // Basic widgets localizations
        GlobalCupertinoLocalizations.delegate, // Cupertino widgets localizations
      ],
      // Callback to resolve the app's locale based on device preferences and supported locales.
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale != null) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
        }
        // If the device locale is not supported, fall back to the first supported locale (English in this case).
        return supportedLocales.first;
      },
      home: MyHomePage(),
    );
  }
}

/// The main screen of the application, demonstrating localized text.
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the AppLocalizations instance for the current context.
    // It might be null initially while loading, so handle that case.
    final AppLocalizations? localizations = AppLocalizations.of(context);

    // Show a loading indicator if localizations are not yet available.
    if (localizations == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Retrieve translated strings
    final String appTitle = localizations.translate('app_title');
    final String helloMessage = localizations.translate('hello_world');
    final String welcomeMessage = localizations.translate(
      'welcome_message',
      args: {'name': 'User'}, // Example argument
    );
    final String currentLanguage = localizations.translate('current_language');
    final String switchToEnglish = localizations.translate('switch_to_english');
    final String switchToRussian = localizations.translate('switch_to_russian');

    return Scaffold(
      appBar: AppBar(title: Text(appTitle), backgroundColor: Colors.blueAccent),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Display localized messages
            Text(
              helloMessage,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(welcomeMessage, style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
            const SizedBox(height: 32),
            Text(
              currentLanguage,
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Buttons to switch languages
            ElevatedButton(
              onPressed: () {
                // Call the setLocale method from MyAppState to change the language
                MyApp.of(context).setLocale(const Locale('eng', ''));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(switchToEnglish, style: const TextStyle(fontSize: 16, color: Colors.white)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Call the setLocale method from MyAppState to change the language
                MyApp.of(context).setLocale(const Locale('ru', ''));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(switchToRussian, style: const TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

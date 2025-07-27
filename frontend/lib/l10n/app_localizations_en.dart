// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get connectionStatusConnecting => 'connecting...';

  @override
  String get connectionStatusServerNotAvailable => 'server not available';

  @override
  String get connectionStatusWaitingToRetry => 'waiting to retry';

  @override
  String get connectionStatusConnected => 'connected';

  @override
  String get connectionStatusFailed => 'failed';

  @override
  String get connectionStatusNoInternet => 'no internet';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get connectionStatusConnecting => 'подключение...';

  @override
  String get connectionStatusServerNotAvailable => 'сервер недоступен';

  @override
  String get connectionStatusWaitingToRetry => 'ожидание повторной попытки';

  @override
  String get connectionStatusConnected => 'подключено';

  @override
  String get connectionStatusFailed => 'ошибка';

  @override
  String get connectionStatusNoInternet => 'нет интернета';
}

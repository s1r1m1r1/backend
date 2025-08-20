import 'package:injectable/injectable.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

abstract class MailingService {
  Future<void> sendConfirmationEmail(String email, String confirmationToken);
}

@LazySingleton(as: MailingService)
class MailingServiceImpl extends MailingService {
  @override
  Future<void> sendConfirmationEmail(
    String email,
    String confirmationToken,
  ) async {
    final smpName = 'smtp.mail.ru';
    const smtpMail = 'devplaygame@mail.ru';
    const password = 'shRXEKLwjhQTkSSM6Fpc';
    final smtpServer = SmtpServer(
      port: 465,
      ssl: true,
      smpName,
      username: smtpMail,
      password: password,
    );

    // Create our message.
    final host = 'http://localhost:8080';

    final message = Message()
      ..from = Address(smtpMail, 'IGAME')
      ..recipients.add(email)
      ..subject = 'Confirm your email for I/GAME'
      ..text =
          'Hey! Here is your confirmation link: $host/users/confirm-email?token=$confirmationToken'
      ..html =
          "<h1>Confirm your email for I/GAME</h1><p>Hey! Here is your confirmation link: <a href=\"$host/users/confirm-email?token=$confirmationToken\">Confirm Email</a></p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      rethrow;
    }
  }
}

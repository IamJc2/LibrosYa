package Mail;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class MailUtil {

    // Método para enviar el correo de verificación
    public static void sendVerificationEmail(String to, String verificationLink, String smtpHost, String smtpPort, String smtpUser, String smtpPassword) {
        final String from = smtpUser;

        Properties properties = new Properties();
        properties.put("mail.smtp.host", smtpHost);
        properties.put("mail.smtp.port", smtpPort);
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(smtpUser, smtpPassword);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
            message.setSubject("Verificación de Email");
            message.setText("Por favor, verifica tu correo electrónico haciendo clic en el siguiente enlace: " + verificationLink);

            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    // Método para enviar el correo de recuperación de contraseña
    public static void sendResetPasswordEmail(String recipientEmail, String resetLink, String smtpHost, String smtpPort, String smtpUser, String smtpPassword) {
        final String from = smtpUser;

        Properties properties = new Properties();
        properties.put("mail.smtp.host", smtpHost);
        properties.put("mail.smtp.port", smtpPort);
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(smtpUser, smtpPassword);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(recipientEmail));
            message.setSubject("Recuperación de Contraseña");
            message.setText("Para restablecer tu contraseña, haz clic en el siguiente enlace: " + resetLink);

            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
    // metodogmail
    public static void sendEmail(String to, String subject, String body, String smtpHost, String smtpPort, String smtpUser, String smtpPassword) {
        final String from = smtpUser;

        Properties properties = new Properties();
        properties.put("mail.smtp.host", smtpHost);
        properties.put("mail.smtp.port", smtpPort);
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(smtpUser, smtpPassword);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
            message.setSubject(subject);
            message.setText(body);

            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}

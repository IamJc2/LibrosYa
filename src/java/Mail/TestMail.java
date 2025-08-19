package Mail;



public class TestMail {
    public static void main(String[] args) {
        String to = "reyes.luisito2002@gmail.com";
        String verificationLink = "http://localhost:8080/tu-app/verifyEmail.jsp?code=testcode";
        String smtpHost = "smtp.gmail.com";
        String smtpPort = "587";
        String smtpUser = "reyes.luisito2002@gmail.com";
        String smtpPassword = "uhnv cbkm gcoq jmqz";

        MailUtil.sendVerificationEmail(to, verificationLink, smtpHost, smtpPort, smtpUser, smtpPassword);
    }
}

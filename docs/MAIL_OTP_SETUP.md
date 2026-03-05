# Fix: Verification OTP email not sending

The 6-digit verification code is sent by email using **Brevo (SMTP)**. If no email arrives, the server is not configured to send mail.

---

## 1. Configure mail in `.env` (Hostinger: `public_html/bulodph-backend/.env`)

Add or set these (use your real Brevo values):

```env
MAIL_MAILER=smtp
MAIL_HOST=smtp-relay.brevo.com
MAIL_PORT=587
MAIL_USERNAME=your-brevo-login-email@example.com
MAIL_PASSWORD=your-brevo-smtp-key
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS="noreply@bulodph.com"
MAIL_FROM_NAME="BulodPH"
```

- **MAIL_MAILER** must be `smtp`. If missing or `log`, emails are only written to the log and never sent.
- **MAIL_USERNAME** = the email you use to log in to Brevo (or the verified sender email).
- **MAIL_PASSWORD** = Brevo **SMTP key** (not the API key). Get it in Brevo: **SMTP & API** → **SMTP** → create or copy the key.
- **MAIL_FROM_ADDRESS** = must be a **verified sender** in Brevo (e.g. noreply@bulodph.com or your domain). Verify it in Brevo under **Senders & IP**.

---

## 2. Get Brevo SMTP credentials

1. Sign up or log in at [brevo.com](https://www.brevo.com).
2. Go to **Settings** → **SMTP & API** → **SMTP**.
3. Copy the **SMTP server** (smtp-relay.brevo.com), **port** (587), and create/copy the **SMTP key** (password).
4. Use your Brevo login email as **MAIL_USERNAME** and the SMTP key as **MAIL_PASSWORD**.
5. In **Senders & IP**, add and verify the **From** address you put in **MAIL_FROM_ADDRESS** (e.g. noreply@bulodph.com).

---

## 3. After changing `.env`

- No need to restart PHP on Hostinger; the next request will use the new values.
- Try “Send code” again. If it still fails, the API will return a 500 response with a message; with **APP_DEBUG=true** the response includes the exact error (then set **APP_DEBUG=false** again).
- Check **public_html/bulodph-backend/storage/logs/laravel.log** for `Mail send failed` and the exception message.

---

## 4. If you don’t want to use Brevo

You can use another SMTP provider (Gmail, SendGrid, etc.). Set **MAIL_HOST**, **MAIL_PORT**, **MAIL_USERNAME**, **MAIL_PASSWORD**, and **MAIL_ENCRYPTION** to that provider’s values. Keep **MAIL_MAILER=smtp**.

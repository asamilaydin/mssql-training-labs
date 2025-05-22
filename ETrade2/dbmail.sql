-- ======================================================
-- SQL SERVER - DATABASE MAIL YAPILANDIRMA AÇIKLAMA VE ÖRNEK
-- Bu script ile SQL Server'da e-posta gönderimi için Database Mail yapılandırılır.
-- Bu yapı genelde job uyarıları, hata bildirimleri ve backup bilgilendirmeleri için kullanılır.
-- ======================================================

-- 1. Database Mail özelliğini etkinleştir
-- Bu özellik kapalıysa, önce aktif hale getirilmelidir.
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

EXEC sp_configure 'Database Mail XPs', 1;
RECONFIGURE;

-- 2. E-posta göndermek için bir hesap oluştur
-- SMTP sunucusu ve kullanıcı bilgileri burada girilir.
EXEC msdb.dbo.sysmail_add_account_sp
    @account_name = 'MailHesabi',  -- Hesap adı (iç kullanım için)
    @description = 'SMTP mail hesabı',
    @email_address = 'youremail@domain.com', -- Gönderici e-posta adresi
    @display_name = 'SQL Server Mail',
    @mailserver_name = 'smtp.yourserver.com', -- SMTP sunucu adresi
    @port = 587,  -- SMTP portu (genellikle 587 veya 25)
    @enable_ssl = 1, -- SSL kullanılacaksa 1
    @username = 'youremail@domain.com', -- SMTP kullanıcı adı
    @password = 'YourSecurePassword'; -- SMTP şifresi

-- 3. Mail profili oluştur
-- Mail profili, birden fazla hesabı bir araya getirmek için kullanılır.
EXEC msdb.dbo.sysmail_add_profile_sp
    @profile_name = 'MailProfili',
    @description = 'SQL Server e-posta gönderim profili';

-- 4. Hesabı, oluşturulan profile bağla
EXEC msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = 'MailProfili',
    @account_name = 'MailHesabi',
    @sequence_number = 1;

-- 5. Profilin kullanıcılar (örneğin: msdb kullanıcıları) tarafından kullanılmasına izin ver
-- Bu adım, SQL Agent gibi bileşenlerin bu profili kullanabilmesini sağlar.
EXEC msdb.dbo.sysmail_add_principalprofile_sp
    @profile_name = 'MailProfili',
    @principal_name = 'public',
    @is_default = 1;

-- 6. Test maili gönder (opsiyonel)
-- Bu komut ile yapılandırmanın doğru çalışıp çalışmadığını test edebilirsin.
EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'MailProfili',
    @recipients = 'test@domain.com',
    @subject = 'Test Maili',
    @body = 'SQL Server üzerinden gönderilen test e-postası.';

-- NOTLAR:
-- - Yukarıdaki SMTP bilgilerini kendi e-posta sağlayıcına göre değiştirmen gerekir.
-- - Database Mail arayüzü üzerinden de aynı işlemler yapılabilir (SSMS -> Object Explorer -> Management -> Database Mail).
-- - Gönderimlerde hata alırsan, Database Mail loglarını kontrol edebilirsin:
--   msdb.dbo.sysmail_event_log veya sysmail_faileditems gibi görünümler kullanılabilir.

-- ========================================================
-- SQL SERVER AGENT NEDİR ve NE İŞE YARAR?
-- Bu doküman, SQL Server Agent ile ilgili temel bilgileri
-- ve kullanım senaryolarını açıklamak için hazırlanmıştır.
-- ========================================================

-- SQL Server Agent, SQL Server ile birlikte gelen bir servis olup;
-- zamanlanmış görevleri (Jobs), uyarıları (Alerts) ve operatörleri (Operators)
-- yönetmek için kullanılır.

-- SQL Server Agent’ın başlıca kullanım alanları:
-- 1. Yedekleme işlemlerini otomatikleştirme
-- 2. Belirli aralıklarla çalışan veri temizleme işlemleri (maintenance)
-- 3. Rapor oluşturma veya mail gönderme görevleri
-- 4. Hata durumlarında yöneticilere e-posta uyarısı gönderme
-- 5. T-SQL veya SSIS paketlerinin zamanlanması

-- --------------------------------------------------------
-- SQL SERVER AGENT NASIL ETKİNLEŞTİRİLİR?
-- --------------------------------------------------------

-- SSMS (SQL Server Management Studio) üzerinden:
-- Object Explorer > SQL Server Agent > Sağ tık > Start ile başlatılır.

-- Eğer SQL Server Agent görünmüyorsa:
-- SQL Server Express sürümünde Agent servisi yoktur.
-- Enterprise, Standard, Developer gibi sürümler gereklidir.

-- --------------------------------------------------------
-- JOB (GÖREV) OLUŞTURMA
-- --------------------------------------------------------

-- SQL Server Agent içindeki “Jobs” bölümü, planlı görevlerin tanımlandığı alandır.

-- ÖRNEK: Her gün gece 02:00’de yedek alma job’ı tanımlama adımları
-- (GUI ile: SQL Server Agent > Jobs > New Job...)

-- Script ile örnek job oluşturma:

USE msdb;
GO

-- 1. Yeni job oluştur
EXEC sp_add_job
    @job_name = N'GunlukYedeklemeJobu',
    @enabled = 1,
    @description = N'Bu job her gece 02:00’de günlük yedek alır.',
    @start_step_id = 1;

-- 2. Job adımını tanımla (örneğin bir yedekleme işlemi)
EXEC sp_add_jobstep
    @job_name = N'GunlukYedeklemeJobu',
    @step_name = N'Full Backup Step',
    @subsystem = N'TSQL',
    @command = N'BACKUP DATABASE Etrade TO DISK = ''C:\Backup\Etrade_Full.bak'' WITH INIT;',
    @retry_attempts = 1,
    @retry_interval = 5;

-- 3. Zamanlama oluştur (her gün 02:00)
EXEC sp_add_schedule
    @schedule_name = N'GunlukSaat02',
    @freq_type = 4, -- Günlük
    @freq_interval = 1,
    @active_start_time = 020000; -- 02:00:00

-- 4. Job ile zamanlamayı ilişkilendir
EXEC sp_attach_schedule
    @job_name = N'GunlukYedeklemeJobu',
    @schedule_name = N'GunlukSaat02';

-- 5. Job’u Agent’a atamak
EXEC sp_add_jobserver
    @job_name = N'GunlukYedeklemeJobu',
    @server_name = @@SERVERNAME;

-- --------------------------------------------------------
-- SQL SERVER AGENT UYARILARI (ALERTS)
-- --------------------------------------------------------

-- SQL Server Agent, belirli hata durumlarında (örneğin disk dolu, login hatası gibi)
-- uyarılar tanımlanmasına ve operatörlere e-posta gönderilmesine olanak sağlar.

-- Operatör: Mail alacak kişi/rol.
-- Alert: Belirli bir hata koduna tepki veren yapı.

-- Örnek:
-- SQL Server Error 823 (Disk hatası) oluştuğunda mail gönder.

-- 1. Operatör oluştur
EXEC msdb.dbo.sp_add_operator
    @name = N'DBAOperator',
    @email_address = N'dba@domain.com';

-- 2. Alert oluştur
EXEC msdb.dbo.sp_add_alert
    @name = N'DiskHatasiUyarisi',
    @message_id = 823, -- SQL error ID
    @severity = 0,
    @notification_message = N'Disk hatası meydana geldi.',
    @include_event_description_in = 1,
    @job_id = NULL;

-- 3. Uyarı ile operatörü ilişkilendir
EXEC msdb.dbo.sp_add_notification
    @alert_name = N'DiskHatasiUyarisi',
    @operator_name = N'DBAOperator',
    @notification_method = 1; -- 1 = Mail

-- --------------------------------------------------------
-- LOG VE DURUM KONTROLLERİ
-- --------------------------------------------------------

-- Agent job geçmişini görüntülemek için:
-- SSMS > SQL Server Agent > Jobs > Job'a sağ tık > View History
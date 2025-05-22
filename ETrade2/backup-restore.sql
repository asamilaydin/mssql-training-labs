--  Etrade veritabanının tam (full) yedeğini alır
-- Bu yedek, diğer yedek türlerinin temelini oluşturur
BACKUP DATABASE Etrade
TO DISK = 'C:\Backups\Etrade_FULL.bak'
WITH 
    FORMAT,                     -- Yeni bir yedek dosyası oluşturur
    INIT,                       -- Mevcut dosya üzerine yazar
    NAME = 'Etrade Full Backup',
    STATS = 10;                 -- %10 ilerlemeleri gösterir

 --  Etrade veritabanı için fark (differential) yedeği alır
-- Bu yedek sadece full backup'tan sonra değişen verileri içerir
BACKUP DATABASE Etrade2
TO DISK = 'C:\Backups\Etrade2_DIFF.bak'
WITH 
    DIFFERENTIAL,              -- Fark yedeği alınmasını sağlar
    INIT,                      -- Üzerine yaz
    NAME = 'Etrade Differential Backup',
    STATS = 10;
-- Etrade veritabanı için transaction log (günlük) yedeği alır
-- Bu yedek sayesinde belirli bir saate kadar geri dönüş yapılabilir
BACKUP LOG Etrade2
TO DISK = 'C:\Backups\Etrade_LOG.trn'
WITH 
    INIT,                      -- Mevcut dosyanın üzerine yazar
    NAME = 'Etrade Transaction Log Backup',
    STATS = 10;

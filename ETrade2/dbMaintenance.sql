-- ========================================================
--          SQL SERVER DATABASE MAINTENANCE PLANS
--              (VERİTABANI BAKIM PLANLARI)
-- ========================================================
-- Bu açıklamalar, SQL Server'da kullanılan bakım planlarının
-- ne işe yaradığını, hangi durumlarda kullanıldığını ve
-- ne zaman tercih edilmesi gerektiğini öğretici şekilde
-- hatırlatmak amacıyla hazırlanmıştır.
-- ========================================================

-- BAKIM PLANLARI NEDİR?
-- ----------------------
-- SQL Server'da veritabanının sağlıklı çalışması için düzenli olarak 
-- yapılması gereken bazı işlemler vardır (yedekleme, indeks bakımı, log küçültme vb.).
-- Bu işlemleri elle yapmak yerine, SQL Server Management Studio (SSMS) üzerinden
-- zamanlayarak otomatik hale getirebiliriz. Bu planlara "Maintenance Plans" denir.

-- Maintenance Plan'lar SQL Server Agent ile birlikte çalışır.

-- --------------------------------------------------------
-- 1. CHECK DATABASE INTEGRITY (Veritabanı Bütünlüğü Kontrolü)
-- --------------------------------------------------------
-- Ne yapar? => DBCC CHECKDB komutu çalıştırılır. 
-- Amaç: Veritabanı içindeki veri yapılarının bozulup bozulmadığını kontrol eder.
-- Ne zaman? => Haftalık veya aylık önerilir.
-- Hangi şartlarda? => Özellikle sistem çökmeleri sonrası mutlaka çalıştırılmalı.
-- Uyarı: Bu işlem I/O yoğunlukludur, gece saatlerinde yapılmalıdır.

-- --------------------------------------------------------
-- 2. REBUILD INDEX (İndeksleri Yeniden Oluşturma)
-- --------------------------------------------------------
-- Ne yapar? => Parçalanmış (fragmented) indeksleri tamamen yeniden oluşturur.
-- Amaç: Sorgu performansını artırmak ve disk erişimini iyileştirmek.
-- Ne zaman? => Haftalık önerilir.
-- Hangi şartlarda? => Büyük veri girişi/silme sonrası.
-- Uyarı: Bu işlem indeksin tamamen silinip yeniden oluşturulmasıdır, transaction log büyür.

-- --------------------------------------------------------
-- 3. REORGANIZE INDEX (İndeksleri Yeniden Düzenleme)
-- --------------------------------------------------------
-- Ne yapar? => Hafif parçalanmış indeksleri defragment eder (yeniden düzenler).
-- Amaç: Daha az kaynakla parçalanmayı azaltmak.
-- Ne zaman? => Günlük ya da haftada birkaç kez.
-- Hangi şartlarda? => %5 - %30 arası parçalanma varsa.
-- Not: Rebuild kadar yoğun değildir, ancak daha az etkilidir.

-- --------------------------------------------------------
-- 4. UPDATE STATISTICS (İstatistikleri Güncelleme)
-- --------------------------------------------------------
-- Ne yapar? => SQL Server'ın sorgu optimizasyonu için kullandığı istatistikleri günceller.
-- Amaç: Sorguların en verimli şekilde planlanmasını sağlamak.
-- Ne zaman? => Günlük önerilir (yoğun veri değişimi varsa).
-- Hangi şartlarda? => Verilerde sürekli değişiklik varsa.
-- Uyarı: Otomatik istatistik güncelleme açıksa bile bu işlem daha kontrollüdür.

-- --------------------------------------------------------
-- 5. BACKUP DATABASE (Veritabanı Yedeği Alma)
-- --------------------------------------------------------
-- Ne yapar? => Full, Differential veya Transaction Log yedeklerini alır.
-- Amaç: Veri kaybını önlemek.
-- Ne zaman? => Full backup günlük/haftalık, Differential birkaç saatte bir, Log her 10-15 dk.
-- Hangi şartlarda? => Kritik veritabanlarında periyodik olarak yapılmalıdır.
-- Not: Backup türü ihtiyaca göre belirlenmeli. (Full + Log veya Full + Differential + Log)

-- --------------------------------------------------------
-- 6. CLEAN UP HISTORY (Geçmiş Verileri Temizleme)
-- --------------------------------------------------------
-- Ne yapar? => Maintenance plan geçmiş kayıtlarını temizler.
-- Amaç: msdb veritabanının gereksiz büyümesini engellemek.
-- Ne zaman? => Haftalık önerilir.
-- Hangi şartlarda? => Plan geçmişi yıllara yayılmışsa temizlenmeli.
-- Not: History temizleme işlemi job'ların ve maintenance geçmişinin loglarını siler.

-- --------------------------------------------------------
-- 7. EXECUTE SQL SERVER AGENT JOBS (Job Çalıştırma)
-- --------------------------------------------------------
-- Ne yapar? => Belirli bir SQL Agent Job’unu bu plan içinde çalıştırır.
-- Amaç: Plan içinden job tetiklemek.
-- Ne zaman? => Örneğin, önce backup al sonra özel bir job çalıştır gibi senaryolarda.
-- Hangi şartlarda? => Planlama esnekliği için kullanılır.

-- --------------------------------------------------------
-- 8. SHRINK DATABASE (Veritabanı Küçültme)
-- --------------------------------------------------------
-- Ne yapar? => Boş alanları geri kazanmak için veritabanı dosya boyutlarını küçültür.
-- Amaç: Disk alanı kazanımı.
-- Ne zaman? => Sadece istisnai durumlarda önerilir.
-- Hangi şartlarda? => Büyük veri silme sonrası, acil disk problemi varsa.
-- Uyarı: Fragmentation’a sebep olur, sık kullanılmaz.

-- --------------------------------------------------------
-- 9. MAINTENANCE CLEANUP TASK (Yedek Temizleme)
-- --------------------------------------------------------
-- Ne yapar? => Eski yedek dosyalarını (.bak, .trn vb.) siler.
-- Amaç: Disk dolmasını engellemek.
-- Ne zaman? => Günlük veya haftalık yapılabilir.
-- Hangi şartlarda? => Belirli bir süre (örneğin 7 gün) öncesindeki yedekler gereksizse.
-- Not: Dosya tipi ve klasör dikkatlice tanımlanmalıdır.

-- ========================================================
-- GENEL ÖNERİLER:
-- - Bakım planları gece saatlerinde çalıştırılmalıdır.
-- - Planlar küçük görevlere bölünmeli, tek büyük plan yapılmamalıdır.
-- - İndeks Rebuild ve Update Statistics çakışmamalı.
-- - Log'lar temizlenmezse msdb büyür, Clean Up History yapılmalı.
-- - Maintenance Plan raporları kontrol edilmeli, Agent log izlenmeli.
-- ========================================================

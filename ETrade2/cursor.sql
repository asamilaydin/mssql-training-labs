-- ================================================
--               SQL SERVER CURSOR NEDİR?
-- ================================================

-- CURSOR (KÜRSÖR) SQL Server'da, satır satır veri üzerinde işlem 
-- yapmamıza olanak sağlayan özel bir kontrol yapısıdır.

-- Normalde SQL sorguları set tabanlı çalışır, yani tüm verileri birden işler.
-- Ancak bazı özel durumlarda, her satıra tek tek erişip işlem yapmamız gerekebilir.
-- İşte bu noktada **CURSOR** kullanılır.

-- ================================================
--          CURSOR'IN KULLANILDIĞI DURUMLAR
-- ================================================

-- 1. Her satırda özel işlem yapılacaksa (örneğin: her müşteri için özel e-posta gönderimi)
-- 2. Her kayıtta şartlara göre farklı işlemler yapılacaksa
-- 3. Bazı işlemler döngüsel mantık gerektiriyorsa
-- 4. Trigger veya prosedürde satır satır kontrol gerekiyorsa

-- Not: Performans açısından cursorlar pahalıdır. Gereksizse set tabanlı çözümler tercih edilmelidir.

-- ================================================
--                CURSOR AŞAMALARI
-- ================================================

-- 1. DECLARE CURSOR → Cursor tanımlanır (hangi sorgudan veri çekeceği belirlenir)
-- 2. OPEN CURSOR   → Cursor çalıştırılır ve veri erişime açılır
-- 3. FETCH NEXT    → Cursor ile sıradaki satır okunur
-- 4. WHILE...      → FETCH sonucu başarılı olduğu sürece döngü devam eder
-- 5. CLOSE CURSOR  → Cursor kapatılır
-- 6. DEALLOCATE    → Cursor bellekten temizlenir

-- ================================================
--            BASİT CURSOR ÖRNEĞİ
-- ================================================

-- Aşağıda basit bir cursor örneği verilmiştir:
-- Her ürün adını tek tek okuyup mesaj olarak yazdırır

DECLARE @ProductName NVARCHAR(100);

-- Cursor'ı tanımlıyoruz (Product tablosundan veri çekecek)
DECLARE ProductCursor CURSOR FOR
SELECT Name FROM Products;

-- Cursor'ı açıyoruz
OPEN ProductCursor;

-- İlk veriyi çekiyoruz
FETCH NEXT FROM ProductCursor INTO @ProductName;

-- FETCH başarılı olduğu sürece döngü çalışır
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Burada işlem yapılır (örnek olarak PRINT kullandık)
    PRINT 'Ürün Adı: ' + @ProductName;

    -- Sonraki veriyi alıyoruz
    FETCH NEXT FROM ProductCursor INTO @ProductName;
END

-- Cursor'ı kapatıyoruz
CLOSE ProductCursor;

-- Cursor'ı bellekten siliyoruz
DEALLOCATE ProductCursor;

-- ================================================
--          PERFORMANS NOTLARI VE UYARILAR
-- ================================================

-- - Cursorlar performans açısından maliyetlidir, mümkünse alternatif çözümler (JOIN, CTE, ROW_NUMBER) düşünülmelidir.
-- - Büyük veri setlerinde cursor kullanımı sistem kaynaklarını tüketebilir.
-- - READ_ONLY veya FORWARD_ONLY cursorlar daha az kaynak tüketir.
-- - FETCH işlemi her satırda işlem yapacağı için transaction log büyüyebilir.

-- ================================================
--      CURSOR TİPLERİ (KISA HATIRLATMA)
-- ================================================

-- STATIC: Snapshot alır, değişiklikleri göstermez (performansı daha iyidir)
-- DYNAMIC: Veritabanındaki değişiklikleri anlık olarak yansıtır
-- FAST_FORWARD: Sadece ileri doğru giden, performanslı cursor
-- KEYSET: Anahtar kolonlarla çalışır, orta seviyede performans sağlar

-- ================================================
--     NE ZAMAN KULLANILMALI / KULLANILMAMALI?
-- ================================================

-- Kullanılmalı:
-- - Her satıra özgü işlem varsa (mail atma, özel hesaplama, güncelleme)
-- - Sorgu ile yapılamayacak karmaşık kontroller varsa

-- Kullanılmamalı:
-- - Tüm işlemler SELECT, UPDATE, JOIN gibi işlemlerle topluca yapılabiliyorsa
-- - Büyük veri setlerinde set-based yaklaşım tercih edilmeli

-- ================================================
--          EKSTRA: CURSOR ALTERNATİFLERİ
-- ================================================

-- - WHILE döngüsü + Temp Table
-- - CTE (Common Table Expression)
-- - MERGE ifadesi (koşullu insert/update)
-- - CROSS APPLY / OUTER APPLY

-- ================================================
-- BU YAPININ SQL AGENT JOB’DA KULLANIMI:
-- ================================================
-- Cursor içeren işlemler bir stored procedure olarak yazılıp,
-- SQL Server Agent Job aracılığıyla zamanlanarak çalıştırılabilir.

-- Örnek: Her gece 01:00'de müşterilere özel kampanya maili hazırlama

-- ================================================

use ETRADE2
SELECT * FROM CUSTOMERS WHERE CITY = 'Ankara';

CREATE INDEX IX_CUSTOMERS_CITY
ON CUSTOMERS (CITY);

--EŞSİZ FISCHENO TEKRAR ETMEYEN SÜTUNLARDA 
CREATE UNIQUE INDEX IX_ITEM_ID
ON ITEMS (ID);

SELECT *FROM ITEMS
--BİRLEŞİK İNDEX
CREATE INDEX IX_CUSTOMERS_CITY_DISTRICT ON SALES(CITY, DISTRICT);

SELECT CUSTOMERNAME,CITY, DISTRICT
FROM SALES
WHERE CITY = 'Ankara' AND DISTRICT = 'Çankaya';

-- =============================================
-- 📌 INDEX FRAGMENTATION (İndeks Bozulmaları)
-- =============================================

-- 🔹 Zamanla tabloya eklenen/silinen/güncellenen veriler, index yapısında parçalanmalara (fragmentation) neden olabilir.
-- 🔹 Bu da sorgu performansını düşürür çünkü SQL Server sayfa sayfa tarama yaparken veriye dağınık erişir.
-- 🔹 Özellikle büyük tablolar ve sık kullanılan index’lerde takip edilmelidir.

-- 🔍 Durumu görmek için (SQL Server Management Studio veya sorguyla):
-- SELECT * FROM sys.dm_db_index_physical_stats (...)

-- 🔄 Bozulmuş index’leri yeniden düzenlemek için:
-- ALTER INDEX IX_INDEXNAME ON dbo.TableName REORGANIZE; -- %10-30 bozulma için
-- ALTER INDEX IX_INDEXNAME ON dbo.TableName REBUILD;    -- %30+ bozulma için

-------------------------------------------------------

-- =============================================
-- 📌 INCLUDE COLUMNS (Kapsayıcı Kolonlar)
-- =============================================

-- 🔹 Index içinde arama yapılmayan ama SELECT ifadesinde dönen kolonları ekleyerek, sadece index'ten veri alınmasını sağlarız.
-- 🔹 Böylece SQL Server ana tabloya dönmeden (bookmark lookup yapmadan) tüm veriyi index üzerinden getirir.

-- 🔍 Örnek:
-- CREATE NONCLUSTERED INDEX IX_CUSTOMERS_CITY_DISTRICT 
-- ON CUSTOMERS(CITY, DISTRICT) 
-- INCLUDE (CUSTOMERNAME, TEL);

-- ✅ SELECT CUSTOMERNAME, TEL WHERE CITY='...' AND DISTRICT='...' gibi sorgular index'ten tam karşılanır.
-- ❗ Sadece arama kolonları değil, döndürülen kolonlar da optimize edilmek isteniyorsa INCLUDE kullanılır.

-------------------------------------------------------

-- =============================================
-- 📌 STATISTICS (İstatistikler)
-- =============================================

-- 🔹 SQL Server, hangi index’in nasıl kullanılacağını belirlerken istatistikleri baz alır.
-- 🔹 Bu istatistikler tablo içerisindeki veri dağılımını temsil eder ve sorgu planı oluştururken kullanılır.
-- 🔹 Ancak zamanla veri değiştikçe güncel kalmazsa, yanlış sorgu planları seçilir.

-- 🔄 Manuel istatistik güncelleme:
-- UPDATE STATISTICS TableName;
-- veya tüm veritabanı için:
-- EXEC sp_updatestats;

-- ⚠️ Otomatik istatistik güncelleme açık olsa da (genelde öyledir), yoğun veri değişikliği sonrası manuel güncelleme tavsiye edilir.

-------------------------------------------------------

-- 💡 NOT:
-- ▪ İndekslerin çok fazla olması güncellemeleri yavaşlatır.
-- ▪ Az olması sorguları yavaşlatır.
-- ▪ Doğru yerde, doğru şekilde kullanılan index performansın anahtarıdır.



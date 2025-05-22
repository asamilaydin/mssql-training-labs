USE Etrade2;
CREATE TABLE SalesAuditLog (
    LogId INT IDENTITY(1,1) PRIMARY KEY,
    SaleId INT,
    CustomerCode INT,
    ItemCode INT,
    Amount DECIMAL(10,2),
    TotalPrice DECIMAL(10,2),
    DateOfSale DATETIME,
    LoggedAt DATETIME DEFAULT GETDATE()
);

CREATE TRIGGER trg_AuditSalesDelete
ON SALES
AFTER DELETE 
AS
BEGIN
    INSERT INTO SalesAuditLog (SaleId, CustomerCode, ItemCode, Amount, TotalPrice, DateOfSale)
    SELECT 
        i.ID,
        i.CustomerCode,
        i.ItemCode,
        i.Amount,
        i.TOTALPRICE,
        i.Date_
    FROM deleted i;
END;

DELETE FROM SALES
WHERE Id = 99;


--  INSTEAD OF TRIGGER gelen INSERT/UPDATE/DELETE işlemini engeller,
--  onun yerine kendi yazdığımız işlemleri çalıştırır. Yani varsayılan işlemi 'yerine' geçer.
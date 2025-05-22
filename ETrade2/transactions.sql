CREATE DATABASE Bank;


USE Bank;
--
CREATE TABLE Customers (
    Id INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    BirthDate DATE,
    Gender CHAR(1), -- 'E' veya 'K'
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    CreatedAt DATETIME DEFAULT GETDATE()
);
--
CREATE TABLE Accounts (
    Id INT PRIMARY KEY IDENTITY(1,1),
    CustomerId INT NOT NULL,
    AccountNumber NVARCHAR(20) UNIQUE NOT NULL,
    Balance DECIMAL(18, 2) DEFAULT 0,
    Currency CHAR(3) DEFAULT 'TRY',
    CreatedAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (CustomerId) REFERENCES Customers(Id)
);
--
CREATE TABLE Transactions (
    Id INT PRIMARY KEY IDENTITY(1,1),
    AccountId INT NOT NULL,
    TransactionDate DATETIME DEFAULT GETDATE(),
    Type NVARCHAR(10), -- 'Deposit', 'Withdraw', 'Transfer'
    Amount DECIMAL(18,2) NOT NULL,
    Description NVARCHAR(255),

    FOREIGN KEY (AccountId) REFERENCES Accounts(Id)
);
--
INSERT INTO Customers (FullName, BirthDate, Gender, Phone, Email)
VALUES ('Ahmet Yılmaz', '1990-05-15', 'E', '05551234567', 'ahmet@example.com');
--
INSERT INTO Customers (FullName, BirthDate, Gender, Phone, Email)
VALUES ('Ayşe Demir', '1988-03-22', 'K', '05439876543', 'ayse@example.com');
--
INSERT INTO Accounts (CustomerId, AccountNumber, Balance, Currency)
VALUES 
(1, 'TR1000000000001', 1500.00, 'TRY'),
(1, 'TR1000000000002', 5000.00, 'USD');
--
INSERT INTO Accounts (CustomerId, AccountNumber, Balance, Currency)
VALUES 
(2, 'TR2000000000001', 2300.00, 'TRY'),
(2, 'TR2000000000002', 12000.00, 'EUR');




BEGIN TRY
    BEGIN TRANSACTION;

    -- Ahmet’in hesabından 100 TL düş
    UPDATE Accounts
    SET Balance = Balance - 100
    WHERE Id = 1; -- Ahmet’in hesabı VAR

    -- Ayşe’nin hesabına 100 TL ekle (hatalı ID: 9999 diye hesap yok)
    UPDATE Accounts
    SET Balance = Balance + 100
    WHERE Id = 9999; -- Bu ID yoksa, satır güncellenmez

    -- Ahmet için işlem kaydı
    INSERT INTO Transactions (AccountId, Type, Amount, Description)
    VALUES (1, 'Transfer', 100, 'Ahmet Ayşe’ye 100 TL gönderdi');

    -- Ayşe için işlem kaydı
    INSERT INTO Transactions (AccountId, Type, Amount, Description)
    VALUES (9999, 'Deposit', 100, 'Ahmet’ten 100 TL geldi');

    COMMIT TRANSACTION;
    PRINT 'Transfer başarılı.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;

    PRINT 'Bir hata oluştu. İşlem geri alındı.';
    PRINT ERROR_MESSAGE(); -- Hatanın detayını verir
END CATCH;

-- WITH (NOLOCK): Sadece **okuma** için kullanılır.
-- Diğer transaction’ların kilitlerini yok sayar.
-- Performans iyidir ama veri tutarlılığı garanti değildir.

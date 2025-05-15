
-- İki tablo için DDL kod;

CREATE TABLE [dbo].[Album]
(
    [AlbumId] INT NOT NULL,
    [Title] NVARCHAR(160) NOT NULL,
    [ArtistId] INT NOT NULL,
    CONSTRAINT [PK_Album] PRIMARY KEY CLUSTERED ([AlbumId])
);

CREATE TABLE [dbo].[Customer]
(
    [CustomerId] INT NOT NULL,
    [FirstName] NVARCHAR(40) NOT NULL,
    [LastName] NVARCHAR(20) NOT NULL,
    [Company] NVARCHAR(80),
    [Address] NVARCHAR(70),
    [City] NVARCHAR(40),
    [State] NVARCHAR(40),
    [Country] NVARCHAR(40),
    [PostalCode] NVARCHAR(10),
    [Phone] NVARCHAR(24),
    [Fax] NVARCHAR(24),
    [Email] NVARCHAR(60) NOT NULL,
    [SupportRepId] INT,
    CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([CustomerId])
);
-- Beş adet DML içeren kodlar.
Select ile ArtistID değeri değiştirme:

DECLARE @YeniArtistId INT;
SET @YeniArtistId = 5;
SELECT * FROM Artist WHERE ArtistId = @YeniArtistId;

Insert ile yeni müşteri ekleme:

INSERT INTO Customer (CustomerId,FirstName, LastName, Company, Address, City, State,Country,PostalCode,Phone,Fax,Email, SupportRepId)
VALUES(60,'Sude','Yılmaz','AppleInc.','Kadikoy','İstanbul',NULL, 'Turkey',34744,+905344562578,02164563553 ,'sude__yilmaz@hotmail.com', 3);
Update ile e-mail adresini değiştirme:

UPDATE Customer
SET Email = 'sude.yilmaz@icloud.com'
WHERE CustomerId = 60;

Select ile Seçilen müşterinin istenilen bilgilerini çekme:

SELECT FirstName, LastName, Email, City
FROM Customer
WHERE CustomerId = 60;

Delete ile eklenen satırı silme:
DELETE FROM Customer
WHERE CustomerId = 60;





--10 adet sorgu;
--Beşten fazla şarkı içeren albüm isimleri ve şarkı sayısı;
SELECT Album.Title, COUNT(Track.TrackId) AS NumberOfTracks
FROM Album
JOIN Track ON Album.AlbumId = Track.AlbumId
GROUP BY Album.Title
HAVING COUNT(Track.TrackId) > 5;


--Sanatçılar ve Albümleri Listeleme
SELECT Artist.Name AS Artist_Name, Album.Title AS Album_Title
FROM Artist
JOIN Album ON Artist.ArtistId = Album.ArtistId;

-- Çoktan aza doğru şarkı sayısı ve sanatçı adı;
SELECT Artist.Name, COUNT(Track.TrackId) AS TotalTracks
FROM Artist
JOIN Album ON Artist.ArtistId = Album.ArtistId
JOIN Track ON Album.AlbumId = Track.AlbumId
GROUP BY Artist.Name
ORDER BY TotalTracks DESC


--Her Albümdeki Ortalama Şarkı Süresi
SELECT Album.Title, AVG(Track.Milliseconds) AS AverageTrackLength
FROM Album
JOIN Track ON Album.AlbumId = Track.AlbumId
GROUP BY Album.Title;

-- Her yöneticinin sorumlu olduğu çalışan sayısı
SELECT Manager.FirstName + ' ' + Manager.LastName AS Manager_Name,
       COUNT(Employee.EmployeeId) AS NumberOfSubordinates
FROM Employee
JOIN Employee AS Manager ON Employee.ReportsTo = Manager.EmployeeId
GROUP BY Manager.FirstName, Manager.LastName;

--5'den Fazla Satın Alım Yapan Müşteriler
SELECT Customer.FirstName, Customer.LastName, COUNT(Invoice.InvoiceId) AS NumberOfPurchases
FROM Customer
JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
GROUP BY Customer.FirstName, Customer.LastName
HAVING COUNT(Invoice.InvoiceId) > 5;


--En Yüksek Fiyatlı Şarkılar
SELECT Track.Name, Track.UnitPrice
FROM Track
ORDER BY Track.UnitPrice DESC


--Şarkıların En Fazla Satıldığı Ülkeler
SELECT BillingCountry, COUNT(InvoiceId) AS NumberOfPurchases
FROM Invoice
GROUP BY BillingCountry
ORDER BY NumberOfPurchases DESC;



--100'den Fazla Şarkı Satışı Yapan Sanatçılar
SELECT Artist.Name AS Artist_Name, COUNT(Track.TrackId) AS NumberOfTracksSold
FROM Artist
JOIN Album ON Artist.ArtistId = Album.ArtistId
JOIN Track ON Album.AlbumId = Track.AlbumId
JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
GROUP BY Artist.Name
HAVING COUNT(InvoiceLine.TrackId) > 100
ORDER BY NumberOfTracksSold DESC;


--En Kısa ve En Uzun Şarkılara Sahip İlk 5 Müzik Türü
SELECT TOP 5
       Genre.Name AS Genre_Name,
       MIN(Track.Milliseconds) / 1000 AS Shortest_Track_Seconds,
       MAX(Track.Milliseconds) / 1000 AS Longest_Track_Seconds
FROM Genre
JOIN Track ON Genre.GenreId = Track.GenreId
GROUP BY Genre.Name
ORDER BY MAX(Track.Milliseconds) DESC;



--Saklı Yordam
-- Önce varsa görünümün silinmesi
IF OBJECT_ID('vw_CustomerInvoices', 'V') IS NOT NULL
    DROP VIEW vw_CustomerInvoices;
GO

-- Yeni View oluşturulması
CREATE VIEW vw_CustomerInvoices AS
SELECT 
    c.FirstName, 
    c.LastName, 
    i.InvoiceId, 
    i.Total
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId;



SELECT * FROM vw_CustomerInvoices;



--View
CREATE PROCEDURE GetCustomerInvoicesById
    @CustomerId INT
AS
BEGIN
    SELECT 
        i.InvoiceId, 
        i.InvoiceDate, 
        i.Total
    FROM Invoice i
    WHERE i.CustomerId = @CustomerId;
END;



EXEC GetCustomerInvoicesById @CustomerId = 59;





;
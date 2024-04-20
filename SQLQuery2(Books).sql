CREATE DATABASE Literature
USE Literature

CREATE TABLE Authors
(
Id int PRIMARY KEY IDENTITY,
[Name] nvarchar(255),
Surname nvarchar(255)
)


CREATE TABLE Books
(
Id int PRIMARY KEY IDENTITY,
[Name] nvarchar(100) CHECK(LEN([Name])>=2),
[PageCount] int CHECK([PageCount]>=10),
AuthorId int FOREIGN KEY REFERENCES Authors(Id)
)


--Id,Name,PageCount ve AuthorFullName columnlarinin valuelarini qaytaran bir view yaradin
CREATE VIEW ShowBooksData
AS
SELECT b.Name [Book Name],b.PageCount, CONCAT(a.Name,' ',a.Surname) [Author FullName] FROM Books b
JOIN Authors a
ON b.AuthorId=a.Id

SELECT * FROM ShowBooksData


--Gonderilmis axtaris deyirene gore hemin axtaris deyeri name ve ya authorFullNamelerinde olan 
--Book-lari Id,Name,PageCount,AuthorFullName columnlari seklinde gostern procedure yazin

CREATE PROCEDURE ShowSomeBooks @SearchData nvarchar(255)
AS 
SELECT b.Name [Book Name],b.PageCount, CONCAT(a.Name,' ',a.Surname) [Author FullName] FROM Books b
JOIN Authors a
ON b.AuthorId=a.Id
WHERE b.Name LIKE '%'+@SearchData+'%' OR CONCAT(a.Name,' ',a.Surname) LIKE '%'+@SearchData+'%'

EXEC ShowSomeBooks @SearchData='t'


--Authors tableinin insert,update ve deleti ucun (her biri ucun ayrica) procedure yaradin
CREATE PROCEDURE InsertAuthor @Name nvarchar(255), @Surname nvarchar(255)
AS 
INSERT INTO Authors (Name,Surname) VALUES (@Name,@Surname)

EXEC InsertAuthor @Name='Ayxan', @Surname='Taghizade'


CREATE PROCEDURE UpdateAuthor @Id int, @Name nvarchar(255)
AS 
UPDATE Authors SET Name=@Name WHERE Id=@Id

EXEC UpdateAuthor @Id=4,@Name='Aykhan'


CREATE PROCEDURE DeleteAuthor @Id int
AS
DELETE FROM Authors WHERE Id=@Id

EXEC DeleteAuthor @Id=4


--Authors-lari Id,FullName,BooksCount,MaxPageCount seklinde qaytaran view yaradirsiniz
CREATE VIEW ShowAuthors
AS 
SELECT CONCAT(a.Name,' ',a.Surname) FullName,COUNT(*) [Count of Books],MAX(b.PageCount) [Max PageCount]FROM Authors a
JOIN Books B
on b.AuthorId=a.Id
GROUP BY CONCAT(a.Name,' ',a.Surname)

SELECT * FROM ShowAuthors
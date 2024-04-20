CREATE DATABASE Spotify
USE Spotify

CREATE TABLE Artists
(
Id int PRIMARY KEY IDENTITY,
[Name] nvarchar(255)
)

CREATE TABLE Musics
(
Id int PRIMARY KEY IDENTITY,
[Name] nvarchar(255),
TotalSecond decimal(3,2),
ArtistId int FOREIGN KEY REFERENCES Artists(Id)
)

EXEC sp_rename 'Artists.Name', 'FullName'

CREATE TABLE Albums
(
Id int PRIMARY KEY IDENTITY,
[Name] nvarchar(255)
)

CREATE TABLE AlbumMusics
(
Id int PRIMARY KEY IDENTITY,
AlbumId int FOREIGN KEY REFERENCES Albums(Id),
MusicId int FOREIGN KEY REFERENCES Musics(Id)
)

--Musics-in name-ni, totalSecond-nu, artist nama-ni, album name-ni göstərən bir view yazırsız.
CREATE VIEW ShowData
AS
SELECT m.Name,m.TotalSecond,a.FullName,ab.Name [Album Name] FROM Musics m
JOIN Artists a
ON m.ArtistId=a.Id
JOIN AlbumMusics am
ON m.id=am.MusicId
JOIN Albums ab
ON am.AlbumId=ab.Id

SELECT * FROM ShowData


--Albumun adını və həmin albumda neçə dənə mahnı var onu göstərən bir view yazırsız.
CREATE VIEW ShowAlbumData
AS 
SELECT a.Name,COUNT(*) [Count of Music]FROM Albums a
JOIN AlbumMusics am
ON a.Id=am.AlbumId
JOIN Musics m
ON am.MusicId=m.Id
GROUP BY a.Name

SELECT * FROM ShowAlbumData

--ListenerCount-u parametr olaraq göndərilən listenerCount-dan böyük olan və 
--Album adında parametr olaraq göndərilən search dəyəri olan bütün mahnıların adını, 
--listenerCount-nu və Album adını göstərən bir procedure yazın.

ALTER TABLE Musics ADD ListenerCount int

CREATE PROCEDURE SelectSomeMusicData @ListenerCount int,@SearchValue nvarchar(255)
AS 
SELECT m.Name [Music Name], m.ListenerCount,al.Name FROM Musics m
JOIN Artists a
ON m.ArtistId=a.Id
JOIN AlbumMusics am
ON am.MusicId=m.Id
JOIN Albums al
ON am.AlbumId=al.Id
WHERE m.ListenerCount>@ListenerCount AND al.Name LIKE '%'+@SearchValue+'%'

EXEC SelectSomeMusicData @ListenerCount=250,@SearchValue='a'

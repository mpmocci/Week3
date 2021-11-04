--CREATE DATABASE Band

CREATE TABLE Band(
ID_Band INT IDENTITY (1,1),
Nome_Band NVARCHAR(50) NOT NULL,
Numero_Componenti INT NOT NULL,
CONSTRAINT PK_IDBand PRIMARY KEY (ID_Band)
);
GO

CREATE TABLE Album(
ID_Album INT IDENTITY (1,1),
Titolo_Album NVARCHAR(50) NOT NULL,
Anno_Uscita INT NOT NULL,
Casa_Discografica NVARCHAR(50) NOT NULL,
Genere NCHAR(20) NOT NULL,
Supporto_Distribuzione NCHAR(20) NOT NULL,
ID_Band INT NOT NULL,
CONSTRAINT PK_IDAlbum PRIMARY KEY (ID_Album),
CONSTRAINT FK_IDBand FOREIGN KEY (ID_Band) REFERENCES Band(ID_Band),
CONSTRAINT U_Album UNIQUE (ID_Band, Titolo_Album, Anno_Uscita, Casa_Discografica, Genere, Supporto_Distribuzione),
CONSTRAINT CHK_Genere CHECK (Genere='Classico' OR Genere='Pop' OR Genere='Rock' OR Genere='Jazz' OR Genere='Metal'),
CONSTRAINT CHK_Supporto_Distribuzione CHECK (Supporto_Distribuzione='Vinile' OR Supporto_Distribuzione='CD' 
OR Supporto_Distribuzione='Streaming')
GO

CREATE TABLE Brano(
ID_Brano INT IDENTITY (1,1),
Titolo_Brano NVARCHAR(50) NOT NULL,
Durata INT NOT NULL,
CONSTRAINT PK_IDBrano PRIMARY KEY (ID_Brano)
);
GO

CREATE TABLE Album_Brano(
ID_Brano INT,
ID_Album INT,
CONSTRAINT FK_IDBrano FOREIGN KEY (ID_Brano) REFERENCES Brano(ID_Brano),
CONSTRAINT FK_IDAlbum FOREIGN KEY (ID_Album) REFERENCES Album(ID_Album),
CONSTRAINT PK_AlbumBrano PRIMARY KEY (ID_Brano,ID_Album)
);
GO

--Nome, NumComp
INSERT INTO Band VALUES ('883',3),
						('Maneskin',4),
						('John Lennon',1),
						('The Giornalisti',6),
						('Mondoramen',10);

--Titolo,anno,casad,genere,supporto,idband
INSERT INTO Album VALUES ('Gli anni',1990,'Polygram', 'Pop','CD',1),
						 ('Nord Sud Ovest Est', 1998, 'Polygram,', 'Pop','CD',1),
						 ('X Factor', 2018,'Sony Music','Rock','Streaming', 2),
						 ('Il Ballo', 2020, 'Sony Music','Rock','Streaming',2),
						 ('Imagine John Lennon', 1970, 'EMI', 'Rock','Vinile', 3),
						 ('Mind Games', 1969, 'EMI', 'Pop','Vinile', 3),
						 ('Love', 2020, 'Polygram', 'Pop','CD', 4),
						 ('Blabla', 2021, 'Sony Music', 'Pop','Vinile', 5);

--INSERT INTO Album VALUES ('Gli anni',1990,'Polygram', 'Pop','CD',1); -- Test per vedere se il vincolo Unique funziona

--Titolo, durata
INSERT INTO Brano VALUES ('Gli anni', 185),
						 ('Hanno ucciso l''uomo ragno', 170),
						 ('La regina', 150),
						 ('Beggin', 190),
						 ('Mammmamia', 200),
						 ('Imagine', 130),
						 ('Strawberry imagine',189),
						 ('Felicita', 180),
						 ('Incredibile', 210),
						 ('Cruel', 190);

--IDBrano, IDAlbum
INSERT INTO Album_Brano VALUES (1,1), 
							   (2,2),
							   (3,2),
							   (4,3),
							   (5,4),
							   (6,5),
							   (7,6),
							   (8,7),
							   (9,7),
							   (10,8);

GO;

--1) Scrivere una query che restituisca i titoli degli album degli “883” in ordine alfabetico; 
SELECT a.Titolo_Album AS [Nome Album]
FROM Album AS a
INNER JOIN Band AS b ON a.ID_Band=b.ID_Band
WHERE B.Nome_Band='883'
ORDER BY A.Titolo_Album
GO

--2) Selezionare tutti gli album della casa discografica “Sony Music” relativi all’anno 2020;
SELECT a.Titolo_Album AS [Nome Album]
FROM Album AS a
WHERE a.Anno_Uscita='2020' AND a.Casa_Discografica='Sony Music'
GO

-- 3) Scrivere una query che restituisca tutti i titoli delle canzoni dei “Maneskin” appartenenti  
--ad album pubblicati prima del 2019; 

SELECT b.Titolo_Brano AS [Brano]
FROM Brano AS b
INNER JOIN Album_Brano AS ab ON ab.ID_Brano = b.ID_Brano
INNER JOIN Album AS a ON ab.ID_Album=a.ID_Album
INNER JOIN Band	AS ba ON ba.ID_Band=a.ID_Band
WHERE ba.Nome_Band='Maneskin' AND a.Anno_Uscita<'2019'
GO

--4) Individuare tutti gli album in cui è contenuta la canzone “Imagine”; 
SELECT a.Titolo_Album AS [Album]
FROM Album AS a
INNER JOIN Album_Brano AS ab ON ab.ID_Album=a.ID_Album
INNER JOIN Brano AS b ON b.ID_Brano= ab.ID_Brano
WHERE b.Titolo_Brano='Imagine'
GO

--5) Restituire il numero totale di canzoni eseguite dalla band “The Giornalisti”; 
SELECT b.Titolo_Brano AS [Brano]
FROM Brano AS b
INNER JOIN Album_Brano AS ab ON ab.ID_Brano = b.ID_Brano
INNER JOIN Album AS a ON ab.ID_Album=a.ID_Album
INNER JOIN Band	AS ba ON ba.ID_Band=a.ID_Band
WHERE ba.Nome_Band='The Giornalisti' 
GO

--6) Contare per ogni album, la “durata totale” cioè la somma dei secondi dei suoi brani 
SELECT a.Titolo_Album AS [Album], SUM(b.Durata) AS [Durata Totale]
FROM Album AS a
INNER JOIN Album_Brano AS ab ON ab.ID_Album=a.ID_Album
INNER JOIN Brano AS b ON b.ID_Brano= ab.ID_Brano
GROUP BY a.Titolo_Album
GO

--7) Mostrare i brani (distinti) degli “883” che durano più di 3 minuti (in alternativa usare i  secondi quindi 180 s). 
SELECT DISTINCT b.Titolo_Brano AS [Brano], b.Durata
FROM Brano AS b
INNER JOIN Album_Brano AS ab ON ab.ID_Brano = b.ID_Brano
INNER JOIN Album AS a ON ab.ID_Album=a.ID_Album
INNER JOIN Band	AS ba ON ba.ID_Band=a.ID_Band
WHERE ba.Nome_Band='883' AND b.Durata>'180'
GO

--8) Mostrare tutte le Band il cui nome inizia per “M” e finisce per “n”. 

INSERT INTO Band VALUES ('Mondocosmo',3);--check per vedere se questo lo fa vedere
GO

SELECT b.Nome_Band
FROM Band AS b
WHERE b.Nome_Band LIKE'M%n'
GO

--9) Mostrare il titolo dell’Album e di fianco un’etichetta che stabilisce che si tratta di un Album: 
--‘Very Old’ se il suo anno di uscita è precedente al 1980,  
--‘New Entry’ se l’anno di uscita è il 2021,  
--‘Recente’ se il suo anno di uscita è compreso tra il 2010 e 2020,  
--‘Old’ altrimenti. 

SELECT a.Titolo_Album,
CASE
WHEN a.Anno_Uscita<'1980' THEN 'Very Old'
WHEN a.Anno_Uscita='2021' THEN 'New Entry'
WHEN a.Anno_Uscita BETWEEN 2010 AND 2020 THEN 'Recente'
ELSE 'Old'
END AS [Etichetta Album]
FROM Album AS a
GO

--10) Mostrare i brani non contenuti in nessun album. 

INSERT INTO Brano VALUES ('Obladioblada', 185); -- non aggiunto a nessun album

SELECT b.Titolo_Brano
FROM Brano AS b
WHERE B.ID_Brano NOT IN (SELECT B.ID_Brano
						 FROM Album_Brano AS ab
						 INNER JOIN Brano AS b ON b.ID_Brano=ab.ID_Brano)
GO

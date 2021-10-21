CREATE DATABASE Romanzi
USE Romanzi


CREATE TABLE Autori(
ID_Autore INT IDENTITY (1,1),
Nome NCHAR(50) NOT NULL,
Cognome NCHAR(50) NOT NULL,
Anno_Nascita DATETIME NOT NULL,
Anno_Morte DATETIME,
Nazionalita  NCHAR(50) NOT NULL,
CONSTRAINT PK_ID_Autore PRIMARY KEY  (ID_Autore),
CONSTRAINT CHK_Datanascita CHECK (DATEPART(YEAR, Anno_Nascita) < DATEPART(YEAR, Anno_Morte))
);


CREATE TABLE Romanzi(
ID_Romanzo INT IDENTITY (1,1),
Titolo NCHAR(50) NOT NULL,
Anno_Pubblicazione DATETIME NOT NULL,
ID_Autore INT,
CONSTRAINT PK_ID_Romanzo PRIMARY KEY (ID_Romanzo),
CONSTRAINT FK_ID_Autore FOREIGN KEY (ID_Autore) REFERENCES Autori(ID_Autore)
);
GO

CREATE TABLE Personaggi(
ID_Personaggio INT IDENTITY(1,1),
Nome NCHAR(50) NOT NULL,
Sesso NCHAR(1) NOT NULL,
Ruolo NCHAR(30) NOT NULL,
CONSTRAINT PK_ID_Personaggio PRIMARY KEY (ID_Personaggio),
);
GO

CREATE TABLE Elenco_Personaggi(
ID_Romanzo INT NOT NULL,
ID_Personaggio INT NOT NULL,
CONSTRAINT FK_ID_Romanzo FOREIGN KEY (ID_Romanzo) REFERENCES Romanzi(ID_Romanzo),
CONSTRAINT FK_ID_Personaggio FOREIGN KEY (ID_Personaggio) REFERENCES Personaggi(ID_Personaggio),
CONSTRAINT PK_ElencoPersonaggi PRIMARY KEY (ID_Romanzo,ID_Personaggio)
);


--Autori: Nome, Cognome, Nascita, Morte,Nazionalita
INSERT INTO Autori VALUES ('Fedor','Dostoevkij', '1821-11-11','1881-02-09','Russa'),
						 ('Lev','Tolstoj', '1828-09-09','1910-11-20','Russa'),
						('Italo','Calvino', '1923-10-15','1985-02-09','Italiana'),
						('Valeria','Parrella', '1974-10-15',NULL,'Italiana'),
						('Teresa', 'Ciabatti', '1979-10-10',NULL,'Italiana'),
						('Jean-Claude', 'Izzo', '1949-04-13','1989-09-09','Francese');
--INSERT INTO Autori VALUES ('Emmanuele', 'Carrere', '1949-04-13','1929-09-09','Francese'); --VIOLAZIONE CHECK

--Romanzi: Titolo, Pubblicazione, ID autore
INSERT INTO Romanzi VALUES ('I fratelli Karamazov','1879-11-11', 1),
							('Delitto e castigo','1860-11-05', 1),
							('Anna Karenina','1866-08-08',2),
							('Marcovaldo','1950-12-12',3),
							('Almarina','2019-03-03',4),
							('Non e'' bellezza','2021-05-05',5),
							('Casino Totale','1970-04-04',6),
							('Chourmo','1972-05-05',6);


--Personaggi: Nome, Sesso, Ruolo
INSERT INTO Personaggi VALUES ('Ivan', 'M','Protagonista'),
								('Dmitrij','M', 'Antagonista'),
								('Raskolnikov','M','Protagonista'),
								('Sofja','F','Secondario'),
								('Anna K','F', 'Protagonista'),
								('Ivan K','M','Secondario'),
								('Vronskij','M','Secondario'),
								('Marcovaldo','M','Protagonista'),
								('Almarina','F','Protagonista'),
								('Valeria','F', 'Protagonista'),
								('Teresa','F', 'Protagonista'),
								('Anna','F', 'Secondaria'),
								('Montale','M','Protagonista'),
								('Nadia','F', 'Secondaria');

--Elenco Personaggi: IDRomanzo, IDPersonaggio
INSERT INTO Elenco_Personaggi VALUES (1,1), (1,2);
INSERT INTO Elenco_Personaggi VALUES (2,3),(2,4),(3,5),(3,6);
INSERT INTO Elenco_Personaggi VALUES (3,7),(4,8);
INSERT INTO Elenco_Personaggi VALUES (5,9),(5,10),(6,11),(6,12),(7,13),(7,14),(8,13),(8,14);


--1- Il titolo dei romanzi del 19° secolo
SELECT r.Titolo
FROM Romanzi AS r
WHERE DATEPART(YEAR,R.Anno_Pubblicazione) BETWEEN 1800 AND 1900
GO 

--2- Il titolo, l’autore e l’anno di pubblicazione dei romanzi di autori russi, ordinati per autore e, per lo stesso autore,
--ordinati per anno di pubblicazione

SELECT r.Titolo,( a.Nome + a.Cognome) AS [Nome], DATEPART(YEAR,R.Anno_Pubblicazione) AS [Anno di Pubblicazione]
FROM Romanzi AS r
INNER JOIN Autori AS a ON a.ID_Autore= r.ID_Autore
ORDER BY a.Nome, DATEPART(YEAR,R.Anno_Pubblicazione)
GO


--3- I personaggi principali (ruolo =”Protagonista”) dei romanzi di autori viventi.
SELECT p.Nome
FROM Personaggi AS p 
INNER JOIN [Elenco_Personaggi] AS ep ON ep.ID_Personaggio=p.ID_Personaggio
INNER JOIN Romanzi AS r ON r.ID_Romanzo=ep.ID_Romanzo
INNER JOIN Autori AS a ON a.ID_Autore= r.ID_Autore
WHERE  p.Ruolo='Protagonista' AND a.Anno_Morte IS NULL
GO

--4- Per ogni autore RUSSO, l’anno del primo e dell’ultimo romanzo.
SELECT a.Nome, MAX(DATEPART(YEAR,R.Anno_Pubblicazione) ) AS [Anno di pubblicazione Ultimo Romanzo]
FROM Romanzi AS r
INNER JOIN Autori AS a ON a.ID_Autore=r.ID_Autore
GROUP BY a.Nome
GO

SELECT a.Nome, MIN(DATEPART(YEAR,R.Anno_Pubblicazione) ) AS [Anno di pubblicazione primo Romanzo]
FROM Romanzi AS r
INNER JOIN Autori AS a ON a.ID_Autore=r.ID_Autore
GROUP BY a.Nome
GO

--5- I nomi dei personaggi che compaiono in più di un romanzo, ed il numero dei romanzi nei quali compaiono

SELECT p.Nome, COUNT(ep.ID_Romanzo) AS [Numero Romanzi]
FROM Personaggi AS p
INNER JOIN Elenco_Personaggi AS ep ON ep.ID_Personaggio=p.ID_Personaggio
GROUP BY p.Nome
GO

--6- Il titolo dei romanzi i cui personaggi principali sono tutti femminili.
SELECT DISTINCT r.Titolo
FROM Romanzi AS r
INNER JOIN Elenco_Personaggi AS ep ON ep.ID_Romanzo=r.ID_Romanzo
INNER JOIN Personaggi AS p ON p.ID_Personaggio=ep.ID_Personaggio
WHERE p.Sesso='F' AND p.Ruolo='Protagonista'
GO

--7 – Mostrare il titolo di un romanzo e di fianco un’etichetta che stabilisce che si tratta di un romanzo ‘Antico’
--se il suo anno di pubblicazione è precedente al 1800, neoclassico se l’anno di pubblicazione è nel secolo 1900, moderno
--se oltre gli anni 2000

SELECT r.Titolo, 
CASE 
WHEN DATEPART(YEAR,r.Anno_Pubblicazione)<1800 THEN 'Antico'
WHEN DATEPART(YEAR,r.Anno_Pubblicazione) BETWEEN 1900 AND 2000 THEN 'Neoclassico'
WHEN DATEPART(YEAR,r.Anno_Pubblicazione)>2000 THEN 'Moderno'
ELSE 'Classico'
END AS [Etichetta Romanzo]
FROM Romanzi AS r
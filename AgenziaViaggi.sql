--CREATE DATABASE AgenziaViaggi

CREATE TABLE Responsabile(
[Codice Responsabile] INT IDENTITY(1,1),
Nome NCHAR(50) NOT NULL,
Cognome NCHAR(50) NOT NULL, 
[Numero Di Telefono] INT NOT NULL,
CONSTRAINT PK_CodiceResponsabile PRIMARY KEY ([Codice Responsabile])
);

CREATE TABLE Partecipanti(
[Codice Partecipante] INT IDENTITY(1,1),
Nome NCHAR(50) NOT NULL,
Cognome NCHAR(50) NOT NULL, 
[Data di nascita] DATE NOT NULL,
[Citta di nascita] NCHAR(30) NOT NULL,
Indirizzo NVARCHAR(60) NOT NULL,
CONSTRAINT PK_CodicePartecipante PRIMARY KEY ([Codice Partecipante])
);

CREATE TABLE Tappe(
[Codice Tappa] INT IDENTITY(1,1),
Citta NCHAR(50) NOT NULL,
CONSTRAINT PK_CodiceTappa PRIMARY KEY ([Codice Tappa])
);

CREATE TABLE Itinerario(
[Codice Itinerario] INT IDENTITY(1,1),
Durata INT NOT NULL,
Prezzo MONEY NOT NULL,
[Codice Tappa] INT NOT NULL,
Descrizione NCHAR(60) NOT NULL,
CONSTRAINT CHK_DurataItinerario CHECK (Durata>0), 
CONSTRAINT CHK_Prezzo CHECK (Prezzo>0), 
CONSTRAINT PK_CodiceItinerario PRIMARY KEY ([Codice Itinerario]),
CONSTRAINT FK_CodiceTappa FOREIGN KEY ([Codice Tappa]) REFERENCES Tappe([Codice Tappa])
);

CREATE TABLE Itinerario_Tappe(
[Codice Itinerario] INT NOT NULL,
[Codice Tappa] INT NOT NULL,
Durata INT NOT NULL,
CONSTRAINT CHK_DurataTappa CHECK (Durata>0), 
CONSTRAINT FK_CodiceTappa_Itinerario_Tappe FOREIGN KEY ([Codice Tappa]) REFERENCES Tappe([Codice Tappa]),
CONSTRAINT FK_CodiceItinerario_Itinerario_Tappe FOREIGN KEY ([Codice Itinerario]) REFERENCES Itinerario([Codice Itinerario]),
CONSTRAINT PK_Itinerario_Tappe PRIMARY KEY ([Codice Itinerario], [Codice Tappa])
);

CREATE TABLE [Gita Turistica](
[Codice Gita] INT IDENTITY(1,1),
[Data Partenza] DATE NOT NULL,
[Codice Responsabile] INT NOT NULL,
[Codice Itinerario] INT NOT NULL ,
CONSTRAINT PK_CodiceGita PRIMARY KEY ([Codice Gita]),
CONSTRAINT FK_CodiceResponsabile FOREIGN KEY ([Codice Responsabile]) REFERENCES Responsabile([Codice Responsabile]),
CONSTRAINT FK_CodiceItinerario FOREIGN KEY ([Codice Itinerario]) REFERENCES Itinerario([Codice Itinerario]),
);

CREATE TABLE [Elenco Partecipanti](
[Codice Partecipante] INT NOT NULL,
[Codice Gita] INT NOT NULL,
CONSTRAINT FK_CodicePartecipante FOREIGN KEY ([Codice Partecipante]) REFERENCES Partecipanti([Codice Partecipante]),
CONSTRAINT FK_CodiceGita FOREIGN KEY ([Codice Gita]) REFERENCES [Gita Turistica]([Codice Gita]),
CONSTRAINT PK_ElencoPartecipanti PRIMARY KEY ([Codice Partecipante], [Codice Gita])
);

---INSERT
INSERT INTO Responsabile VALUES ('Federico', 'Massa', 34568),('Francesca','Collu', 8373);
INSERT INTO Tappe VALUES ('Roma'), ('Firenze'), ('Cagliari'), ('Venezia');
INSERT INTO Partecipanti VALUES ('Federico', 'Montella', '1980/10/10', 'Cagliari', 'via Logudoro');
INSERT INTO Partecipanti VALUES('Federica', 'Intina', '1980/10/10', 'Cagliari', 'via Logudoro');
INSERT INTO Itinerario VALUES (20, 945, 1, 'Giro dei Musei'),(5, 432, 1, 'Le strade di Roma'), (15, 789, 2, 'Gli Uffizi e il centro storico'),
(10, 100, 3, 'Cagliari sotterranea e costa sud-occidentale'), (40, 800, 4, 'I canali e gita a Trieste');--Durata,Prezzo,CodTappa, Descrizione
INSERT INTO Itinerario VALUES (15, 1040, 3, 'Escursioni a sud-est'),(3, 1500,2,'Valle del Chianti');--Durata,Prezzo,CodTappa
INSERT INTO [Gita Turistica] VALUES ('2020/03/03',1,1),('2021/05/05',1,2),('2021/10/10',2,3),('2022/01/01',2,4);
INSERT INTO [Gita Turistica] VALUES ('2022/04/03',1,1);--DataPartenza,CodResp,CodItinerario
INSERT INTO [Elenco Partecipanti] VALUES (1,1), (2,1),(1,2),(2,2)--CodPart,CodGita
INSERT INTO [Itinerario_Tappe] VALUES (1,1,15), (2,1,5),(3,2,10),(4,3,10);--CodIt,COdTappa,Durata
INSERT INTO [Itinerario_Tappe] VALUES (5,4,2);
INSERT INTO [Itinerario_Tappe] VALUES (6,3,1),(7,2,1);
GO



--1.Mostrare tutti i dati dei partecipanti di Roma
SELECT DISTINCT p.Nome, p.Cognome,p.[Citta di nascita],p.[Data di nascita],p.Indirizzo
FROM Partecipanti p
JOIN [Elenco Partecipanti] AS ep ON p.[Codice Partecipante]=ep.[Codice Partecipante]
JOIN [Gita Turistica] AS g ON g.[Codice Gita]=ep.[Codice Gita]
JOIN [Itinerario] AS i ON i.[Codice Itinerario]= g.[Codice Itinerario]
JOIN [Itinerario_Tappe] AS it ON it.[Codice Itinerario]= i.[Codice Itinerario]
JOIN [Tappe] AS t ON t.[Codice Tappa]= it.[Codice Tappa]
WHERE t.Citta='Roma'
GO
--2.Mostrare i dati degli itinerari con prezzo superiore ai 500 euro o durata superiore ai 7 giorni

SELECT DISTINCT i.[Codice Itinerario],i.Descrizione, t.Citta, i.Durata,i.Prezzo
FROM Itinerario AS i
INNER JOIN [Itinerario_Tappe] AS it ON it.[Codice Itinerario]=i.[Codice Itinerario]
INNER JOIN [Tappe] AS t ON t.[Codice Tappa]=it.[Codice Tappa]
WHERE i.Prezzo>500 OR i.Durata>7
GO


--3.Selezionare la data di partenza delle gite il cui itinerario ha un prezzo superiore ai 100 euro

SELECT i.Descrizione, g.[Data Partenza]
FROM [Gita Turistica] AS g
INNER JOIN Itinerario AS i ON i.[Codice Itinerario]= g.[Codice Itinerario]
WHERE i.Prezzo>100
GO

--4.Mostrare nome, cognome e numero di telefono dei responsabili delle gite in partenza il 3 Aprile 2022

SELECT Nome,
	 Cognome,
	 [Numero Di Telefono]
FROM Responsabile r
JOIN [Gita Turistica] AS gt ON r.[Codice Responsabile]= gt.[Codice Responsabile]
WHERE gt.[Data Partenza]='2022/04/03'
GO


--5.Mostrare i dati degli itinerari ordinati per prezzo e per durata
SELECT DISTINCT i.[Codice Itinerario],i.Descrizione,t.Citta, i.Prezzo, i.Durata
FROM Itinerario AS i
INNER JOIN [Itinerario_Tappe] AS it ON it.[Codice Itinerario]=i.[Codice Itinerario]
INNER JOIN [Tappe] AS t ON t.[Codice Tappa]=it.[Codice Tappa]
ORDER BY i.Prezzo, i.Durata
GO

--6.Mostrare gli itinerari con durata massima e minima
SELECT DISTINCT i.[Codice Itinerario],i.Descrizione,t.Citta, i.Prezzo, i.Durata
FROM Itinerario AS i
INNER JOIN [Itinerario_Tappe] AS it ON it.[Codice Itinerario]=i.[Codice Itinerario]
INNER JOIN [Tappe] AS t ON t.[Codice Tappa]=it.[Codice Tappa]
WHERE i.Durata= (SELECT MIN(Durata) FROM Itinerario) OR  i.Durata= (SELECT MAX(Durata) FROM Itinerario)
GO


--7.Mostrare le gite in partenza tra il 1 Gennaio 2021 ed il 31 Dicembre 2021
SELECT gt.[Codice Gita],i.Descrizione, t.Citta, gt.[Data Partenza], i.Prezzo, i.Durata,  (r.Nome + r.Cognome) AS [Nome Responsabile]
FROM [Gita Turistica] AS gt
INNER JOIN Responsabile AS r ON r.[Codice Responsabile]=gt.[Codice Responsabile]
INNER JOIN Itinerario AS i ON i.[Codice Itinerario]=gt.[Codice Itinerario]
INNER JOIN [Itinerario_Tappe] AS it ON it.[Codice Itinerario]=i.[Codice Itinerario]
INNER JOIN Tappe AS t ON t.[Codice Tappa]=it.[Codice Tappa]
WHERE  [Data Partenza] BETWEEN '2021/01/01' AND '2021/12/31'
GO


--TOP limita il numero di righe restituito da una query


SELECT * FROM Partecipanti
SELECT * FROM [Elenco Partecipanti]
SELECT * FROM [Gita Turistica]
SELECT * FROM Responsabile
SELECT * FROM Itinerario
SELECT * FROM Tappe
SELECT * FROM [Itinerario_Tappe]
--CREATE DATABASE Ricette;


CREATE TABLE Libro(
[Codice Libro] INT IDENTITY (1,1),
Nome NCHAR(30) NOT NULL,
Tipologia NCHAR(30) NOT NULL,
CONSTRAINT PK_CodiceLibro PRIMARY KEY ([Codice Libro])
);

CREATE TABLE Ingrediente (
[Codice Ingrediente] INT IDENTITY (1,1),
Nome NCHAR(50) NOT NULL,
[Unita Di Misura] NCHAR(20) NOT NULL,
CONSTRAINT PK_CodiceIngrediente PRIMARY KEY ([Codice Ingrediente])
);


CREATE TABLE Ricette(
[Codice Ricetta] INT IDENTITY (1,1),
Nome NCHAR (100) NOT NULL,
Preparazione NVARCHAR(500) NOT NULL,
[Quantita Persone] INT NOT NULL,
[Tempo Preparazione] INT NOT NULL,
[Codice Libro] INT NOT NULL,
[Codice Ingrediente] INT NOT NULL,
CONSTRAINT CHK_QuantitaPersone CHECK ([Quantita Persone] >0),
CONSTRAINT CHK_TempoPreparazione CHECK ([Tempo Preparazione] >0),
CONSTRAINT PK_CodiceRicetta PRIMARY KEY ([Codice Ricetta]),
CONSTRAINT FK_CodiceLibro FOREIGN KEY ([Codice Libro]) REFERENCES Libro([Codice Libro]),
CONSTRAINT FK_CodiceIngrediente FOREIGN KEY ([Codice Ingrediente]) REFERENCES Ingrediente([Codice Ingrediente])
);

CREATE TABLE Ingrediente_Ricetta(
[Codice Ricetta] INT,
[Codice Ingrediente] INT,
Quantita INT NOT NULL,
CONSTRAINT CHK_Quantita CHECK ([Quantita] >0),
CONSTRAINT FK_CodiceRicetta FOREIGN KEY ([Codice Ricetta]) REFERENCES Ricette([Codice Ricetta]),
CONSTRAINT FK_CodiceIngrediente_Ricetta FOREIGN KEY ([Codice Ingrediente]) REFERENCES Ingrediente([Codice Ingrediente]),
CONSTRAINT PK_CodiceRicettaIngrediente PRIMARY KEY ([Codice Ricetta],[Codice Ingrediente])
);

INSERT INTO Ingrediente VALUES ('Uova','g'),('Pepe','g'),('Latte','ml'),('Zucchero','g'),('Mascarpone','g'),
							('Pesto','g'),('Carne','g'),('Pasta','g'),('Pesce','g');--codIng,Nome,UM
INSERT INTO Libro VALUES ('Libro dei Primi','Primi'),('Libro dei secondi','Secondi'),('Libro dei dolci','Dolci');--Nome, tipologia
INSERT INTO Ricette VALUES ('Tiramisu','Separare tuorli da albumi, unire lo zucchero, etc', 4, 30,3,1),
							('Zabaione', 'Montare l''uovo con lo zucchero', 1, 3,3,1),
							('Cheesecake','Sciogliere il burro e unire ai biscotti etc', 5, 45,3,4),
							('Carne alla griglia', 'Mettere la carne sulla griglia calda etc', 6, 10,2,7),
							('Pasta al pesto', 'Mettere l''acqua a bollire etc', 10, 20,1,6);--Nome,Prep,quantitàPers,tempo,CodLibro,CodIng
INSERT INTO Ingrediente_Ricetta  VALUES (1,1,5),(2,1,1),(3,4,100),(4,7,2000),(5,6,150);--CodRic,CodIng,Quantità
INSERT INTO Ricette VALUES ('Bollito', 'Mettere la carne in acqua bollente etc', 4, 4,2,7);




SELECT * FROM Ricette
SELECT * FROM Ingrediente_Ricetta
SELECT * FROM Ingrediente
SELECT * FROM Libro

--Esercitazione Ricette Nonna
--1.Visualizzare tutta la lista degli ingredienti distinti.
SELECT DISTINCT Nome
FROM Ingrediente

--2.Visualizzare tutta la lista degli ingredienti distinti utilizzati in almeno una ricetta.
SELECT i.Nome
FROM Ingrediente AS i
INNER JOIN Ingrediente_Ricetta AS ir ON ir.[Codice Ingrediente]=i.[Codice Ingrediente]
WHERE ir.[Codice Ricetta] IS NOT NULL


--3.Estrarre tutte le ricette che contengono l’ingrediente uova.
SELECT r.Nome
FROM Ricette AS r 
INNER JOIN Ingrediente_Ricetta AS ir ON ir.[Codice Ricetta]=r.[Codice Ricetta]
INNER JOIN Ingrediente AS i ON i.[Codice Ingrediente]=ir.[Codice Ingrediente]
WHERE i.Nome='Uova'


--4.Mostrare il titolo delle ricette che contengono almeno 4 uova
SELECT r.Nome,ir.Quantita, r.[Codice Ricetta]
FROM Ricette as r
INNER JOIN Ingrediente_Ricetta AS ir ON ir.[Codice Ricetta]=r.[Codice Ricetta]
INNER JOIN Ingrediente AS i ON i.[Codice Ingrediente]=ir.[Codice Ingrediente]
WHERE i.Nome='Uova' AND ir.Quantita>=4

--5.Estrarre tutte le ricette dei libri di Tipologia=Secondi per 4 persone contenenti l’ingrediente carne
SELECT r.Nome
FROM Ricette AS r
INNER JOIN Libro AS l ON l.[Codice Libro]=r.[Codice Libro]
WHERE l.Tipologia='Secondi'AND r.[Quantita Persone]=4 
							AND r.[Codice Ingrediente]=(SELECT i.[Codice Ingrediente]
														FROM Ingrediente AS i
														WHERE i.Nome='Carne')

--6.Mostrare tutte le ricette che hanno un tempo di preparazione inferiore a 10 minuti.
SELECT r.Nome
FROM Ricette AS r
WHERE r.[Tempo Preparazione]<10


--7.Mostrare il titolo del libro che contiene più ricette

SELECT Titolo  
FROM (SELECT l.Nome AS Titolo, COUNT(r.[Codice Ricetta]) AS cont
FROM Ricette AS r INNER JOIN Libro AS l ON r.[Codice Libro] = l.[Codice Libro] GROUP BY l.Nome) AS new
WHERE cont = (SELECT MAX(cont) 
			FROM (SELECT l.Nome AS Titolo, COUNT(r.[Codice Ricetta]) AS cont
FROM Ricette AS r INNER JOIN Libro AS l ON r.[Codice Libro] = l.[Codice Libro] GROUP BY l.Nome) AS new) 





--8.Visualizzare i Titoli dei libri ordinati rispetto al numero di ricette che contengono 
--(il libro che contiene più ricette deve essere visualizzato per primo, quello con meno ricette per ultimo) e,
--a parità di numero ricette in ordine alfabetico su Titolo del libro.

SELECT l.Nome, COUNT(r.[Codice Ricetta]) AS cont
FROM Ricette AS r INNER JOIN Libro AS l ON r.[Codice Libro] = l.[Codice Libro] GROUP BY l.Nome
ORDER BY cont DESC, l.Nome
--creare il database "POLIZIA" per gestire l'associazione tra agenti di polizia e le aree metropolitane che devono pattugliare 
--(può essere che un agente venga assegnato a più aree. Un’area è sorvegliata da almeno un agente)

--entità coinvolte in questo esercizio:
--AGENTE DI POLIZIA:
--- nome (stringa obbligatoria di massimo 30 caratteri)
--- cognome (stringa obbligatoria di massimo 50 caratteri)
--- codice fiscale (stringa di 16 caratteri obbligatoria)
--- data di nascita (data obbligatoria. Deve essere maggiorenne)
--- anni di servizio (valore numerico valorizzato con gli effettivi anni di servizio)

--AREA METROPOLITANA
--- codice area (stringa alfabetica di 5 caratteri che identifica l'area (non è l'id))
--- alto rischio (valore che può assumere "0" o "1" a seconda se l'area è considerata ad alto rischio)

--individuare la soluzione più adatta a livello di tabelle e creare tutte le relazioni necessarie.
--IMPLEMENTARE I SEGUENTI VINCOLI:
---gli id devono essere auto incrementali
---l'agente di polizia deve essere maggiorenne
---il codice fiscale non può essere duplicato


--CREATE DATABASE Polizia

CREATE TABLE Agente(
ID INT IDENTITY(1,1),
Nome NCHAR(30) NOT NULL,
Cognome NCHAR(50) NOT NULL,
Codice_fiscale NVARCHAR(16) NOT NULL UNIQUE,
Data_nascita DATETIME NOT NULL,
Anni_servizio INT ,
CONSTRAINT PK_ID_Agente PRIMARY KEY (ID),
CONSTRAINT CHK_Età CHECK (DATEDIFF(year, Data_nascita, GETDATE()) >= 18)
);
GO

CREATE TABLE Area_Metropolitana(
ID INT IDENTITY(1,1),
Codice_area NCHAR(5) NOT NULL,
Alto_rischio BIT NOT NULL,
CONSTRAINT PK_ID_Area PRIMARY KEY (ID)
);
GO

ALTER TABLE Area_Metropolitana
ADD CONSTRAINT U_area UNIQUE (Codice_area)
GO

CREATE TABLE Agente_Area(
ID_Agente INT,
ID_Area INT,
CONSTRAINT FK_IDAgente FOREIGN KEY (ID_Agente) REFERENCES Agente(ID),
CONSTRAINT FK_IDArea FOREIGN KEY (ID_Area) REFERENCES Area_Metropolitana(ID),
CONSTRAINT  PK_AgenteArea PRIMARY KEY (ID_Agente,ID_Area)
);
GO

INSERT INTO Agente VALUES ('Marco', 'Montella', 'mmmnmn367382', '1990-05-05',4), 
						('Francesca', 'Collu', 'mmmnfff367382', '1988-08-05',9),
						  ('Federico', 'Massa', 'mththfff367382', '1992-10-05',1),
						  ('Sara', 'Intina', 'sssssfff367382', '1989-08-05',15); 
INSERT INTO Agente VALUES ('Francesca', 'Pala', 'ffffpp367382', '1988-05-11',2);
INSERT INTO Area_Metropolitana VALUES ('CFRS5', 1), ('MNBH8', 1), ('UYDI9',0),('WERQ2',0);
INSERT INTO Agente_Area VALUES (1,1),(1,2),(2,4),(3,3),(4,2),(4,1),(4,2);
INSERT INTO Agente_Area VALUES (5,2);
GO

SELECT * FROM Agente
SELECT * FROM Area_Metropolitana
SELECT * FROM Agente_Area
GO


--QUERIES:
--1) visualizzare l'elenco degli agenti che lavorano in "aree ad alto rischio" e hanno meno di 3 anni di servizio 
SELECT DISTINCT a.Nome, a.Cognome, a.ID
FROM Agente AS a
INNER JOIN Agente_Area AS aa ON aa.ID_Agente=a.ID
INNER JOIN Area_Metropolitana AS ar ON aa.ID_Area=ar.ID
WHERE ar.Alto_rischio=1 AND a.Anni_servizio<3
GO

--2) visualizzare il numero di agenti assegnati per ogni area geografica (numero agenti e codice area)

SELECT ar.Codice_area, COUNT(a.ID) AS [Numero Agenti]
FROM Area_Metropolitana AS ar 
INNER JOIN Agente_Area AS aa ON aa.ID_Area=ar.ID
INNER JOIN Agente AS a ON a.ID=aa.ID_Agente
GROUP BY ar.Codice_area
GO

--CREATE DATABASE Cinema

CREATE TABLE Attore (
CodiceAttore INT IDENTITY(1,1),
Nome NVARCHAR(30) NOT NULL,
Nazionalita NVARCHAR(20) NOT NULL,
DataNascita DATETIME,
CONSTRAINT PK_Attore PRIMARY KEY (CodiceAttore)
);

CREATE TABLE Sala(
CodiceSala INT IDENTITY(1,1),
Nome VARCHAR(30) NOT NULL,
PostiTotali INT,
CONSTRAINT CHK_PostiTotali CHECK(PostiTotali >=0),
CONSTRAINT PK_Sala PRIMARY KEY (CodiceSala)
);

CREATE TABLE Film(
CodiceFilm INT IDENTITY(1,1),
Titolo VARCHAR(50) NOT NULL,
Genere VARCHAR(20) NOT NULL,
Durata INT NOT NULL
CONSTRAINT CHK_Durata CHECK(Durata>0),
CONSTRAINT PK_CodiceFilm PRIMARY KEY (CodiceFilm),
CONSTRAINT CHK_Genere CHECK(Genere='Fantasy' OR Genere='Drammatico' OR Genere='Storico' OR Genere='Commedia')
);

CREATE TABLE [Cast Film](
CodiceFilm INT NOT NULL,
CodiceAttore INT NOT NULL,
Cache DECIMAL(9,2) CHECK(Cache>0),
CONSTRAINT FK_CodiceFilm_Cast FOREIGN KEY (CodiceFilm) REFERENCES Film(CodiceFilm),
CONSTRAINT FK_CodiceAttore_Cast FOREIGN KEY (CodiceAttore) REFERENCES Attore(CodiceAttore),
CONSTRAINT PK_FilmAttore PRIMARY KEY (CodiceFilm,CodiceAttore)
);


CREATE TABLE Programmazione(
CodiceProgrammazione INT IDENTITY(1,1),
DataOra DATETIME NOT NULL,
PostiDisponibili INT NOT NULL,
CodiceSala INT NOT NULL,
CodiceFilm INT NOT NULL,
CONSTRAINT CHK_PostiDisponibili CHECK (PostiDisponibili>=0),
CONSTRAINT PK_CodiceProgrammazione PRIMARY KEY (CodiceProgrammazione),
CONSTRAINT FK_CodiceSala_Programmazione FOREIGN KEY (CodiceSala) REFERENCES Sala(CodiceSala),
CONSTRAINT FK_CodiceFilm_Programmazione FOREIGN KEY (CodiceFilm) REFERENCES Film(CodiceFilm)
);

CREATE TABLE Prenotazione(
CodicePrenotazione INT IDENTITY(1,1),
Email NVARCHAR(30) NOT NULL,
PostiDaPrenotare INT NOT NULL,
CodiceProgrammazione INT,
CONSTRAINT CHK_PostiDaPrenotare CHECK (PostiDaPrenotare>0),
CONSTRAINT FK_CodiceProgrammazione FOREIGN KEY (CodiceProgrammazione) REFERENCES Programmazione(CodiceProgrammazione)
);



--inserimento dati 
--insert into NomeTabella values (elenco dei valori da inserire nell'ordine delle colonne)
insert Film values ('Harry Potter e la pietra filosofare', 'Fantasy', 140);
insert Film values ('Forest Gump', 'Drammatico', 156), ('Mamma ho perso l''aereo', 'Commedia', 125);
insert Film values ('Prova222', 'Fantasy', 145);
insert Film values ('Django', 'Storico', 145);
insert Film values ('Mamma ho perso l''aereo', 'Commedia', 145);



insert into Attore values ('Jiulia Roberts', 'Americana', '1975-10-12')
insert into Attore values ('Brad Pitt', 'Americana', '1977-11-23')
insert into Attore values ('Leonardo Di Caprio', 'Americana', '1975-06-24')
insert into Attore values ('Samuel L.Jackson', 'Americana', '1969-06-24')


insert into [Cast Film] values (1, 3, 5679.87);
insert into [Cast Film] values (1, 2, 1000.00);
insert into [Cast Film] values (3, 1, 1500.00);
insert into [Cast Film] values (3, 2, 1550.00);
insert into [Cast Film] values (4, 1, 2750.00);
insert into [Cast Film] values (4, 3, 2800.00);
insert into [Cast Film] values (5, 1, 30000.00);
insert into [Cast Film] values (5, 3, 4000.00);


insert into Sala values ('Sala Rossa', 120), ('Sala Verde', 80), ('Sala Bianca', 80);

insert into Programmazione values ('2021-12-24 20:00', 30, 1, 4);
insert into Programmazione values ('2021-12-20 20:00', 35, 2, 3);
insert into Programmazione values ('2021-12-20 20:00', 20, 3, 2);
insert into Programmazione values ('2021-12-20 20:00', 35, 2, 1);
insert into Programmazione values ('2021-10-20 20:00', 28, 2, 3);
insert into Programmazione values ('2021-10-20 17:00', 28, 3, 3);





---1. Mostrare tutti gli attori del film Harry Potter e la pietra in ordine alfabetico crescente

SELECT   Nome
FROM Attore AS a
JOIN [Cast Film] AS cf ON a.CodiceAttore=cf.CodiceAttore
WHERE cf.CodiceFilm=1
ORDER BY Nome

--2. Mostrare Nome, nazionalità e cachet percepito dagli attori di “Mamma Ho perso l’aereo” in ordine decrescente per cachet percepito.

SELECT  a.Nome,
		a.Nazionalita,
		cf.cache
FROM Attore AS a
JOIN [Cast Film] AS cf ON a.CodiceAttore=cf.CodiceAttore
JOIN Film AS f ON f.CodiceFilm=cf.CodiceFilm
WHERE cf.CodiceFilm=3
ORDER BY cf.cache DESC


--3. Mostrare tutti gli attori dei film programmati nella sala verde.
SELECT a.Nome
FROM Attore AS a
JOIN [Cast Film] AS cf ON a.CodiceAttore = cf.CodiceAttore
JOIN Programmazione AS p ON p.CodiceFilm = cf.CodiceFilm
JOIN Sala AS s ON s.CodiceSala=p.CodiceSala
WHERE s.Nome= 'Sala Verde'

--4. Mostrare quanti posti disponibili ci sono nella programmazione di oggi alle 17:00 del film Mamma ho perso l’aereo.

SELECT PostiDisponibili
FROM Programmazione AS p
WHERE p.CodiceFilm=3 AND DATEPART(DAYOFYEAR, SYSDATETIME()) = DATEPART(DAYOFYEAR, p.DataOra)
AND DATEPART(HOUR, p.DataOra)=17
AND DATEPART(MINUTE, p.DataOra)=00

--5. Mostrare gli attori (nome e data di nascita) dei soli film proiettati oggi nella sala rossa se i posti disponibili
--sono maggiori di 30 e se il cachet percepito è superiore a 1000 euro

SELECT a.Nome,
	   a.DataNascita
FROM Attore AS a
JOIN [Cast Film] AS cf ON cf.CodiceAttore= a.CodiceAttore
JOIN Programmazione AS p ON p.CodiceFilm=cf.CodiceFilm
JOIN Sala AS s ON p.CodiceSala=s.CodiceSala
WHERE DATEPART(DAYOFYEAR, SYSDATETIME()) = DATEPART(DAYOFYEAR, p.DataOra) AND s.Nome='Sala Rossa' AND p.PostiDisponibili>30 AND cf.Cache>1000

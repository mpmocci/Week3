USE [master]
GO
/****** Object:  Database [Band]    Script Date: 10/22/2021 3:22:34 PM ******/
CREATE DATABASE [Band]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Band', FILENAME = N'C:\Users\paola\Band.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Band_log', FILENAME = N'C:\Users\paola\Band_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [Band] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Band].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Band] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Band] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Band] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Band] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Band] SET ARITHABORT OFF 
GO
ALTER DATABASE [Band] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [Band] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Band] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Band] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Band] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Band] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Band] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Band] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Band] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Band] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Band] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Band] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Band] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Band] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Band] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Band] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Band] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Band] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Band] SET  MULTI_USER 
GO
ALTER DATABASE [Band] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Band] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Band] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Band] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Band] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Band] SET QUERY_STORE = OFF
GO
USE [Band]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [Band]
GO
/****** Object:  Table [dbo].[Album]    Script Date: 10/22/2021 3:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Album](
	[ID_Album] [int] IDENTITY(1,1) NOT NULL,
	[Titolo_Album] [nvarchar](50) NOT NULL,
	[Anno_Uscita] [int] NOT NULL,
	[Casa_Discografica] [nvarchar](50) NOT NULL,
	[Genere] [nchar](20) NOT NULL,
	[Supporto_Distribuzione] [nchar](20) NOT NULL,
	[ID_Band] [int] NOT NULL,
 CONSTRAINT [PK_IDAlbum] PRIMARY KEY CLUSTERED 
(
	[ID_Album] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Album_Brano]    Script Date: 10/22/2021 3:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Album_Brano](
	[ID_Brano] [int] NOT NULL,
	[ID_Album] [int] NOT NULL,
 CONSTRAINT [PK_AlbumBrano] PRIMARY KEY CLUSTERED 
(
	[ID_Brano] ASC,
	[ID_Album] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Band]    Script Date: 10/22/2021 3:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Band](
	[ID_Band] [int] IDENTITY(1,1) NOT NULL,
	[Nome_Band] [nvarchar](50) NOT NULL,
	[Numero_Componenti] [int] NOT NULL,
 CONSTRAINT [PK_IDBand] PRIMARY KEY CLUSTERED 
(
	[ID_Band] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Brano]    Script Date: 10/22/2021 3:22:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Brano](
	[ID_Brano] [int] IDENTITY(1,1) NOT NULL,
	[Titolo_Brano] [nvarchar](50) NOT NULL,
	[Durata] [int] NOT NULL,
 CONSTRAINT [PK_IDBrano] PRIMARY KEY CLUSTERED 
(
	[ID_Brano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Album] ON 

INSERT [dbo].[Album] ([ID_Album], [Titolo_Album], [Anno_Uscita], [Casa_Discografica], [Genere], [Supporto_Distribuzione], [ID_Band]) VALUES (1, N'Gli anni', 1990, N'Polygram', N'Pop                 ', N'CD                  ', 1)
INSERT [dbo].[Album] ([ID_Album], [Titolo_Album], [Anno_Uscita], [Casa_Discografica], [Genere], [Supporto_Distribuzione], [ID_Band]) VALUES (2, N'Nord Sud Ovest Est', 1998, N'Polygram,', N'Pop                 ', N'Cassetta            ', 1)
INSERT [dbo].[Album] ([ID_Album], [Titolo_Album], [Anno_Uscita], [Casa_Discografica], [Genere], [Supporto_Distribuzione], [ID_Band]) VALUES (4, N'Il Ballo', 2020, N'Sony Music', N'Rock                ', N'CD                  ', 2)
INSERT [dbo].[Album] ([ID_Album], [Titolo_Album], [Anno_Uscita], [Casa_Discografica], [Genere], [Supporto_Distribuzione], [ID_Band]) VALUES (3, N'X Factor', 2018, N'Sony Music', N'Rock                ', N'CD                  ', 2)
INSERT [dbo].[Album] ([ID_Album], [Titolo_Album], [Anno_Uscita], [Casa_Discografica], [Genere], [Supporto_Distribuzione], [ID_Band]) VALUES (5, N'Imagine John Lennon', 1970, N'EMI', N'Rock                ', N'Vinile              ', 3)
INSERT [dbo].[Album] ([ID_Album], [Titolo_Album], [Anno_Uscita], [Casa_Discografica], [Genere], [Supporto_Distribuzione], [ID_Band]) VALUES (6, N'Mind Games', 1969, N'EMI', N'Pop                 ', N'Cassetta            ', 3)
INSERT [dbo].[Album] ([ID_Album], [Titolo_Album], [Anno_Uscita], [Casa_Discografica], [Genere], [Supporto_Distribuzione], [ID_Band]) VALUES (7, N'Love', 2020, N'Polygram', N'Pop                 ', N'CD                  ', 4)
INSERT [dbo].[Album] ([ID_Album], [Titolo_Album], [Anno_Uscita], [Casa_Discografica], [Genere], [Supporto_Distribuzione], [ID_Band]) VALUES (8, N'Blabla', 2021, N'Sony Music', N'Pop                 ', N'Vinile              ', 5)
SET IDENTITY_INSERT [dbo].[Album] OFF
GO
INSERT [dbo].[Album_Brano] ([ID_Brano], [ID_Album]) VALUES (1, 1)
INSERT [dbo].[Album_Brano] ([ID_Brano], [ID_Album]) VALUES (2, 2)
INSERT [dbo].[Album_Brano] ([ID_Brano], [ID_Album]) VALUES (3, 2)
INSERT [dbo].[Album_Brano] ([ID_Brano], [ID_Album]) VALUES (4, 3)
INSERT [dbo].[Album_Brano] ([ID_Brano], [ID_Album]) VALUES (5, 4)
INSERT [dbo].[Album_Brano] ([ID_Brano], [ID_Album]) VALUES (6, 5)
INSERT [dbo].[Album_Brano] ([ID_Brano], [ID_Album]) VALUES (7, 6)
INSERT [dbo].[Album_Brano] ([ID_Brano], [ID_Album]) VALUES (8, 7)
INSERT [dbo].[Album_Brano] ([ID_Brano], [ID_Album]) VALUES (9, 7)
INSERT [dbo].[Album_Brano] ([ID_Brano], [ID_Album]) VALUES (10, 8)
GO
SET IDENTITY_INSERT [dbo].[Band] ON 

INSERT [dbo].[Band] ([ID_Band], [Nome_Band], [Numero_Componenti]) VALUES (1, N'883', 3)
INSERT [dbo].[Band] ([ID_Band], [Nome_Band], [Numero_Componenti]) VALUES (2, N'Maneskin', 4)
INSERT [dbo].[Band] ([ID_Band], [Nome_Band], [Numero_Componenti]) VALUES (3, N'John Lennon', 1)
INSERT [dbo].[Band] ([ID_Band], [Nome_Band], [Numero_Componenti]) VALUES (4, N'The Giornalisti', 6)
INSERT [dbo].[Band] ([ID_Band], [Nome_Band], [Numero_Componenti]) VALUES (5, N'Mondoramen', 10)
INSERT [dbo].[Band] ([ID_Band], [Nome_Band], [Numero_Componenti]) VALUES (6, N'Mondocosmo', 3)
SET IDENTITY_INSERT [dbo].[Band] OFF
GO
SET IDENTITY_INSERT [dbo].[Brano] ON 

INSERT [dbo].[Brano] ([ID_Brano], [Titolo_Brano], [Durata]) VALUES (1, N'Gli anni', 185)
INSERT [dbo].[Brano] ([ID_Brano], [Titolo_Brano], [Durata]) VALUES (2, N'Hanno ucciso l''uomo ragno', 170)
INSERT [dbo].[Brano] ([ID_Brano], [Titolo_Brano], [Durata]) VALUES (3, N'La regina', 150)
INSERT [dbo].[Brano] ([ID_Brano], [Titolo_Brano], [Durata]) VALUES (4, N'Beggin', 190)
INSERT [dbo].[Brano] ([ID_Brano], [Titolo_Brano], [Durata]) VALUES (5, N'Mammmamia', 200)
INSERT [dbo].[Brano] ([ID_Brano], [Titolo_Brano], [Durata]) VALUES (6, N'Imagine', 130)
INSERT [dbo].[Brano] ([ID_Brano], [Titolo_Brano], [Durata]) VALUES (7, N'Strawberry imagine', 189)
INSERT [dbo].[Brano] ([ID_Brano], [Titolo_Brano], [Durata]) VALUES (8, N'Felicita', 180)
INSERT [dbo].[Brano] ([ID_Brano], [Titolo_Brano], [Durata]) VALUES (9, N'Incredibile', 210)
INSERT [dbo].[Brano] ([ID_Brano], [Titolo_Brano], [Durata]) VALUES (10, N'Cruel', 190)
INSERT [dbo].[Brano] ([ID_Brano], [Titolo_Brano], [Durata]) VALUES (11, N'Obladioblada', 185)
SET IDENTITY_INSERT [dbo].[Brano] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [U_Album]    Script Date: 10/22/2021 3:22:34 PM ******/
ALTER TABLE [dbo].[Album] ADD  CONSTRAINT [U_Album] UNIQUE NONCLUSTERED 
(
	[ID_Band] ASC,
	[Titolo_Album] ASC,
	[Anno_Uscita] ASC,
	[Casa_Discografica] ASC,
	[Genere] ASC,
	[Supporto_Distribuzione] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Album]  WITH CHECK ADD  CONSTRAINT [FK_IDBand] FOREIGN KEY([ID_Band])
REFERENCES [dbo].[Band] ([ID_Band])
GO
ALTER TABLE [dbo].[Album] CHECK CONSTRAINT [FK_IDBand]
GO
ALTER TABLE [dbo].[Album_Brano]  WITH CHECK ADD  CONSTRAINT [FK_IDAlbum] FOREIGN KEY([ID_Album])
REFERENCES [dbo].[Album] ([ID_Album])
GO
ALTER TABLE [dbo].[Album_Brano] CHECK CONSTRAINT [FK_IDAlbum]
GO
ALTER TABLE [dbo].[Album_Brano]  WITH CHECK ADD  CONSTRAINT [FK_IDBrano] FOREIGN KEY([ID_Brano])
REFERENCES [dbo].[Brano] ([ID_Brano])
GO
ALTER TABLE [dbo].[Album_Brano] CHECK CONSTRAINT [FK_IDBrano]
GO
USE [master]
GO
ALTER DATABASE [Band] SET  READ_WRITE 
GO

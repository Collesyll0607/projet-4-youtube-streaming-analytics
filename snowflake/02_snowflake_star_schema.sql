-- =============================================================================
-- PROJET 4 : Schéma en Étoile Snowflake (Strictement aligné sur votre Worksheet)
-- Compte      : kyykmpb-lu82975
-- Database    : YOUTUBE_DATA_WH
-- Schéma      : PUBLIC
-- Utilisateur : COLLE
-- =============================================================================

USE DATABASE YOUTUBE_DATA_WH;
USE SCHEMA PUBLIC;

-- 1. Dimension Temps
CREATE OR REPLACE TABLE Dim_Time (
    Time_ID VARCHAR(50) PRIMARY KEY,
    Year INT,
    Month INT,
    Day INT,
    Hour INT,
    Full_Date TIMESTAMP
);

-- 2. Dimension Chaîne
CREATE OR REPLACE TABLE Dim_Channel (
    Channel_ID VARCHAR(255) PRIMARY KEY,
    Channel_Name VARCHAR(255)
);

-- 3. Dimension Vidéo
CREATE OR REPLACE TABLE Dim_Video (
    Video_ID VARCHAR(100) PRIMARY KEY,
    Title VARCHAR(1000)
);

-- 4. Table de Faits Principale (Fact_Youtube)
CREATE OR REPLACE TABLE Fact_Youtube (
    Fact_ID VARCHAR(255) PRIMARY KEY,
    Video_ID VARCHAR(100) REFERENCES Dim_Video(Video_ID),
    Channel_ID VARCHAR(255) REFERENCES Dim_Channel(Channel_ID),
    Time_ID VARCHAR(50) REFERENCES Dim_Time(Time_ID),
    View_Count INT,
    Like_Count INT,
    Comment_Count INT,
    Engagement_Rate NUMBER(6,2),
    Ingest_Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- 5. Table de Faits Commentaires & Sentiment
CREATE OR REPLACE TABLE Fact_Comments_Sentiment (
    Comment_ID VARCHAR(255) PRIMARY KEY,
    Video_ID VARCHAR(100) REFERENCES Dim_Video(Video_ID),
    Time_ID VARCHAR(50) REFERENCES Dim_Time(Time_ID),
    Author VARCHAR(255),
    Comment_Text TEXT,
    Sentiment_Score NUMBER(4,3),
    Sentiment_Label VARCHAR(20),
    Like_Count INT
);

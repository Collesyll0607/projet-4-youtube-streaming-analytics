-- =============================================================================
-- PROJET 4 : Requêtes et Vues Analytiques Avancées Snowflake
-- Compte      : kyykmpb-lu82975
-- Database    : YOUTUBE_DATA_WH
-- Schéma      : PUBLIC
-- Utilisateur : COLLE
-- =============================================================================

USE DATABASE YOUTUBE_DATA_WH;
USE SCHEMA PUBLIC;

-- -----------------------------------------------------------------------------
-- VUE 1 : Vue Décisionnelle du Top 20 des Vidéos avec Window Functions
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_TOP_PERFORMING_VIDEOS AS
SELECT 
    v.Video_ID,
    v.Title,
    c.Channel_Name,
    f.View_Count,
    f.Like_Count,
    f.Comment_Count,
    f.Engagement_Rate,
    DENSE_RANK() OVER (ORDER BY f.View_Count DESC) AS Rang_Vues,
    RATIO_TO_REPORT(f.View_Count) OVER () * 100 AS Part_De_Marche_Vues_Pct
FROM Fact_Youtube f
JOIN Dim_Video v ON f.Video_ID = v.Video_ID
JOIN Dim_Channel c ON f.Channel_ID = c.Channel_ID;


-- -----------------------------------------------------------------------------
-- VUE 2 : Synthèse des Sentiments des Commentaires par Chaîne YouTube
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_SENTIMENT_BY_CHANNEL AS
SELECT 
    c.Channel_Name,
    COUNT(cs.Comment_ID) AS Total_Commentaires,
    ROUND(AVG(cs.Sentiment_Score), 3) AS Score_Sentiment_Moyen,
    SUM(CASE WHEN cs.Sentiment_Label = 'POSITIVE' THEN 1 ELSE 0 END) AS Positifs,
    SUM(CASE WHEN cs.Sentiment_Label = 'NEGATIVE' THEN 1 ELSE 0 END) AS Negatifs,
    ROUND((SUM(CASE WHEN cs.Sentiment_Label = 'POSITIVE' THEN 1 ELSE 0 END) * 100.0) / NULLIF(COUNT(cs.Comment_ID), 0), 2) AS Taux_Positivite_Pct
FROM Fact_Comments_Sentiment cs
JOIN Dim_Video v ON cs.Video_ID = v.Video_ID
JOIN Dim_Channel c ON v.Channel_ID = c.Channel_ID
GROUP BY c.Channel_Name;


-- -----------------------------------------------------------------------------
-- REQUÊTE DIRECTE : Analyse de Croissance Temporelle des Vues
-- -----------------------------------------------------------------------------
SELECT 
    v.Title,
    t.Full_Date,
    f.View_Count,
    LAG(f.View_Count, 1) OVER (PARTITION BY v.Video_ID ORDER BY t.Full_Date) AS Vues_Precedentes,
    (f.View_Count - LAG(f.View_Count, 1) OVER (PARTITION BY v.Video_ID ORDER BY t.Full_Date)) AS Croissance_Vues
FROM Fact_Youtube f
JOIN Dim_Video v ON f.Video_ID = v.Video_ID
JOIN Dim_Time t ON f.Time_ID = t.Time_ID
ORDER BY t.Full_Date DESC;

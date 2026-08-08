-- =============================================================================
-- PROJET 4 : Modélisation en Étoile (Star Schema) - Entrepôt Décisionnel YouTube
-- =============================================================================

DROP TABLE IF EXISTS Fact_Video_Performance CASCADE;
DROP TABLE IF EXISTS Fact_Comments CASCADE;
DROP TABLE IF EXISTS Dim_Video CASCADE;
DROP TABLE IF EXISTS Dim_Channel CASCADE;
DROP TABLE IF EXISTS Dim_Category CASCADE;
DROP TABLE IF EXISTS Dim_Sentiment CASCADE;
DROP TABLE IF EXISTS Dim_Temps CASCADE;

-- 1. Dimension Vidéo
CREATE TABLE Dim_Video (
    sk_video INT PRIMARY KEY,
    video_id_source VARCHAR(50) NOT NULL UNIQUE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    published_at TIMESTAMP
);

-- 2. Dimension Chaîne YouTube
CREATE TABLE Dim_Channel (
    sk_channel INT PRIMARY KEY,
    channel_id_source VARCHAR(50) NOT NULL UNIQUE,
    channel_title VARCHAR(150) NOT NULL
);

-- 3. Dimension Catégorie
CREATE TABLE Dim_Category (
    sk_category INT PRIMARY KEY,
    category_id_source VARCHAR(20) NOT NULL UNIQUE,
    category_name VARCHAR(100) NOT NULL
);

-- 4. Dimension Sentiment
CREATE TABLE Dim_Sentiment (
    sk_sentiment INT PRIMARY KEY,
    sentiment_label VARCHAR(20) NOT NULL, -- POSITIVE, NEUTRAL, NEGATIVE
    polarity_range VARCHAR(50) NOT NULL
);

-- 5. Dimension Temps
CREATE TABLE Dim_Temps (
    sk_temps INT PRIMARY KEY, -- YYYYMMDDHH
    full_datetime TIMESTAMP NOT NULL,
    annee INT NOT NULL,
    mois INT NOT NULL,
    jour INT NOT NULL,
    heure INT NOT NULL,
    jour_semaine VARCHAR(20) NOT NULL
);

-- 6. Table de Fait 1 : Performance des Vidéos
CREATE TABLE Fact_Video_Performance (
    fact_video_id INT PRIMARY KEY,
    sk_video INT NOT NULL,
    sk_channel INT NOT NULL,
    sk_category INT NOT NULL,
    sk_temps INT NOT NULL,
    
    view_count BIGINT NOT NULL,
    like_count BIGINT NOT NULL,
    comment_count BIGINT NOT NULL,
    engagement_rate DECIMAL(6,2) NOT NULL,
    
    CONSTRAINT fk_yt_video FOREIGN KEY (sk_video) REFERENCES Dim_Video(sk_video),
    CONSTRAINT fk_yt_channel FOREIGN KEY (sk_channel) REFERENCES Dim_Channel(sk_channel),
    CONSTRAINT fk_yt_category FOREIGN KEY (sk_category) REFERENCES Dim_Category(sk_category),
    CONSTRAINT fk_yt_temps FOREIGN KEY (sk_temps) REFERENCES Dim_Temps(sk_temps)
);

-- 7. Table de Fait 2 : Analyse des Commentaires
CREATE TABLE Fact_Comments (
    fact_comment_id INT PRIMARY KEY,
    sk_video INT NOT NULL,
    sk_channel INT NOT NULL,
    sk_sentiment INT NOT NULL,
    sk_temps INT NOT NULL,
    
    sentiment_score DECIMAL(4,3) NOT NULL,
    comment_likes INT NOT NULL,
    
    CONSTRAINT fk_comm_video FOREIGN KEY (sk_video) REFERENCES Dim_Video(sk_video),
    CONSTRAINT fk_comm_channel FOREIGN KEY (sk_channel) REFERENCES Dim_Channel(sk_channel),
    CONSTRAINT fk_comm_sentiment FOREIGN KEY (sk_sentiment) REFERENCES Dim_Sentiment(sk_sentiment),
    CONSTRAINT fk_comm_temps FOREIGN KEY (sk_temps) REFERENCES Dim_Temps(sk_temps)
);

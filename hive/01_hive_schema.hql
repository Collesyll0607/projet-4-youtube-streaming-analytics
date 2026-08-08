-- =============================================================================
-- PROJET 4 : DDL Hive pour le Traitement des Données YouTube Streaming
-- Création des Tables Externes Partitionnées
-- =============================================================================

CREATE DATABASE IF NOT EXISTS youtube_analytics_db;
USE youtube_analytics_db;

-- -----------------------------------------------------------------------------
-- 1. Table Externe Raw pour les Métriques Vidéo YouTube (format JSON Kafka/HDFS)
-- -----------------------------------------------------------------------------
CREATE EXTERNAL TABLE IF NOT EXISTS raw_youtube_videos (
    video_id STRING,
    title STRING,
    channel_id STRING,
    channel_title STRING,
    view_count BIGINT,
    like_count BIGINT,
    comment_count BIGINT,
    published_at TIMESTAMP,
    ingested_at TIMESTAMP
)
PARTITIONED BY (dt STRING, category_id STRING)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
LOCATION '/data/youtube/raw_videos/';

-- -----------------------------------------------------------------------------
-- 2. Table Externe Raw pour les Commentaires YouTube
-- -----------------------------------------------------------------------------
CREATE EXTERNAL TABLE IF NOT EXISTS raw_youtube_comments (
    video_id STRING,
    author STRING,
    comment_text STRING,
    like_count INT,
    sentiment_score DOUBLE,
    sentiment_label STRING,
    published_at TIMESTAMP
)
PARTITIONED BY (dt STRING)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
LOCATION '/data/youtube/raw_comments/';

-- -----------------------------------------------------------------------------
-- 3. Table ORC Optimisée pour les Analyses Decisionnelles (Managed Table)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS processed_youtube_metrics (
    video_id STRING,
    title STRING,
    channel_title STRING,
    category_id STRING,
    view_count BIGINT,
    like_count BIGINT,
    comment_count BIGINT,
    engagement_rate DOUBLE,
    ingest_date STRING
)
STORED AS ORC
TBLPROPERTIES ("orc.compress"="SNAPPY");

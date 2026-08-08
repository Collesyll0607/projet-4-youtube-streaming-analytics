-- =============================================================================
-- PROJET 4 : Requêtes d'Analyse Hive (HQL) sur le Flux YouTube
-- =============================================================================

USE youtube_analytics_db;

-- -----------------------------------------------------------------------------
-- REQUÊTE 1 : Top 10 des vidéos les plus engagées par catégorie
-- -----------------------------------------------------------------------------
SELECT 
    category_id,
    video_id,
    title,
    view_count,
    like_count,
    comment_count,
    ROUND(((like_count + comment_count) / CAST(view_count AS DOUBLE)) * 100, 2) AS engagement_rate_pct
FROM raw_youtube_videos
WHERE dt = '2026-02-08'
ORDER BY engagement_rate_pct DESC
LIMIT 10;


-- -----------------------------------------------------------------------------
-- REQUÊTE 2 : Distribution des Sentiments sur les Commentaires par Vidéo
-- -----------------------------------------------------------------------------
SELECT 
    video_id,
    COUNT(*) AS total_commentaires,
    SUM(CASE WHEN sentiment_label = 'POSITIVE' THEN 1 ELSE 0 END) AS nb_positifs,
    SUM(CASE WHEN sentiment_label = 'NEUTRAL' THEN 1 ELSE 0 END) AS nb_neutres,
    SUM(CASE WHEN sentiment_label = 'NEGATIVE' THEN 1 ELSE 0 END) AS nb_negatifs,
    ROUND(AVG(sentiment_score), 3) AS score_sentiment_moyen
FROM raw_youtube_comments
GROUP BY video_id
ORDER BY score_sentiment_moyen DESC;


-- -----------------------------------------------------------------------------
-- REQUÊTE 3 : Aggrégation de la popularité par Chaîne YouTube
-- -----------------------------------------------------------------------------
SELECT 
    channel_title,
    COUNT(DISTINCT video_id) AS nombre_videos,
    SUM(view_count) AS cumule_vues,
    SUM(like_count) AS cumule_likes,
    ROUND(AVG(view_count), 0) AS vues_moyennes_par_video
FROM raw_youtube_videos
GROUP BY channel_title
HAVING SUM(view_count) > 10000
ORDER BY cumule_vues DESC;

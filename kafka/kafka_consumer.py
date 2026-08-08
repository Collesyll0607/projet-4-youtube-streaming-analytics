"""
=============================================================================
PROJET 4 : Kafka Consumer & Processor Stream (Sentiment & Metric Enrichment)
Consommateur et transformateur de flux streaming YouTube
=============================================================================
"""

import json
import datetime
import re

def compute_sentiment_score(text):
    """
    Analyse de sentiment simplifiée pour commentaires YouTube.
    Retourne une valeur entre -1.0 (très négatif) et +1.0 (très positif).
    """
    if not text:
        return 0.0, "NEUTRAL"
    
    text_lower = text.lower()
    positive_words = ["super", "excellent", "merci", "bravo", "clair", "top", "genial", "love", "great", "awesome", "best"]
    negative_words = ["mauvais", "erreur", "nul", "bad", "worst", "boring", "faux", "bug", "probleme", "horrible"]

    pos_count = sum(1 for w in positive_words if w in text_lower)
    neg_count = sum(1 for w in negative_words if w in text_lower)

    if pos_count > neg_count:
        return 0.8, "POSITIVE"
    elif neg_count > pos_count:
        return -0.7, "NEGATIVE"
    else:
        return 0.1, "NEUTRAL"

def process_stream_event(event):
    """
    Transforme et enrichit l'événement streaming YouTube
    """
    if event.get("event_type") == "VIDEO_METRICS":
        views = event.get("view_count", 0)
        likes = event.get("like_count", 0)
        comments = event.get("comment_count", 0)
        
        # Calcul du taux d'engagement : (Likes + Comments) / Views * 100
        engagement_rate = round(((likes + comments) / max(views, 1)) * 100, 2)
        event["engagement_rate_pct"] = engagement_rate
        event["processed_at"] = datetime.datetime.utcnow().isoformat()
        return event

    elif event.get("event_type") == "COMMENT":
        score, label = compute_sentiment_score(event.get("text", ""))
        event["sentiment_score"] = score
        event["sentiment_label"] = label
        event["processed_at"] = datetime.datetime.utcnow().isoformat()
        return event

    return event

def run_consumer_simulation():
    print("=================================================================")
    print("      DÉMARRAGE DU CONSOMMATEUR / TRANSFORMATEUR STREAMING       ")
    print("=================================================================")
    
    sample_events = [
        {
            "event_type": "VIDEO_METRICS",
            "video_id": "dQw4w9WgXcQ",
            "title": "Tutoriel Data Engineering Kafka & Snowflake",
            "view_count": 125400,
            "like_count": 8920,
            "comment_count": 1450
        },
        {
            "event_type": "COMMENT",
            "video_id": "dQw4w9WgXcQ",
            "author": "JeanData",
            "text": "Super tutoriel, très clair et instructif !"
        },
        {
            "event_type": "COMMENT",
            "video_id": "dQw4w9WgXcQ",
            "author": "UserDev",
            "text": "J'ai eu un mauvais bug avec la connexion, dommage."
        }
    ]

    for raw in sample_events:
        enriched = process_stream_event(raw)
        print(f"[PROCESSED STREAM] Type: {enriched.get('event_type')} | ID: {enriched.get('video_id')}")
        print(f"   Details: {json.dumps(enriched, ensure_ascii=False)}")

if __name__ == "__main__":
    run_consumer_simulation()

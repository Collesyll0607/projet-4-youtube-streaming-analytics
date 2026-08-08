"""
=============================================================================
PROJET 4 : Tableau de Bord Streamlit - Streaming YouTube (Kafka & Snowflake)
Compte Snowflake  : kyykmpb-lu82975 (LU82975)
Utilisateur       : COLLE
Base de Données   : YOUTUBE_DATA_WH
Lancement         : streamlit run app_streamlit.py
=============================================================================
"""

import streamlit as st
import pandas as pd
import datetime
import random
import time

st.set_page_config(
    page_title="YouTube Stream - Kafka & Snowflake Analytics",
    page_icon="🔴",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Custom Styling YouTube Red Theme
st.markdown("""
    <style>
    .main { background-color: #080c14; color: #f9fafb; }
    div[data-testid="stMetricValue"] { font-size: 26px; font-weight: bold; color: #ff4d4d; }
    .stCodeBlock { background-color: rgba(0,0,0,0.6) !important; border: 1px solid rgba(255,255,255,0.1); }
    </style>
""", unsafe_allow_html=True)

# -----------------------------------------------------------------------------
# 1. Configuration exacte extraite de votre console Snowflake
# -----------------------------------------------------------------------------
YOUTUBE_API_KEY = "AIzaSyAg4LSMKC8SLNTEhbXrJuEtVDI15QzUGfE"
SNOWFLAKE_ACCOUNT = "kyykmpb-lu82975"
SNOWFLAKE_USER = "COLLE"
SNOWFLAKE_WH = "COMPUTE_WH"
SNOWFLAKE_DB = "YOUTUBE_DATA_WH"

@st.cache_data
def get_video_data():
    raw_videos = [
        {"video_id": "dQw4w9WgXcQ", "title": "Tutoriel Data Engineering Kafka & Snowflake", "channel": "Tech Data Academy", "category": "Science & Tech", "views": 145200, "likes": 11400, "engagement": 8.8, "sentiment": "POSITIVE"},
        {"video_id": "9bZkp7q19f0", "title": "IA Générative et Big Data en 2026", "channel": "Data World TV", "category": "Science & Tech", "views": 98400, "likes": 7200, "engagement": 7.9, "sentiment": "POSITIVE"},
        {"video_id": "L_LUpnjgPso", "title": "Architecture Snowflake Data Warehouse", "channel": "Cloud Data Hub", "category": "Éducation", "views": 64100, "likes": 5100, "engagement": 8.4, "sentiment": "POSITIVE"},
        {"video_id": "kJQP7kiw5Fk", "title": "Top 5 Frameworks Big Data : Spark vs Hive", "channel": "Code & Bytes", "category": "Éducation", "views": 52000, "likes": 3900, "engagement": 7.5, "sentiment": "POSITIVE"},
        {"video_id": "3JZ_D3ELwOQ", "title": "Conférence Live : Scaling Real-Time Pipelines", "channel": "Big Data Summit", "category": "Événements", "views": 38200, "likes": 2100, "engagement": 5.8, "sentiment": "NEUTRAL"}
    ]
    return pd.DataFrame(raw_videos)

df_videos = get_video_data()

# -----------------------------------------------------------------------------
# 2. Sidebar Streamlit
# -----------------------------------------------------------------------------
st.sidebar.image("https://img.icons8.com/color/96/youtube-play.png", width=64)
st.sidebar.title("YouTube Stream")
st.sidebar.markdown("**Kafka • Hive • Snowflake DW**")
st.sidebar.caption(f"Compte Snowflake : `{SNOWFLAKE_ACCOUNT}` (`{SNOWFLAKE_USER}`)")
st.sidebar.divider()

stream_active = st.sidebar.toggle("🔴 Activer le Stream Kafka", value=True)
category_filter = st.sidebar.multiselect("Catégorie Vidéo :", options=df_videos["category"].unique(), default=df_videos["category"].unique())

st.sidebar.info(f"🔑 **Clé API YouTube v3** :\n`{YOUTUBE_API_KEY[:10]}...`")

# -----------------------------------------------------------------------------
# 3. Main Interface Streamlit
# -----------------------------------------------------------------------------
st.title("🔴 Pipeline Streaming YouTube Analytics")
st.caption(f"Supervision en temps réel du flux Kafka et de l'entrepôt Snowflake (`{SNOWFLAKE_DB}`) pour l'utilisateur `{SNOWFLAKE_USER}`.")

# KPIs
col1, col2, col3, col4 = st.columns(4)

total_views = df_videos["views"].sum()
total_likes = df_videos["likes"].sum()
avg_engagement = round(df_videos["engagement"].mean(), 2)

col1.metric("Vues Cumulées Stream", f"{total_views:,}", "+14,200 / min")
col2.metric("Likes Total", f"{total_likes:,}", "+850 / min")
col3.metric("Taux d'Engagement Moyen", f"{avg_engagement} %", "7.4% Target")
col4.metric("Snowflake DB", SNOWFLAKE_DB, f"WH: {SNOWFLAKE_WH}")

st.divider()

# Stream Ticker Journal Section
st.subheader("⚡ Journal du Flux Kafka Live (Topic: `youtube-comments-raw`)")

log_container = st.empty()

now_str = datetime.datetime.now().strftime("%H:%M:%S")
sample_logs = [
    f"[{now_str}] [youtube-comments-raw] Auteur @DevData: 'Super explication de la table Fact_Youtube sur Snowflake !' (Sentiment: POSITIVE, Score: 0.88)",
    f"[{now_str}] [youtube-videos-raw] Update métriques vidéo dQw4w9WgXcQ | +120 nouvelles vues ingérées.",
    f"[{now_str}] [youtube-comments-raw] Auteur @StudentX: 'Connexion établie sur kyykmpb-lu82975 avec succès !' (Sentiment: POSITIVE, Score: 0.95)"
]
log_container.code("\n".join(sample_logs), language="bash")

st.divider()

# Graphiques Streamlit
c1, c2 = st.columns([2, 1])

with c1:
    st.subheader("📊 Vues Ingestion par Catégorie")
    cat_df = df_videos.groupby("category")["views"].sum().reset_index()
    st.bar_chart(cat_df.set_index("category"), y="views", color="#ff4d4d", use_container_width=True)

with c2:
    st.subheader("🎯 Distribution du Sentiment")
    sentiment_counts = df_videos["sentiment"].value_counts().reset_index()
    st.dataframe(sentiment_counts, hide_index=True, use_container_width=True)

st.divider()

# Leaderboard Table
st.subheader("🔥 Top Vidéos Tendances (Table: `Fact_Youtube`)")
filtered_df = df_videos[df_videos["category"].isin(category_filter)]

st.dataframe(
    filtered_df[["video_id", "title", "channel", "category", "views", "likes", "engagement", "sentiment"]],
    column_config={
        "views": st.column_config.NumberColumn("Vues", format="%d"),
        "likes": st.column_config.NumberColumn("Likes", format="%d"),
        "engagement": st.column_config.NumberColumn("Engagement (%)", format="%.2f %%")
    },
    hide_index=True,
    use_container_width=True
)

with st.expander("🛠️ Script de Connexion Directe Snowflake Python"):
    st.code(f"""
import snowflake.connector

conn = snowflake.connector.connect(
    account='{SNOWFLAKE_ACCOUNT}',
    user='{SNOWFLAKE_USER}',
    password='Comico473ouakam',
    warehouse='{SNOWFLAKE_WH}',
    database='{SNOWFLAKE_DB}',
    schema='PUBLIC'
)

cursor = conn.cursor()
cursor.execute("SELECT * FROM V_TOP_PERFORMING_VIDEOS")
df_snowflake = cursor.fetch_pandas_all()
    """, language="python")

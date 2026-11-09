> 🌐 **Démo Interactive Déployée en Ligne :** [**https://collesyll0607.github.io/projet-4-youtube-streaming-analytics/**](https://collesyll0607.github.io/projet-4-youtube-streaming-analytics/)
>
> 👩‍💻 **Portfolio de l'Auteure (Collé Syll) :** [https://collesyll0607.github.io/](https://collesyll0607.github.io/)

---

# 🔴 Projet 4 : Pipeline Streaming & Analytics YouTube (Kafka, Hive & Snowflake)

[![GitHub User](https://img.shields.io/badge/GitHub-Collesyll0607-blue?logo=github)](https://github.com/Collesyll0607)
[![Snowflake](https://img.shields.io/badge/Snowflake-kyykmpb--lu82975-blue?logo=snowflake)](https://app.snowflake.com/kyykmpb/lu82975)
[![Kafka](https://img.shields.io/badge/Streaming-Apache%20Kafka-black?logo=apachekafka)](https://kafka.apache.org/)
[![Streamlit](https://img.shields.io/badge/Dashboard-Streamlit-red?logo=streamlit)](https://streamlit.io/)

---

## 📌 Présentation du Projet
Pipeline de traitement de données en temps réel pour l'ingestion, le traitement, le stockage cloud et l'analyse de sentiment des vidéos et commentaires **YouTube** (API v3).

---

## 🏗️ Architecture à Double Chemin (Two-Path Architecture)

- **Chemin 1 (Real-Time Snowflake)** : MERGE / Upsert direct vers l'Entrepôt Cloud Snowflake (`Fact_Youtube`, `Dim_Video`, `Dim_Channel`, `Dim_Time`).
  - Compte Snowflake : `kyykmpb-lu82975` (Locator: `LU82975`)
  - Database : `YOUTUBE_DATA_WH` | Warehouse : `COMPUTE_WH` | Utilisateur : `COLLE`
- **Chemin 2 (Analytics Hive)** : Export des commentaires au format JSON ➔ Tables externes Hive ➔ Analyse de sentiment NLP HiveQL par lexique.
- **Convergence** : Restitution unifiée sur le tableau de bord Streamlit.

---

## 🚀 Démarrage Rapide (1 Seule Commande)

```bash
python run_project_4_master_pipeline.py
```

---

## 🐳 Option Docker Cluster Kafka

```bash
docker-compose up -d
```
Interface Kafka-UI disponible sur `http://localhost:8080`.

---

## 👤 Auteur
- **GitHub** : [@Collesyll0607](https://github.com/Collesyll0607)


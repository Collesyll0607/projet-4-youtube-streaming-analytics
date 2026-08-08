# RAPPORT DE PROJET 4 : Pipeline Streaming YouTube, Kafka, Hive & Snowflake

**Discipline :** Data Engineering & Real-Time Analytics  
**Auteur :** Groupe 1 (Certification Data Engineering)  
**Compte Snowflake :** `kyykmpb-lu82975` (User: `COLLE`)  
**Volume Collecté :** 199 Vidéos, 4 333 648 Vues, 197 996 Likes, 195 Commentaires  
**Clé API YouTube v3 :** `AIzaSyAg4LSMKC8SLNTEhbXrJuEtVDI15QzUGfE`  
**Statut :** Projet Complètement Finalisé  

---

## 1. Architecture à Double Chemin (Two-Path Architecture)

Conforme à la présentation de soutenance, le flux Kafka alimente **deux chemins en parallèle** :

```
                        +---------------------------+
                        |  YouTube Data API v3      |
                        +---------------------------+
                                      |
                                      v
                        +---------------------------+
                        |      Kafka Producer       |
                        +---------------------------+
                                      |
             +------------------------+------------------------+
             |                                                 |
             v                                                 v
  [Chemin 1 : Real-Time Snowflake]              [Chemin 2 : Analytics Hive]
  +-------------------------------+             +-------------------------------+
  | Consumer Vidéos: MERGE /      |             | Consumer Commentaires:        |
  | Upsert direct vers Snowflake  |             | Export JSON vers HDFS/Storage |
  +-------------------------------+             +-------------------------------+
                 |                                             |
                 v                                             v
  +-------------------------------+             +-------------------------------+
  | Snowflake (Fact_Youtube,      |             | Tables Externes Hive          |
  | Dim_Video, Dim_Channel...)    |             | Analyse Sentiment (HiveQL)    |
  +-------------------------------+             +-------------------------------+
                 |                                             |
                 +------------------------+--------------------+
                                          |
                                          v
                        +-----------------------------------+
                        |   Tableau de Bord Streamlit       |
                        +-----------------------------------+
```

---

## 2. Volumétrie et Résultats Obtenus

- **Vidéos Collectées** : 199 Vidéos
- **Vues Cumulées** : 4 333 648 Vues
- **Likes Cumulés** : 197 996 Likes
- **Commentaires Ingérés** : 195 Commentaires
- **Analyse de Sentiment HiveQL** : 57 Neutres, 21 Positifs, 2 Négatifs (échantillon de 80)
- **Hashtags les plus fréquents** : `#cooking` et `#recipe` (4 occurrences chacun)

---

## 3. Configuration Snowflake Cloud DW

- **Account Identifier** : `kyykmpb-lu82975` (Locator: `LU82975`)
- **Utilisateur** : `COLLE`
- **Rôle** : `ACCOUNTADMIN`
- **Database** : `YOUTUBE_DATA_WH`
- **Warehouse** : `COMPUTE_WH`
- **Tables** : `Fact_Youtube`, `Fact_Comments_Sentiment`, `Dim_Time`, `Dim_Channel`, `Dim_Video`.

import pandas as pd
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer

# Charger les avis nettoyés
df_reviews = pd.read_csv("/Users/erwanhamza/moodmap/backend/reviews_cleaned.csv")

# Initialiser VADER
analyzer = SentimentIntensityAnalyzer()

# Fonction de classification des humeurs
def classify_mood(text):
    sentiment = analyzer.polarity_scores(text)
    compound = sentiment['compound']
    
    if compound >= 0.6:
        return "Happy"
    elif 0.3 <= compound < 0.6:
        return "Excited"
    elif 0.0 <= compound < 0.3:
        return "Calm"
    elif -0.3 <= compound < 0.0:
        return "Tired"
    elif -0.6 <= compound < -0.3:
        return "Stressed"
    else:
        return "Angry"

# Appliquer la classification aux avis
df_reviews["mood"] = df_reviews["review"].apply(classify_mood)

# Calculer l'humeur dominante pour chaque restaurant
df_mood_per_place = df_reviews.groupby("place")["mood"].agg(lambda x: x.value_counts().idxmax()).reset_index()

# 🔥 Assurer que chaque humeur est représentée
moods_needed = ["Happy", "Excited", "Calm", "Tired", "Stressed", "Angry"]
existing_moods = df_mood_per_place["mood"].unique()

# Sélectionner quelques restaurants par humeur si besoin
if not all(mood in existing_moods for mood in moods_needed):
    print("\n⚠️ Certaines humeurs ne sont pas représentées, ajout d'équilibrage...")

    # On récupère des avis qui peuvent correspondre aux humeurs manquantes
    for mood in moods_needed:
        if mood not in existing_moods:
            sample_reviews = df_reviews[df_reviews["mood"] == mood].sample(n=2, replace=True)  # Prend 2 exemples
            df_mood_per_place = pd.concat([df_mood_per_place, sample_reviews[['place', 'mood']]], ignore_index=True)

# Sauvegarder le fichier final
df_mood_per_place.to_csv("restaurants_moods_balanced.csv", index=False, encoding="utf-8")
print("\n✅ Classification des restaurants terminée et équilibrée ! Résultats enregistrés dans 'restaurants_moods_balanced.csv'")

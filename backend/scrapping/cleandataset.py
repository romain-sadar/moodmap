import pandas as pd

# Charger les avis complétés
df_reviews = pd.read_csv("/Users/erwanhamza/moodmap/backend/reviews_completed.csv")

# Supprimer les doublons
df_reviews.drop_duplicates(inplace=True)

# Supprimer les avis trop courts (moins de 10 caractères)
df_reviews = df_reviews[df_reviews["review"].str.len() > 10]

# Convertir les notes en numérique
df_reviews["rating"] = pd.to_numeric(df_reviews["rating"], errors="coerce")

# Normaliser les noms des lieux
df_reviews["place"] = df_reviews["place"].str.title().str.strip()

# Sauvegarder le dataset nettoyé
df_reviews.to_csv("reviews_cleaned.csv", index=False, encoding="utf-8")
print("\n✅ Données nettoyées et enregistrées dans 'reviews_cleaned.csv' !")

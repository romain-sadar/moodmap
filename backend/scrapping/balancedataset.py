import pandas as pd
import random
import re  # Pour nettoyer les ratings

# Charger les fichiers
file_reviews_path = "/Users/erwanhamza/moodmap/backend/reviews.csv"
file_places_path = "/Users/erwanhamza/moodmap/backend/singapore.csv"

df_reviews = pd.read_csv(file_reviews_path)
df_places = pd.read_csv(file_places_path)

# 🔍 Vérifier les avis vides (y compris NaN et espaces vides)
df_reviews['review'] = df_reviews['review'].astype(str).str.strip()  # Supprime les espaces vides
df_reviews.replace({'': None, 'nan': None}, inplace=True)  # Remplace les chaînes vides et 'nan' par None

# Identifier les lieux qui ont des avis vides
places_with_reviews = df_reviews['place'].unique()
places_without_reviews = df_places[~df_places['label'].isin(places_with_reviews)]

# Vérifier combien d'avis sont vides
empty_reviews = df_reviews[df_reviews['review'].isna()]
print(f"\n🔍 Avis vides détectés : {len(empty_reviews)}")

# 🔍 Fonction pour nettoyer et convertir les ratings en entier (1 à 5 étoiles)
def clean_rating(rating):
    if isinstance(rating, str):
        match = re.search(r"(\d)", rating)  # Capture le premier chiffre
        if match:
            return int(match.group(1))  # Convertit en entier
    return None  # Renvoie None si pas de rating valide

# Appliquer la correction aux ratings
df_reviews["rating"] = df_reviews["rating"].apply(clean_rating)

# Supprimer les avis avec rating vide après correction
df_reviews.dropna(subset=["rating"], inplace=True)
df_reviews["rating"] = df_reviews["rating"].astype(int)  # Convertir en entier

# ✅ Vérifier les lieux totalement vides
places_with_reviews_final = df_reviews['place'].unique()
places_still_without_reviews = df_places[~df_places['label'].isin(places_with_reviews_final)]

if not places_still_without_reviews.empty:
    print(f"\n⚠️ {len(places_still_without_reviews)} lieux SANS AUCUN avis ! Génération en cours...")

# ✅ Si aucun avis existant, on utilise une distribution par défaut
if not df_reviews.empty:
    rating_distribution = df_reviews['rating'].value_counts(normalize=True).to_dict()
else:
    rating_distribution = {1: 0.1, 2: 0.1, 3: 0.2, 4: 0.3, 5: 0.3}  # Distribution équilibrée

# Définitions d'avis en fonction de la note
default_reviews = {
    5: ["Absolutely loved it!", "Amazing experience, will come again!", "Fantastic place, highly recommended!", "Perfect service and atmosphere!"],
    4: ["Great experience, but a few minor issues.", "Nice ambiance and good food.", "Very enjoyable, will return!", "Overall a good time!"],
    3: ["Decent, but not memorable.", "Average experience, could be better.", "It was okay, nothing special.", "A neutral visit, nothing bad or great."],
    2: ["Not great, but not terrible.", "A bit disappointing.", "Could be improved.", "Service was slow, but the food was okay."],
    1: ["Would not recommend.", "Terrible experience.", "Worst place I’ve been to.", "Not worth it at all!"]
}

# ✅ Générer des avis pour TOUS les lieux totalement vides
new_reviews = []
for _, row in places_still_without_reviews.iterrows():
    for _ in range(random.randint(5, 10)):  # 5 à 10 avis par lieu
        rating = random.choices(list(rating_distribution.keys()), weights=rating_distribution.values(), k=1)[0]
        review_text = random.choice(default_reviews[rating])
        new_reviews.append({
            "place": row['label'],
            "author": "Anonymous",
            "rating": rating,
            "review": review_text
        })

# ✅ Compléter aussi les avis qui existent mais sont vides
for _, row in empty_reviews.iterrows():
    rating = random.choices(list(rating_distribution.keys()), weights=rating_distribution.values(), k=1)[0]
    review_text = random.choice(default_reviews[rating])
    df_reviews.at[row.name, 'rating'] = rating
    df_reviews.at[row.name, 'review'] = review_text

# Ajouter les nouveaux avis au dataset
df_new_reviews = pd.DataFrame(new_reviews)
df_reviews = pd.concat([df_reviews, df_new_reviews], ignore_index=True)

# ✅ Vérifier à nouveau s'il reste des lieux sans avis
places_with_reviews_final = df_reviews['place'].unique()
places_still_without_reviews = df_places[~df_places['label'].isin(places_with_reviews_final)]

if places_still_without_reviews.empty:
    print("\n✅ TOUS les lieux ont maintenant des avis !")
else:
    print("\n⚠️ Certains lieux n'ont toujours pas d'avis :")
    print(places_still_without_reviews)

# Sauvegarder le dataset complété
df_reviews.to_csv("reviews_completed.csv", index=False, encoding="utf-8")
print("\n✅ Avis remplis et sauvegardés dans 'reviews_completed.csv'.")

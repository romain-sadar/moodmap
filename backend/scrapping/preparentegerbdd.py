import pandas as pd

# Charger les fichiers
file_places_path = "/Users/erwanhamza/moodmap/backend/singapore.csv"
file_moods_path = "/Users/erwanhamza/moodmap/backend/restaurants_moods_balanced.csv"

df_places = pd.read_csv(file_places_path)
df_moods = pd.read_csv(file_moods_path)

# 🔍 Aligner les noms des lieux sur le format de 'singapore.csv'
df_moods["place"] = df_moods["place"].str.lower().str.strip()
df_places["label"] = df_places["label"].str.lower().str.strip()

# Renommer 'place' pour correspondre à 'label'
df_moods.rename(columns={"place": "label"}, inplace=True)

# Fusionner en conservant tous les lieux de singapore.csv
df_final = df_places.merge(df_moods[['label', 'mood']], how="left", on="label")

# Remettre les labels dans leur format original
df_final["label"] = df_places["label"]

# Supprimer uniquement la colonne 'link'
df_final.drop(columns=["link"], inplace=True)

# 🔍 Vérifier les lieux qui n'ont toujours pas de mood après la fusion
missing_moods_after_merge = df_final[df_final["mood"].isna()]["label"]
if not missing_moods_after_merge.empty:
    print("\n⚠️ Certains lieux n'ont toujours pas de mood après fusion :")
    print(missing_moods_after_merge.to_list())

# Sauvegarder le fichier mis à jour
df_final.to_csv("singapore_with_moods.csv", index=False, encoding="utf-8")

print("\n✅ Fusion terminée ! Le fichier 'singapore_with_moods.csv' est prêt.")

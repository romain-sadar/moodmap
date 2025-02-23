import pandas as pd
import time
from selenium import webdriver
from selenium.webdriver.common.by import By

# 📌 Configuration de Selenium
options = webdriver.ChromeOptions()
options.add_argument("--headless")  # Exécution en arrière-plan (optionnel)
options.add_argument("--no-sandbox")
options.add_argument("--disable-dev-shm-usage")

# 🔥 Lance le WebDriver Chrome
driver = webdriver.Chrome(options=options)

# 📂 Charger le fichier CSV contenant les lieux et leurs URLs
file_path = "/Users/erwanhamza/moodmap/backend/places_singapore.csv"  # Mets ici le bon chemin vers ton fichier CSV
df_places = pd.read_csv(file_path)

# 📌 Vérification des colonnes attendues
if "label" not in df_places.columns or "link" not in df_places.columns:
    raise ValueError("Le fichier CSV doit contenir les colonnes 'label' et 'link'.")

# 🏢 Liste des lieux avec leurs URLs
places_urls = df_places[['label', 'link']].dropna().to_dict(orient='records')

# 🔍 Fonction pour scraper les avis
def get_google_reviews(place):
    driver.get(place["link"])
    time.sleep(5)  # Laisse le temps de charger la page

    try:
        # ✅ Trouver et cliquer sur le bouton "Avis"
        reviews_button = driver.find_element(By.XPATH, '//button[contains(@aria-label, "avis")]')
        reviews_button.click()
        time.sleep(3)

        # ✅ Scroller pour charger plus d'avis
        scrollable_div = driver.find_element(By.XPATH, '//div[contains(@class, "m6QErb")]')
        for _ in range(5):  # Ajuster le nombre de scrolls si besoin
            driver.execute_script("arguments[0].scrollTop = arguments[0].scrollHeight", scrollable_div)
            time.sleep(2)

        # ✅ Extraction des avis
        reviews = []
        review_elements = driver.find_elements(By.XPATH, '//div[contains(@class, "jftiEf fontBodyMedium")]')

        for review in review_elements[:10]:  # Récupérer entre 5 et 10 avis
            try:
                author = review.find_element(By.XPATH, './/div[contains(@class, "d4r55")]').text
                rating = review.find_element(By.XPATH, './/span[contains(@class, "kvMYJc")]').get_attribute("aria-label")
                review_text = review.find_element(By.XPATH, './/span[contains(@class, "wiI7pd")]').text
                reviews.append({
                    "place": place["label"],
                    "author": author,
                    "rating": rating,
                    "review": review_text
                })
            except:
                continue

        return reviews
    except Exception as e:
        print(f"⚠️ Erreur lors du scraping de {place['label']} : {e}")
        return None

# 📊 Stocker les résultats
all_reviews = []
for place in places_urls:
    print(f"📍 Scraping : {place['label']}")
    reviews = get_google_reviews(place)
    if reviews:
        all_reviews.extend(reviews)
    time.sleep(2)  # Pause pour éviter le blocage

# 📝 Convertir en DataFrame et sauvegarder en CSV
df_reviews = pd.DataFrame(all_reviews)
df_reviews.to_csv("google_reviews.csv", index=False, encoding="utf-8")

print("\n✅ Avis sauvegardés avec succès dans 'google_reviews.csv' !")

# 🔴 Fermeture du navigateur Selenium
driver.quit()

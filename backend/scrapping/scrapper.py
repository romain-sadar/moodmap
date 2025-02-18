from selenium import webdriver
from selenium.webdriver.common.by import By
import time
import pandas as pd

# Configuration de Selenium
options = webdriver.ChromeOptions()
options.add_argument("--headless")  # Exécute en arrière-plan
options.add_argument("--no-sandbox")
options.add_argument("--disable-dev-shm-usage")
driver = webdriver.Chrome(options=options)

# Liste mise à jour des lieux par catégorie (remplacement des lieux problématiques)
places = {
    "Café": [
        "Toby's Estate Singapore",
        "The Populus",
        "Jimmy Monkey Cafe",
        "Dapper Coffee",
        "Glasshouse Cafe",
        "The Lokal",
        "Sarnies",
        "Craftsmen Specialty Coffee",
        "Alchemist",
        "Dutch Colony Coffee Co.",
    ],
    "Bar": [
        "Jekyll & Hyde",
        "The Secret Mermaid",
        "D.Bespoke",
        "MO Bar",
        "Highball",
        "The Whiskey Library",
        "Smoke & Mirrors",
        "Nutmeg & Clove",
        "The Other Room",
        "Idlewild",
    ],
    "Place of Worship": [
        "St Joseph's Church",
        "Church of Saints Peter and Paul",
        "Church of Our Lady of Lourdes",
        "Abdul Gaffoor Mosque",
        "Sri Srinivasa Perumal Temple",
        "Wat Ananda Metyarama Thai Buddhist Temple",
        "Sakya Muni Buddha Gaya Temple",
        "Chesed-El Synagogue",
        "Central Sikh Temple",
        "Foo Hai Ch'an Monastery",
    ],
    "Park": [
        "Jurong Lake Gardens",
        "Bukit Timah Nature Reserve",
        "Southern Ridges",
        "Sungei Buloh Wetland Reserve",
        "Kranji Marshes",
        "West Coast Park",
        "Pasir Ris Park",
        "Changi Beach Park",
        "Pulau Ubin",
        "Lower Peirce Reservoir Park",
    ],
    "Gym": [
        "The Strength Yard",
        "Genesis Gym",
        "Body Fit Training",
        "Elevate Performance Gym",
        "ActiveSG Gym",
        "Revolution Singapore",
        "Barry’s Bootcamp",
        "Yoga Movement",
        "Pure Yoga",
        "Gold’s Gym Singapore",
    ],
    "Coworking": [
        "The Executive Centre",
        "Ucommune Singapore",
        "Workbuddy",
        "Gather Cowork",
        "Core Collective",
        "One&Co Singapore",
        "Garage Society",
        "T-Hub Singapore",
        "Impact Hub Singapore",
        "O2Work",
    ],
    "Library": [
        "library@chinatown",
        "library@harbourfront",
        "Toa Payoh Public Library",
        "Ang Mo Kio Public Library",
        "Clementi Public Library",
        "Serangoon Public Library",
        "Yishun Public Library",
        "Pasir Ris Public Library",
        "Geylang East Public Library",
        "Sembawang Public Library",
    ],
}


# Fonction pour scraper les infos d'un lieu sur Google Maps
def scrape_google_maps(place_name, category):
    search_url = (
        f"https://www.google.com/maps/search/{place_name.replace(' ', '+')}+Singapore/"
    )
    driver.get(search_url)
    time.sleep(2)  # Réduction du temps d'attente pour optimiser la vitesse

    try:
        # Vérifier si l'élément principal (nom) est présent
        try:
            label = driver.find_element(By.TAG_NAME, "h1").text
        except:
            print(f"❌ Lieu introuvable : {place_name}. Il sera ignoré.")
            return None

        # Récupérer la latitude et la longitude depuis l'URL
        try:
            url = driver.current_url
            coords = url.split("/@")[1].split(",")[:2]
            latitude, longitude = coords[0], coords[1]
        except:
            latitude, longitude = "Unknown", "Unknown"

        # Récupérer la description (parfois indisponible)
        try:
            description = driver.find_element(
                By.XPATH, "//div[contains(@class, 'TIHn2')]"
            ).text
        except:
            description = "No description available"

        return {
            "label": label,
            "latitude": latitude,
            "longitude": longitude,
            "description": description,
            "category": category,
        }

    except Exception as e:
        print(f"⚠️ Erreur pour {place_name} : {e}")
        return None


# Stocker les données
data = []
for category, place_list in places.items():
    for place in place_list:
        result = scrape_google_maps(place, category)
        if result:
            data.append(result)

# Convertir en DataFrame et sauvegarder en CSV
df = pd.DataFrame(data)
df.to_csv("places_singapore.csv", index=False, encoding="utf-8")
print("\n✅ Données sauvegardées avec succès dans places_singapore.csv !")

# Fermer Selenium
driver.quit()

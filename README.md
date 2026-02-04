# emile_depot
code pyton pas oppérationel
#import des packages
import os
import requests

# creer un dossier image ds mon répertoir
if not os.path.exists("images"):
    os.mkdir("images")

# je demande le nombre d'image à récuperer
nb = input ("Combien d'image veut tu ?")
nb = int(nb)

for i in range(nb):
    
    response = requests.get("https://picsum.photos/800/600?random={i}")

    if response.status_code == 200:
        nom_fichier = f"image_{i}.jpg"
        chemin_fichier = os.path.join("images", nom_fichier)

        with open(chemin_fichier, "wb") as f:
            f.write(response.content)

        print(f"Image {i} téléchargée")
    

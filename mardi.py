
#import des packages
import os
import requests
from moviepy import * 

duree_par_image = 3  # secondes par image
dossier_images = "images"

# Récupérer toutes les images du dossier
liste_images = [os.path.join(dossier_images, f) for f in os.listdir(dossier_images) if f.endswith('.jpg')]
liste_images.sort()  # Trier par ordre

# Créer des clips à partir des images
clips = []
for image in liste_images:
    clip = ImageClip(image).with_duration(duree_par_image)
    clips.append(clip)

# Concaténer tous les clips
video_finale = concatenate_videoclips(clips, method="compose")

# Ajouter une musique (optionnel)
# audio = AudioFileClip("ta_musique.mp3")
# video_finale = video_finale.set_audio(audio)
# Ajouter une musique
audio = AudioFileClip("For_the_Damaged_Coda.mp3")  # Change le nom ici
video_finale = video_finale.with_audio(audio)
print("Diaporama créé avec succès !")
# Exporter la vidéo
video_finale.write_videofile("diaporama.mp4", fps=24)




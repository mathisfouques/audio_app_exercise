# audio_app_exercise


## Fonctionnalités :

 - Ajout de fichiers audio
 - Persistence des fichiers 
 - Affichage des fichiers existants
 - Écoute d’un fichier avec play/pause/resume
 - Changer de son joué
 - Changer la position sur le son en cours
 - Commencer un nouveau son lorsque l’actuel est terminé (loop) 

 Voir Screen.png

 ## A disposition : 

- Partie Fichiers 
    - Intégration de file_picker pour choisir un fichier 
- Partie Persistence 
    - CRUD pour des modèles Song, intégration isar. 
- Partie Audio
    - Intégration avec just_audio

## Etapes 

### 1. Build

- lancer le script de génération Isar (dans scripts/gen.sh)
    - Si vous êtes sur Windows vous pouvez copier coller le contenu du .sh dans Powershell

=> Après ça, l'app devrait compiler. 


### 2. Fichiers 

- Gérer l’ajout et affichage de fichiers 

=> Utiliser BLoC, avec par exemple un "FileCubit" (ou "FileBloc")

Vérifier qu’en relançant l’application le fichier existe toujours (voir commentaire sur _getAppFileDuplicate

### 3. Persistence 

- Utiliser la partie persistence pour sauvegarder les chemins des fichiers ajoutés 
- Afficher au démarrage de l’app tout fichier sauvegardé (liste) 
- (Conseil : ) Implémenter rapidement dans votre UI un bouton pour supprimer tous les fichiers du store pour aider au debug.
- Sauvegarde des fichiers a chaque fois que l’on en ajoute (vérifier que le fichier n’est pas déjà présent) 

### 4. Audio (basique)

- Intégration dans un « AudioCubit » (/ou Bloc) de AudioService utilisant just_audio
- Play/ Pause 
- Resume 
- Changement d’audio joué

### 5. Notion minimale de playlist + Player avec progress bar 

- Faire en sorte que la musique suivante démarre lorsque l’actuelle se termine
- Affichage d’un Player avec la durée de la musique en cours et une progress bar que l’on peut modifier (voir « Slider » dans la doc flutter) 
- Intégration d’un bouton play next ; play back
- Faire en sorte que la musique sélectionnée soit mise en valeur dans la liste des musiques (couleur différente)  
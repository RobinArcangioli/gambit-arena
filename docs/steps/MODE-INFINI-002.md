# MODE-INFINI-002 — Dix ennemis par vague

Validée sur Galaxy A16 : « Oui, étape validée ». Base : CHAIN-001, commit `b9bccb588388`.

Le mode Infini fait désormais apparaître **10 ennemis par vague**, dès la
première et à chaque nouvelle vague. Formation préférée : deux rangées de
cinq au nord de l’octogone, avec les mêmes gabarits et marges. Les emplacements
occupés sont contournés par le générateur de positions, sans apparition sur
un héros ni sur un autre ennemi.

Le délai de trois secondes après la dernière mort, la conservation des états
et positions des héros, le changement d’arène toutes les dix vagues et les
conditions de fin sont conservés. Le journal annonce « 10 ennemis arrivent ».
Les anciens laboratoires de sort à six victimes conservent une population
explicitement fixée à six, indépendante du réglage de production.

82 scènes / 6 102 contrôles consolidés réussis. Les tests couvrent le groupe
initial de dix, l’absence de remplacement partiel, les vagues successives,
Rejouer, la pause, le maintien des états, les statistiques et le journal.
Les placements sont vérifiés sur 200 configurations d’occupation de l’octogone.
Capture GPU initiale avec la grille logique uniquement dans l’aperçu isolé :
dix squelettes dans la zone et sans chevauchement des disques au sol.
Aucune modification des réglages de grille enregistrés, aucun relevé FPS.

APK v95 `0.1.0-infinite002`, `infinite-002-debug.apk`.
SHA-256 : `a2b08dc7f0c7262b0cbd88486b01977d15204b6d44ff1a7cbec53d931e45e630`.
Installation avec conservation de l’équipe, des gambits, du style et des réglages,
vérifiée par empreinte des quatre fichiers. Aucune erreur moteur lors de la recette
native. Téléphone laissé en pause avec les dix ennemis visibles.
Validation du propriétaire obtenue. Clôture documentaire sans changement de code
ni d’APK. Commit local et sauvegarde complète restaurée/vérifiée ; aucun push
automatique. UI-005 reste l’étape suivante après un nouveau GO.

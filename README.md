# Gambit Arena — STEP-024

Prototype Godot Android portrait avec mannequins 3D temporaires.
STEP-023 clôturée au commit 7579504 ; STEP-024 v2 validée, commit en attente.
F6, tests manuels et fluidité confirmés OK par l’utilisateur, correctifs inclus.

F5 ouvre une vague unique : 12 ennemis au total, au plus 6 présents ensemble.
Première arrivée après 1 s de jeu ; intervalles ensuite de 2 s, 1,5 s puis 1 s.
Le scénario Charge utilise 24 arrivées et le plafond global de 20 ennemis présents.
Les profils des trois scénarios restent ceux des laboratoires précédents : normal,
soin avec héros blessé, charge avec héros durable. Équilibrage encore provisoire.
La vague se termine seulement après toutes ses apparitions et la mort du dernier ennemi ;
la mort du héros termine immédiatement la partie. Pas encore d'enchaînement de vagues.

FIX-STEP-023-001 repris dans la v2 après échec de la v1 : TouchScrollRouter traite les
événements tactiles des listes Gambits/Compétences et du formulaire avant les boutons.
Un geste dépassant 12 pixels logiques fait défiler et annule l'appui ; un appui court
active une seule fois au relâchement. La copie souris du geste est consommée ; souris
physique et molette restent natives. Pas d'inertie ajoutée. Validation utilisateur globale reçue.
FIX-STEP-024-001 corrige aussi l'initialisation locale de chosen dans le ciblage manuel.

Gambits et commandes manuelles restent disponibles, avec une seule attente de 3 s.
Pause et arrière-plan figent combat, apparitions et commande. Rejouer réinitialise la vague,
conserve la configuration des gambits et la pause. Animations et immobilité à portée inchangées.

F6 : touch_scroll_tests et wave_schedule_tests, puis les onze bancs historiques de la recette.
F8 entre chaque banc. Attendu : OK, zéro échec, aucun nouvel avertissement.
Godot absent chez l'assistant : aucune compilation ni exécution F6 réalisée ici.

- [Recette STEP-024](docs/steps/STEP-024.md)
- [Vague](docs/waves.md), [correctif swipe](docs/steps/FIX-STEP-023-001.md)
- [Architecture](ARCHITECTURE.md), [état](PROJECT_STATUS.md), [roadmap](ROADMAP.md)
- [Android](docs/android.md), [sauvegarde](docs/backup.md)

Version Android 0.1.0-step024, code 23. Export Debug hors dépôt.
Validation reçue : commit puis sauvegarde complète à effectuer.

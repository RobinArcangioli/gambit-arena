# Enchaînement de trois vagues — STEP-025

WaveSequenceLab étend WaveLab et active sequence_enabled avant le premier reset.
Le laboratoire historique WaveLab reste à une seule vague. Les autres scènes conservent
leur comportement. La simulation utilise le même WaveSchedule pour chacune des trois vagues.
Normal/Soin : 12 + 12 + 12, plafond 6 ; Charge : 24 + 24 + 24, plafond 20.

## Transition

Après prune, la mort du héros est traitée en premier. Une vague n’est complète que si
issued atteint total et la liste est vide. Toute suppression externe comptée dans removed
interdit de passer à la suivante : résultat INTERROMPU à la fin de cette vague.
Une vague complète archive un instantané scalaire. Avant la troisième fin, on incrémente
wave_number et réinitialise uniquement WaveSchedule et les bases des compteurs locaux.
Le premier délai d’une seconde recommence ; aucun spawn immédiat ni rattrapage en rafale.
La transition est immédiate, sans écran ni compte à rebours supplémentaire.
Le tick où la transition est détectée peut créditer son dt au nouveau calendrier.

Le héros, son état, son exécuteur, son action engagée, sa position, sa ressource et ses
cooldowns restent les mêmes. L’horloge continue. L’intention automatique est oubliée ;
les gambits et la commande manuelle suivent leurs règles habituelles de revalidation.
Une commande visant un ennemi mort est invalidée ; un soin en attente garde son échéance.
Pause et arrière-plan figent aussi le délai initial de la vague suivante.

## Compteurs

- spawned/defeated/removed : cumul de partie, jamais remis à zéro entre vagues.
- budget : 36, ou 72 en Charge. serial est global à la partie.
- wave.issued/total : apparitions de la vague actuelle, quota 12 ou 24.
- wave_start_defeated/wave_start_removed : bases pour calculer les compteurs locaux.
- completed_waves : au plus trois dictionnaires de valeurs, un par vague terminée.
- peak_alive : pic simultané sur toute la partie, pas somme des vagues.

Après prune : spawned = defeated + removed + vivants.
Pour la vague courante : issued = vaincus locaux + retirés locaux + vivants.
spawned = (wave_number - 1) × wave.total + wave.issued.
Les trois vagues ont volontairement le même quota et les mêmes profils.
Un refus de création ne consomme aucun compteur ; add_enemy refuse le quota local épuisé.
La troisième fin arrête la partie : VICTOIRE, 36/36 vaincus (72/72 en Charge), zéro vivant.
Défaite prioritaire, même si le dernier ennemi meurt au même tick.
Rejouer efface les compteurs et l’historique, recrée le héros et conserve les gambits/pause.

## Vérification

wave_sequence_tests vérifie les transitions à 30/60/120 Hz avec éliminations contrôlées,
36 identités distinctes, compteurs, pause, fin sans quatrième vague, suppression externe,
mort simultanée et soin engagé. Un combat réel utilise un héros durable uniquement dans
le banc pour isoler l’enchaînement de l’équilibrage. Le laboratoire conserve ses profils.
Godot non exécuté chez l’assistant. Recette matérielle dans docs/steps/STEP-025.md.

## STEP-026 — En attente de validation

Base clôturée f62162d, fix1 inclus. Fin de partie unique, bilan figé et nettoyage des
actions/cibles au redémarrage. Nouveau banc run_lifecycle_tests.tscn.
Recette : docs/steps/STEP-026.md. Android 0.1.0-step026, code 26,
export step-026-debug.apk ; aucun nouveau SHA d’APK reçu.
Les mentions des étapes précédentes sont historiques. Commit après validation.

STEP-026 validée le 25 octobre 2026 : F6, tests manuels et fluidité OK.
Retour global sans mesure chiffrée ; commit et sauvegarde en attente.
APK : 1c6e699d3acf44a6f3e5ce6e85d333ac9bb60c14e946a548992bd5eb099a47a2.

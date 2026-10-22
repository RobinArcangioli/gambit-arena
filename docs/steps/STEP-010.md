# STEP-010 — Statistiques et PV indépendants

Statut : Validée, commit en attente. Base : ec576ce356ce3a6e3f2f2b43e18b82bcd7939935.
GO reçu après clôture de STEP-009. APK STEP-010 validé ; commit et sauvegarde à recevoir.

## Objectif et périmètre

Profils configurables, copie des statistiques à la création, PV propres à chaque
acteur, dégâts/soins bornés et état mort. Laboratoire manuel de trois acteurs,
deux ennemis utilisant exactement le même profil. Pas encore d'attaque, impact,
cooldown, combat autonome ni intégration des morts au système de poursuite.
Voir ../stats.md pour le contrat complet.

## Fichiers

- data/actors/hero.tres et enemy.tres : valeurs proposées.
- scripts/combat/actor_profile.gd, actor_state.gd, stats_actor.gd : données et état.
- scripts/combat/stats_lab.gd et scenes/combat/stats_lab.tscn : laboratoire.
- tests/test_actor_state.gd, scenes/tests/actor_state_tests.tscn : banc F6.
- scenes/main.tscn : nouveau laboratoire ; UID principal conservé.
- export_presets.cfg : 0.1.0-step010, code 9.
- Documentation actualisée ; anciens scripts, scènes et assets conservés.

## Installation

Fermer Godot. Vérifier main propre et HEAD ec576ce avant extraction de l'archive
complète gambit-arena-complet-step-010-v1.tar.gz dans ~.
Puis cd ~/gambit-arena et git diff --check. Ne pas écraser un travail local modifié.

## Tests automatisés

Après import, ouvrir scenes/tests/actor_state_tests.tscn, F6. Attendu : OK,
zéro échec. Tests : deux instances issues d'un profil partagé ; indépendance
sur 20 états ; modification ultérieure du profil ; bornes, soins, mort unique,
absence de résurrection ; vraie scène, commandes en pause et après retour,
présentation de la mort, dix resets sans résidus. F8 pour arrêter.
Relancer aussi les bancs ground_mover_tests, enemy_director_tests et
ground_crowd_tests pour vérifier les laboratoires historiques.
Godot indisponible chez l'assistant : ces tests ne sont pas déclarés exécutés.

## Recette F5 puis Android

Les trois lignes correspondent aux mannequins de gauche à droite : héros, A, B.
Cible / P parcourt les trois acteurs ; le préfixe > marque la sélection.

| Commande | Touche | Résultat |
|---|---|---|
| Dégâts 15 | D | Retire au plus 15 PV à la sélection |
| Soin 10 | H | Rend au plus 10 PV, uniquement si vivant |
| ATQ +5 | T | Modifie seulement l'attaque sélectionnée |
| Fatal | K | Amène à zéro ; mannequin masqué, ligne MORT |
| Rejouer | R | Trois états neufs, profils inchangés, sélection héros |
| Pause / Reprendre | Espace | Bloque mutations et sélection |
| Repères | G | Utilisable aussi en pause |

1. Départ : héros 100/100 ATQ12 DEF3 ; A et B 60/60 ATQ8 DEF1.
2. Sélectionner A ; D donne 45/60 ; T donne ATQ13. Héros et B inchangés.
3. H donne 55 puis 60 ; les soins suivants ne dépassent pas le maximum.
4. K sur A : 0/60 MORT, seul A disparaît. D/H répétés ne changent rien.
5. Sélectionner B puis le héros ; vérifier dégâts et soins indépendants.
6. Pause : aucun dégât, soin, bonus, Fatal ou changement de cible. Repères OK.
7. Rejouer en pause : valeurs initiales, trois mannequins, toujours en pause.
   Dix répétitions : aucun doublon ni erreur. Reprendre permet les commandes.
8. Six cases À venir inactives, arène et texte lisibles, aucune erreur, F8 OK.
9. Android : mêmes vérifications tactiles ; accueil/réduction/verrouillage
   doivent imposer Reprendre au retour. Fluidité à confirmer.

Exporter Android Debug avec débogage, hors dépôt :
~/gambit-arena-builds/step-010-debug.apk. Installer par adb -d install -r,
calculer sha256sum et transmettre le résultat F6, la recette et l'empreinte.

## Clôture ultérieure

Validation explicite reçue. L’archive complète de validation consigne les
résultats sans changer le code testé. Commit proposé :
feat: [STEP-010] isoler les statistiques et PV des acteurs
Puis sauvegarde complète avec tools/create_backup.sh et contrôle du point de reprise.
STEP-011 attend clôture et GO : action identifiée, impact unique, portée et mort.

## Validation utilisateur reçue

STEP-010 explicitement validée : tous les tests manuels OK, F6 OK, aucun doublon.
Installation ADB Success sur Samsung Galaxy A16 SM-A165F.
APK : step-010-debug.apk ; version 0.1.0-step010, code 9.
SHA-256 : 1ca1bbdaca13512c31d5627bea7fa0994aaeaa2d9619950a01a44b794b5a6c1e.
Aucune mesure chiffrée de performance fournie.

Archive : gambit-arena-complet-step-010-validation.tar.gz.
Code, scènes, profils, tests et configuration identiques à la livraison v1.
Seule la documentation évolue ; aucun lancement Godot chez l’assistant.
Statut : Validée, commit en attente. Hash et sauvegarde à recevoir.

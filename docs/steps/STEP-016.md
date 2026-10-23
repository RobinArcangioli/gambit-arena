# STEP-016 — Évaluateur déterministe sans effet de bord

Statut : Validée, commit en attente.
Base : dd9fec88067da7e677e731b4e5338840ba8dccdf, STEP-015 clôturée.
STEP-016 validée par l’utilisateur ; empreinte APK reçue. Commit et sauvegarde à recevoir.

## Périmètre

Trois règles maximum, premier choix applicable, conditions always/hp_below,
cibles self/enemy, compétences basic/heal/special. Disponibilité et seuils stricts,
ciblage déterministe indépendant de l'ordre des ennemis. Résultat sans exécution.
Les choix précis sont documentés dans docs/gambits.md, sans ajout au périmètre MVP.

Nouveaux : scripts/gambits/{gambit_rule,gambit_snapshot,gambit_evaluator,gambit_lab}.gd,
tests/test_gambits.gd, leurs UID, scènes gambit_lab et gambit_tests,
docs/gambits.md et cette recette. Main et version Android actualisés.
Composants historiques inchangés. Version 0.1.0-step016, code 15.

## Installation et tests F6

Fermer Godot. Vérifier main propre à dd9fec8. Extraire dans ~ le projet complet
gambit-arena-complet-step-016-v1.tar.gz, sans remplacer .git.
Vérifier git diff --check, puis importer dans Godot.

Dans scenes/tests/, lancer avec F6, F8 entre chaque banc :
1. gambit_tests.tscn : priorités, mille évaluations identiques sans mutation,
   permutation des ennemis, seuils exacts/fractionnaires, ressources/CD, règles
   invalides, cibles mortes/absentes, portée, snapshot invalide, plafond 20,
   vraie scène, cadence 10 Hz à 30/60/120 Hz, pause et dix resets.
2. lifecycle_tests.tscn : non-régression de la pause et du cycle de vie.
3. combat_simulation_tests.tscn : non-régression du combat autonome existant.

Attendu : OK, zéro échec par banc. Godot non exécuté chez l'assistant.

## Recette F5 et Android

| Bouton | Touche | Intervention de diagnostic |
|---|---|---|
| Blesser 30 | A | Retire 30 PV au héros |
| Rétablir | H | Rend les PV manquants, sans ressusciter |
| Énergie 0/60 | S | Alterne l'énergie simulée |
| CD spec 0/6 | D | Alterne le cooldown simulé de spéciale |
| Évaluer | E | Force une lecture, sans lancer d'action |
| Rejouer | R | Réinitialise les fixtures et conserve la pause |
| Scénario | P | Priorités / Hors portée / Égalité / Sans cible |
| Pause/Reprendre | Espace | Gèle les lectures et interventions |
| Repères | G | Repères utilisables en pause |

1. Priorités : héros 60/100, énergie 60, CD spéciale 0. Intention R2 special → #2,
   à portée. Laisser tourner : lectures +10/s environ ; aucun PV ni énergie dépensé.
2. Blesser : héros 30/100, intention R1 heal → #1. Les PV restent à 30, aucun soin
   exécuté. Rétablir : 100/100 et retour à R2 special.
3. Énergie 0 : R3 basic. Énergie 60 : R2 special. CD spéciale 6 : R3 basic.
   Le CD reste à 6, car il s'agit d'une entrée simulée ; remettre à 0.
4. Hors portée : R2 special → #2 / approche. Aucun déplacement ne doit se produire.
5. Égalité : deux ennemis équidistants ; toujours #2, jamais alternance vers #3.
6. Sans cible : aucune intention / no_match. Blesser → R1 heal sur soi possible.
7. Pause : compteur figé, boutons d'intervention et scénario bloqués. Rejouer reste
   possible, conserve la pause, remet le compteur à zéro. Reprendre relance la lecture.
8. Dix resets en alternant les scénarios : deux acteurs, ou trois dans Égalité,
   sans doublon ni erreur. Blesser jusqu'à mort : aucune intention ; Rejouer restaure.
9. Android : mêmes essais tactiles, accueil/verrouillage/retour : reprise explicite,
   aucun rattrapage. Vérifier fluidité, textes, arène et six cases À venir inactives.

Le combat historique reste accessible via scenes/combat/battle_lab.tscn.
Le contrôleur de combat n'est pas remplacé dans cette étape.

## Export et clôture

Exporter Android Debug avec débogage vers ~/gambit-arena-builds/step-016-debug.apk,
hors dépôt. Installer avec adb -d install -r puis calculer sha256sum.
Transmettre F6, tests manuels, fluidité et SHA-256. Validation utilisateur reçue.
Message de commit proposé :
feat: [STEP-016] ajouter un evaluateur deterministe de gambits
Puis sauvegarde complète et vérification du point de reprise.
STEP-017 attend clôture et nouveau GO : intégration des intentions au héros.

## Validation utilisateur reçue — 23 octobre 2026

STEP-016 explicitement validée : F6 OK, tests manuels OK, fluidité OK.
Retour F6 global, sans résultat séparé pour chacun des trois bancs demandés.
APK : step-016-debug.apk ; version de la livraison 0.1.0-step016, code 15.
SHA-256 communiqué : a844beb6d1c6bb10010944d52b35153267ce9bd3f21a953aed44304d2180971c.
Aucune mesure chiffrée de performance fournie.

Archive : gambit-arena-complet-step-016-validation.tar.gz.
Code, scènes, profils, tests et configuration identiques à la livraison v1.
Seule la documentation évolue ; aucun lancement Godot chez l’assistant.
Statut : Validée, commit en attente. Hash et sauvegarde à recevoir.

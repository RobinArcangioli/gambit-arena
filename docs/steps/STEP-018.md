# STEP-018 — Diagnostics bornés et scénarios reproductibles

Statut : Validée, commit en attente.
Base : 5b2bc4d692bd99f29774c19caf4eec3d3d93598f, STEP-017 clôturée.
STEP-018 validée par l’utilisateur ; empreinte APK reçue. Commit et sauvegarde à recevoir.

## Périmètre

Explication du choix/rejet des règles via le même évaluateur. Journal en mémoire
de 64 événements maximum, trois motifs par entrée, chaînes bornées et copies à la
lecture. Huit fixtures et un combat réel, trace désactivable, pause et reset cohérents.

Nouveaux : gambit_trace.gd, gambit_scenarios.gd, gambit_diagnostics_lab.gd,
test_gambit_diagnostics.gd et leurs UID, scènes gambit_diagnostics_lab et
gambit_diagnostics_tests, docs/gambit-diagnostics.md et cette recette.
Modifiés : évaluateur (parcours partagé avec explication), contrôleur (instrumentation),
CombatSimulation (motif/temps de fin), Main et export Android.
Version 0.1.0-step018, code 17. Pas d'éditeur ou de modification des compétences.

## Installation et tests F6

Fermer Godot. Vérifier main propre à 5b2bc4d. Extraire dans ~ le projet complet
gambit-arena-complet-step-018-v2.tar.gz, sans remplacer .git.
Vérifier git diff --check, puis importer dans Godot.

Dans scenes/tests/, lancer avec F6, F8 entre chaque banc :
1. gambit_diagnostics_tests.tscn : huit résultats/motifs attendus, répétitions,
   absence de mutation, 2000 écritures, copies, limites de payload, combat avec/sans
   trace, replay normalisé, invalidation, refus, scène réelle, pause et dix resets.
2. gambit_controller_tests.tscn : non-régression du pilotage et des coûts uniques.
3. gambit_tests.tscn : non-régression du contrat de l'évaluateur.
4. lifecycle_tests.tscn : pause, mort et absence d'effet tardif.
5. combat_simulation_tests.tscn : combat autonome historique, contacts et resets.

Attendu : OK, zéro échec par banc. Attendre le bilan des combats simulés.
Godot non exécuté chez l'assistant.

## Recette F5 et Android

| Commande | Touche | Effet |
|---|---|---|
| Scénario | P | Combat, puis huit cas fixes |
| Rejouer | R | Remet scénario et journal à zéro, conserve pause/trace |
| Vue journal/raisons | V | Bascule l'affichage, possible en pause |
| Trace oui/non | T | Active/coupe l'enregistrement, bloqué en pause |
| Pause/Reprendre | Espace | Gèle temps de jeu et nouveaux événements |
| Repères | G | Repères du combat, utilisables en pause |

1. Combat : vérifier le déroulement normal jusqu'à victoire. Vue raisons : règle
   choisie et refus précédents cohérents. Vue journal : decision puis commit,
   éventuellement invalidated, et stopped à la fin. Un commit n'est pas un impact.
2. Couper Trace pendant le combat : le héros continue, les nouvelles écritures
   cessent. Réactiver : les nouvelles écritures reprennent. Rejouer conserve le choix.
3. Parcourir les huit cas ; comparer aux résultats ci-dessous et aux motifs affichés :
   Soin prioritaire → R1 heal #1 ; Seuil 50 % → R2 special #2 ; Énergie vide → R3 basic ;
   Cooldowns → R3 basic ; Sans cible → no_match ; Égalité → #2 ; Hors portée → approche ;
   Désactivées → no_match. Les détails sont dans docs/gambit-diagnostics.md.
4. Dans les cas fixes, l'arène est masquée volontairement. PV/énergie/CD ne changent
   pas ; aucune compétence exécutée. Le compteur avance d'environ 10 lectures/s.
5. Trace activée, rester au moins 8 s dans un cas fixe : journal plafonné à 64,
   compteur des anciennes entrées retirées en hausse. L'affichage garde quatre lignes.
6. Rejouer un cas : même choix et mêmes motifs ; journal/compteur remis à zéro.
   Répéter dix fois, y compris en pause : aucune accumulation d'acteurs ou erreur.
7. Pause : nouvelles lectures/écritures figées ; changer de vue fonctionne. Rejouer
   conserve la pause avec prévisualisation du cas, mais aucune entrée enregistrée.
8. Android : mêmes essais tactiles ; accueil/verrouillage/retour pendant combat ou
   cas fixe : reprise explicite, aucun rattrapage. Vérifier lisibilité et fluidité.
9. Les six cases À venir restent inactives. Le laboratoire STEP-017 et son Groupe 20
   restent accessibles via scenes/gambits/gambit_battle_lab.tscn.

## Export et clôture

Exporter Android Debug avec débogage vers ~/gambit-arena-builds/step-018-debug.apk,
hors dépôt. Installer avec adb -d install -r puis calculer sha256sum.
Transmettre F6, tests manuels, fluidité et SHA-256. Validation utilisateur reçue.
Message de commit proposé :
feat: [STEP-018] ajouter des diagnostics bornes et des scenarios reproductibles
Puis sauvegarde complète et vérification du point de reprise.
STEP-019 attend clôture et nouveau GO : règles activables et réordonnables au toucher.

## FIX-STEP-018-001 — 24 octobre 2026

Retour F6 utilisateur sur v1 : avertissement CONFUSABLE_LOCAL_DECLARATION pour
report et échec du contrôle des résidus après dix resets en pause. À ce stade,
STEP-018 restait en attente de validation ; ce retour ne constituait pas un succès global F6.

Le test utilisait World.get_child_count() == 4, mais World possède aussi une caméra,
un WorldEnvironment et un DirectionalLight3D. Le correctif compte les ProxyActor
(et leurs sous-classes) et vérifie leur appartenance aux quatre acteurs courants.
Pause et remise à zéro du journal disposent désormais de contrôles séparés.
Le texte du bilan est renommé summary_text pour éviter le nom report utilisé dans
une boucle du même bloc parent. Aucun composant de gameplay ou diagnostic ne change.

Livraison corrigée : gambit-arena-complet-step-018-v2.tar.gz.
Validation utilisateur reçue le 24 octobre 2026 : F6, tests manuels et fluidité OK.
FIX-STEP-018-001 validé dans ce retour global ; aucun résultat détaillé par banc fourni.
Contrôles statiques effectués ; Godot non exécuté chez l'assistant.

## Validation utilisateur reçue — 24 octobre 2026

STEP-018 explicitement validée : F6 OK, tests manuels OK, fluidité OK.
Retour F6 global, sans résultat séparé pour chacun des cinq bancs demandés.
APK : step-018-debug.apk ; version de la livraison 0.1.0-step018, code 17.
SHA-256 communiqué : aadad09948a5ce8ccf5c078075cce4a86e1e3fb38158fffae6602aa096af96ef.
Aucune mesure chiffrée de performance fournie.

Archive : gambit-arena-complet-step-018-validation.tar.gz.
Code, scènes, profils, tests et configuration identiques à la livraison v2.
Seule la documentation évolue ; aucun lancement Godot chez l’assistant.
Statut : Validée, commit en attente. Hash et sauvegarde à recevoir.

## Clôture vérifiée — 24 octobre 2026

Commit 4719e8d2790cb6dd371733d2beebcec51d145d46, parent 5b2bc4d.
Main propre ; sauvegarde gambit-arena-20261024-180732-4719e8d2790c.tar.gz vérifiée.
Historique complet et intègre ; 207 fichiers identiques au commit et à la livraison validée.
Le statut « commit en attente » ci-dessus décrit la livraison de validation antérieure.

# STEP-024 — Vague progressive et swipe tactile

Statut : Validée, commit en attente.
Base : 7579504fd4a11b5b6fa1440567c597a92c67fa49, STEP-023 clôturée.
GO reçu le 25 octobre 2026. FIX-STEP-023-001 inclus sur demande utilisateur.
Validation utilisateur et SHA-256 APK v2 reçus le 25 octobre 2026.

## Périmètre

Une seule vague progressive (12 arrivées/6 simultanés), scénario de charge 24/20,
quota consommé seulement à l'apparition réussie, attente bornée en cas de saturation,
fin correcte et pause commune. Les gambits et commandes manuelles sont conservés.
Correction du swipe Gambits/Compétences et du formulaire, sans action lors du glissement.
Animations et immobilité à portée inchangées. Pas d'enchaînement de vagues dans cette étape.
Nouveaux scripts de vague, deux bancs F6, leurs scènes/UID et documentation.
Main/export STEP-024 : version 0.1.0-step024, code 23.

## Installation et tests F6

Fermer Godot. Partir de main propre 7579504. Extraire dans ~
gambit-arena-complet-step-024-v2.tar.gz sans remplacer .git, puis git diff --check.
Ouvrir Godot et laisser l'import se terminer.

Dans scenes/tests/, F6 puis F8 entre chaque banc :

1. touch_scroll_tests.tscn : swipe sur boutons et espaces, pas d'action involontaire,
   appuis courts, légère dérive, molette, formulaire et dernier détail accessible.
2. wave_schedule_tests.tscn : cadence 30/60/120 Hz, quota/plafond, saturation sans rafale,
   apparition refusée sans consommation, victoire/défaite/interruption, pause et dix resets.
3. manual_commands_tests.tscn : priorité, remplacement, expiration et revalidation.
4. skill_slots_tests.tscn : disponibilité et consultation historique.
5. portrait_hud_tests.tscn : zones sûres et accès au bas.
6. gambit_fields_tests.tscn : édition validée.
7. attack_stationary_tests.tscn : immobilité à portée.
8. gambit_editor_tests.tscn : activation et ordre.
9. gambit_diagnostics_tests.tscn : journal et scénarios.
10. gambit_controller_tests.tscn : pilotage automatique.
11. gambit_tests.tscn : évaluateur.
12. lifecycle_tests.tscn : pause et mort.
13. combat_simulation_tests.tscn : combat historique sans mode vague.

Attendu : OK, zéro échec, aucun nouvel avertissement GDScript.
Godot absent chez l'assistant : aucune compilation ni exécution de ces bancs effectuée ici.
Le banc swipe utilise un petit espace utile pour forcer le défilement ; sa réussite
ne remplace pas une vérification des vrais gestes sur Android.

## Recette F5, PC et Android

1. Vague 12 : arène initialement vide, première apparition après environ 1 s de jeu,
   puis arrivées progressives. Affichage présents/6 et apparus/12 cohérent ; jamais plus
   de 6 présents. Un intervalle vide entre deux arrivées ne doit pas donner victoire.
2. Laisser combattre et utiliser les commandes manuelles. Aucun double coût, aucune
   interruption d'action par un appui ; absence de petits pas sur une cible à portée.
   La victoire nécessite les 12 apparitions et la mort du dernier ennemi. Si le héros
   meurt d'abord : défaite, aucune apparition ou commande tardive. Équilibrage provisoire.
3. Soin 12 : héros blessé, soin et arrivée différée fonctionnels. Charge 24 : quota 24,
   maximum 20 présents, aucune rafale lorsque des places se libèrent. Le plafond exact
   et la saturation sont aussi exercés par le banc F6, même si le combat évite le maximum.
4. Pause pendant l'attente d'une apparition/commande : compteurs et délais figés.
   Accueil/verrouillage/retour Android : pause conservée, reprise explicite.
5. Rejouer puis dix redémarrages en pause : une seule vague neuve, aucun ennemi ou commande
   résiduel, gambits conservés. Changer de scénario revient à zéro apparition.
6. FIX-STEP-023-001 : swiper les listes Gambits et Compétences dans les deux sens,
   depuis un bouton puis un espace libre. Atteindre la dernière règle et le dernier
   détail, sans ouverture d'éditeur, réordonnancement ou commande involontaire.
7. Appui court sur compétence, activation, Haut/Bas et édition : un seul effet.
   Un swipe revenant sur le bouton de départ ne doit pas activer ce bouton.
8. Formulaire, pause et retour d'arrière-plan : scroll fonctionnel si le contenu dépasse ;
   commandes fixes accessibles. Molette PC toujours fonctionnelle. Vérifier lisibilité,
   zones sûres et fluidité sur téléphone, notamment en Charge 24.

## Export et clôture

Exporter Android Debug vers ~/gambit-arena-builds/step-024-debug.apk, hors dépôt.
Installer avec adb -d install -r puis calculer sha256sum.
Transmettre F6, tests manuels, résultat explicite du swipe, fluidité et SHA-256.
Validation reçue. Message de commit proposé :
feat: [STEP-024] ajouter une vague progressive et retablir le swipe tactile
Puis sauvegarde complète et vérification du point de reprise.
STEP-025 attend clôture et nouveau GO : enchaînement de trois vagues et compteurs exacts.

## V2 — FIX-STEP-024-001

La v1 n’a pas passé le banc tactile utilisateur. La v2 remplace la dépendance au scroll
natif par TouchScrollRouter et initialise chosen à null pour supprimer UNASSIGNED_VARIABLE.
La vague est identique à la v1. Appliquer l’archive complète sur STEP-024 non commitée.
Relancer touch_scroll_tests puis wave_schedule_tests et manual_commands_tests avant les
autres bancs de la recette. Exiger zéro avertissement et confirmer aussi les vrais gestes
sur Android : appui court, swipe dans les deux sens, pause, formulaire et molette PC.

## Validation utilisateur reçue — 25 octobre 2026

STEP-024 v2 explicitement validée : F6 OK, tests manuels OK, fluidité OK.
FIX-STEP-023-001 et FIX-STEP-024-001 inclus dans cette version validée.
Retour global, sans résultat séparé pour chacun des treize bancs ni chaque geste tactile.
Aucune mesure chiffrée de performance fournie. Aucune réserve nouvelle signalée.
APK : step-024-debug.apk ; version 0.1.0-step024, code 23.
SHA-256 communiqué : d367d52fb3a3e6857d90c19f333d819a0b6e28d888fcab92c5a38a8dc46fcb09.

Archive : gambit-arena-complet-step-024-validation.tar.gz.
Code, scènes, profils, tests et configuration identiques à la livraison v2.
Seule la documentation évolue ; aucun lancement Godot chez l’assistant.
Statut : Validée, commit en attente. Hash et sauvegarde à recevoir.
Les mentions d’attente précédentes décrivent les recettes et livraisons antérieures.

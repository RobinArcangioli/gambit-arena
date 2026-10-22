# STEP-011 — Action identifiée, impact unique, portée et mort

Statut : Validée, commit en attente.
Base : ba56209085c2d89153ca9ff7fbeba21fbf385719, STEP-010 clôturée.
GO reçu. STEP-011 validée ; empreinte APK reçue, commit et sauvegarde à recevoir.

## Périmètre et fichiers

Exécuteur d'attaque simple avec ID, préparation, récupération, cible verrouillée,
impact unique et revalidation de portée/vie. Dégâts max(1, attaque - défense),
portée 1,0 u, préparation 0,6 s, récupération 0,4 s : propositions de prototype.
Pas encore de combat autonome, poursuite raccordée, compétences, coûts ou gambits.

- scripts/combat/attack_action.gd : contrat d'action et garde d'impact.
- scripts/combat/attack_lab.gd, scenes/combat/attack_lab.tscn : laboratoire F5.
- tests/test_attack_action.gd, scenes/tests/attack_action_tests.tscn : banc F6.
- scenes/main.tscn conserve son UID et utilise le nouveau laboratoire.
- export_presets.cfg : version 0.1.0-step011, code 10.
- Documentation : docs/actions.md, README, ARCHITECTURE, ROADMAP, PROJECT_STATUS.

Les anciens scripts, scènes et profils restent inchangés. Les anciens laboratoires
restent disponibles avec F6. Les animations finales ne font pas partie de ce lot.

## Installation

Fermer Godot, vérifier dépôt propre sur main et HEAD ba56209.
Extraire gambit-arena-complet-step-011-v1.tar.gz dans ~, sans remplacer .git.
Dans ~/gambit-arena : git diff --check, puis git status --short --branch.

## Banc F6

Après import : ouvrir scenes/tests/attack_action_tests.tscn, F6.
Attendu : OK, zéro échec ; F8 arrête. Transmettre toute erreur avant de poursuivre.
Couvre : portée inclusive au sol, refus hors portée, cible verrouillée, double
lancement, appel prématuré/réentrant/dupliqué/ancien ID, pause, deltas invalides,
grand pas, 30/60/120 Hz, sortie de portée sans effet tardif, mort et destruction
réelle de source/cible, état remplacé, annulation, dégâts létaux, récupération,
formule/minimum, IDs entre exécuteurs, vraie scène, arrière-plan et dix resets.
Les anciens bancs restent accessibles, notamment actor_state_tests.tscn.
Godot absent chez l'assistant : compilation et exécution moteur non effectuées.

## Commandes F5

| Commande | Touche | Effet |
|---|---|---|
| Scénario | P | Impact / Hors portée / Mort cible / Mort héros / Retrait cible |
| Attaquer | A | Engage le héros contre la sélection ; refus si occupé/invalide |
| Cible A/B | T | Change la sélection pour la prochaine attaque |
| Éloigner A | E | Place A hors portée, intervention manuelle de test |
| Tuer cible | K | Met la sélection à zéro PV |
| Tuer héros | H | Met le héros à zéro PV |
| Rejouer | R | Annule l'action et recrée les acteurs ; conserve la pause |
| Pause/Reprendre | Espace | Gèle commandes et temps de l'action |
| Repères | G | Utilisable aussi en pause |

## Recette PC et Android

1. Impact : A démarre à 60 PV, héros 100, B 60. Attaquer : préparation,
   puis A 49 PV une seule fois, puis récupération/terminée. B reste 60.
2. Répéter Attaquer pendant préparation/récupération : refus, même ID,
   aucun coup ajouté. Après la fin, une nouvelle commande reçoit un nouvel ID.
3. Rejouer, Attaquer puis Cible B avant impact : A perd 11 PV, B reste intact.
   L'action suivante vise B. La cible engagée apparaît séparément dans le HUD.
4. Rejouer, Éloigner A puis Attaquer : refus immédiat, aucun dégât.
5. Scénario Hors portée, Attaquer : cible déplacée à 0,3 s, résultat hors portée,
   zéro dégât. Rejouer remet les positions initiales.
6. Mort cible, Attaquer : cible morte à 0,3 s, action annulée, dégâts d'action 0.
7. Mort héros, Attaquer : héros mort à 0,3 s ; cible intacte, action annulée.
8. Retrait cible, Attaquer : cible supprimée à 0,3 s ; action annulée sans erreur.
   Une commande contre la référence retirée est refusée. Rejouer restaure tout.
9. Impact : six attaques successives contre A la tuent (60→49→38→27→16→5→0).
   Dernier impact : 5 dégâts effectifs ; aucune attaque possible contre A morte.
10. Pause pendant préparation : temps et PV figés, commandes bloquées.
    Reprendre : un seul impact après le temps restant. Rejouer pendant cette
    pause : états neufs, aucune ancienne attaque après reprise. Dix resets :
    aucun doublon, toujours trois acteurs au départ.
11. Six cases À venir inactives ; texte/arène lisibles ; aucune erreur ; F8 OK.
12. Android : mêmes essais tactiles, fluidité, réduction/accueil/verrouillage.
    Le retour doit rester en pause jusqu'à Reprendre ; aucun impact en retard.

## Android et clôture

Exporter Android Debug, débogage activé, hors dépôt :
~/gambit-arena-builds/step-011-debug.apk. Installer avec adb -d install -r et
calculer sha256sum. Transmettre F6, recette manuelle, fluidité et SHA-256.
Validation utilisateur reçue. Archive documentaire de validation préparée ;
commit proposé :
feat: [STEP-011] garantir un impact unique par action
Puis statut propre, sauvegarde complète et contrôle du point de reprise.
STEP-012 attend clôture et GO : premier combat autonome contre plusieurs ennemis.

## Validation utilisateur reçue — 23 octobre 2026

STEP-011 explicitement validée : F6 OK, tests manuels OK, fluidité OK.
APK identifié : step-011-debug.apk ; version de la livraison 0.1.0-step011, code 10.
SHA-256 communiqué : b6fe668b4647f2b84e2b8271a1e06bb351fe0e3247412de80f58663d7b879c3e.
Aucune mesure chiffrée de performance fournie.

Archive : gambit-arena-complet-step-011-validation.tar.gz.
Code, scènes, profils, tests et configuration identiques à la livraison v1.
Seule la documentation évolue ; aucun lancement Godot chez l’assistant.
Statut : Validée, commit en attente. Hash et sauvegarde à recevoir.

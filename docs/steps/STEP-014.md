# STEP-014 — Attaque, soin, spéciale et ressource récupérable

Statut : Validée, commit en attente.
Base : 1ffd24ad027991f57f2aee1d96b1cbcfa87228c6, STEP-013 clôturée.
GO reçu. STEP-014 validée ; empreinte APK reçue, commit et sauvegarde à recevoir.

## Périmètre et fichiers

Soin personnel 30 PV/coût20/CD4 s, spéciale 2×attaque-défense/coût30/CD6 s,
attaque normale conservée. Récupération5 points/s jusqu'à60. Valeurs de prototype.
Tous les effets passent par la garde d'impact et l'engagement commun.

Nouveaux : scripts/skills/skills_lab.gd, scenes/skills/skills_lab.tscn,
tests/test_skills.gd, scenes/tests/skills_tests.tscn, docs/skills.md et cette recette.
Modifiés : AttackAction (points de spécialisation), SkillExecutor (effets et
récupération), CombatUnit (récupération activée), Main et version Android.
Version 0.1.0-step014, code 13. UID principal et anciens laboratoires conservés.

## Installation et tests Godot

Fermer Godot, vérifier main propre et HEAD 1ffd24a. Extraire le projet complet
'gambit-arena-complet-step-014-v1.tar.gz' dans ~, sans remplacer .git.
Dans ~/gambit-arena : git diff --check puis git status --short --branch.

Après import, lancer successivement avec F6 les scènes de scenes/tests/ :
- skills_tests.tscn : nouvelles compétences, coûts, soins bornés et récupération.
- attack_action_tests.tscn : garde d'impact et attaque historique.
- skill_executor_tests.tscn : engagement et comptes STEP-013 sans régénération.
- combat_simulation_tests.tscn : combat autonome des deux camps.

Attendu pour chaque banc : OK, zéro échec. F8 entre les bancs.
Transmettre toute erreur avant la recette manuelle. Godot non exécuté ici.
Le nouveau banc couvre notamment refus à PV pleins, cible de soin invalide,
impact prématuré/dupliqué/réentrant, heal/special/basic dans le même exécuteur,
cooldowns indépendants, attaque copiée, portée perdue, soin devenu inutile,
mort avant soin, remplacement d'état, récupération à30/60/120 Hz, plafond sans
réserve cachée, pause, ressource initialement vide, vraie scène et dix resets.

## Recette F5 puis Android

| Commande | Touche | Effet |
|---|---|---|
| Scénario | P | Compétences / Ressource vide / Mort avant effet |
| Attaque0 | A | Attaque normale gratuite |
| Soin20 | H | Soin personnel30 PV, CD4 s |
| Spéciale30 | S | Attaque renforcée, CD6 s |
| Blesser30 | D | Retire30 PV au héros pour tester le soin |
| Éloigner/Rapprocher | E | Modifie la distance de l'ennemi |
| Rejouer | R | Annule, recrée les états et conserve la pause |
| Pause/Reprendre | Espace | Gèle effets, ressource et cooldowns |
| Repères | G | Repères utilisables aussi en pause |

1. Compétences : départ héros60/100, ennemi600, énergie60.
   Attaque : ennemi589, dégâts11. Rejouer, spéciale : ennemi577, dégâts23.
   La dépense spéciale est30 une seule fois ; l'énergie remonte ensuite à5/s.
2. Rejouer, soin : héros60→90 après0,6 s ; dépense20 une fois, CD4 s.
   Après expiration du CD, second soin : 90→100, soin effectif10.
   À100 PV, soin refusé sans coût ni cooldown engagé.
3. Marteler les commandes pendant une action : refus occupé, pas d'interruption
   ni de double coût. L'attaque gratuite reste possible pendant les cooldowns,
   après récupération d'action. Soin et spéciale ont leurs propres cooldowns.
4. Ressource vide : énergie0 au départ, puis environ20 après4 s actives,
   30 après6 s, 60 après12 s. Avant le coût requis : refus sans dépense.
   Attendre au plafond ne crée pas de réserve ; après une dépense, retour à5/s.
5. Éloigner avant spéciale : refus sans coût. Éloigner pendant préparation :
   aucun dégât, mais coût conservé. Rapprocher ne provoque aucun effet tardif.
6. Mort avant effet : lancer un soin. Héros tué à0,3 s, aucun soin/résurrection,
   aucune récupération de ressource après mort. Rejouer restaure le scénario.
7. Pause pendant préparation puis au repos : PV, ressource et CD figés.
   Rejouer en pause : états initiaux, toujours en pause, aucun ancien effet.
   Dix répétitions : deux acteurs, pas de doublon ni d'erreur.
8. Six cases À venir inactives ; boutons/texte/arène lisibles ; F8 fonctionne.
9. Android : mêmes essais tactiles, fluidité, réduction/accueil/verrouillage
   pendant une préparation : retour en pause jusqu'à Reprendre. Aucun rattrapage.

Le laboratoire est immobile et l'ennemi passif. Le combat autonome conserve ses
attaques de base : l'automatisation du choix des compétences n'est pas ajoutée ici.

## Export et clôture

Exporter Android Debug avec débogage vers ~/gambit-arena-builds/step-014-debug.apk,
hors dépôt. Installer avec adb -d install -r puis calculer sha256sum.
Transmettre les quatre résultats F6, tests manuels, fluidité et SHA-256.
Validation utilisateur reçue. Commit proposé :
feat: [STEP-014] ajouter soin speciale et recuperation de ressource
Puis sauvegarde complète et contrôle du point de reprise.
STEP-015 attend clôture et GO : pause commune et interruption par la mort sans effet tardif.

## Validation utilisateur reçue — 23 octobre 2026

STEP-014 explicitement validée : F6 OK, tests manuels OK, fluidité OK.
Le retour F6 est global, sans résultat séparé pour chacun des quatre bancs demandés.
APK identifié : step-014-debug.apk ; version de la livraison 0.1.0-step014, code 13.
SHA-256 communiqué : ac06b695682b55268e741cffbaa1c3316022feb1daf10e30a7851e9fc83417d8.
Aucune mesure chiffrée de performance fournie.

Archive : gambit-arena-complet-step-014-validation.tar.gz.
Code, scènes, profils, tests et configuration identiques à la livraison v1.
Seule la documentation évolue ; aucun lancement Godot chez l’assistant.
Statut : Validée, commit en attente. Hash et sauvegarde à recevoir.

# Prompt à transmettre à la prochaine IA

Tu reprends Gambit Arena, prototype Godot Android portrait. Travaille en français et commence
par lire HANDOFF.md, PROJECT_STATUS.md, ARCHITECTURE.md, ROADMAP.md et docs/handoff/.
Lis aussi les instructions locales éventuellement présentes dans ton nouvel environnement.
Le dépôt fourni est la source de vérité ; vérifie ses fichiers et son état avant de modifier.

Dernière base commitée : HANDOFF-001 au commit
cc91c79b0bcf82df6fb852d9b792fce63aa32148, parent 665c0c8d86a6400f88c77773295ed06b1a518206.
STEP-028 est validée par l'utilisateur mais son commit et sa sauvegarde restent à faire.
Vérifie git log, git status et le remote réel. Ne suppose pas un push déjà effectué.

APK de référence STEP-028 : step-028-debug.apk, version 0.1.0-step028, code 28,
SHA-256 d2c710ef6fb1c935eb6afecbfe54e98b1a03d0a03266753c5c8b537cce1a23b9.
L'utilisateur a validé F6, F5, tactile Android et pause/reprise. Les mesures et leurs limites
sont dans docs/steps/STEP-028.md ; le seuil historique de 30 FPS Debug n'est pas atteint mais
est explicitement accepté pour le périmètre réel. Godot 4.7.2 et l'appareil ont été utilisés :
ne présente pas les contrôles historiques comme la seule preuve disponible.

Le jeu utilise des mannequins 3D procéduraux, pas des assets finaux. Un coordinateur contrôle
le combat, les coûts/effets sont uniques et partagés entre commandes manuelles et gambits.
Préserve impérativement : cible vivante à portée conservée entre actions et après soin,
aucun pas/jambes en marche à portée, swipe tactile sans commande parasite, trois vagues avec
comptes exacts, défaite/replay sans résidus, pause au retour Android avec reprise explicite.
Ne change pas animations, équilibrage ou gameplay pendant un chantier sans rapport.

Méthode établie : étape autorisée par GO ; archive complète sans .git/.godot ; recette F6 et
APK ; retour utilisateur + SHA ; archive de validation documentaire seule ; commit utilisateur
et sauvegarde vérifiée avant l’étape suivante. Ne réécris pas l’historique, ne fais pas de push
forcé, ne restaure pas silencieusement les modifications utilisateur. Les correctifs doivent
reproduire le bug dans un banc pertinent. Tous les détails sont dans la passation.

La clôture immédiate est le commit utilisateur STEP-028 puis sa sauvegarde vérifiée. STEP-029
(clone/import/export/install propre) et STEP-030 (recette finale MVP) ne sont pas réalisées.
Le plan détaillé proposé dans docs/handoff/NEXT_STEPS.md ne remplace pas le GO utilisateur.
Après vérification du commit et de la sauvegarde, attendre un GO explicite pour STEP-029.

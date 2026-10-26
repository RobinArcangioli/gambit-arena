# Prompt à transmettre à la prochaine IA

Tu reprends Gambit Arena, prototype Godot Android portrait. Travaille en français et commence
par lire HANDOFF.md, PROJECT_STATUS.md, ARCHITECTURE.md, ROADMAP.md et docs/handoff/.
Lis aussi les instructions locales éventuellement présentes dans ton nouvel environnement.
Le dépôt fourni est la source de vérité ; vérifie ses fichiers et son état avant de modifier.

Dernière étape fonctionnelle clôturée : STEP-027 au commit
665c0c8d86a6400f88c77773295ed06b1a518206, parent 344a584ec680ba7b45fb648b3a2eceb8937a97ae.
Sauvegarde/bundle vérifiés, 307 fichiers identiques à la livraison validée. HANDOFF-001 ajoute
uniquement la documentation ; son commit/push peut avoir été réalisé après la rédaction.
Vérifie git log, git status et le remote réel. Ne suppose pas un push déjà effectué.

Dernier APK validé : step-027-debug.apk, version 0.1.0-step027, code 27,
SHA-256 07467efcfb7e663e363e6f6fc61644fd2bf2889e7ee3a3001d42589e0c6cf611.
L’utilisateur a confirmé F6, tests manuels et fluidité OK. Aucun FPS chiffré n’est acquis.
L’assistant précédent n’avait pas Godot : ne présente pas ses contrôles statiques comme des
compilations ou des tests moteur. Vérifie les outils réellement disponibles chez toi.

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

La prochaine étape de la roadmap est STEP-028 : mesures de performance reproductibles sur
Galaxy A16, objectif provisoire 30 FPS soutenues. Puis STEP-029 clone/import/export/install
propre et STEP-030 recette finale MVP. Ces étapes ne sont pas encore réalisées.
Le plan détaillé proposé dans docs/handoff/NEXT_STEPS.md ne remplace pas le GO utilisateur.
Si la demande actuelle concerne encore GitHub, termine la publication/documentation avant
le chantier performance. Sinon, après vérification de la base et autorisation, poursuis STEP-028.

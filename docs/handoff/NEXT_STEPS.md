# GRAPHICS-005 validée — 26 octobre 2026

Le propriétaire confirme « Step validée. » pour la livraison GRAPHICS-005,
APK 0.1.0-graphics005 (36), installé sur Galaxy A16.
SHA-256 APK : `060c79e8cedc6236d7d4ea33a7df8ec7245b9c938b94976fc9362f01251cc8da`.
Validation globale, sans détail supplémentaire ni nouvelle mesure FPS.
Les fichiers non documentaires sont identiques à la livraison validée ; les 35 bancs /
2 243 contrôles déjà réussis ne sont pas relancés pour cette clôture documentaire.
Clôture par un commit unique, puis sauvegarde et restauration vérifiées.
Prochaine étape : GRAPHICS-006, effet Foudre de Mako ; attendre GO avant de la démarrer.
Les mentions de recette ci-dessous décrivent les états antérieurs.

# GRAPHICS-005 — effet de soin en recette

GRAPHICS-004/fix1 clôturée au commit local 074f971, sauvegarde restaurée/vérifiée.
Halo de soin, signes + et valeur réellement rendue, uniquement après résolution positive.
Apparence remplaçable, origine par modèle et suivi de cible ; pause/reprise et nettoyage.
35 bancs / 2 243 contrôles passent. Voir docs/steps/GRAPHICS-005.md et docs/heal-presentation.md.
F6 : scenes/debug/heal_lab.tscn, bouton Soin (demo), puis F8/F5 pour le vrai combat.
APK 0.1.0-graphics005 (36), installé et lancé sur Galaxy A16, version vérifiée par ADB.
Étape non commitée ; attendre validation avant clôture et GRAPHICS-006.
Les sections suivantes décrivent les états historiques.

# GRAPHICS-004 et fix1 validés — 26 octobre 2026

Le propriétaire confirme « Tout est OK. Step validée. » pour la livraison fix1,
APK 0.1.0-graphics004-fix1 (35), installé sur Galaxy A16.
SHA-256 APK : `242961171f11a2f9e0ae1dbd9efad59af43df5b02e8e745261ca24c9bd805959`.
Les fichiers non documentaires restent identiques à la livraison validée ; les 34 bancs /
2 154 contrôles déjà réussis ne sont pas relancés pour cette clôture documentaire.
Clôture par un commit unique, fix1 inclus, puis sauvegarde et restauration vérifiées.
Prochaine étape : GRAPHICS-005, effet de soin ; attendre GO avant de la démarrer.
Les mentions de recette ci-dessous décrivent les états antérieurs.

# Actualisation GRAPHICS-004/fix1

Lire docs/steps/GRAPHICS-004.md et docs/combat-presentation.md : priorité stricte,
Sword/HitReact/Death/Duck, 34 bancs / 2 154 contrôles, APK actif code 35 installé et lancé
sur Galaxy A16, version vérifiée par ADB. Attendre validation
avant clôture et GRAPHICS-005. Dernier commit b1dfb33, sauvegarde vérifiée.
Les sections suivantes décrivent les états antérieurs.

# GAMEPLAY-001 et fix1 validés

Le propriétaire confirme « Steps validée. ». La livraison fix1, APK 0.1.0-gameplay001-fix1
(code 33), est validée. Les sources non documentaires sont identiques à la livraison.
Clôture par un commit unique, fix1 inclus, puis sauvegarde vérifiée. GRAPHICS-004 est la
prochaine étape ; attendre GO. Les statuts de recette antérieurs ci-dessous sont historiques.

# GAMEPLAY-001-fix1 — correctif en recette

Le soin inclut Anne et privilégie le plus bas pourcentage de PV. La mana est débitée
uniquement à l'effet réussi ; une annulation pendant l'incantation ne coûte rien.
32 bancs / 1 959 contrôles passent. APK 0.1.0-gameplay001-fix1 (33) installé sur A16.
Voir docs/steps/GAMEPLAY-001-fix1.md et docs/party-gameplay.md. Les états de livraison
précédents ci-dessous sont historiques. Validation de GAMEPLAY-001 toujours attendue.

# Actualisation GAMEPLAY-001

Lire docs/steps/GAMEPLAY-001.md et docs/party-gameplay.md : étape en recette, 31 bancs /
1 921 contrôles, APK 0.1.0-gameplay001 (32) installé sur A16. Dernier commit GRAPHICS-003
7956cfce2efcdaf4b95fd3f0631193cb9d442589, sauvegarde restaurée et vérifiée.
Attendre validation, puis clôturer GAMEPLAY-001 avant GRAPHICS-004. Les paragraphes suivants
sont historiques lorsqu'ils décrivent une ancienne composition ou un ancien statut.

# État courant

GRAPHICS-003 est en recette : modèles pirates, vues remplaçables, Idle/Walk, galerie.
Voir ../steps/GRAPHICS-003.md. Attendre validation puis commit/sauvegarde vérifiée.
Étape suivante : GAMEPLAY-001 selon ../party-skills-plan.md, puis GRAPHICS-004 à 007.
Les propositions anciennes ci-dessous sont remplacées lorsqu'elles contredisent ce plan.

# Roadmap restante et plan de reprise

## Nouvelle priorité validée — évolutions graphiques

STEP-028 est maintenant clôturée : commit 580ce64, push et sauvegarde vérifiés. Le propriétaire
a demandé de préparer des évolutions graphiques avant la recette finale. Lire la
[roadmap graphique](../graphics-roadmap.md), GRAPHICS-001 à GRAPHICS-007 : arènes, modèles 3D,
attaque, soin et Foudre, avec présentation interchangeable et gameplay préservé.
GRAPHICS-001 est clôturée au commit local f5a790d, sauvegarde restaurée/vérifiée.
GRAPHICS-002 est validée par le propriétaire, qui demande son commit ; les huit arènes et
leur catalogue sont implémentés. Les sections ci-dessous conservent le contexte des étapes
initiales de livraison, qui gardent leurs identifiants. La prochaine étape graphique est
GRAPHICS-003 : modèles 3D et animation de base, en attente des modèles annoncés par le propriétaire.

STEP-001 à STEP-027 sont clôturées selon les preuves du registre, avec reprise d’historique
RECOVERY-001 et transition 3D TRANSITION-001. HANDOFF-001 prépare la transmission et GitHub ;
elle n’autorise ni n’implémente STEP-028. Les trois étapes restantes gardent leur périmètre.

## STEP-028 — Mesures reproductibles et budget matériel

Actualisation du 26 octobre : instrumentation, protocole et campagnes Android sont exécutés.
Consulter ../steps/STEP-028.md pour les essais, résultats et SHA testé. L'ancien objectif de
30 FPS Debug n'est pas atteint ; le propriétaire a cependant accepté explicitement la performance
pour le périmètre réel, où 20 ennemis simultanés ne sont pas prévus. Le plan ci-dessous reste
le contexte historique de l'étape, pas une promesse de performance générale.

Le propriétaire a ensuite validé STEP-028 : F6, F5, tactile Android et pause/reprise OK.
La clôture immédiate consiste uniquement à commiter puis sauvegarder cette étape ; STEP-029
reste une étape distincte, à démarrer seulement avec son GO.

Objectif initial : vérifier le budget matériel, avec cible provisoire de 30 images/s soutenues
sur le Galaxy A16. Les mesures chiffrées et la décision produit sont maintenant consignées dans
`../steps/STEP-028.md` ; ne pas les remplacer par ce plan antérieur.

Plan d’implémentation proposé, à préciser au démarrage :

1. Relever appareil/OS, Godot/templates, APK/SHA, mode Debug ou Release, options de rendu,
   conditions de test (charge batterie, alimentation, luminosité, température si disponible).
2. Définir un protocole reproductible : durée de chauffe, durée de capture, scénario normal
   et scénario saturé à 20 ennemis, même UI/règles et répétitions. Fixer explicitement ces
   durées et critères avant de comparer des résultats.
3. Mesurer des temps de frame réels de rendu et de simulation séparément. Ne pas calculer
   les FPS avec le dt borné de GameClock ni présenter un test accéléré F6 comme une mesure réelle.
4. Relever distribution des temps de frame (médiane/p95/p99 ou équivalent), images longues,
   mémoire si disponible, pics d’acteurs/objets et dérive après resets. Choisir une collecte
   bornée et un export exploitable, sans remplir indéfiniment un tableau ou le journal UI.
5. Confronter les résultats à l’objectif 30 FPS ; documenter les limites des compteurs et
   l’influence de Debug/USB/éditeur. Ne pas promettre une conformité avec la seule moyenne.
6. N’optimiser que les postes réellement dominants, un changement à la fois, avec nouvelle
   mesure comparable et régressions ciblage/actions/swipe/cycle de vie.

Points à examiner, pas des goulots déjà prouvés : séparateur Crowd, captures/allocations de
snapshots, HUD actualisé et relayout différé, rendu SubViewport, ressources de diagnostic
incluses par all_resources. Aucun de ces éléments ne doit être supprimé sans preuve et recette.
Livrables attendus : protocole, données brutes, synthèse, APK identifié, décision sur budget.

## STEP-029 — Clone propre, import, export et installation

Objectif approuvé : reproduire une installation depuis un clone neuf sans cache existant.
La première publication GitHub de HANDOFF-001 ne valide pas à elle seule STEP-029.

Plan proposé : vérifier l’URL/branche et le commit de référence ; cloner dans un nouveau
dossier ; relever versions et chemins SDK/JDK/templates ; importer sans .godot réutilisé ;
exécuter les tests utiles ; exporter/installler un APK propre et relever son SHA ; documenter
ce qui est global à la machine (SDK, templates, signature Debug) et ce qui est versionné.
Ne pas exiger un APK bit-à-bit reproductible sans avoir étudié métadonnées et signature.
Vérifier aussi la restauration du bundle et une nouvelle sauvegarde. Ne pas inscrire de
mot de passe ou clé privée dans export_presets.cfg. La CI éventuelle n’est pas déjà en place.

## STEP-030 — Recette finale MVP

Objectif approuvé : validation finale sur un APK identifié. Rassembler la matrice gameplay,
UI/portrait/zones sûres, ciblage, coûts/impacts, trois vagues, défaite/replay, pause/Android,
performance et installation. Consigner les réserves connues, décisions, SHA et commit.
Ne pas déclarer le MVP finalisé simplement parce que STEP-027 est validée. Le contenu
artistique reste provisoire tant qu’un chantier distinct n’a pas été décidé.

## Après MVP — propositions, hors autorisation actuelle

Production de modèles/rigs/animations et décors définitifs, direction artistique, équilibrage,
options d’accessibilité, sauvegarde persistante ou publication boutique demanderaient des
choix explicites. Ce ne sont pas des extensions automatiques de STEP-028 à STEP-030.
L’annexe détaillée initiale n’était pas fournie dans le fichier de lancement : le registre
des 30 étapes est conservé, mais ne pas inventer une spécification originale plus détaillée.

## Premier tour recommandé pour la prochaine IA

Vérifier le commit STEP-028 et sa sauvegarde une fois fournis ; lire HANDOFF.md et les
invariants ; confirmer les outils réellement disponibles. Attendre ensuite un GO explicite
pour STEP-029. Toujours conserver les corrections utilisateur et les preuves de validation.
